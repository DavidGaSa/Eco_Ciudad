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
        title: const Text(' Bienvenido a Eco-Ciudad'),
        centerTitle: true,
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 32),
              Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            ElevatedButton(
              key: const Key('btnCalendar'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Scaffold(
                    appBar: AppBar(title: const Text('Calendario de Recolección')), 
                    body: const Center(child: Text('Aquí va el calendario')),
                  )),
                );
              },
              child: Text(AppStrings.calendar),
            ),
            ElevatedButton(
              key: const Key('btnMap'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Scaffold(
                    appBar: AppBar(title: const Text('Puntos de Reciclaje')), 
                    body: const Center(child: Text('Aquí van los puntos de reciclaje')),
                  )),
                );
              },
              child: Text(AppStrings.map),
            ),
            ElevatedButton(
              key: const Key('btnStats'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Scaffold(
                    appBar: AppBar(title: const Text('Puntos de Reciclaje')), 
                    body: const Center(child: Text('Aquí van las estadísticas del usuario')),
                  )),
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
