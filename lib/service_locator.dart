import 'package:get_it/get_it.dart';
import 'app_state.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  if (!getIt.isRegistered<AppState>()) {
    getIt.registerSingleton<AppState>(AppState());
  }
}
