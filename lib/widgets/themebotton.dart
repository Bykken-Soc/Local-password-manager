import 'package:final_project_desktop/views/add_passwords.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

// Stateless navigation bar component handling user action triggers to change application visual modes
class themebutton extends StatelessWidget {
  const themebutton({
    super.key,
    required this.themeProvider,
  });

  final ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return IconButton(
      icon: Icon(
        themeProvider.isLightTheme 
            ? Icons.dark_mode_rounded 
            : Icons.light_mode_rounded, 
      ),
      tooltip: themeProvider.isLightTheme 
          ? 'Change to dark mode' 
          : 'Change to light mode',
      onPressed: () {
        themeProvider.toggleTheme();
      },
    );
  }
}