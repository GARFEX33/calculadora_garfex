import 'package:app/screens/home_screen.dart';
import 'package:app/screens/memoria_form_screen/memoria_form_screen.dart';
import 'package:flutter/material.dart';


class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/memoria-form':
        return MaterialPageRoute(builder: (_) => MemoriaFormScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Ruta no definida para ${settings.name}'),
            ),
          ),
        );
    }
  }
}
