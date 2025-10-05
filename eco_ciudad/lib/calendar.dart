// Importa la librería de Flutter y el paquete del calendario de Syncfusion.
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

// Es un StatefulWidget porque su estado (la fecha mostrada) puede cambiar.
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  // Controlador para manipular el calendario (ej: cambiar la fecha visible).
  final CalendarController _calendarController = CalendarController();
  // Almacena la fecha actual que se está mostrando en la UI.
  DateTime _currentDate = DateTime.now();

  // Listas para poblar los menús desplegables de mes y año en la AppBar.
  final List<String> _months = [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre',
  ];
  late final List<int> _years;

  // Se ejecuta una sola vez al crear el widget.
  @override
  void initState() {
    super.initState();
    // Inicializa la lista de años, generando 11 años a partir de 2020.
    _years = List<int>.generate(11, (index) => 2020 + index);
  }

  // Método para cambiar al mes anterior (-1) o siguiente (+1) usando los botones de flecha.
  void _changeMonth(int offset) {
    // setState notifica a Flutter que el estado ha cambiado y debe redibujar la UI.
    setState(() {
      _currentDate = DateTime(
        _currentDate.year,
        _currentDate.month + offset,
        1,
      );
      // Actualiza la fecha que el calendario está mostrando.
      _calendarController.displayDate = _currentDate;
    });
  }

  // Construye la interfaz visual de la pantalla.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra superior personalizada con controles de navegación para el calendario.
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Botón para ir al mes anterior.
            IconButton(
              icon: const Icon(Icons.chevron_left, color: Colors.white),
              onPressed: () => _changeMonth(-1),
            ),
            // Menú desplegable para seleccionar el mes.
            DropdownButton<String>(
              dropdownColor: Colors.white,
              value: _months[_currentDate.month - 1], // Mes actualmente seleccionado.
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              underline: const SizedBox(), // Oculta la línea de subrayado.
              // Cuando el usuario elige un nuevo mes, se actualiza el estado.
              onChanged: (String? newMonth) {
                if (newMonth != null) {
                  setState(() {
                    final monthIndex = _months.indexOf(newMonth) + 1;
                    _currentDate = DateTime(_currentDate.year, monthIndex, 1);
                    _calendarController.displayDate = _currentDate;
                  });
                }
              },
              // Genera los ítems del menú a partir de la lista de meses.
              items: _months.map<DropdownMenuItem<String>>((String month) {
                return DropdownMenuItem<String>(value: month, child: Text(month));
              }).toList(),
            ),
            const SizedBox(width: 8),
            // Menú desplegable para seleccionar el año.
            DropdownButton<int>(
              dropdownColor: Colors.white,
              value: _currentDate.year, // Año actualmente seleccionado.
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
                return DropdownMenuItem<int>(value: year, child: Text(year.toString()));
              }).toList(),
            ),
            // Botón para ir al mes siguiente.
            IconButton(
              icon: const Icon(Icons.chevron_right, color: Colors.white),
              onPressed: () => _changeMonth(1),
            ),
          ],
        ),
        backgroundColor: Colors.green,
      ),
      // Widget principal que muestra el calendario de Syncfusion.
      body: SfCalendar(
        controller: _calendarController,
        view: CalendarView.month, // Muestra el calendario en vista mensual.
        firstDayOfWeek: 1, // Establece el Lunes como primer día de la semana.
        dataSource: RecyclingDataSource(_getDataSource()), // Proporciona los eventos.
        monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
        ),
        // Builder para personalizar la apariencia de cada evento en el calendario.
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

  // Método que crea y devuelve la lista de eventos de reciclaje.
  List<Appointment> _getDataSource() {
    final List<Appointment> appointments = <Appointment>[];
    final DateTime today = DateTime.now();
    // Calcula el inicio de la semana actual para establecer los eventos.
    final DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));

    // ---- LUNES: Creación de 3 eventos para los lunes ----
    appointments.add(
      Appointment(
        startTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day, 8, 0),
        endTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day, 10, 0),
        subject: 'Orgánico',
        color: Colors.orange,
        // Regla de recurrencia: se repite semanalmente (WEEKLY) los lunes (MO).
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=MO',
      ),
    );
    // ... (los demás eventos siguen la misma lógica)
    appointments.add(
      Appointment(
        startTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day, 10, 30),
        endTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day, 12, 30),
        subject: 'Residuos Generales',
        color: Colors.grey,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=MO',
      ),
    );
    appointments.add(
      Appointment(
        startTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day, 14, 0),
        endTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day, 16, 0),
        subject: 'Plástico',
        color: Colors.yellow,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=MO',
      ),
    );

    // ---- MARTES: Se añade 1 día a la fecha de inicio de la semana ----
    appointments.add(
      Appointment(
        startTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + 1, 8, 0),
        endTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + 1, 10, 0),
        subject: 'Plástico',
        color: Colors.yellow,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=TU',
      ),
    );
    // ... (y así sucesivamente para el resto de la semana)
    appointments.add(
      Appointment(
        startTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + 1, 10, 30),
        endTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + 1, 12, 30),
        subject: 'Vidrio',
        color: Colors.green,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=TU',
      ),
    );
    appointments.add(
      Appointment(
        startTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + 1, 14, 0),
        endTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + 1, 16, 0),
        subject: 'Residuos Generales',
        color: Colors.grey,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=TU',
      ),
    );

    // ---- MIÉRCOLES ----
    appointments.add(
      Appointment(
        startTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + 2, 8, 0),
        endTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + 2, 10, 0),
        subject: 'Papel y Cartón',
        color: Colors.blue,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=WE',
      ),
    );
    appointments.add(
      Appointment(
        startTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + 2, 10, 30),
        endTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + 2, 12, 30),
        subject: 'Orgánico',
        color: Colors.orange,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=WE',
      ),
    );
    appointments.add(
      Appointment(
        startTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + 2, 14, 0),
        endTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + 2, 16, 0),
        subject: 'Vidrio',
        color: Colors.green,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=WE',
      ),
    );

    // ---- JUEVES ----
    appointments.add(
      Appointment(
        startTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + 3, 8, 0),
        endTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + 3, 10, 0),
        subject: 'Vidrio',
        color: Colors.green,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=TH',
      ),
    );
    appointments.add(
      Appointment(
        startTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + 3, 10, 30),
        endTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + 3, 12, 30),
        subject: 'Plástico',
        color: Colors.yellow,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=TH',
      ),
    );
    appointments.add(
      Appointment(
        startTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + 3, 14, 0),
        endTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + 3, 16, 0),
        subject: 'Orgánico',
        color: Colors.orange,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=TH',
      ),
    );

    // ---- VIERNES ----
    appointments.add(
      Appointment(
        startTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + 4, 8, 0),
        endTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + 4, 10, 0),
        subject: 'Orgánico',
        color: Colors.orange,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=FR',
      ),
    );
    appointments.add(
      Appointment(
        startTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + 4, 10, 30),
        endTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + 4, 12, 30),
        subject: 'Papel y Cartón',
        color: Colors.blue,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=FR',
      ),
    );
    appointments.add(
      Appointment(
        startTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + 4, 14, 0),
        endTime: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + 4, 16, 0),
        subject: 'Residuos Generales',
        color: Colors.grey,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=FR',
      ),
    );

    return appointments;
  }
}

// Clase requerida por SfCalendar para manejar la fuente de datos de los eventos.
class RecyclingDataSource extends CalendarDataSource {
  RecyclingDataSource(List<Appointment> source) {
    appointments = source;
  }
}