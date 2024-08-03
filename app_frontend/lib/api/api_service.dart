import '../models/datos_entrada.dart';
import 'api_client.dart';

class ApiService {
  final ApiClient apiClient;

  ApiService({required this.apiClient});

  Future<Map<String, dynamic>> calcularCorriente(DatosEntrada datosEntrada) {
    return apiClient.calcularCorriente(datosEntrada);
  }
}
