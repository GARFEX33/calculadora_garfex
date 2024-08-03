import 'package:flutter/material.dart';
import 'package:app/utils/theme.dart'; // Importar el tema

class CircuitInfo extends StatelessWidget {
  final double potencia;
  final double corrienteNominal;
  final double corrienteAjustada;
  final String interruptor;
  final double voltage;
  final double powerFactor;
  final double caidaTension;
  final double longitud;
  final String tipoDeVoltaje;
  final String tipoDePotencia;
  final double corrientePorCapacidadDeConduccion;
  final double factorAjusteAgrupamiento;
  final double factorAjusteTemperatura;
  final String tipoCircuito;

  CircuitInfo({
    required this.potencia,
    required this.corrienteNominal,
    required this.corrienteAjustada,
    required this.interruptor,
    required this.voltage,
    required this.powerFactor,
    required this.caidaTension,
    required this.longitud,
    required this.tipoDeVoltaje,
    required this.tipoDePotencia,
    required this.corrientePorCapacidadDeConduccion,
    required this.factorAjusteAgrupamiento,
    required this.factorAjusteTemperatura,
    required this.tipoCircuito,
  });

  int _convertTipoCircuito(String tipoCircuito) {
    switch (tipoCircuito) {
      case 'monofasico':
        return 1;
      case 'bifasico':
        return 2;
      case 'trifasico':
        return 3;
      default:
        return 1; // default to monofasico if not recognized
    }
  }

  @override
  Widget build(BuildContext context) {
    final int tipoCircuitoNumero = _convertTipoCircuito(tipoCircuito);
    final String interruptorTexto = 'Interruptor seleccionado: $tipoCircuitoNumero X $interruptor';
    final Color iconColor = Theme.of(context).primaryColor;
    final Color textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87;
    final Color titleColor = Theme.of(context).textTheme.headlineSmall?.color ?? Colors.blueGrey;

    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Información del Circuito',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: titleColor,
            ),
          ),
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildCircuitInfoColumn(
                  [
                    ['Voltage:', '$voltage $tipoDeVoltaje', Icons.electrical_services],
                    ['Potencia:', '$potencia $tipoDePotencia', Icons.flash_on],
                    ['Corriente Nominal:', '$corrienteNominal A', Icons.electric_bolt],
                    ['Corriente ajustada para seleccion ITM:', '$corrienteAjustada A', Icons.adjust],
                    ['Corriente por capacidad de conducción:', '$corrientePorCapacidadDeConduccion A', Icons.speed],
                  ],
                  iconColor,
                  textColor,
                ),
              ),
            const  SizedBox(width: 20),
              Expanded(
                child: _buildCircuitInfoColumn(
                  [
                    ['Power factor:', '$powerFactor', Icons.power],
                    ['Caída de tensión seleccionada:', '$caidaTension %', Icons.trending_down],
                    ['Longitud (L):', '$longitud m', Icons.straighten],
                    ['Factor ajuste agrupamiento:', '$factorAjusteAgrupamiento', Icons.group],
                    ['Factor ajuste temperatura:', '$factorAjusteTemperatura', Icons.thermostat],
                  ],
                  iconColor,
                  textColor,
                ),
              ),
            ],
          ),
         const SizedBox(height: 20),
          Center(
            child: Text(
              interruptorTexto,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: secondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircuitInfoColumn(List<List<dynamic>> info, Color iconColor, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: info.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            children: [
              Icon(
                item[2],
                color: iconColor,
                size: 24,
              ),
             const SizedBox(width: 10),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 18, color: textColor),
                    children: [
                      TextSpan(
                        text: item[0],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ' ${item[1]}',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
