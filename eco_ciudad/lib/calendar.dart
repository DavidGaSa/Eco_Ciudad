import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendario de Recolección"),
        backgroundColor: Colors.green,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              // Barra de navegación personalizada (solo una)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      tooltip: 'Mes anterior',
                      icon: const Icon(Icons.chevron_left, size: 32),
                      onPressed: () {
                        _calendarController.backward!();
                        setState(() {});
                      },
                    ),
                    Text(
                      "${_getMonthName((_calendarController.displayDate ?? DateTime.now()).month)} ${(_calendarController.displayDate ?? DateTime.now()).year}",
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      tooltip: 'Mes siguiente',
                      icon: const Icon(Icons.chevron_right, size: 32),
                      onPressed: () {
                        _calendarController.forward!();
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  child: SfCalendar(
                    controller: _calendarController,
                    view: CalendarView.month,
                    firstDayOfWeek: 1, // Lunes
                    dataSource: RecyclingDataSource(_getDataSource()),
                    monthViewSettings: const MonthViewSettings(
                      appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                      showAgenda: true,
                    ),
                    todayHighlightColor: Colors.green,
                    selectionDecoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      border: Border.all(color: Colors.green, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    showNavigationArrow: false, // Oculta la barra interna de navegación
                    allowViewNavigation: true,
                    showDatePickerButton: false, // Oculta el botón de selección de fecha
                    headerHeight: 0, // Oculta el header interno del calendario
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return months[month - 1];
  }

  /// Función que devuelve eventos repetitivos y fines de semana
  List<Appointment> _getDataSource() {
    final List<Appointment> appointments = <Appointment>[];

    final DateTime today = DateTime.now();
    final DateTime startOfWeek = today.subtract(
      Duration(days: today.weekday - 1),
    );

    // Orgánico - Lunes y Jueves (más frecuente)
    appointments.add(
      Appointment(
        startTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day, 9, 0),
        endTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day, 11, 0),
        subject: 'Orgánico',
        color: Colors.orange,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=MO,TH',
      ),
    );

    // Plástico - Martes y Sábado
    appointments.add(
      Appointment(
        startTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + 1, 9, 0),
        endTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + 1, 11, 0),
        subject: 'Plástico',
        color: Colors.yellow,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=TU,SA',
      ),
    );

    // Papel y Cartón - Miércoles y Domingo
    appointments.add(
      Appointment(
        startTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + 2, 9, 0),
        endTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + 2, 11, 0),
        subject: 'Papel y Cartón',
        color: Colors.blue,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=WE,SU',
      ),
    );

    // Vidrio - Jueves
    appointments.add(
      Appointment(
        startTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + 3, 9, 0),
        endTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + 3, 11, 0),
        subject: 'Vidrio',
        color: Colors.green,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=TH',
      ),
    );

    // Residuos Generales - Viernes y Domingo
    appointments.add(
      Appointment(
        startTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + 4, 9, 0),
        endTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + 4, 11, 0),
        subject: 'Residuos Generales',
        color: Colors.grey,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=FR,SU',
      ),
    );

    // Evento especial de reciclaje comunitario - Sábado (fin de semana)
    appointments.add(
      Appointment(
        startTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + 5, 12, 0),
        endTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + 5, 14, 0),
        subject: 'Reciclaje Comunitario',
        color: Colors.teal,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=SA',
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