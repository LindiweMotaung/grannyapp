import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/supabase_service.dart';
import 'screens/splash_screen.dart';
import 'providers/theme_provider.dart';
// import 'screens/ui_preview_screen.dart'; // UI Preview for design mode

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase (with dummy values for UI preview mode)
  await SupabaseService.initialize();
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const ElderCareApp(),
    ),
  );
}

class ElderCareApp extends StatelessWidget {
  const ElderCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Beau Bassin Elderly Care Hostel',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
          theme: ThemeProvider.lightTheme,
          darkTheme: ThemeProvider.darkTheme,
          home: const SplashScreen(), // App starts with splash screen
          // home: const UIPreviewScreen(), // UI DESIGN MODE - Disabled
        );
      },
    );
  }
}
