import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> resultados;

  ResultScreen({required this.resultados});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultados'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('CALCULO DE LA CORRIENTE NOMINAL: ${resultados['corriente_nominal']}A'),
            Text('CÁLCULO DEL INTERRUPTOR TERMOMAGNETICO : ${resultados['corriente_ajustada']}A'),
            Text('INTERRUPTOR SELECCIONADO: ${resultados['itm']['tipo_circuito']} X ${resultados['itm']['interruptor']}A'),
            
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CAPACIDAD DE CONDUCCIÓN',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: resultados['capacidad_conduccion'].length,
                        itemBuilder: (context, index) {
                          final item = resultados['capacidad_conduccion'][index];
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${item[0]}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    '${item[1]}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 8),
                                  Text('Hilos por Fase: ${item[2]}'),
                                  Text('AWG: ${item[3]}'),
                                  Text('mm: ${item[4]} mm'),
                                  Text('Amperaje: ${item[5]}A'),
                                  Text('Temperatura: ${item[6]}'),
                                  Text('Referencia: ${item[7]}'),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CAÍDA DE TENSIÓN',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: resultados['caida_tension'].length,
                        itemBuilder: (context, index) {
                          final item = resultados['caida_tension'][index];
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Conductor Seleccionado: ${item[1]}'),
                                  Text('mm: ${item[2]}mm'),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
