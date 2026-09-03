import 'package:final_project_desktop/providers/theme_provider.dart';
import 'package:final_project_desktop/repositories/repositories_password.dart';
import 'package:final_project_desktop/widgets/themebotton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../db/app_db.dart';
import '../services/service_locator.dart';

// Main landing screen that displays a divided layout with category navigation and filtered password cards
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final database = locator<AppDatabase>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Manager'),
        actions: [
          themebutton(themeProvider: themeProvider),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add password',
            onPressed: () => context.pushNamed('add-password'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: [
          // Sidebar menu container handling live selection values to filter database queries
          Container(
            width: 240,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              border: Border(right: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.2), width: 1)),
            ),
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              children: [
                _buildSidebarTile(title: 'All', dbValue: 'All', icon: Icons.all_inbox_rounded),
                _buildSidebarTile(title: 'General', dbValue: 'general', icon: Icons.insert_drive_file_outlined),
                _buildSidebarTile(title: 'Social media', dbValue: 'social media', icon: Icons.people_outline_rounded),
                _buildSidebarTile(title: 'Bank', dbValue: 'bank', icon: Icons.account_balance_wallet_outlined),
                _buildSidebarTile(title: 'Work', dbValue: 'work', icon: Icons.business_center_outlined),
              ],
            ),
          ),

          // Reactive data stream consumer that filters list elements and renders password actions
          Expanded(
            child: StreamBuilder<List<DbpasswordData>>(
              stream: database.select(database.dbpassword).watch(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
                }

                final totalList = snapshot.data ?? [];

                final filteredList = _selectedCategory == 'All'
                    ? totalList
                    : totalList.where((item) {
                        return item.Category.toLowerCase().trim() == _selectedCategory.toLowerCase().trim();
                      }).toList();

                if (filteredList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock_open_outlined, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          _selectedCategory == 'All' ? 'There are no passwords here.' : 'There are no passwords in $_selectedCategory.',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final item = filteredList[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        onTap: () {
                          context.pushNamed('details', pathParameters: {'id': item.id.toString()});
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.15)),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                child: Icon(Icons.vpn_key_outlined, color: Theme.of(context).colorScheme.primary),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.site, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    Text(item.userkey, style: TextStyle(fontSize: 14, color: Theme.of(context).hintColor)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(item.Category, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.secondary)),
                              ),
                              const SizedBox(width: 12),
                              
                              IconButton(
                                icon: const Icon(Icons.copy_rounded, size: 20),
                                tooltip: 'Copy plain password',
                                onPressed: () async {
                                  try {
                                    final repository = locator<PasswordRepository>();
                                    final plainPassword = repository.desencriptar(item.password);
                                    await Clipboard.setData(ClipboardData(text: plainPassword));
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('📋 Password copied to clipboard!'), behavior: SnackBarBehavior.floating));
                                    }
                                  } catch (e) {
                                    await Clipboard.setData(ClipboardData(text: item.password));
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined),
                                tooltip: 'Edit credentials',
                                onPressed: () {
                                  context.pushNamed('details', pathParameters: {'id': item.id.toString()});
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
                                tooltip: 'Delete credentials',
                                onPressed: () {
                                  _showDeleteConfirmationDialog(context, database, item.id, item.site);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper builder widget that structures individual sidebar buttons and changes opacity states when active
  Widget _buildSidebarTile({required String title, required String dbValue, required IconData icon}) {
    final isSelected = _selectedCategory == dbValue;
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: InkWell(
        onTap: () { setState(() { _selectedCategory = dbValue; }); },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.primary.withOpacity(0.08) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(icon, color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant, size: 20),
              const SizedBox(width: 14),
              Text(title, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? colorScheme.primary : colorScheme.onSurface, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

  // Opens an alert overlay box asking validation permissions before purging local databases and remote copies
  void _showDeleteConfirmationDialog(BuildContext context, AppDatabase database, int recordId, String targetSite) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Theme.of(context).colorScheme.error),
              const SizedBox(width: 10),
              const Text('Delete password?'),
            ],
          ),
          content: Text('Are you sure you want to delete the credentials for "$targetSite"? This action cannot be undone.', style: const TextStyle(fontSize: 14)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error, foregroundColor: Theme.of(context).colorScheme.onError),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                try {
                  final repository = locator<PasswordRepository>();
                  await repository.eliminarContrasenaCompleta(recordId);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Credentials deleted locally'), behavior: SnackBarBehavior.floating));
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Local save removed.'), duration: const Duration(seconds: 4)));
                  }
                }
              },
              child: const Text('Delete permanently'),
            ),
          ],
        );
      },
    );
  }
}