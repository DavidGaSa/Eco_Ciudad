import 'dart:async';
import 'package:flutter/material.dart';
// Permite cargar archivos locales como el CSV.
import 'package:flutter/services.dart' show rootBundle;
// Paquetes principales para el mapa, manejo de coordenadas, y geolocalización.
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:csv/csv.dart';
import 'package:geolocator/geolocator.dart';

// Función asíncrona para obtener la ubicación actual del dispositivo de forma segura.
Future<Position> _getCurrentLocation() async {
  // Comprueba si los servicios de ubicación están activados.
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Si no lo están, pide al usuario que los active.
    await Geolocator.openLocationSettings();
    return Future.error('Los servicios de ubicación están desactivados.');
  }

  // Comprueba los permisos de ubicación de la app.
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    // Si no tiene permisos, los solicita.
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Los permisos de ubicación fueron denegados');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Si el usuario ha denegado los permisos permanentemente.
    return Future.error(
      'Los permisos de ubicación están denegados permanentemente.',
    );
  }

  // Si todo está correcto, obtiene y devuelve la posición actual.
  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
}

// Widget de la página del mapa, es StatefulWidget porque su contenido cambia.
class RecyclePage extends StatefulWidget {
  final Widget? map;

  const RecyclePage({super.key, this.map});

  @override
  State<RecyclePage> createState() => _RecyclePageState();
}

// Función que lee el archivo CSV de los assets y lo convierte en una lista de coordenadas.
Future<void> parseBins(List<LatLng> bins) async {
  // Carga el contenido del archivo CSV como un String.
  final rawData = await rootBundle.loadString("assets/contenedores.csv");

  // Convierte el String del CSV en una lista de listas (filas y columnas).
  List<List<dynamic>> rows = const CsvToListConverter(
    fieldDelimiter: ',',
    eol: '\n',
  ).convert(rawData);

  // Recorre las filas (empezando por la 1 para saltar la cabecera).
  for (int i = 1; i < rows.length; i++) {
    // Extrae la longitud (columna 9) y latitud (columna 10) de cada fila.
    final double lon = double.parse(rows[i][9].toString());
    final double lat = double.parse(rows[i][10].toString());
    // Añade la nueva coordenada a la lista de contenedores.
    bins.add(LatLng(lat, lon));
  }
}

// Lógica y estado de la página del mapa.
class _RecyclePageState extends State<RecyclePage> {
  // Controlador para interactuar con el mapa (mover la cámara, hacer zoom, etc.).
  final MapController _mapController = MapController();
  // Límite de contenedores a mostrar simultáneamente para mejorar el rendimiento.
  final int maxBins = 100;

  double _currentZoom = 18;

  // Lista con TODOS los contenedores cargados del CSV.
  List<LatLng> bins = [];
  // Lista con los contenedores que se están mostrando actualmente en el mapa (los más cercanos).
  List<LatLng> recycleBins = [];

  // Se ejecuta al iniciar el widget.
  @override
  void initState() {
    super.initState();
    _loadCsv(); // Inicia la carga de datos.
  }

  // Carga los datos del CSV y centra el mapa en la ubicación del usuario.
  Future<void> _loadCsv() async {
    // Espera a que se lean todos los contenedores del archivo.
    await parseBins(bins);

    // Muestra inicialmente los primeros 'maxBins' contenedores.
    setState(() {
      recycleBins = bins.take(maxBins).toList();
    });

    // Intenta obtener la ubicación del usuario y mover el mapa a esa posición.
    try {
      Position position = await _getCurrentLocation();
      _mapController.move(
        LatLng(position.latitude, position.longitude),
        _currentZoom,
      );
    } catch (e) {
      // Si hay un error (ej: permisos denegados), no hace nada y el mapa se queda en la posición por defecto.
    }

    // Actualiza los contenedores para mostrar los más cercanos a la vista actual.
    setState(() {
      updateBins();
    });
  }

  // **Optimización clave:** Actualiza la lista de contenedores visibles.
  void updateBins() {
    final Distance distance = Distance();
    final LatLng center = _mapController.camera.center; // Obtiene el centro del mapa.
    // Ordena la lista completa de contenedores por distancia al centro del mapa.
    bins.sort((a, b) => distance(center, a).compareTo(distance(center, b)));
    // Se queda solo con los 'maxBins' más cercanos para mostrarlos.
    recycleBins = bins.take(maxBins).toList();
  }

  // Funciones para los botones de zoom.
  void _zoomIn() {
    setState(() {
      _currentZoom++;
      _mapController.move(_mapController.camera.center, _currentZoom);
      updateBins(); // Actualiza los contenedores visibles tras el zoom.
    });
  }

  void _zoomOut() {
    setState(() {
      _currentZoom--;
      _mapController.move(_mapController.camera.center, _currentZoom);
      updateBins();
    });
  }

  // Construye la interfaz visual del widget.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Puntos de Reciclaje')),
      // Muestra un indicador de carga mientras los datos del CSV no están listos.
      body: recycleBins.isEmpty
          ? widget.map ?? const Center(child: CircularProgressIndicator())
          // Usa un Stack para superponer elementos (botones, texto) sobre el mapa.
          : Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: recycleBins.first, // Centrado inicial.
                    initialZoom: _currentZoom,
                    // Se activa cuando el usuario termina de mover o hacer zoom en el mapa.
                    onMapEvent: (event) {
                      if (event is MapEventMoveEnd) {
                        setState(() {
                          _currentZoom = _mapController.camera.zoom;
                          updateBins(); // Actualiza los contenedores a los más cercanos.
                        });
                      }
                    },
                  ),
                  children: [
                    // Capa que dibuja el mapa base (las calles, edificios, etc.).
                    TileLayer(
                      urlTemplate:
                          "https://cartodb-basemaps-a.global.ssl.fastly.net/light_all/{z}/{x}/{y}{r}.png",
                    ),
                    // Capa que dibuja los marcadores (pines) de los contenedores.
                    MarkerLayer(
                      markers: recycleBins.map((point) {
                        return Marker(
                          point: point,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.delete,
                            color: Colors.green,
                            size: 30,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                // Controles de Zoom superpuestos en la esquina inferior derecha.
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Column(
                    children: [
                      FloatingActionButton(
                        heroTag: "zoomIn",
                        mini: true,
                        onPressed: _zoomIn,
                        child: const Icon(Icons.add),
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton(
                        heroTag: "zoomOut",
                        mini: true,
                        onPressed: _zoomOut,
                        child: const Icon(Icons.remove),
                      ),
                    ],
                  ),
                ),
                // Texto informativo superpuesto en la esquina superior derecha.
                Positioned(
                  top: 80,
                  right: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green[700],
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.pink,
                          blurRadius: 10,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Mostrando $maxBins puntos de reciclaje mas cercanos.',
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                // Campo de búsqueda superpuesto en la parte superior.
                Positioned(
                  top: 20,
                  left: 20,
                  right: 20,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar tu barrio/calle...',
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      // Lógica de búsqueda (no implementada).
                    },
                  ),
                ),
              ],
            ),
    );
  }
}