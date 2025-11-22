import 'package:flutter/material.dart';
import '../task.dart';
import '../app_state.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final tasks = appState.tasks;
    return Scaffold(
      appBar: AppBar(title: Text('Task Planner')),
      body: Builder(builder: (context) {
    DateTime today = DateTime.now();
    List<Task> todayTasks = tasks
        .where((task) =>
            task.date.day == today.day &&
            task.date.month == today.month &&
            task.date.year == today.year)
        .toList();

    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text('Задачи на сегодня',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        ...todayTasks.map((task) {
          final idx = tasks.indexOf(task);
          return ListTile(
              leading: Checkbox(
                  value: task.completed,
                  onChanged: (val) {
                  task.completed = val ?? false;
                    appState.notify();
                  }),
              title: Text(task.title),
              subtitle: Text(task.description),
              onTap: () => context.push('/task/$idx'),
            );
        }),
        if (todayTasks.isEmpty) Center(child: Text('Сегодня задач нет!')),
      ],
    );
      }),
    );
  }
}
