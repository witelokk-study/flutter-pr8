import 'package:flutter/material.dart';
import '../task.dart';
import '../app_state.dart';

class StatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tasks = AppStateProvider.of(context).tasks;
    int total = tasks.length;
    int completed = tasks.where((t) => t.completed).length;
    int pending = total - completed;
    return Scaffold(
      appBar: AppBar(title: Text('Статистика')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Статистика задач', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            LinearProgressIndicator(value: total == 0 ? 0 : completed / total),
            SizedBox(height: 16),
            Text('Всего задач: $total'),
            Text('Выполнено: $completed'),
            Text('Осталось: $pending'),
          ],
        ),
      ),
    );
  }
}
