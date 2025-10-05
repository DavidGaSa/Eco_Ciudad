// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:eco_ciudad/calendar.dart';
import 'package:eco_ciudad/main.dart';
import 'package:eco_ciudad/recycle.dart';
import 'package:eco_ciudad/statistics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class FakeGeolocator extends GeolocatorPlatform {
  @override
  Future<bool> isLocationServiceEnabled() async => false;

  @override
  Future<LocationPermission> checkPermission() async =>
      LocationPermission.deniedForever;

  @override
  Future<Position> getCurrentPosition({
    LocationSettings? locationSettings,
  }) async {
    return Position(
      longitude: -3.7038,
      latitude: 40.4168,
      timestamp: DateTime.now(),
      accuracy: 1,
      altitude: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
    );
  }
}

class FakeFlutterMap extends StatelessWidget {
  final List<LatLng> recycleBins;

  const FakeFlutterMap({super.key, required this.recycleBins});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: recycleBins
          .map((_) => const Icon(Icons.delete, color: Colors.green, size: 30))
          .toList(),
    );
  }
}

void main() {
  setUp(() {
    GeolocatorPlatform.instance = FakeGeolocator();
  });

  testWidgets('Counter increments Plástico recycling', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: StatisticsPage()));

    expect(find.textContaining('Bolsas recicladas'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('1'), findsOneWidget);
    expect(find.text('1 bolsas'), findsOneWidget);
  });

  testWidgets('Shows todays date on calendar', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: CalendarPage()));
    final today = DateTime.now();
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    expect(find.textContaining(months[today.month - 1]), findsOneWidget);
    expect(find.textContaining(today.year.toString()), findsOneWidget);
  });

  testWidgets('RecyclePage shows progress and then map', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RecyclePage(
          map: FakeFlutterMap(
            recycleBins: [
              LatLng(40.416775, -3.703790),
              LatLng(40.417000, -3.704000),
              LatLng(40.418000, -3.705000),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Puntos de Reciclaje'), findsOneWidget);
    expect(find.byIcon(Icons.delete), findsAtLeastNWidgets(2));
  });

  testWidgets("Integration test all pages navigation", (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: MainScreen()));

    final buttons = {
      'btnCalendar': CalendarPage,
      // 'btnMap': RecyclePage,
      'btnStats': StatisticsPage,
    };

    for (var entry in buttons.entries) {
      final button = find.byKey(Key(entry.key));

      expect(button, findsOneWidget);

      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(find.byType(entry.value), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();
    }
  });
}
