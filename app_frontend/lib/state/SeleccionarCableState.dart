import 'package:flutter/material.dart';

class SeleccionarCableState with ChangeNotifier {
  final Map<String, dynamic> data;
  final double voltaje;
  final double potencia;
  final double fp;
  final String tipoCircuito;
  final int temperatura;
  final int numeroHilos;
  final String tipoDeVoltaje;
  final String tipoDePotencia;
  final String factorAjusteItm;
  final double longitud;
  final String circuito;
  final double e;
  // Añadimos las propiedades necesarias para el estado
  String tipoCanalizacion = 'Tubería';
  String tipoTuberiaDescripcion = 'TUBO ACERO TIPO EMT ART 358 PARED DELGADA ETIQUETA VERDE';
  String tipoCable = 'cobre'; 

  SeleccionarCableState({
    required this.data,
    required this.voltaje,
    required this.potencia,
    required this.fp,
    required this.tipoCircuito,
    required this.temperatura,
    required this.numeroHilos,
    required this.tipoDeVoltaje,
    required this.tipoDePotencia,
    required this.factorAjusteItm,
    required this.longitud,
    required this.circuito,
    required this.e,
  });

  void onSelectionChanged(String canalizacion, String? tuberiaDescripcion) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      tipoCanalizacion = canalizacion;
      tipoTuberiaDescripcion = _getTuberiaDescripcion(tuberiaDescripcion);
      notifyListeners();
    });
  }

  String _getTuberiaDescripcion(String? tuberia) {
    switch (tuberia) {
      case 'Tubo Pared Delgada':
        return 'TUBO ACERO TIPO EMT ART 358 PARED DELGADA ETIQUETA VERDE';
      case 'Tubo Pared Gruesa':
        return 'TUBO ACERO TIPO RMC (CED 40) ART 344, PESADA ETIQUETA NARANJA';
      case 'Tubo de PVC Electrico':
        return 'TUBO TIPO PVC CED 40 ART 352 y 353';
      default:
        return 'TUBO ACERO TIPO EMT ART 358 PARED DELGADA ETIQUETA VERDE';
    }
  }

  void setTipoCable(String tipo) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      tipoCable = tipo;
      notifyListeners();
    });
  }
}
