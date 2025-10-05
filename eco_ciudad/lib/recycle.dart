import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:csv/csv.dart';
import 'package:geolocator/geolocator.dart';

Future<Position> _getCurrentLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Instead of throwing, prompt user to enable location
    await Geolocator.openLocationSettings();
    return Future.error('Location services are disabled.');
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
      'Location permissions are permanently denied, cannot request permissions.',
    );
  }

  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
}

class RecyclePage extends StatefulWidget {
  final Widget? map;

  const RecyclePage({super.key, this.map});

  @override
  State<RecyclePage> createState() => _RecyclePageState();
}

Future<void> parseBins(List<LatLng> bins) async {
  final rawData = await rootBundle.loadString("assets/contenedores.csv");

  List<List<dynamic>> rows = const CsvToListConverter(
    fieldDelimiter: ',',
    eol: '\n',
  ).convert(rawData);

  for (int i = 1; i < rows.length; i++) {
    final double lon = double.parse(rows[i][9].toString());
    final double lat = double.parse(rows[i][10].toString());
    bins.add(LatLng(lat, lon));
  }
}

class _RecyclePageState extends State<RecyclePage> {
  final MapController _mapController = MapController();
  final int maxBins = 100;

  double _currentZoom = 18;

  List<LatLng> recycleBins = [];
  List<LatLng> bins = [];

  @override
  void initState() {
    super.initState();
    _loadCsv();
  }

  Future<void> _loadCsv() async {
    await parseBins(bins);

    setState(() {
      recycleBins = bins.take(maxBins).toList();
    });

    try {
      Position position = await _getCurrentLocation();
      _mapController.move(
        LatLng(position.latitude, position.longitude),
        _currentZoom,
      );
    } catch (e) {}

    setState(() {
      updateBins();
    });
  }

  void updateBins() {
    final Distance distance = Distance();
    final LatLng center = _mapController.camera.center;
    bins.sort((a, b) => distance(center, a).compareTo(distance(center, b)));
    recycleBins = bins.take(maxBins).toList();
  }

  void _zoomIn() {
    setState(() {
      _currentZoom++;
      _mapController.move(_mapController.camera.center, _currentZoom);
      updateBins();
    });
  }

  void _zoomOut() {
    setState(() {
      _currentZoom--;
      _mapController.move(_mapController.camera.center, _currentZoom);
      updateBins();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Puntos de Reciclaje')),
      body: recycleBins.isEmpty
          ? widget.map ?? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: recycleBins.first,
                    initialZoom: _currentZoom,
                    onMapEvent: (event) {
                      if (event is MapEventMoveEnd) {
                        setState(() {
                          _currentZoom = _mapController.camera.zoom;
                          updateBins();
                        });
                      }
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://cartodb-basemaps-a.global.ssl.fastly.net/light_all/{z}/{x}/{y}{r}.png",
                      subdomains: const ['a', 'b', 'c', 'd'],
                      userAgentPackageName: 'com.example.recycle_app',
                    ),
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
                // Zoom controls
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
                Positioned(
                  top: 80,
                  right: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green[700],
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink,
                          blurRadius: 10,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Mostrando $maxBins puntos de reciclaje mas cercanos.',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
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
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
    );
  }
}
