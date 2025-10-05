// Importa las páginas de la aplicación y la librería principal de Flutter.
import 'package:eco_ciudad/calendar.dart';
import 'package:eco_ciudad/recycle.dart';
import 'package:eco_ciudad/statistics.dart';
import 'package:flutter/material.dart';

// Clase para centralizar todos los textos de la app. Facilita la gestión y traducción.
class AppStrings {
  static const calendar = 'Calendario de Recolección';
  static const map = 'Puntos de Reciclaje';
  static const stats = 'Mis Estadísticas';
}

// Punto de entrada principal de la aplicación.
void main() {
  runApp(const MainApp());
}

// Widget raíz de la aplicación.
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp es el widget base que configura la aplicación.
    return MaterialApp(
      // Define la pantalla principal que se mostrará al iniciar.
      home: const MainScreen(),
      // Define el tema visual global (colores, estilos de botones, etc.).
      theme: ThemeData(
        // Genera una paleta de colores a partir de un color semilla.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),

        // Estilo global para todos los botones de tipo ElevatedButton.
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

// Widget que construye la interfaz de la pantalla de bienvenida.
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold proporciona la estructura básica de una pantalla (barra superior, cuerpo).
    return Scaffold(
      // Barra de navegación superior (AppBar).
      appBar: AppBar(
        title: const Text('Bienvenido a Eco-Ciudad'),
        centerTitle: true,
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      // Cuerpo principal de la pantalla.
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.lightGreen[100], // Fondo verde claro
        // Permite que el contenido se desplace si no cabe, evitando errores de overflow.
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          // Organiza los widgets hijos en una columna vertical.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Muestra el logo de la aplicación desde la carpeta 'assets'.
              Image.asset(
                'assets/Eco-Ciudad-Logo.png',
                width: 330,
                height: 330,
              ),
              // Widget para añadir un espacio vertical.
              const SizedBox(height: 8),
              // Texto de descripción de la aplicación.
              const Center(
                child: SizedBox(
                  width: 400,
                  child: Text(
                    'El reciclaje es esencial en el ciudado del planeta y la salud de los habitantes. Por eso presentamos Eco-Ciudad, una app para facilitar el reciclaje en tu ciudad al mismo tiempo que te motiva a llevar un control de tu impacto ambiental.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18, color: Colors.black87),
                  ),
                ),
              ),
              const SizedBox(height: 24), // Espacio mayor antes de los botones.
              // Wrap organiza los botones y los baja a la siguiente línea si no hay espacio.
              Wrap(
                spacing: 16, // Espacio horizontal entre botones.
                runSpacing: 16, // Espacio vertical entre líneas de botones.
                children: [
                  // Botón para ir a la pantalla del Calendario.
                  ElevatedButton(
                    key: const Key('btnCalendar'), // Clave para tests automáticos.
                    // Define la acción que se ejecuta al presionar el botón.
                    onPressed: () {
                      // Navega a la pantalla CalendarPage.
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CalendarPage(),
                        ),
                      );
                    },
                    child: const Text(AppStrings.calendar),
                  ),
                  // Botón para ir a la pantalla de Puntos de Reciclaje.
                  ElevatedButton(
                    key: const Key('btnMap'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RecyclePage()),
                      );
                    },
                    child: const Text(AppStrings.map),
                  ),
                  // Botón para ir a la pantalla de Estadísticas.
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
                    child: const Text(AppStrings.stats),
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