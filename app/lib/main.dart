import 'package:flutter/material.dart';
import 'screens/form_screen.dart';
import 'utils/theme.dart'; // Importa el tema personalizado

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulario de Datos',
      theme: appTheme, // Aplica el tema personalizado
      home: FormScreen(),
    );
  }
}
