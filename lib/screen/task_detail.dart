import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../task.dart';
import 'package:intl/intl.dart';
import '../app_state.dart';

class TaskDetailScreen extends StatefulWidget {
  final int taskIndex;

  TaskDetailScreen({required this.taskIndex});

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  DateTime? _date;
  Task? _task;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    final appState = AppStateProvider.of(context);
    if (widget.taskIndex < 0 || widget.taskIndex >= appState.tasks.length) {
      _task = null;
    } else {
      _task = appState.tasks[widget.taskIndex];
      _titleController.text = _task!.title;
      _descController.text = _task!.description;
      _date = _task!.date;
    }
    _initialized = true;
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  void _save() {
    final appState = AppStateProvider.of(context);
    if (_task == null || _date == null) {
      context.pop();
      return;
    }
    _task!
      ..title = _titleController.text
      ..description = _descController.text
      ..date = _date!;
    appState.notify();
    
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_task == null || _date == null) {
      return Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: () => context.pop()),
          title: Text('Детали задачи'),
        ),
        body: Center(child: Text('Task not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: Text('Детали задачи'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Название'),
            ),
            TextField(
              controller: _descController,
              decoration: InputDecoration(labelText: 'Описание'),
            ),
            Row(
              children: [
                Text('Дата: ${DateFormat('dd.MM.yyyy').format(_date!)}'),
                TextButton.icon(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _pickDate(context),
                  label: Text('Выбрать дату'),
                ),
              ],
            ),
            CheckboxListTile(
              title: Text('Выполнено'),
              value: _task!.completed,
              onChanged: (val) {
                setState(() {
                  _task!.completed = val ?? false;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _save, child: Text('Сохранить')),
          ],
        ),
      ),
    );
  }
}
