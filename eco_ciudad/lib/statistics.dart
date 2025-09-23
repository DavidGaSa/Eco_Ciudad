import 'package:flutter/material.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Estadísticas')),
      body: const Center(child: Text('Aquí van las estadísticas del usuario')),
    );
  }
}
