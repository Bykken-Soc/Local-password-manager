import 'package:flutter/material.dart';
import '../repositories/repositories_password.dart';
import '../models/password_model.dart';

// Defines the discrete states of the form lifecycle during save operations
enum PasswordUiState { initial, loading, success, error }

// State management provider that controls the password form UI logic and operations
class PasswordProvider extends ChangeNotifier {
  final PasswordRepository _repository;

  PasswordUiState _uiState = PasswordUiState.initial;
  String _mensajeError = '';

  PasswordProvider(this._repository);

  PasswordUiState get uiState => _uiState;
  String get mensajeError => _mensajeError;

  // Handles the password saving workflow by managing loading states, errors, and UI updates
  Future<void> ejecutarGuardado(PasswordModel nuevoPassword) async {
    _uiState = PasswordUiState.loading;
    notifyListeners(); // Triggers a UI redraw to show the loading state

    try {
      // Delegates data persistence to the repository layer
      await _repository.guardarContrasenaCompleta(nuevoPassword);
      
      _uiState = PasswordUiState.success;
    } catch (errorGenerado) {
      _uiState = PasswordUiState.error;
      _mensajeError = errorGenerado.toString(); 
    }

    notifyListeners(); // Triggers a final UI redraw to reflect success or error outcomes
  }
}