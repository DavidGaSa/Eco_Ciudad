import 'package:eco_ciudad/calendar.dart';
import 'package:eco_ciudad/recycle.dart';
import 'package:eco_ciudad/statistics.dart';
import 'package:flutter/material.dart';

// Simulación de strings.xml
class AppStrings {
  static const calendar = 'Calendario de Recolección';
  static const map = 'Puntos de Reciclaje';
  static const stats = 'Mis Estadísticas';
}

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MainScreen(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[700],
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido a Eco-Ciudad'),
        centerTitle: true,
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.lightGreen[100], // Fondo verde claro
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'assets/Eco-Ciudad-Logo.png',
                width: 330,
                height: 330,
              ),
              // Espacio uniforme
              // Breve descripción
              const SizedBox(height: 8), // Espacio uniforme
              // Breve descripción
              Center(
                child: SizedBox(
                  width: 400,
                  child: const Text(
                    'El reciclaje es esencial en el ciudado del planeta y la salud de los habitantes. Por eso presentamos Eco-Ciudad, una app para facilitar el reciclaje en tu ciudad al mismo tiempo que te motiva a llevar un control de tu impacto ambiental.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18, color: Colors.black87),
                  ),
                ),
              ),
              const SizedBox(height: 24), // Espacio uniforme
              // Botones
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  ElevatedButton(
                    key: const Key('btnCalendar'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CalendarPage(),
                        ),
                      );
                    },
                    child: Text(AppStrings.calendar),
                  ),
                  ElevatedButton(
                    key: const Key('btnMap'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RecyclePage()),
                      );
                    },
                    child: Text(AppStrings.map),
                  ),
                  ElevatedButton(
                    key: const Key('btnStats'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StatisticsPage(),
                        ),
                      );
                    },
                    child: Text(AppStrings.stats),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
