import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:final_project_desktop/db/app_db.dart';

import '../repositories/repositories_password.dart';
import '../providers/password_provider.dart';

final GetIt locator = GetIt.instance;

// Configures the GetIt service locator to manage global dependency injection for the app
void setupLocator() {
  // Registers the local SQLite database instance as a persistent global singleton
  final db = AppDatabase();
  locator.registerSingleton<AppDatabase>(db);
  
  // Initializes the network client and handles API configuration dependencies
  



  // Connects data structures by injecting database and network clients into the repository
 // 3. Repositorio (Solo consume la DB)
     final repository = PasswordRepository(db);
    locator.registerSingleton<PasswordRepository>(repository);

  // Registers the state manager factory to create clean instances whenever the UI requests one
  locator.registerFactory<PasswordProvider>(() => PasswordProvider(repository));
}