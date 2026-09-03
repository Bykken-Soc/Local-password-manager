import 'package:final_project_desktop/providers/theme_provider.dart';
import 'package:final_project_desktop/widgets/themebotton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import '../db/app_db.dart';
import '../services/service_locator.dart';

// Serves as the security gatekeeper screen handling local registration, login authentication, and emergency factory resets
class LockScreen extends StatefulWidget {
  const LockScreen({super.key});
  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final _passwordController = TextEditingController();
  bool _isSignUpMode = true;
  String? _savedPassword;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _checkLockStatus();
  }

  // Asynchronously queries key-value storage to detect if a master password configuration signature already exists
  Future<void> _checkLockStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _savedPassword = prefs.getString('master_password');
    if (_savedPassword != null) {
      setState(() { _isSignUpMode = false; });
    }
  }

  // Processes form inputs: commits new master keys to disk or evaluates verification attempts to grant environment access
  Future<void> _handleSubmit() async {
    final input = _passwordController.text.trim();
    if (input.isEmpty || input.length < 4) {
      setState(() { _errorMessage = 'Password must be at least 4 characters long.'; });
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    if (_isSignUpMode) {
      await prefs.setString('master_password', input);
      if (mounted) context.goNamed('home');
    } else {
      if (input == _savedPassword) {
        if (mounted) context.goNamed('home');
      } else {
        setState(() { _errorMessage = 'Incorrect master password. Access denied.'; });
      }
    }
  }

  // Security purge interface: wipes the master authentication token and drops all local SQLite database tables via Drift
  Future<void> _handleFactoryReset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('master_password'); 
    
    final database = locator<AppDatabase>();
    await database.delete(database.dbpassword).go(); 
    
    setState(() {
      _isSignUpMode = true;
      _passwordController.clear();
      _errorMessage = '';
    });
  }

  // Triggers an emergency confirmation alert detailing the destructive consequences of data recovery omissions
  void _showForgotDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Theme.of(context).colorScheme.error),
              const SizedBox(width: 10),
              const Text('Forgot Password?'),
            ],
          ),
          content: const Text(
            'Due to encryption security protocols, your master password cannot be recovered.\n\nPerforming a reset will erase the master key and completely wipe all locally saved credentials to protect your data.',
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await _handleFactoryReset();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Application reset successful. Please set a new master password.')),
                  );
                }
              },
              child: const Text('Reset and Wipe Data'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
     final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [themebutton(themeProvider: themeProvider)],
      ),
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(32.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.2)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(_isSignUpMode ? Icons.security_outlined : Icons.lock_outline_rounded, size: 64, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                _isSignUpMode ? 'Setup Master Password' : 'Enter Master Password',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                _isSignUpMode ? 'Create a secure key to protect all your credentials.' : 'Your database is encrypted. Unlock to proceed.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Theme.of(context).hintColor),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Master Password', border: OutlineInputBorder(), prefixIcon: Icon(Icons.password_rounded)),
                onSubmitted: (_) => _handleSubmit(),
              ),
              if (_errorMessage.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(_errorMessage, style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 13, fontWeight: FontWeight.w500)),
              ],
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _handleSubmit,
                child: Text(_isSignUpMode ? 'Set Password and Enter' : 'Unlock Application'),
              ),
              if (!_isSignUpMode) ...[
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _showForgotDialog,
                  child: Text('Forgot master password?', style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 13)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}