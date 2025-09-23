import 'package:flutter/material.dart';

class RecyclePage extends StatelessWidget {
  const RecyclePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Puntos de Reciclaje')),
      body: const Center(child: Text('Aquí van los puntos de reciclaje')),
    );
  }
}
