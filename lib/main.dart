import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmint/screens/splash_screen.dart';
import 'package:taskmint/services/app_provider.dart';
import 'package:taskmint/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appProvider = AppProvider();
  await appProvider.init();

  runApp(
    ChangeNotifierProvider(
      create: (_) => appProvider,
      child: const TaskMintApp(),
    ),
  );
}

class TaskMintApp extends StatelessWidget {
  const TaskMintApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return MaterialApp(
          title: 'TaskMint',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const SplashScreen(),
        );
      },
    );
  }
}
