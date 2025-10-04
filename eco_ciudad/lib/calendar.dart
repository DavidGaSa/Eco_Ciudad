import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendario de Recolección"),
        backgroundColor: Colors.green,
      ),
      body: SfCalendar(
        view: CalendarView.month,
        firstDayOfWeek: 1, // Lunes
        dataSource: RecyclingDataSource(_getDataSource()),
        monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
        ),
      ),
    );
  }

  /// Función que devuelve eventos repetitivos
  List<Appointment> _getDataSource() {
    final List<Appointment> appointments = <Appointment>[];

    final DateTime today = DateTime.now();
    final DateTime startOfWeek = today.subtract(
      Duration(days: today.weekday - 1),
    );

    // Lunes - Orgánico
    appointments.add(
      Appointment(
        startTime: DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day,
          9,
          0,
        ),
        endTime: DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day,
          11,
          0,
        ),
        subject: 'Orgánico',
        color: Colors.orange,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=MO',
      ),
    );

    // Martes - Plástico
    appointments.add(
      Appointment(
        startTime: DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day + 1,
          9,
          0,
        ),
        endTime: DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day + 1,
          11,
          0,
        ),
        subject: 'Plástico',
        color: Colors.yellow,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=TU',
      ),
    );

    // Miércoles - Papel
    appointments.add(
      Appointment(
        startTime: DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day + 2,
          9,
          0,
        ),
        endTime: DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day + 2,
          11,
          0,
        ),
        subject: 'Papel y Cartón',
        color: Colors.blue,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=WE',
      ),
    );

    // Jueves - Vidrio
    appointments.add(
      Appointment(
        startTime: DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day + 3,
          9,
          0,
        ),
        endTime: DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day + 3,
          11,
          0,
        ),
        subject: 'Vidrio',
        color: Colors.green,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=TH',
      ),
    );

    // Viernes - General
    appointments.add(
      Appointment(
        startTime: DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day + 4,
          9,
          0,
        ),
        endTime: DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day + 4,
          11,
          0,
        ),
        subject: 'Residuos Generales',
        color: Colors.grey,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=FR',
      ),
    );

    return appointments;
  }
}

/// Clase para manejar los eventos
class RecyclingDataSource extends CalendarDataSource {
  RecyclingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
