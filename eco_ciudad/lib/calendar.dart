import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final CalendarController _calendarController = CalendarController();
  DateTime _currentDate = DateTime.now();

  final List<String> _months = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre',
  ];

  late final List<int> _years;

  @override
  void initState() {
    super.initState();
    _years = List<int>.generate(11, (index) => 2020 + index);
  }

  void _changeMonth(int offset) {
    setState(() {
      _currentDate = DateTime(
        _currentDate.year,
        _currentDate.month + offset,
        1,
      );
      _calendarController.displayDate = _currentDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, color: Colors.white),
              onPressed: () => _changeMonth(-1),
            ),
            DropdownButton<String>(
              dropdownColor: Colors.white,
              value: _months[_currentDate.month - 1],
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              underline: const SizedBox(),
              onChanged: (String? newMonth) {
                if (newMonth != null) {
                  setState(() {
                    final monthIndex = _months.indexOf(newMonth) + 1;
                    _currentDate = DateTime(_currentDate.year, monthIndex, 1);
                    _calendarController.displayDate = _currentDate;
                  });
                }
              },
              items: _months.map<DropdownMenuItem<String>>((String month) {
                return DropdownMenuItem<String>(
                  value: month,
                  child: Text(month),
                );
              }).toList(),
            ),
            const SizedBox(width: 8),
            DropdownButton<int>(
              dropdownColor: Colors.white,
              value: _currentDate.year,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              underline: const SizedBox(),
              onChanged: (int? newYear) {
                if (newYear != null) {
                  setState(() {
                    _currentDate = DateTime(newYear, _currentDate.month, 1);
                    _calendarController.displayDate = _currentDate;
                  });
                }
              },
              items: _years.map<DropdownMenuItem<int>>((int year) {
                return DropdownMenuItem<int>(
                  value: year,
                  child: Text(year.toString()),
                );
              }).toList(),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, color: Colors.white),
              onPressed: () => _changeMonth(1),
            ),
          ],
        ),
        backgroundColor: Colors.green,
      ),
      body: SfCalendar(
        controller: _calendarController,
        view: CalendarView.month,
        firstDayOfWeek: 1,
        dataSource: RecyclingDataSource(_getDataSource()),
        monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
        ),
        appointmentBuilder: (context, details) {
          final Appointment appointment = details.appointments.first;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: appointment.color,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              appointment.subject,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        },
      ),
    );
  }

  List<Appointment> _getDataSource() {
    final List<Appointment> appointments = <Appointment>[];
    final DateTime today = DateTime.now();
    final DateTime startOfWeek = today.subtract(
      Duration(days: today.weekday - 1),
    );

    // LUNES: Orgánico, Residuos generales y Plástico
    appointments.add(
      Appointment(
        startTime: DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day,
          8,
          0,
        ),
        endTime: DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day,
          10,
          0,
        ),
        subject: 'Orgánico',
        color: Colors.orange,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=MO',
      ),
    );
    appointments.add(
      Appointment(
        startTime: DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day,
          10,
          30,
        ),
        endTime: DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day,
          12,
          30,
        ),
        subject: 'Residuos Generales',
        color: Colors.grey,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=MO',
      ),
    );
    appointments.add(
      Appointment(
        startTime: DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day,
          14,
          0,
        ),
        endTime: DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day,
          16,
          0,
        ),
        subject: 'Plástico',
        color: Colors.yellow,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=MO',
      ),
    );

    // MARTES: Plástico, Vidrio y Residuos generales
    appointments.add(
      Appointment(
        startTime: DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day + 1,
          8,
          0,
        ),
        endTime: DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day + 1,
          10,
          0,
        ),
        subject: 'Plástico',
        color: Colors.yellow,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=TU',
      ),
    );
    appointments.add(
      Appointment(
        startTime: DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day + 1,
          10,
          30,
        ),
        endTime: DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day + 1,
          12,
          30,
        ),
        subject: 'Vidrio',
        color: Colors.green,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=TU',
      ),
    );
    appointments.add(
      Appointment(
        startTime: DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day + 1,
          14,
          0,
        ),
        endTime: DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day + 1,
          16,
          0,
        ),
        subject: 'Residuos Generales',
        color: Colors.grey,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=TU',
      ),
    );

    // MIÉRCOLES: Papel y Cartón, Orgánico y Vidrio
    appointments.add(
      Appointment(
        startTime: DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day + 2,
          8,
          0,
        ),
        endTime: DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day + 2,
          10,
          0,
        ),
        subject: 'Papel y Cartón',
        color: Colors.blue,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=WE',
      ),
    );
    appointments.add(
      Appointment(
        startTime: DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day + 2,
          10,
          30,
        ),
        endTime: DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day + 2,
          12,
          30,
        ),
        subject: 'Orgánico',
        color: Colors.orange,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=WE',
      ),
    );
    appointments.add(
      Appointment(
        startTime: DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day + 2,
          14,
          0,
        ),
        endTime: DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day + 2,
          16,
          0,
        ),
        subject: 'Vidrio',
        color: Colors.green,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=WE',
      ),
    );

    // JUEVES: Vidrio, Plástico y Orgánico
    appointments.add(
      Appointment(
        startTime: DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day + 3,
          8,
          0,
        ),
        endTime: DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day + 3,
          10,
          0,
        ),
        subject: 'Vidrio',
        color: Colors.green,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=TH',
      ),
    );
    appointments.add(
      Appointment(
        startTime: DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day + 3,
          10,
          30,
        ),
        endTime: DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day + 3,
          12,
          30,
        ),
        subject: 'Plástico',
        color: Colors.yellow,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=TH',
      ),
    );
    appointments.add(
      Appointment(
        startTime: DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day + 3,
          14,
          0,
        ),
        endTime: DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day + 3,
          16,
          0,
        ),
        subject: 'Orgánico',
        color: Colors.orange,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=TH',
      ),
    );

    // VIERNES: Orgánico, Papel y Cartón, Residuos Generales
    appointments.add(
      Appointment(
        startTime: DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day + 4,
          8,
          0,
        ),
        endTime: DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day + 4,
          10,
          0,
        ),
        subject: 'Orgánico',
        color: Colors.orange,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=FR',
      ),
    );
    appointments.add(
      Appointment(
        startTime: DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day + 4,
          10,
          30,
        ),
        endTime: DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day + 4,
          12,
          30,
        ),
        subject: 'Papel y Cartón',
        color: Colors.blue,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=FR',
      ),
    );
    appointments.add(
      Appointment(
        startTime: DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day + 4,
          14,
          0,
        ),
        endTime: DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day + 4,
          16,
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

class RecyclingDataSource extends CalendarDataSource {
  RecyclingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
