import 'package:flutter/material.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> with RestorationMixin {
  // Persistencia del contador durante la sesión
  final RestorableInt _recycleCount = RestorableInt(0);
  final int _monthlyGoal = 50;

  @override
  String? get restorationId => 'statistics_page';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_recycleCount, 'recycle_count');
    debugPrint('restoreState: recycleCount=${_recycleCount.value}');
  }

  void _incrementRecycleCount() {
    setState(() {
      _recycleCount.value++;
      debugPrint('Añadir: recycleCount=${_recycleCount.value}');
    });
  }

  void _decrementRecycleCount() {
    setState(() {
      if (_recycleCount.value > 0) {
        _recycleCount.value--;
        debugPrint('Quitar: recycleCount=${_recycleCount.value}');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    debugPrint('initState');
  }

  @override
  void dispose() {
    debugPrint('dispose');
    _recycleCount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('build');
    double progress = _monthlyGoal > 0 ? _recycleCount.value / _monthlyGoal : 0;

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
                          '${_recycleCount.value}',
                          style: Theme.of(context).textTheme.displayLarge
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
          ],
        ),
      ),
    );
  }
}