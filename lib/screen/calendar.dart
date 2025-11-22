import 'package:flutter/material.dart';
import '../task.dart';
import 'package:table_calendar/table_calendar.dart';
import '../app_state.dart';
import 'package:go_router/go_router.dart';


class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  Map<DateTime, List<Task>> _groupTasks(List<Task> tasks) {
    final grouped = <DateTime, List<Task>>{};
    for (var task in tasks) {
      final day = DateTime(task.date.year, task.date.month, task.date.day);
      grouped.putIfAbsent(day, () => []).add(task);
    }
    return grouped;
  }

  List<Task> _tasksForDay(DateTime day, Map<DateTime, List<Task>> tasksByDay) {
    final date = DateTime(day.year, day.month, day.day);
    return tasksByDay[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final tasksByDay = _groupTasks(AppStateProvider.of(context).tasks);
    return Scaffold(
      appBar: AppBar(title: Text('Календарь')),
      body: Column(
      children: [
        TableCalendar<Task>(
          firstDay: DateTime(2020),
          lastDay: DateTime(2100),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          calendarFormat: CalendarFormat.month,
          eventLoader: (day) => _tasksForDay(day, tasksByDay),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          calendarStyle: CalendarStyle(
            markersMaxCount: 3,
            markerDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _buildTaskList(tasksByDay),
        ),
      ],
    ),
    );
  }

  Widget _buildTaskList(Map<DateTime, List<Task>> tasksByDay) {
    if (_selectedDay == null) return Center(child: Text('Выберите дату'));
    final appState = AppStateProvider.of(context);
    final tasks = _tasksForDay(_selectedDay!, tasksByDay);
    if (tasks.isEmpty) return Center(child: Text('Задач на этот день нет'));
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return ListTile(
          title: Text(task.title),
          subtitle: Text(task.description),
          trailing: Checkbox(
            value: task.completed,
            onChanged: (val) {
              setState(() {
                task.completed = val ?? false;
              });
              appState.notify();
            },
          ),
          onTap: () {
            final idx = appState.tasks.indexOf(task);
            context.push('/task/$idx');
          },
        );
      },
    );
  }
}
