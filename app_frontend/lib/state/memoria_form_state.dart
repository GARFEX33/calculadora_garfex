import 'package:app/screens/seleccionar_cable_screen/seleccionar_cable_screen.dart';
import 'package:app/state/SeleccionarCableState.dart';
import 'package:flutter/material.dart';
import 'package:app/api/api_service.dart';
import 'package:app/models/datos_entrada.dart';
import 'package:provider/provider.dart';

class MemoriaFormState with ChangeNotifier {
  final ApiService apiService;
  final TextEditingController voltajeController;
  final TextEditingController potenciaController;
  final TextEditingController fpController;
  final TextEditingController temperaturaController;
  final TextEditingController numeroHilosController;
  final TextEditingController longitudController;
  final TextEditingController manualController;

  String tipoCircuito = 'trifasico';
  String tipoDeVoltaje = 'V';
  String tipoDePotencia = 'KW';
  String factorAjusteItm = 'capacitor';
  String circuito = 'manual';
  bool mostrarCampoManual = true; // Nueva variable de estado

  MemoriaFormState({required this.apiService})
      : voltajeController = TextEditingController(text: '220'),
        potenciaController = TextEditingController(text: '100'),
        fpController = TextEditingController(text: '1.0'),
        temperaturaController = TextEditingController(text: '30'),
        numeroHilosController = TextEditingController(text: '3'),
        longitudController = TextEditingController(text: '10'),
        manualController = TextEditingController(text: '3.0');

  void actualizarCircuito(String nuevoCircuito) {
    circuito = nuevoCircuito;
    mostrarCampoManual = (circuito == 'manual');
    notifyListeners();
  }

  Future<void> sendRequest(BuildContext context, DatosEntrada datosEntrada) async {
    try {
      final resultados = await apiService.calcularCorriente(datosEntrada);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
              create: (_) => SeleccionarCableState(
                data: resultados,
                voltaje: datosEntrada.voltaje,
                potencia: datosEntrada.potencia,
                fp: datosEntrada.fp,
                tipoCircuito: datosEntrada.tipoCircuito,
                temperatura: datosEntrada.temperatura,
                numeroHilos: datosEntrada.numeroHilos,
                tipoDeVoltaje: datosEntrada.tipoDeVoltaje,
                tipoDePotencia: datosEntrada.tipoDePotencia,
                factorAjusteItm: datosEntrada.factorAjusteItm,
                longitud: datosEntrada.longitud,
                circuito: datosEntrada.circuito,
                e: datosEntrada.e,
              ),
              child: SeleccionarCableScreen(),
            ),
          ),
        );
      });
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  void submitForm(GlobalKey<FormState> formKey, BuildContext context) {
    if (formKey.currentState!.validate()) {
      final double eValue = mostrarCampoManual ? double.parse(manualController.text) : 1.0;

      final datosEntrada = DatosEntrada(
        voltaje: double.parse(voltajeController.text),
        potencia: double.parse(potenciaController.text),
        fp: double.parse(fpController.text),
        tipoCircuito: tipoCircuito,
        temperatura: int.parse(temperaturaController.text),
        numeroHilos: int.parse(numeroHilosController.text),
        tipoDeVoltaje: tipoDeVoltaje,
        tipoDePotencia: tipoDePotencia,
        factorAjusteItm: factorAjusteItm,
        longitud: double.tryParse(longitudController.text) ?? 1.0,
        circuito: circuito,
        e: eValue,
      );

      sendRequest(context, datosEntrada);
    }
  }

  String? validateVoltaje(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese el voltaje';
    }
    final doubleValue = double.tryParse(value);
    if (doubleValue == null || doubleValue <= 0) {
      return 'El voltaje debe ser mayor que 0';
    }
    return null;
  }

  String? validatePotencia(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese la potencia';
    }
    final doubleValue = double.tryParse(value);
    if (doubleValue == null || doubleValue <= 0) {
      return 'La potencia debe ser mayor que 0';
    }
    return null;
  }

  String? validateFactorPotencia(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese el factor de potencia';
    }
    final doubleValue = double.tryParse(value);
    if (doubleValue == null || doubleValue <= 0 || doubleValue > 1) {
      return 'El factor de potencia debe ser mayor de 0 y menor a 1';
    }
    return null;
  }

  String? validateTemperatura(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese la temperatura';
    }
    final intValue = int.tryParse(value);
    if (intValue == null || intValue < 0) {
      return 'La temperatura debe ser un valor positivo';
    }
    return null;
  }

  String? validateNumeroHilos(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese el número de hilos';
    }
    final intValue = int.tryParse(value);
    if (intValue == null || intValue <= 0) {
      return 'El número de hilos debe ser mayor que 0';
    }
    return null;
  }

  String? validateLongitud(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese la longitud';
    }
    final doubleValue = double.tryParse(value);
    if (doubleValue == null || doubleValue <= 0) {
      return 'La longitud debe ser mayor que 0';
    }
    return null;
  }

  String? validateManual(String? value) {
    if (!mostrarCampoManual) return null;
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese el valor manual';
    }
    final doubleValue = double.tryParse(value);
    if (doubleValue == null || doubleValue <= 0 || doubleValue > 5) {
      return 'El valor manual debe ser mayor de 0 y menor a 5';
    }
    return null;
  }
}
