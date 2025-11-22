import 'package:flutter/widgets.dart';
import 'task.dart';

class AppState extends ChangeNotifier {
  final List<Task> tasks = [];

  void addTask(Task task) {
    tasks.add(task);
    notifyListeners();
  }

  void notify() => notifyListeners();
}

class AppStateInheritedWidget extends InheritedWidget {
  final AppState state;

  const AppStateInheritedWidget({
    super.key,
    required this.state,
    required Widget child,
  }) : super(child: child);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateInheritedWidget>();
    assert(scope != null, 'AppStateInheritedWidget not found in context');
    return scope!.state;
  }

  @override
  bool updateShouldNotify(covariant AppStateInheritedWidget oldWidget) => true;
}

class AppStateProvider extends StatefulWidget {
  final AppState state;
  final Widget child;

  const AppStateProvider({super.key, required this.state, required this.child});

  static AppState of(BuildContext context) => AppStateInheritedWidget.of(context);

  @override
  State<AppStateProvider> createState() => _AppStateProviderState();
}

class _AppStateProviderState extends State<AppStateProvider> {
  @override
  void initState() {
    super.initState();
    widget.state.addListener(_onChange);
  }

  @override
  void didUpdateWidget(covariant AppStateProvider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      oldWidget.state.removeListener(_onChange);
      widget.state.addListener(_onChange);
    }
  }

  @override
  void dispose() {
    widget.state.removeListener(_onChange);
    super.dispose();
  }

  void _onChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return AppStateInheritedWidget(
      state: widget.state,
      child: widget.child,
    );
  }
}
