import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/edit_equipo_screen.dart' as edit_equipo;
import 'models/equipo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/edit_equipo') {
          final args = settings.arguments;
          if (args is Equipo) {
            return MaterialPageRoute(
              builder: (context) => edit_equipo.EditEquipoScreen(equipo: args),
            );
          }
        }
        return null;
      },
    );
  }
}
