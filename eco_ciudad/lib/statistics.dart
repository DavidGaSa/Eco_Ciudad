import 'package:flutter/material.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

// ...existing code...
class _StatisticsPageState extends State<StatisticsPage> {
  final int _monthlyGoal = 50; // Example monthly goal

  // Tipos de residuos y su conteo
  final Map<String, int> _recycleCounts = {
    'Plástico': 0,
    'Papel': 0,
    'Vidrio': 0,
    'Orgánico': 0,
    'Otros': 0,
  };

  String _selectedType = 'Plástico';

  void _incrementRecycleCount() {
    setState(() {
      _recycleCounts[_selectedType] = (_recycleCounts[_selectedType] ?? 0) + 1;
    });
  }

  void _decrementRecycleCount() {
    setState(() {
      if ((_recycleCounts[_selectedType] ?? 0) > 0) {
        _recycleCounts[_selectedType] = (_recycleCounts[_selectedType] ?? 0) - 1;
      }
    });
  }

  int get _totalRecycleCount =>
      _recycleCounts.values.fold(0, (sum, count) => sum + count);

  @override
  Widget build(BuildContext context) {
    double progress =
        _monthlyGoal > 0 ? _totalRecycleCount / _monthlyGoal : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Estadísticas'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text(
                      'Bolsas recicladas este mes',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '$_totalRecycleCount',
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' / $_monthlyGoal',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 12,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Selector de tipo de residuo
            DropdownButton<String>(
              value: _selectedType,
              items: _recycleCounts.keys
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedType = value;
                  });
                }
              },
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _decrementRecycleCount,
                  icon: const Icon(Icons.remove),
                  label: const Text('Quitar'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _incrementRecycleCount,
                  icon: const Icon(Icons.add),
                  label: const Text('Añadir'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Tabla resumen por tipo
            Expanded(
              child: ListView(
                children: _recycleCounts.entries
                    .map(
                      (entry) => ListTile(
                        leading: Icon(Icons.recycling, color: Colors.green[700]),
                        title: Text(entry.key),
                        trailing: Text(
                          '${entry.value} bolsas',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// ...existing code...