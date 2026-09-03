import 'package:final_project_desktop/views/add_passwords.dart';
import 'package:final_project_desktop/views/block_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../views/home_screen.dart';
import '../views/add_passwords.dart';
import '../views/details_screen.dart';
import '../models/password_model.dart';

// Configures the global navigation map and routes for the desktop application
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [

    // Root path configuration displaying the security master key entry screen
    GoRoute(
      path: '/',
      name: 'lock',
      builder: (context, state) => const LockScreen(),
    ),
    
    // Main target route showcasing the reactive list of stored user credentials
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),

    // Entry path rendering the text field form required to save new accounts
    GoRoute(
      path: '/add',
      name: 'add-password',
      builder: (context, state) => const AgregarPasswordScreen(),
    ),

    // Dynamic path parsing route parameters to display deep info for a specific entry ID
    GoRoute(
      path: '/details/:id', 
      name: 'details',
      builder: (context, state) {
        final idString = state.pathParameters['id']!;
        final int passwordId = int.parse(idString);
        
        return DetailsScreen(id: passwordId);
      },
    ),

  ],
);