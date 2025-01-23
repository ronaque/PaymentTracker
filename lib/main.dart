import 'package:flutter/material.dart';
import 'package:payment_tracker/src/home/home_page.dart';
import 'package:payment_tracker/src/month/month_page.dart';
import 'package:payment_tracker/src/resumo/resumo_page.dart';
import 'package:payment_tracker/src/profile/profile_page.dart';
import 'package:payment_tracker/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp()); // Directly run MyApp
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getAppTheme(), // Define theme here
      initialRoute: '/home',
      routes: {
        '/home': (context) => const Home(),
        '/mes': (context) => Month(DateTime.now()),
        '/perfil': (context) => const Profile(),
        '/resumo': (context) => const Resumo(),
      },
    );
  }
}
