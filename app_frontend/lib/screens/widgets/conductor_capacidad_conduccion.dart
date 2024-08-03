import 'package:flutter/material.dart';
import 'package:app/screens/calculo_canalizacion_screen/calculo_de_canalizacion_screen.dart';
import 'dart:convert';
import 'dart:io';
import 'package:app/utils/theme.dart'; // Importar el tema

class ConductorCapacidadConduccion extends StatefulWidget {
  final Map<String, dynamic> data;
  final String tipoCanalizacion;
  final String tipoConductor;
  final String tipoTuberiaDescripcion;
  final int numeroHilos;

  const ConductorCapacidadConduccion({super.key, 
    required this.data,
    required this.tipoCanalizacion,
    required this.tipoConductor,
    required this.tipoTuberiaDescripcion,
    required this.numeroHilos,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ConductorCapacidadConduccionState createState() => _ConductorCapacidadConduccionState();
}

class _ConductorCapacidadConduccionState extends State<ConductorCapacidadConduccion> {
  late ConductorCapacidadConduccionLogic _logic;

  @override
  void initState() {
    super.initState();
    _logic = ConductorCapacidadConduccionLogic(
      context: context,
      data: widget.data,
      tipoCanalizacion: widget.tipoCanalizacion,
      tipoConductor: widget.tipoConductor,
      tipoTuberiaDescripcion: widget.tipoTuberiaDescripcion,
      numeroHilos: widget.numeroHilos,
    );
  }

  @override
  void didUpdateWidget(covariant ConductorCapacidadConduccion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tipoCanalizacion != widget.tipoCanalizacion ||
        oldWidget.tipoConductor != widget.tipoConductor ||
        oldWidget.data != widget.data) {
      _logic = ConductorCapacidadConduccionLogic(
        context: context,
        data: widget.data,
        tipoCanalizacion: widget.tipoCanalizacion,
        tipoConductor: widget.tipoConductor,
        tipoTuberiaDescripcion: widget.tipoTuberiaDescripcion,
        numeroHilos: widget.numeroHilos,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> conductores = _logic.getConductorData();
    Map<String, dynamic> tierraFisica = _logic.getTierraFisicaData();

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
                DataColumn(label: Text('Corriente Máxima (A)')),
                DataColumn(label: Text('Número de Fases')),
                DataColumn(label: Text('Tabla Norma')),
              ],
              rows: conductores.map((conductor) {
                print(conductor);
                return DataRow(
                  cells: [
                    DataCell(
                      Text(conductor['awg']),
                      onTap: () {
                        if (widget.tipoCanalizacion == 'Tubería') {
                          _logic.sendPostRequest(conductor, tierraFisica['awg']);
                        } else {
                          _logic.sendCharolaPostRequest(conductor, tierraFisica['awg']);
                        }
                      },
                    ),
                    DataCell(
                      Text(conductor['mm'].toString()),
                      onTap: () {
                        if (widget.tipoCanalizacion == 'Tubería') {
                          _logic.sendPostRequest(conductor, tierraFisica['awg']);
                        } else {
                          _logic.sendCharolaPostRequest(conductor, tierraFisica['awg']);
                        }
                      },
                    ),
                    DataCell(
                      Text(conductor['corriente_maxima'].toString()),
                      onTap: () {
                        if (widget.tipoCanalizacion == 'Tubería') {
                          _logic.sendPostRequest(conductor, tierraFisica['awg']);
                        } else {
                          _logic.sendCharolaPostRequest(conductor, tierraFisica['awg']);
                        }
                      },
                    ),
                    DataCell(
                      Text(conductor['numero_de_conductores_por_fase'].toString()),
                      onTap: () {
                        if (widget.tipoCanalizacion == 'Tubería') {
                          _logic.sendPostRequest(conductor, tierraFisica['awg']);
                        } else {
                          _logic.sendCharolaPostRequest(conductor, tierraFisica['awg']);
                        }
                      },
                    ),
                    DataCell(
                      Text(conductor['tabla_nom']),
                      onTap: () {
                        if (widget.tipoCanalizacion == 'Tubería') {
                          _logic.sendPostRequest(conductor, tierraFisica['awg']);
                        } else {
                          _logic.sendCharolaPostRequest(conductor, tierraFisica['awg']);
                        }
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
                      const DataCell(Text('-')),
                      const DataCell(
                        Text(
                          'Tierra Física',
                          style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
                        ),
                      ),
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
}

class ConductorCapacidadConduccionLogic {
  final BuildContext context;
  final Map<String, dynamic> data;
  final String tipoCanalizacion;
  final String tipoConductor;
  final String tipoTuberiaDescripcion;
  final int numeroHilos;

  ConductorCapacidadConduccionLogic({
    required this.context,
    required this.data,
    required this.tipoCanalizacion,
    required this.tipoConductor,
    required this.tipoTuberiaDescripcion,
    required this.numeroHilos,
  });

  Future<void> sendPostRequest(Map<String, dynamic> conductor, String tierraAwg) async {
    final url = Uri.parse('http://127.0.0.1:5000/calcular-tuberia');
    final httpClient = HttpClient();

    final Map<String, dynamic> requestBody = {
      'cable': conductor['awg'],
      'tierra': tierraAwg,
      'numero_de_hilos': numeroHilos,
      'numero_de_circuitos': conductor['numero_de_conductores_por_fase'] ?? 1,
      'tipo_tuberia': tipoTuberiaDescripcion,
      'tipo_conductor': tipoConductor, // Agregar tipo de conductor
    };

    try {
      print("body: $requestBody");
      final request = await httpClient.postUrl(url);
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json; charset=UTF-8');
      request.write(jsonEncode(requestBody));

      final response = await request.close();

      final responseBody = await response.transform(utf8.decoder).join(); // Capturar la respuesta
      if (response.statusCode == HttpStatus.ok) {
        final result = jsonDecode(responseBody);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CalculoDeCanalizacionScreen(
              data: result,
              cable: conductor['awg'],
              tierra: tierraAwg,
              numeroDeHilos: numeroHilos,
              numeroDeCircuitos: conductor['numero_de_conductores_por_fase'] ?? 1,
              tipoCanalizacion: tipoCanalizacion,
              tipoTuberia: tipoTuberiaDescripcion,
              tipoConductor: tipoConductor, // Pasar tipo de conductor
            ),
          ),
        );
      } else {
        print('Failed to calculate: ${response.statusCode}');
        print('Response Body: $responseBody'); // Imprimir el cuerpo de la respuesta en caso de error
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      httpClient.close();
    }
  }

  Future<void> sendCharolaPostRequest(Map<String, dynamic> conductor, String tierraAwg) async {
    final url = Uri.parse('http://127.0.0.1:5000/calcular-charola');
    final httpClient = HttpClient();

    final Map<String, dynamic> requestBody = {
      'cable': conductor['awg'],
      'tierra': tierraAwg,
      'numero_de_hilos': numeroHilos,
      'numero_de_circuitos': conductor['numero_de_conductores_por_fase'] ?? 1,
      'tipo_conductor': tipoConductor, // Agregar tipo de conductor
    };

    try {
      final request = await httpClient.postUrl(url);
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json; charset=UTF-8');
      request.write(jsonEncode(requestBody));

      final response = await request.close();

      final responseBody = await response.transform(utf8.decoder).join(); // Capturar la respuesta
      if (response.statusCode == HttpStatus.ok) {
        final result = jsonDecode(responseBody);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CalculoDeCanalizacionScreen(
              data: result,
              cable: conductor['awg'],
              tierra: tierraAwg,
              numeroDeHilos: numeroHilos,
              numeroDeCircuitos: conductor['numero_de_conductores_por_fase'] ?? 1,
              tipoCanalizacion: tipoCanalizacion,
              tipoTuberia: tipoTuberiaDescripcion,
              tipoConductor: tipoConductor, // Pasar tipo de conductor
            ),
          ),
        );
      } else {
        print('Failed to calculate: ${response.statusCode}');
        print('Response Body: $responseBody'); // Imprimir el cuerpo de la respuesta en caso de error
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      httpClient.close();
    }
  }

  List<dynamic> getConductorData() {
    Map<String, dynamic> conduccionData = data['conductor_capacidad_de_conduccion'];
    
    if (tipoCanalizacion == 'Tubería') {
      return tipoConductor.toLowerCase() == 'cobre'
          ? conduccionData['tuberia']['cobre']
          : conduccionData['tuberia']['aluminio'];
    } else {
      return tipoConductor.toLowerCase() == 'cobre'
          ? conduccionData['charola']['cobre']
          : conduccionData['charola']['aluminio'];
    }
  }

  Map<String, dynamic> getTierraFisicaData() {
    Map<String, dynamic> tierraFisicaData = data['conductor_tierra_fisica'] ?? {};
    return tipoConductor.toLowerCase() == 'cobre'
        ? tierraFisicaData['cobre']
        : tierraFisicaData['aluminio'];
  }
}
