import 'package:flutter/material.dart';
import 'package:knownbase/shared/buttons/action_button_demo.dart';
import 'core/services/dependency_injection.dart';
import 'core/services/supabase_config.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await SupabaseConfig.initialize();
  
  // Setup dependency injection
  await setupDependencies();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KnownBase',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const ActionButtonDemo(),
    );
  }
}
