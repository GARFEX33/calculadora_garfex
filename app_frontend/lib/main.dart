import 'package:app/state/memoria_form_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/routers/app_router.dart';
import 'utils/theme.dart';
import 'api/api_client.dart';
import 'api/api_service.dart';

void main() {
  final ApiService apiService = ApiService(apiClient: ApiClient(baseUrl: 'http://127.0.0.1:5000'));
  runApp(
    ChangeNotifierProvider(
      create: (context) => MemoriaFormState(apiService: apiService),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora Eléctrica',
      theme: appTheme,
      home: HomeScreen(),
      initialRoute: '/',
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
