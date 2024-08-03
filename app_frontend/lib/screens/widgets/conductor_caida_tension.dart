import 'package:flutter/material.dart';
import 'package:app/screens/calculo_canalizacion_screen/calculo_de_canalizacion_screen.dart';
import 'dart:convert';
import 'dart:io';
import 'package:app/utils/theme.dart'; // Importar el tema

class ConductorCaidaTension extends StatefulWidget {
  final Map<String, dynamic> data;
  final String tipoCanalizacion;
  final String tipoTuberiaDescripcion;
  final int numeroHilos;
  final String tipoConductor; // Agregar la propiedad tipoConductor

  const ConductorCaidaTension({
    super.key,
    required this.data,
    required this.tipoCanalizacion,
    required this.tipoTuberiaDescripcion,
    required this.numeroHilos,
    required this.tipoConductor, // Inicializar la propiedad tipoConductor
  });

  @override
  _ConductorCaidaTensionState createState() => _ConductorCaidaTensionState();
}

class _ConductorCaidaTensionState extends State<ConductorCaidaTension> {
  Future<void> _sendPostRequest(Map<String, dynamic> conductor, String tierraAwg) async {
    final url = Uri.parse('http://127.0.0.1:5000/calcular-tuberia');
    final httpClient = HttpClient();

    final Map<String, dynamic> requestBody = {
      'cable': conductor['awg'],
      'tierra': tierraAwg,
      'numero_de_hilos': widget.numeroHilos,
      'numero_de_circuitos': conductor['numero_de_conductores_por_fase'] ?? 1,
      'tipo_tuberia': widget.tipoTuberiaDescripcion,
      'tipo_conductor': widget.tipoConductor, // Agregar tipo de conductor
    };

    print('Request Body: ${jsonEncode(requestBody)}');

    try {
      final request = await httpClient.postUrl(url);
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json; charset=UTF-8');
      request.write(jsonEncode(requestBody));

      final response = await request.close();

      if (response.statusCode == HttpStatus.ok) {
        final responseBody = await response.transform(utf8.decoder).join();
        final result = jsonDecode(responseBody);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CalculoDeCanalizacionScreen(
              data: result,
              cable: conductor['awg'],
              tierra: tierraAwg,
              numeroDeHilos: widget.numeroHilos,
              numeroDeCircuitos: conductor['numero_de_conductores_por_fase'] ?? 1,
              tipoCanalizacion: widget.tipoCanalizacion,
              tipoTuberia: widget.tipoTuberiaDescripcion,
              tipoConductor: widget.tipoConductor, // Pasar tipo de conductor
            ),
          ),
        );
      } else {
        print('Failed to calculate: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      httpClient.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> conductores = _getConductorData();
    Map<String, dynamic> tierraFisica = _getTierraFisicaData();

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: DataTable(
              columns: const [
                DataColumn(label: Text('AWG')),
                DataColumn(label: Text('Sección (mm²)')),
                DataColumn(label: Text('Número de Fases')),
              ],
              rows: conductores.map((conductor) {
                return DataRow(
                  cells: [
                    DataCell(
                      Text(conductor['awg']),
                      onTap: () {
                        _sendPostRequest(conductor, tierraFisica['awg']);
                      },
                    ),
                    DataCell(
                      Text(conductor['mm'].toString()),
                      onTap: () {
                        _sendPostRequest(conductor, tierraFisica['awg']);
                      },
                    ),
                    DataCell(
                      Text(conductor['numero_de_conductores_por_fase'].toString()),
                      onTap: () {
                        _sendPostRequest(conductor, tierraFisica['awg']);
                      },
                    ),
                  ],
                );
              }).toList()
                ..add(
                  DataRow(
                    cells: [
                      DataCell(
                        Text(
                          tierraFisica['awg'],
                          style: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
                        ),
                      ),
                      DataCell(
                        Text(
                          tierraFisica['mm'].toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
                        ),
                      ),
                      const DataCell(Text('-')),
                    ],
                    color: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return Theme.of(context).colorScheme.primary.withOpacity(0.08);
                        }
                        return secondaryColor.withOpacity(0.2); // Color de fondo para resaltar la fila de Tierra Física
                      },
                    ),
                  ),
                ),
            ),
          ),
        );
      },
    );
  }

  List<dynamic> _getConductorData() {
    Map<String, dynamic> caidaTensionData = widget.data['conductor_caida_de_tension'];

    if (widget.tipoCanalizacion == 'Tubería') {
      return caidaTensionData['tuberia'];
    } else {
      return caidaTensionData['charola'];
    }
  }

  Map<String, dynamic> _getTierraFisicaData() {
    Map<String, dynamic> tierraFisicaData = widget.data['conductor_tierra_fisica'] ?? {};
    return widget.tipoConductor.toLowerCase() == 'cobre'
        ? tierraFisicaData['cobre']
        : tierraFisicaData['aluminio'];
  }
}
