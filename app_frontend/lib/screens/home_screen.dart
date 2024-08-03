import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora Eléctrica'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/memoria-form');
              },
              child: Text('Memoria de cálculo'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Acción para el botón "Calcular con ITM"
              },
              child: Text('Calcular con ITM'),
            ),
          ],
        ),
      ),
    );
  }
}
