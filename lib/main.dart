import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screen/home.dart';
import 'screen/tasks.dart';
import 'screen/calendar.dart';
import 'screen/task_detail.dart';
import 'screen/stats.dart';
import 'app_state.dart';

void main() {
  final appState = AppState();
  runApp(TaskPlannerApp(appState: appState));
}

class TaskPlannerApp extends StatelessWidget {
  final AppState appState;
  TaskPlannerApp({required this.appState});
  late final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          final loc = state.location;
          int selected = 0;
          if (loc.startsWith('/tasks')) selected = 1;
          else if (loc.startsWith('/calendar')) selected = 2;
          else if (loc.startsWith('/stats')) selected = 3;

          final paths = ['/', '/tasks', '/calendar', '/stats'];

          final onTaskDetail = loc.startsWith('/task/');

          return Scaffold(
            body: child,
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: selected,
              onTap: (i) {
                final path = (i >= 0 && i < paths.length) ? paths[i] : '/';
                context.go(path);
              },
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
                BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Задачи'),
                BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Календарь'),
                BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Статистика'),
              ],
            ),
          );
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            pageBuilder: (context, state) => NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
            path: '/tasks',
            name: 'tasks',
            pageBuilder: (context, state) => NoTransitionPage(child: TasksScreen()),
          ),
          GoRoute(
            path: '/calendar',
            name: 'calendar',
            pageBuilder: (context, state) => NoTransitionPage(child: CalendarScreen()),
          ),
          GoRoute(
            path: '/stats',
            name: 'stats',
            pageBuilder: (context, state) => NoTransitionPage(child: StatsScreen()),
          ),
          GoRoute(
            path: '/task/:taskIndex',
            name: 'taskDetail',
            builder: (context, state) {
              final idx = int.tryParse(state.pathParameters['taskIndex'] ?? '-1') ?? -1;
              return TaskDetailScreen(taskIndex: idx);
            },
          ),
        ],
      ),
      
    ],
  );

  @override
  Widget build(BuildContext context) {
    return AppStateProvider(
      state: appState,
      child: MaterialApp.router(
        title: 'Task Planner',
        theme: ThemeData(primarySwatch: Colors.blue),
        routerConfig: _router,
      ),
    );
  }
}
