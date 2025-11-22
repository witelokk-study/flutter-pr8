import 'package:flutter/material.dart';
import '../task.dart';
import 'package:intl/intl.dart';
import '../app_state.dart';
import 'package:go_router/go_router.dart';

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerDesc = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  void _addTask() {
    final appState = AppStateProvider.of(context);
    if (_controllerTitle.text.isEmpty) return;
    appState.addTask(Task(title: _controllerTitle.text, description: _controllerDesc.text, date: _selectedDate));
    _controllerTitle.clear();
    _controllerDesc.clear();
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context, initialDate: _selectedDate, firstDate: DateTime(2020), lastDate: DateTime(2100));
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Задачи')),
      body: Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _controllerTitle,
                decoration: InputDecoration(labelText: 'Название задачи'),
              ),
              TextField(
                controller: _controllerDesc,
                decoration: InputDecoration(labelText: 'Описание'),
              ),
              Row(
                children: [
                  TextButton.icon(icon: Icon(Icons.calendar_today), label: Text('Выбрать дату'), onPressed: () => _pickDate(context)),
                  Spacer(),
                  ElevatedButton.icon(icon: Icon(Icons.add), label: Text('Добавить'), onPressed: _addTask),
                ],
              )
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: AppStateProvider.of(context).tasks.map((task) {
              return CheckboxListTile(
                title: Text('${task.title} (${DateFormat('dd.MM.yyyy').format(task.date)})'),
                subtitle: Text(task.description),
                value: task.completed,
                onChanged: (val) {
                  task.completed = val ?? false;
                  AppStateProvider.of(context).notify();
                },
                secondary: IconButton(icon: Icon(Icons.info), onPressed: () {
                  final tasks = AppStateProvider.of(context).tasks;
                  final idx = tasks.indexOf(task);
                  context.push('/task/$idx');
                }),
              );
            }).toList(),
          ),
        ),
      ],
    ),
    );
  }
}
