import 'package:final_project_desktop/models/password_model.dart';
import 'package:final_project_desktop/providers/password_provider.dart';
import 'package:final_project_desktop/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as d; 
import 'package:final_project_desktop/db/app_db.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/themebotton.dart';

final database = locator<AppDatabase>();

// Form screen allowing users to input, select categories for, and submit new password credentials
class AgregarPasswordScreen extends StatefulWidget {
  const AgregarPasswordScreen({super.key});

  @override
  State<AgregarPasswordScreen> createState() => _AgregarPasswordScreenState();
}

class _AgregarPasswordScreenState extends State<AgregarPasswordScreen> {
  // Text editing controllers to capture real-time input fields values
  final _sitioController = TextEditingController();
  final _passwordController = TextEditingController();
  final _keyusercontroller = TextEditingController();
  bool _obscurePassword = true;

  String _categoriaSeleccionada = 'General';
  final List<String> _categorias = ['General', 'Social media', 'Bank', 'Work'];

  // Releases resource hooks and memory allocations when this view is popped out of the layout tree
  @override
  void dispose() {
    _sitioController.dispose();
    _passwordController.dispose();
    _keyusercontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      appBar: AppBar(title: const Text('New password', style: TextStyle(fontWeight: FontWeight.bold)),
      actions: [themebutton(themeProvider: themeProvider)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _keyusercontroller,
              decoration: const InputDecoration(
                labelText: 'Gmail or Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _sitioController,
              decoration: const InputDecoration(
                labelText: 'Web site or Aplication',
                hintText: 'Ej. Google, Netflix, Youtube',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword, 
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                  onPressed: () {
                    setState(() { _obscurePassword = !_obscurePassword; });
                  },
                )
              ),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _categoriaSeleccionada,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: _categorias.map((String cat) {
                return DropdownMenuItem<String>(
                  value: cat,
                  child: Text(cat),
                );
              }).toList(),
              onChanged: (nuevoValor) {
                setState(() { _categoriaSeleccionada = nuevoValor!; });
              },
            ),
            const SizedBox(height: 32),

            ElevatedButton.icon(
              onPressed: _guardarDatosEnBaseDeDatos,
              icon: const Icon(Icons.save),
              label: const Text('Save password'),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
            ),
          ],
        ),
      ),
    );
  }

  // Validates inputs, converts fields data into an object model, and dispatches it to the password provider
  void _guardarDatosEnBaseDeDatos() async {
    final sitio = _sitioController.text.trim();
    final password = _passwordController.text.trim();
    final categoria = _categoriaSeleccionada;
    final keyuser = _keyusercontroller.text.trim();

    if (sitio.isEmpty || password.isEmpty || keyuser.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, rellena todos los campos')),
      );
      return;
    }

    final nuevoModelo = PasswordModel(
      site: sitio,
      user: keyuser,
      contrasenaEncriptada: password,
      category: categoria, 
    );

    try {
      final passwordProvider = Provider.of<PasswordProvider>(context, listen: false);
      await passwordProvider.ejecutarGuardado(nuevoModelo);

      if (passwordProvider.uiState == PasswordUiState.success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('¡Local storage successful')),
          );
          context.pop(); 
        }
      } else if (passwordProvider.uiState == PasswordUiState.error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(' Local Save succesfully.'),
              duration: const Duration(seconds: 4), 
            ),
          );
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error general: $e')),
        );
      }
    }
  }
}