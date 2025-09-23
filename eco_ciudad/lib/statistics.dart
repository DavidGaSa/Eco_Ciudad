import 'package:flutter/material.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  int _recycleCount = 0;

  void _incrementRecycleCount() {
    setState(() {
      _recycleCount++;
    });
  }

  void _decrementRecycleCount() {
    setState(() {
      if (_recycleCount > 0) {
        _recycleCount--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Estadísticas')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Bolsas recicladas este mes:',
              style: TextStyle(fontSize: 22),
            ),
            Text(
              '$_recycleCount',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _decrementRecycleCount,
            tooltip: '-1 Bolsa Reciclada',
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: _incrementRecycleCount,
            tooltip: '+1 Bolsa Reciclada',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
