import 'package:app/screens/widgets/custom_button.dart';
import 'package:app/screens/widgets/dropdown_field.dart';
import 'package:app/screens/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/state/memoria_form_state.dart';

class MemoriaFormScreen extends StatelessWidget {
  const MemoriaFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final memoriaFormState = Provider.of<MemoriaFormState>(context);
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Memoria de cálculo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: InputField(
                      label: 'Voltaje',
                      controller: memoriaFormState.voltajeController,
                      hintText: 'Ingrese voltaje',
                      keyboardType: TextInputType.number,
                      validator: memoriaFormState.validateVoltaje,
                    ),
                  ),
                const  SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: DropdownField(
                      label: 'Tipo',
                      value: memoriaFormState.tipoDeVoltaje,
                      items: const ['V', 'KV', 'MV'],
                      onChanged: (value) {
                        memoriaFormState.tipoDeVoltaje = value!;
                      },
                    ),
                  ),
               const   SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: InputField(
                      label: 'Potencia',
                      controller: memoriaFormState.potenciaController,
                      hintText: 'Ingrese potencia',
                      keyboardType: TextInputType.number,
                      validator: memoriaFormState.validatePotencia,
                    ),
                  ),
                const  SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: DropdownField(
                      label: 'Tipo',
                      value: memoriaFormState.tipoDePotencia,
                      items: const ['W', 'KW', 'MW'],
                      onChanged: (value) {
                        memoriaFormState.tipoDePotencia = value!;
                      },
                    ),
                  ),
                ],
              ),
            const  SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: InputField(
                      label: 'Factor de Potencia',
                      controller: memoriaFormState.fpController,
                      hintText: 'Ingrese factor de potencia',
                      keyboardType: TextInputType.number,
                      validator: memoriaFormState.validateFactorPotencia,
                    ),
                  ),
               const   SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: InputField(
                      label: 'Número de Hilos',
                      controller: memoriaFormState.numeroHilosController,
                      hintText: 'Ingrese número de hilos',
                      keyboardType: TextInputType.number,
                      validator: memoriaFormState.validateNumeroHilos,
                    ),
                  ),
                const  SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: InputField(
                      label: 'Longitud (m)',
                      controller: memoriaFormState.longitudController,
                      hintText: 'Ingrese longitud',
                      keyboardType: TextInputType.number,
                      validator: memoriaFormState.validateLongitud,
                    ),
                  ),
                ],
              ),
           const   SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: InputField(
                      label: 'Temperatura (°C)',
                      controller: memoriaFormState.temperaturaController,
                      hintText: 'Ingrese temperatura',
                      keyboardType: TextInputType.number,
                      validator: memoriaFormState.validateTemperatura,
                    ),
                  ),
                const  SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: DropdownField(
                      label: 'Factor de Ajuste ITM',
                      value: memoriaFormState.factorAjusteItm,
                      items: const ['general', 'motor', 'aire acondicionado', 'capacitor'],
                      onChanged: (value) {
                        memoriaFormState.factorAjusteItm = value!;
                      },
                    ),
                  ),
                ],
              ),
            const  SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: DropdownField(
                      label: 'Circuito',
                      value: memoriaFormState.circuito,
                      items: const [
                        'circuitos_derivados',
                        'circuito_alimentadores_secundario',
                        'circuito_alimentadores',
                        'manual'
                      ],
                      onChanged: (value) {
                        memoriaFormState.actualizarCircuito(value!);
                      },
                    ),
                  ),
                const  SizedBox(width: 8),
                  if (memoriaFormState.mostrarCampoManual)
                    Expanded(
                      flex: 2,
                      child: InputField(
                        label: 'Valor Manual',
                        controller: memoriaFormState.manualController,
                        hintText: 'Ingrese el valor manual',
                        keyboardType: TextInputType.number,
                        validator: memoriaFormState.validateManual,
                      ),
                    ),
                ],
              ),
             const SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomRight,
                child: CustomButton(
                  text: 'Calcular',
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      memoriaFormState.submitForm(formKey, context);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
