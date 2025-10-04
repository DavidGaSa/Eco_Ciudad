import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:csv/csv.dart';

class RecyclePage extends StatefulWidget {
  const RecyclePage({super.key});

  @override
  State<RecyclePage> createState() => _RecyclePageState();
}

class _RecyclePageState extends State<RecyclePage> {
  final MapController _mapController = MapController();
  final int maxBins = 100;

  double _currentZoom = 13;

  List<LatLng> recycleBins = [];
  List<LatLng> bins = [];

  @override
  void initState() {
    super.initState();
    _loadCsv();
  }

  Future<void> _loadCsv() async {
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

    setState(() {
      recycleBins = bins.take(maxBins).toList();
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
          ? const Center(child: CircularProgressIndicator())
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
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
              ],
            ),
    );
  }
}
