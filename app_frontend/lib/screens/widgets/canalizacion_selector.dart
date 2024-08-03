import 'package:flutter/material.dart';

class CanalizacionSelector extends StatefulWidget {
  final Function(String, String?) onSelectionChanged;
  final String tipoCable;
  final Function(String) onTipoCableChanged;

  const CanalizacionSelector({super.key, 
    required this.onSelectionChanged,
    required this.tipoCable,
    required this.onTipoCableChanged,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CanalizacionSelectorState createState() => _CanalizacionSelectorState();
}

class _CanalizacionSelectorState extends State<CanalizacionSelector> {
  String _tipoCanalizacion = 'Tubería';
  String? _tipoTuberia;

  @override
  void initState() {
    super.initState();
    _tipoTuberia = 'Tubo Pared Delgada';
    widget.onSelectionChanged(_tipoCanalizacion, _tipoTuberia);
  }

  @override
  Widget build(BuildContext context) {
    final Color iconColor = Theme.of(context).primaryColor;
    final Color textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87;
    final TextStyle labelStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold) ?? const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDropdown(
          label: 'Tipo de Canalización',
          value: _tipoCanalizacion,
          items: const <String>['Tubería', 'Charola'],
          onChanged: (String? newValue) {
            setState(() {
              _tipoCanalizacion = newValue!;
              if (_tipoCanalizacion == 'Tubería') {
                _tipoTuberia = 'Tubo Pared Delgada';
              } else {
                _tipoTuberia = null;
              }
              widget.onSelectionChanged(_tipoCanalizacion, _tipoTuberia);
            });
          },
          icon: Icons.settings_input_composite,
          iconColor: iconColor,
          labelStyle: labelStyle,
          textColor: textColor,
        ),
        if (_tipoCanalizacion == 'Tubería')
          _buildDropdown(
            label: 'Tipo de Tubería',
            value: _tipoTuberia,
            items: const <String>[
              'Tubo Pared Delgada',
              'Tubo Pared Gruesa',
              'Tubo de PVC Electrico'
            ],
            onChanged: (String? newValue) {
              setState(() {
                _tipoTuberia = newValue!;
                widget.onSelectionChanged(_tipoCanalizacion, _tipoTuberia);
              });
            },
            icon: Icons.linear_scale, // Usando un ícono diferente
            iconColor: iconColor,
            labelStyle: labelStyle,
            textColor: textColor,
          ),
        const SizedBox(height: 20),
        _buildDropdown(
          label: 'Tipo de Cable',
          value: widget.tipoCable,
          items: const <String>['cobre', 'aluminio'],
          onChanged: (String? newValue) {
            widget.onTipoCableChanged(newValue!);
          },
          icon: Icons.electrical_services,
          iconColor: iconColor,
          labelStyle: labelStyle,
          textColor: textColor,
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
    required Color iconColor,
    required TextStyle labelStyle,
    required Color textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: labelStyle,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          prefixIcon: Icon(icon, color: iconColor),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            onChanged: onChanged,
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(color: textColor)),
              );
            }).toList(),
            style: TextStyle(fontSize: 16, color: textColor),
            icon: Icon(Icons.arrow_drop_down, color: textColor),
          ),
        ),
      ),
    );
  }
}
