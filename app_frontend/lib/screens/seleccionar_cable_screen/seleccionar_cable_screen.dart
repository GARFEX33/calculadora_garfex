import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/state/SeleccionarCableState.dart';
import 'package:app/screens/widgets/canalizacion_selector.dart';
import 'package:app/screens/widgets/circuit_info.dart';
import 'package:app/screens/widgets/conductor_caida_tension.dart';
import 'package:app/screens/widgets/conductor_capacidad_conduccion.dart';
import 'package:app/utils/theme.dart'; // Importar el tema

class SeleccionarCableScreen extends StatelessWidget {
  const SeleccionarCableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final seleccionarCableState = Provider.of<SeleccionarCableState>(context);

    final Map<String, dynamic> data = seleccionarCableState.data;

    final double corrienteNominal = data['corriente_nominal'] ?? 0.0;
    final double corrienteAjustada = data['interruptor']?['corriente_ajustada'] ?? 0.0;
    final String interruptor = '${data['interruptor']?['interruptor'] ?? 'N/A'} A';
    final double corrientePorCapacidadDeConduccion = data['conductor_capacidad_de_conduccion']?['datos_capacidad_de_conduccion']?['corriente_por_capacidad_de_conduccion'] ?? 0.0;
    final double factorAjusteAgrupamiento = data['conductor_capacidad_de_conduccion']?['datos_capacidad_de_conduccion']?['factor_ajuste_agrupamiento'] ?? 0.0;
    final double factorAjusteTemperatura = data['conductor_capacidad_de_conduccion']?['datos_capacidad_de_conduccion']?['factor_ajuste_temperatura'] ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Cable'),
      ),
      body:  Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                context,
                child: CircuitInfo(
                  potencia: seleccionarCableState.potencia,
                  corrienteNominal: corrienteNominal,
                  corrienteAjustada: corrienteAjustada,
                  interruptor: interruptor,
                  voltage: seleccionarCableState.voltaje,
                  powerFactor: seleccionarCableState.fp,
                  caidaTension: seleccionarCableState.e,
                  longitud: seleccionarCableState.longitud,
                  tipoDeVoltaje: seleccionarCableState.tipoDeVoltaje,
                  tipoDePotencia: seleccionarCableState.tipoDePotencia,
                  corrientePorCapacidadDeConduccion: corrientePorCapacidadDeConduccion,
                  factorAjusteAgrupamiento: factorAjusteAgrupamiento,
                  factorAjusteTemperatura: factorAjusteTemperatura,
                  tipoCircuito: seleccionarCableState.tipoCircuito,
                ),
              ),
              Center(
                child: _buildSection(
                  context,
                  title: 'Configuración de Canalización y Tipo de Cable',
                  short: true, // Añadimos una propiedad para hacer la tarjeta más corta
                  child: CanalizacionSelector(
                    onSelectionChanged: seleccionarCableState.onSelectionChanged,
                    tipoCable: seleccionarCableState.tipoCable,
                    onTipoCableChanged: seleccionarCableState.setTipoCable,
                  ),
                ),
              ),
              _buildSection(
                context,
                title: 'Conductor Capacidad de Conducción',
                child: ConductorCapacidadConduccion(
                  data: seleccionarCableState.data,
                  tipoCanalizacion: seleccionarCableState.tipoCanalizacion,
                  tipoConductor: seleccionarCableState.tipoCable,
                  tipoTuberiaDescripcion: seleccionarCableState.tipoTuberiaDescripcion,
                  numeroHilos: seleccionarCableState.numeroHilos,
                ),
              ),
              _buildSection(
                context,
                title: 'Conductor Caída de Tensión',
                child: ConductorCaidaTension(
                  data: seleccionarCableState.data,
                  tipoCanalizacion: seleccionarCableState.tipoCanalizacion,
                  tipoTuberiaDescripcion: seleccionarCableState.tipoTuberiaDescripcion,
                  numeroHilos: seleccionarCableState.numeroHilos,
                  tipoConductor: seleccionarCableState.tipoCable, // Pasar el tipo de conductor
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildSection(BuildContext context, {String? title, required Widget child, bool short = false}) {
    return Container(
      width: short ? 600 : double.infinity, // Ajustar el ancho según la propiedad short
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor, // Usar el color de fondo del tema
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5.0, // Menor blurRadius para una sombra más sutil
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Center( // Centrar el título
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20, // Título más grande
                    color: primaryColor, // Usar el color primario del tema
                  ),
                ),
              ),
            ),
          child,
        ],
      ),
    );
  }
}
