class DatosEntrada {
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
  double e;

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
    required this.longitud,
    required this.circuito,
    double? e,
  }) : e = e ?? 1.0;

  Map<String, dynamic> toJson() {
    return {
      'voltaje': voltaje,
      'potencia': potencia,
      'fp': fp,
      'tipo_circuito': tipoCircuito,
      'temperatura': temperatura,
      'numero_hilos': numeroHilos,
      'tipo_de_voltaje': tipoDeVoltaje,
      'tipo_de_potencia': tipoDePotencia,
      'factor_ajuste_itm': factorAjusteItm,
      'longitud': longitud,
      'circuito': circuito,
      'e': e,
    };
  }
}