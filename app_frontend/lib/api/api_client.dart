import 'dart:convert';
import 'dart:io';
import '../models/datos_entrada.dart';

class ApiClient {
  final String baseUrl;

  ApiClient({required this.baseUrl});

  Future<Map<String, dynamic>> calcularCorriente(DatosEntrada datosEntrada) async {
    final url = Uri.parse('$baseUrl/calcular');
    final httpClient = HttpClient();

    try {
      final request = await httpClient.postUrl(url);
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json; charset=UTF-8');

      final Map<String, dynamic> body = datosEntrada.toJson();

      request.write(jsonEncode(body));

      final response = await request.close();

      if (response.statusCode == HttpStatus.ok) {
        final responseBody = await response.transform(utf8.decoder).join();

        try {
          final resultados = jsonDecode(responseBody);

          if (resultados['error'] != null) {
            throw HttpException('API Error: ${resultados['error']}', uri: url);
          }

          return resultados;
        } catch (e) {
          throw HttpException('Error decoding response: $e', uri: url);
        }
      } else {
        throw HttpException('Failed to calculate corriente: ${response.statusCode}', uri: url);
      }
    } catch (e) {
      throw HttpException('Error: $e', uri: url);
    } finally {
      httpClient.close();
    }
  }
}
