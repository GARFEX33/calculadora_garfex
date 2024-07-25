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
