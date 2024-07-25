Entiendo que deseas una estructura clara y organizada para tu proyecto Flutter, especialmente para el formulario que estamos desarrollando. Aquí tienes la estructura de carpetas y archivos recomendada:

### Estructura de Carpetas y Archivos

```plaintext
lib/
│
├── main.dart
│
├── models/
│   └── datos_entrada.dart
│
├── screens/
│   └── form_screen.dart
│
├── utils/
│   └── theme.dart
│
└── widgets/
    └── custom_button.dart
```

### Descripción de los Archivos

1. **`main.dart`**: El punto de entrada de la aplicación.
2. **`models/datos_entrada.dart`**: Archivo que contiene la definición de la clase `DatosEntrada`.
3. **`screens/form_screen.dart`**: Archivo que contiene la implementación de la pantalla del formulario.
4. **`utils/theme.dart`**: Archivo que contiene la definición del tema de la aplicación.
5. **`widgets/custom_button.dart`**: Archivo que contiene la implementación del botón personalizado.

### Contenidos de los Archivos

#### `lib/main.dart`

```dart
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
```

#### `lib/models/datos_entrada.dart`

```dart
import 'package:flutter/material.dart';

class DatosEntrada {
  final double voltaje;
  final double potencia;
  final double fp;
  final String tipoCircuito;
  final double temperatura;
  final int numeroHilos;
  final String tipoDeVoltaje;
  final String tipoDePotencia;
  final String factorAjusteItm;
  final String circuito;
  final double longitud;
  final double? corriente;

  DatosEntrada({
    required this.voltaje,
    required this.potencia,
    required this.fp,
    required this.tipoCircuito,
    required this.temperatura,
    required this.numeroHilos,
    required this.tipoDeVoltaje,
    required this.tipoDePotencia,
    required this.factorAjusteItm,
    required this.circuito,
    this.longitud = 1.0,
    this.corriente,
  });
}
```

#### `lib/screens/form_screen.dart`

```dart
import 'package:flutter/material.dart';
import '../models/datos_entrada.dart';
import '../widgets/custom_button.dart';

class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de texto
  final TextEditingController _voltajeController = TextEditingController();
  final TextEditingController _potenciaController = TextEditingController();
  final TextEditingController _fpController = TextEditingController();
  final TextEditingController _temperaturaController = TextEditingController();
  final TextEditingController _numeroHilosController = TextEditingController();
  final TextEditingController _longitudController = TextEditingController();
  final TextEditingController _corrienteController = TextEditingController();

  // Valores iniciales para los campos de selección
  String _tipoCircuito = 'monofásico';
  String _tipoDeVoltaje = 'V';
  String _tipoDePotencia = 'W';
  String _factorAjusteItm = 'general';
  String _circuito = 'circuitos_derivados';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Captura de datos del formulario
      final datosEntrada = DatosEntrada(
        voltaje: double.parse(_voltajeController.text),
        potencia: double.parse(_potenciaController.text),
        fp: double.parse(_fpController.text),
        tipoCircuito: _tipoCircuito,
        temperatura: double.parse(_temperaturaController.text),
        numeroHilos: int.parse(_numeroHilosController.text),
        tipoDeVoltaje: _tipoDeVoltaje,
        tipoDePotencia: _tipoDePotencia,
        factorAjusteItm: _factorAjusteItm,
        circuito: _circuito,
        longitud: double.tryParse(_longitudController.text) ?? 1,
        corriente: double.tryParse(_corrienteController.text),
      );

      // Imprimir datos en la consola
      print(datosEntrada);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario de Datos'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ingrese voltaje en volts'),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _voltajeController,
                      maxLength: 10,
                      decoration: InputDecoration(
                        hintText: 'Voltaje',
                        border: OutlineInputBorder(),
                        counterText: '',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el voltaje';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: _tipoDeVoltaje,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: ['V', 'KV', 'MV']
                          .map((label) => DropdownMenuItem(
                                child: Text(label),
                                value: label,
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _tipoDeVoltaje = value!;
                        });
                      },
                      style: TextStyle(color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text('Ingrese potencia en watts'),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _potenciaController,
                      maxLength: 10,
                      decoration: InputDecoration(
                        hintText: 'Potencia',
                        border: OutlineInputBorder(),
                        counterText: '',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese la potencia';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: _tipoDePotencia,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: ['W', 'KW', 'MW']
                          .map((label) => DropdownMenuItem(
                                child: Text(label),
                                value: label,
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _tipoDePotencia = value!;
                        });
                      },
                      style: TextStyle(color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text('Ingrese factor de potencia'),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _fpController,
                      maxLength: 10,
                      decoration: InputDecoration(
                        hintText: 'Factor de Potencia',
                        border: OutlineInputBorder(),
                        counterText: '',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el factor de potencia';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: _tipoCircuito,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: ['monofásico', 'bifásico', 'trifásico']
                          .map((label) => DropdownMenuItem(
                                child: Text(label),
                                value: label,
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _tipoCircuito = value!;
                        });
                      },
                      style: TextStyle(color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text('Ingrese temperatura en °C'),
              TextFormField(
                controller: _temperaturaController,
                maxLength: 10,
                decoration: InputDecoration(
                  hintText: 'Temperatura',
                  border: OutlineInputBorder(),
                  counterText: '',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la temperatura';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text('Ingrese número de hilos'),
              TextForm

Field(
                controller: _numeroHilosController,
                maxLength: 10,
                decoration: InputDecoration(
                  hintText: 'Número de Hilos',
                  border: OutlineInputBorder(),
                  counterText: '',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el número de hilos';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text('Ingrese longitud en metros'),
              TextFormField(
                controller: _longitudController,
                maxLength: 10,
                decoration: InputDecoration(
                  hintText: 'Longitud',
                  border: OutlineInputBorder(),
                  counterText: '',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la longitud';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text('Ingrese corriente (opcional)'),
              TextFormField(
                controller: _corrienteController,
                maxLength: 10,
                decoration: InputDecoration(
                  hintText: 'Corriente',
                  border: OutlineInputBorder(),
                  counterText: '',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  // Campo opcional, sin validación obligatoria
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text('Factor de Ajuste ITM'),
              DropdownButtonFormField<String>(
                value: _factorAjusteItm,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: ['general', 'motor', 'aire acondicionado', 'capacitor']
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _factorAjusteItm = value!;
                  });
                },
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              SizedBox(height: 20),
              Text('Circuito'),
              DropdownButtonFormField<String>(
                value: _circuito,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: [
                  'circuitos_derivados',
                  'circuito_alimentadores_secundario',
                  'circuito_alimentadores',
                  'manual'
                ]
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _circuito = value!;
                  });
                },
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomRight,
                child: CustomButton(
                  text: 'Calcular',
                  onPressed: _submitForm,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

#### `lib/widgets/custom_button.dart`

```dart
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  CustomButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).colorScheme.primary, // Color de fondo del botón
        onPrimary: Colors.white, // Color del texto del botón
        textStyle: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Text(text),
    );
  }
}
```

Con esta estructura de carpetas y archivos, tu proyecto estará organizado y el formulario debería funcionar de manera más adecuada y coherente con los requisitos dados. Si tienes alguna otra solicitud o pregunta, no dudes en decírmelo.