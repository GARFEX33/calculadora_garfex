import 'package:app/utils/theme.dart';
import 'package:flutter/material.dart';

class CalculoDeCanalizacionScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  final String cable;
  final String tierra;
  final int numeroDeHilos;
  final int numeroDeCircuitos;
  final String tipoCanalizacion;
  final String tipoTuberia;
  final String tipoConductor; // Agregar la propiedad tipoConductor

  const CalculoDeCanalizacionScreen({super.key, 
    required this.data,
    required this.cable,
    required this.tierra,
    required this.numeroDeHilos,
    required this.numeroDeCircuitos,
    required this.tipoCanalizacion,
    required this.tipoTuberia,
    required this.tipoConductor, // Inicializar la propiedad tipoConductor
  });

  @override
  Widget build(BuildContext context) {
    bool isTuberia = tipoCanalizacion == 'Tubería';
    final Color iconColor = Theme.of(context).primaryColor;
    final Color textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87;
    final Color titleColor = Theme.of(context).textTheme.headlineSmall?.color ?? Colors.blueGrey;
    final String circuitoTexto = isTuberia ? 'Circuito: $numeroDeCircuitos- $numeroDeHilos-$cable awg -$tierra d -T${data['TUBERIA']['DESIGNACION METRICA']}mm' : 'Circuito $numeroDeCircuitos- $numeroDeHilos-$cable awg -$tierra d - CH-${data['CHAROLA']['CHAROLA']}"';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cálculo de Canalización'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildInfoCard(
              'Datos de Entrada',
              [
                ['Cable:', cable, Icons.cable],
                ['Tierra:', tierra, Icons.public],
                ['Número de Hilos:', '$numeroDeHilos', Icons.straighten],
                ['Número de Circuitos:', '$numeroDeCircuitos', Icons.autorenew],
                ['Tipo de Conductor:', tipoConductor, Icons.electrical_services], // Mostrar tipoConductor
                if (isTuberia) ['Tipo de Tubería:', tipoTuberia, Icons.settings_input_component],
              ],
              iconColor,
              textColor,
              titleColor,
            ),
          const   SizedBox(height: 20),
                          Center(
            child: Text(
              circuitoTexto,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: secondaryColor,
              ),
            ),
          ), 
          const SizedBox(height: 20),
           
            _buildInfoCard(
              'Resultados',
              [
                if (isTuberia) ...[
                  ['Área Total por Circuito:', '${data['AREA TOTAL POR CIRCUITO']} mm²', Icons.area_chart],

                  ['Tipo de Tubería:', '${data['TUBERIA']['TIPO DE TUBERIA']}', Icons.settings_input_component],
                  ['AL 40:', '${data['TUBERIA']['AL 40']} mm²', Icons.adjust],
                  ['Designación Métrica:', '${data['TUBERIA']['DESIGNACION METRICA']} mm', Icons.code],
                  ['Pulgadas:', '${data['TUBERIA']['PULGADAS']}"', Icons.straighten],
                ] else ...[
                  ['Arreglo:', '${data['ARREGLO']}', Icons.grid_on],
                  ['Diámetro Total:', '${data['DIAMETRO TOTAL']} mm', Icons.circle],
                  ['Ancho (mm):', '${data['CHAROLA']['MM']} mm', Icons.straighten],
                  ['Charola:', '${data['CHAROLA']['CHAROLA']}"', Icons.settings_input_component],

                ],
              ],
              iconColor,
              textColor,
              titleColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<List<dynamic>> info, Color iconColor, Color textColor, Color titleColor) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 10),
            Column(
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
            ),
          ],
        ),
      ),
    );
  }
}
