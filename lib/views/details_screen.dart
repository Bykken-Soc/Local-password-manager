import 'package:final_project_desktop/models/password_model.dart';
import 'package:final_project_desktop/repositories/repositories_password.dart';
import 'package:final_project_desktop/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as d; 
import 'package:final_project_desktop/db/app_db.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart'; 
import '../providers/theme_provider.dart';
import '../widgets/themebotton.dart';

final database = locator<AppDatabase>();
bool _obscurePassword = true;

// Detail and editing screen that pulls existing credential records by ID and processes updates
class DetailsScreen extends StatefulWidget {
  final int id; 

  const DetailsScreen({super.key, required this.id});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final _sitioController = TextEditingController();
  final _passwordController = TextEditingController();
  final _keyusercontroller = TextEditingController();

  String _categoriaSeleccionada = 'General';
  final List<String> _categorias = ['General', 'Social media', 'Bank', 'Work'];

  bool _isDataLoaded = false; 

  // Cleans up system memory hooks and input streams when the view is permanently closed
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
      appBar: AppBar(
        title: const Text(
          'Edit password', 
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [themebutton(themeProvider: themeProvider)],
      ),
      body: FutureBuilder<DbpasswordData?>(
        future: (database.select(database.dbpassword)
              ..where((t) => t.id.equals(widget.id)))
            .getSingleOrNull(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && !_isDataLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error loading data: ${snapshot.error}'));
          }

          final record = snapshot.data;
          if (record == null) {
            return const Center(child: Text('The selected ID was not found.'));
          }

          if (!_isDataLoaded) {
            _sitioController.text = record.site;
            _keyusercontroller.text = record.userkey;
            
            final repository = locator<PasswordRepository>();
            try {
              _passwordController.text = repository.desencriptar(record.password);
            } catch (e) {
              _passwordController.text = record.password;
            }

          if (_categorias.contains(record.Category)) { _categoriaSeleccionada = record.Category; }
            _isDataLoaded = true;
          }

          return Padding(
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
                    labelText: 'Web site or Application',
                    hintText: 'Ej. Google, Netflix, youtube',
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
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,)
                    ,onPressed: (){setState(() {
                      _obscurePassword = !_obscurePassword;
                    });},)
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
                    setState(() {
                      _categoriaSeleccionada = nuevoValor!;
                    });
                  },
                ),
                const SizedBox(height: 32),

                ElevatedButton.icon(
                  onPressed: _actualizarContrasena,
                  icon: const Icon(Icons.update), 
                  label: const Text('Save Changes'),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Packs modified fields into a new data model and fires database updates across infrastructure layers
  void _actualizarContrasena() async {
    final sitio = _sitioController.text.trim();
    final usuario = _keyusercontroller.text.trim();
    final password = _passwordController.text.trim();
    final categoria = _categoriaSeleccionada;

    if (sitio.isEmpty || usuario.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all the fields')),
      );
      return;
    }

    final modeloActualizado = PasswordModel(
      site: sitio,
      user: usuario,
      contrasenaEncriptada: password,
      category: categoria,
    );

    try {
      final repository = locator<PasswordRepository>();
      
      await repository.modificarContrasenaCompleta(widget.id, modeloActualizado);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Up-to-date credentials backed up in the local host')),
        );
        context.pop(); 
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(' Local Save succesfully.'),
              duration: const Duration(seconds: 4), 
            ),
          );
          context.pop();
      }
    }
  }
}