import 'package:flutter/material.dart';

class Historial extends StatefulWidget {
  final List<MedicineHistory> medicines;
  const Historial({Key? key, required this.medicines}) : super(key: key);
  @override
  State<Historial> createState() => _HistorialState();
}

class _HistorialState extends State<Historial> {
  String selectedPeriod = "week";
  int currentWeek = 0;
  int currentMonth = 0;
  final double adherenceRate = 78;

  final List<MedicineHistory> historyData = [
    // Semana actual
    MedicineHistory(
      date: DateTime(2024, 1, 15),
      time: const TimeOfDay(hour: 8, minute: 0),
      medicine: "Paracetamol",
      dosage: "500mg",
      status: "taken",
      takenAt: const TimeOfDay(hour: 8, minute: 5),
    ),
    MedicineHistory(
      date: DateTime(2024, 1, 15),
      time: const TimeOfDay(hour: 16, minute: 0),
      medicine: "Paracetamol",
      dosage: "500mg",
      status: "taken",
      takenAt: const TimeOfDay(hour: 16, minute: 15),
    ),
    MedicineHistory(
      date: DateTime(2024, 1, 15),
      time: const TimeOfDay(hour: 0, minute: 0),
      medicine: "Paracetamol",
      dosage: "500mg",
      status: "late",
      delay: 30,
      takenAt: const TimeOfDay(hour: 0, minute: 30),
    ),
    MedicineHistory(
      date: DateTime(2024, 1, 14),
      time: const TimeOfDay(hour: 8, minute: 0),
      medicine: "Paracetamol",
      dosage: "500mg",
      status: "taken",
      takenAt: const TimeOfDay(hour: 8, minute: 0),
    ),
    MedicineHistory(
      date: DateTime(2024, 1, 14),
      time: const TimeOfDay(hour: 16, minute: 0),
      medicine: "Paracetamol",
      dosage: "500mg",
      status: "missed",
    ),
    MedicineHistory(
      date: DateTime(2024, 1, 14),
      time: const TimeOfDay(hour: 0, minute: 0),
      medicine: "Paracetamol",
      dosage: "500mg",
      status: "taken",
      takenAt: const TimeOfDay(hour: 23, minute: 55),
    ),
    MedicineHistory(
      date: DateTime(2024, 1, 13),
      time: const TimeOfDay(hour: 8, minute: 0),
      medicine: "Paracetamol",
      dosage: "500mg",
      status: "taken",
      takenAt: const TimeOfDay(hour: 8, minute: 10),
    ),
    MedicineHistory(
      date: DateTime(2024, 1, 13),
      time: const TimeOfDay(hour: 16, minute: 0),
      medicine: "Paracetamol",
      dosage: "500mg",
      status: "taken",
      takenAt: const TimeOfDay(hour: 16, minute: 0),
    ),
    MedicineHistory(
      date: DateTime(2024, 1, 13),
      time: const TimeOfDay(hour: 0, minute: 0),
      medicine: "Paracetamol",
      dosage: "500mg",
      status: "taken",
      takenAt: const TimeOfDay(hour: 0, minute: 5),
    ),
    // Ibuprofeno
    MedicineHistory(
      date: DateTime(2024, 1, 15),
      time: const TimeOfDay(hour: 9, minute: 0),
      medicine: "Ibuprofeno",
      dosage: "400mg",
      status: "taken",
      takenAt: const TimeOfDay(hour: 9, minute: 0),
    ),
    MedicineHistory(
      date: DateTime(2024, 1, 15),
      time: const TimeOfDay(hour: 21, minute: 0),
      medicine: "Ibuprofeno",
      dosage: "400mg",
      status: "missed",
    ),
    MedicineHistory(
      date: DateTime(2024, 1, 14),
      time: const TimeOfDay(hour: 9, minute: 0),
      medicine: "Ibuprofeno",
      dosage: "400mg",
      status: "taken",
      takenAt: const TimeOfDay(hour: 9, minute: 15),
    ),
    MedicineHistory(
      date: DateTime(2024, 1, 14),
      time: const TimeOfDay(hour: 21, minute: 0),
      medicine: "Ibuprofeno",
      dosage: "400mg",
      status: "taken",
      takenAt: const TimeOfDay(hour: 21, minute: 0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // HEADER con fondo azul sólido
          Container(
            width: double.infinity,
            color: const Color(0xFF3B82F6),
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Historial",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Seguimiento detallado de tu tratamiento",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFBFDBFE),
                  ),
                ),
              ],
            ),
          ),

          // CUERPO CON TABBAR
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // TABBAR estilo cuadrado
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9), // Fondo gris claro
                        borderRadius: BorderRadius.circular(4), // Bordes cuadrados
                      ),
                      child: TabBar(
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey,
                        indicator: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4), // Selección cuadrada
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: const [
                          Tab(text: "DÍA"),
                          Tab(text: "SEMANA"),
                          Tab(text: "MES"),
                        ],
                        onTap: (index) {
                          setState(() {
                            selectedPeriod = ["day", "week", "month"][index];
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Widget de estadísticas
                    _buildAdherenceStats(),

                    // Contenido de las pestañas
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildDayView(),
                          _buildWeekView(),
                          _buildMonthView(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildAdherenceStats() {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.blue.shade50],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Adherencia al tratamiento",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Últimos 7 días",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "$adherenceRate%",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade600,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.trending_up, size: 16, color: Colors.green.shade600),
                    const SizedBox(width: 4),
                    Text(
                      "+5% vs semana anterior",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayView() {
    final today = DateTime(2024, 1, 15);
    final todayRecords = historyData.where((record) =>
    record.date.year == today.year &&
        record.date.month == today.month &&
        record.date.day == today.day).toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: todayRecords.length,
      itemBuilder: (context, index) {
        final record = todayRecords[index];
        return _buildHistoryCard(record);
      },
    );
  }

  Widget _buildWeekView() {
    final weekDates = _getWeekDates(currentWeek);
    final medicines = ["Paracetamol", "Ibuprofeno"];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: medicines.length,
      itemBuilder: (context, medicineIndex) {
        final medicine = medicines[medicineIndex];
        return _buildMedicineWeekCard(medicine, weekDates);
      },
    );
  }

  Widget _buildMonthView() {
    final monthDates = _getMonthDates(currentMonth);
    final medicines = ["Paracetamol", "Ibuprofeno"];
    final weeks = _groupDatesByWeeks(monthDates);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: medicines.length,
      itemBuilder: (context, medicineIndex) {
        final medicine = medicines[medicineIndex];
        return _buildMedicineMonthCard(medicine, weeks);
      },
    );
  }

  Widget _buildHistoryCard(MedicineHistory record) {
    Color cardColor;
    Color statusColor;
    IconData statusIcon;

    switch (record.status) {
      case "taken":
        cardColor = Colors.green.shade50;
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case "missed":
        cardColor = Colors.red.shade50;
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      case "late":
        cardColor = Colors.orange.shade50;
        statusColor = Colors.orange;
        statusIcon = Icons.access_time;
        break;
      default:
        cardColor = Colors.grey.shade50;
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: statusColor.withOpacity(0.3), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(statusIcon, color: statusColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${record.medicine} ${record.dosage}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Programado: ${record.time.format(context)}",
                    style: const TextStyle(fontSize: 12),
                  ),
                  if (record.takenAt != null)
                    Text(
                      "Tomado: ${record.takenAt!.format(context)}",
                      style: const TextStyle(fontSize: 12),
                    ),
                ],
              ),
            ),
            Chip(
              backgroundColor: statusColor.withOpacity(0.2),
              label: Text(
                record.status == "taken"
                    ? "Tomado"
                    : record.status == "missed"
                    ? "Perdido"
                    : "Tarde",
                style: TextStyle(color: statusColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicineWeekCard(String medicine, List<DateTime> weekDates) {
    final schedules = _getMedicineSchedules(medicine);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  medicine,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Navegación de semana
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      currentWeek--;
                    });
                  },
                ),
                Text(
                  "${_formatDate(weekDates.first, dayOnly: true)} - ${_formatDate(weekDates.last)}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: currentWeek >= 0
                      ? null
                      : () {
                    setState(() {
                      currentWeek++;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Calendario semanal
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 0.7,
              ),
              itemCount: 7,
              itemBuilder: (context, dayIndex) {
                final date = weekDates[dayIndex];
                return _buildWeekDayCell(medicine, schedules, date);
              },
            ),
            const SizedBox(height: 16),

            // Resumen semanal
            Divider(color: Colors.grey.shade300),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Esta semana:",
                    style: TextStyle(fontSize: 12),
                  ),
                  Row(
                    children: [
                      _buildWeekSummaryItem(
                        icon: Icons.check,
                        count: historyData.where((h) =>
                        h.medicine == medicine &&
                            h.status == "taken" &&
                            _isDateInWeek(h.date, weekDates)).length,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 16),
                      _buildWeekSummaryItem(
                        icon: Icons.access_time,
                        count: historyData.where((h) =>
                        h.medicine == medicine &&
                            h.status == "late" &&
                            _isDateInWeek(h.date, weekDates)).length,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 16),
                      _buildWeekSummaryItem(
                        icon: Icons.close,
                        count: historyData.where((h) =>
                        h.medicine == medicine &&
                            h.status == "missed" &&
                            _isDateInWeek(h.date, weekDates)).length,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekDayCell(String medicine, List<TimeOfDay> schedules, DateTime date) {
    return Column(
      children: [
        Text(
          _getDayName(date),
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Text(
          date.day.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Column(
          children: schedules.map((time) {
            final status = _getDoseStatus(medicine, date, time);
            final record = historyData.firstWhere(
                  (h) =>
              h.medicine == medicine &&
                  h.date.day == date.day &&
                  h.date.month == date.month &&
                  h.date.year == date.year &&
                  h.time.hour == time.hour &&
                  h.time.minute == time.minute,
              orElse: () => MedicineHistory(
                date: date,
                time: time,
                medicine: medicine,
                dosage: "",
                status: "pending",
              ),
            );

            Color cellColor;
            IconData? cellIcon;

            switch (status) {
              case "taken":
                cellColor = Colors.green.shade100;
                cellIcon = Icons.check;
                break;
              case "missed":
                cellColor = Colors.red.shade100;
                cellIcon = Icons.close;
                break;
              case "late":
                cellColor = Colors.orange.shade100;
                cellIcon = Icons.access_time;
                break;
              default:
                cellColor = Colors.grey.shade100;
            }

            return GestureDetector(
              onTap: () {
                // Mostrar detalles al tocar
                _showDoseDetails(record);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  color: cellColor,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    Text(
                      time.format(context),
                      style: const TextStyle(fontSize: 10),
                    ),
                    if (cellIcon != null)
                      Icon(cellIcon, size: 12),
                    if (record.takenAt != null)
                      Text(
                        record.takenAt!.format(context),
                        style: const TextStyle(fontSize: 8),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMedicineMonthCard(String medicine, List<List<DateTime>> weeks) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  medicine,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Navegación de mes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      currentMonth--;
                    });
                  },
                ),
                Text(
                  _getMonthName(currentMonth),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: currentMonth >= 0
                      ? null
                      : () {
                    setState(() {
                      currentMonth++;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Calendario mensual por semanas
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: weeks.length,
              itemBuilder: (context, weekIndex) {
                final week = weeks[weekIndex];
                return _buildMonthWeekCard(medicine, weekIndex, week);
              },
            ),
            const SizedBox(height: 16),

            // Resumen mensual
            Divider(color: Colors.grey.shade300),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMonthSummaryItem(
                    value: historyData.where((h) =>
                    h.medicine == medicine &&
                        h.status == "taken" &&
                        _isDateInMonth(h.date, currentMonth)).length.toString(),
                    label: "Tomadas",
                    color: Colors.green,
                  ),
                  _buildMonthSummaryItem(
                    value: historyData.where((h) =>
                    h.medicine == medicine &&
                        h.status == "late" &&
                        _isDateInMonth(h.date, currentMonth)).length.toString(),
                    label: "Tarde",
                    color: Colors.orange,
                  ),
                  _buildMonthSummaryItem(
                    value: historyData.where((h) =>
                    h.medicine == medicine &&
                        h.status == "missed" &&
                        _isDateInMonth(h.date, currentMonth)).length.toString(),
                    label: "Perdidas",
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthWeekCard(String medicine, int weekIndex, List<DateTime> week) {
    final schedules = _getMedicineSchedules(medicine);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              "Semana ${weekIndex + 1} - ${_formatDate(week.first, dayOnly: true)} al ${_formatDate(week.last, dayOnly: true)}",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
              ),
              itemCount: week.length,
              itemBuilder: (context, dayIndex) {
                final date = week[dayIndex];
                final dayRecords = historyData.where((h) =>
                h.medicine == medicine &&
                    h.date.day == date.day &&
                    h.date.month == date.month &&
                    h.date.year == date.year).toList();

                final takenCount = dayRecords.where((r) => r.status == "taken").length;
                final missedCount = dayRecords.where((r) => r.status == "missed").length;
                final lateCount = dayRecords.where((r) => r.status == "late").length;
                final totalScheduled = schedules.length;

                return GestureDetector(
                  onTap: () {
                    // Mostrar detalles del día
                    _showDayDetails(medicine, date);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          date.day.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getDayName(date).substring(0, 1),
                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        if (totalScheduled > 0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (takenCount > 0)
                                Container(
                                  width: 6,
                                  height: 6,
                                  margin: const EdgeInsets.symmetric(horizontal: 1),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              if (lateCount > 0)
                                Container(
                                  width: 6,
                                  height: 6,
                                  margin: const EdgeInsets.symmetric(horizontal: 1),
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              if (missedCount > 0)
                                Container(
                                  width: 6,
                                  height: 6,
                                  margin: const EdgeInsets.symmetric(horizontal: 1),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                        const SizedBox(height: 4),
                        Text(
                          totalScheduled > 0 ? "$takenCount/$totalScheduled" : "-",
                          style: TextStyle(
                            fontSize: 10,
                            color: takenCount == totalScheduled
                                ? Colors.green
                                : takenCount > 0
                                ? Colors.orange
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            Divider(color: Colors.grey.shade300),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Semana ${weekIndex + 1}:",
                    style: const TextStyle(fontSize: 12),
                  ),
                  Row(
                    children: [
                      _buildWeekSummaryItem(
                        icon: Icons.check,
                        count: historyData.where((h) =>
                        h.medicine == medicine &&
                            h.status == "taken" &&
                            _isDateInWeek(h.date, week)).length,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 16),
                      _buildWeekSummaryItem(
                        icon: Icons.access_time,
                        count: historyData.where((h) =>
                        h.medicine == medicine &&
                            h.status == "late" &&
                            _isDateInWeek(h.date, week)).length,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 16),
                      _buildWeekSummaryItem(
                        icon: Icons.close,
                        count: historyData.where((h) =>
                        h.medicine == medicine &&
                            h.status == "missed" &&
                            _isDateInWeek(h.date, week)).length,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekSummaryItem({required IconData icon, required int count, required Color color}) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 12,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthSummaryItem({required String value, required String label, required Color color}) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  void _showDoseDetails(MedicineHistory record) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("${record.medicine} ${record.dosage}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Fecha: ${_formatDate(record.date)}"),
              Text("Hora programada: ${record.time.format(context)}"),
              if (record.status == "taken" || record.status == "late")
                Text("Tomado a: ${record.takenAt?.format(context) ?? '--:--'}"),
              if (record.delay != null)
                Text("Retraso: ${record.delay} minutos"),
              const SizedBox(height: 16),
              Text(
                "Estado: ${record.status == "taken" ? "Tomado" : record.status == "missed" ? "Perdido" : "Tarde"}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: record.status == "taken"
                      ? Colors.green
                      : record.status == "missed"
                      ? Colors.red
                      : Colors.orange,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }

  void _showDayDetails(String medicine, DateTime date) {
    final dayRecords = historyData.where((h) =>
    h.medicine == medicine &&
        h.date.day == date.day &&
        h.date.month == date.month &&
        h.date.year == date.year).toList();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("$medicine - ${_formatDate(date)}"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: dayRecords.length,
              itemBuilder: (context, index) {
                final record = dayRecords[index];
                return ListTile(
                  title: Text("Hora: ${record.time.format(context)}"),
                  subtitle: Text("Estado: ${record.status == "taken" ? "Tomado" : record.status == "missed" ? "Perdido" : "Tarde"}"),
                  trailing: Icon(
                    record.status == "taken"
                        ? Icons.check_circle
                        : record.status == "missed"
                        ? Icons.cancel
                        : Icons.access_time,
                    color: record.status == "taken"
                        ? Colors.green
                        : record.status == "missed"
                        ? Colors.red
                        : Colors.orange,
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }

  // Funciones auxiliares
  List<DateTime> _getWeekDates([int weekOffset = 0]) {
    final today = DateTime.now();
    final currentDay = today.weekday;
    final monday = today.subtract(Duration(days: currentDay - 1 + weekOffset * 7));

    return List.generate(7, (i) => monday.add(Duration(days: i)));
  }

  List<DateTime> _getMonthDates([int monthOffset = 0]) {
    final today = DateTime.now();
    final year = today.year;
    final month = today.month + monthOffset;

    final firstDay = DateTime(year, month, 1);
    final lastDay = DateTime(year, month + 1, 0);
    final daysInMonth = lastDay.day;

    return List.generate(daysInMonth, (i) => DateTime(year, month, i + 1));
  }

  List<List<DateTime>> _groupDatesByWeeks(List<DateTime> monthDates) {
    final weeks = <List<DateTime>>[];
    var currentWeek = <DateTime>[];

    for (final date in monthDates) {
      if (date.weekday == DateTime.monday || currentWeek.isEmpty) {
        if (currentWeek.isNotEmpty) {
          weeks.add([...currentWeek]);
        }
        currentWeek = [date];
      } else {
        currentWeek.add(date);
      }
    }

    if (currentWeek.isNotEmpty) {
      weeks.add(currentWeek);
    }

    return weeks;
  }

  List<TimeOfDay> _getMedicineSchedules(String medicine) {
    if (medicine == "Paracetamol") {
      return const [
        TimeOfDay(hour: 8, minute: 0),
        TimeOfDay(hour: 16, minute: 0),
        TimeOfDay(hour: 0, minute: 0),
      ];
    } else if (medicine == "Ibuprofeno") {
      return const [
        TimeOfDay(hour: 9, minute: 0),
        TimeOfDay(hour: 21, minute: 0),
      ];
    }
    return [];
  }

  String _getDoseStatus(String medicine, DateTime date, TimeOfDay time) {
    try {
      final record = historyData.firstWhere((h) =>
      h.medicine == medicine &&
          h.date.day == date.day &&
          h.date.month == date.month &&
          h.date.year == date.year &&
          h.time.hour == time.hour &&
          h.time.minute == time.minute);

      return record.status;
    } catch (e) {
      return "pending";
    }
  }

  bool _isDateInWeek(DateTime date, List<DateTime> week) {
    return date.isAfter(week.first.subtract(const Duration(days: 1))) &&
        date.isBefore(week.last.add(const Duration(days: 1)));
  }

  bool _isDateInMonth(DateTime date, int monthOffset) {
    final today = DateTime.now();
    final year = today.year;
    final month = today.month + monthOffset;

    return date.year == year && date.month == month;
  }

  String _formatDate(DateTime date, {bool dayOnly = false}) {
    if (dayOnly) {
      return "${date.day}/${date.month}";
    }
    return "${date.day}/${date.month}/${date.year}";
  }

  String _getDayName(DateTime date) {
    const days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    return days[date.weekday - 1];
  }

  String _getMonthName(int monthOffset) {
    final today = DateTime.now();
    final date = DateTime(today.year, today.month + monthOffset, 1);
    const months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return "${months[date.month - 1]} ${date.year}";
  }
}

class MedicineHistory {
  final DateTime date;
  final TimeOfDay time;
  final String medicine;
  final String dosage;
  final String status; // "taken", "missed", "late"
  final int? delay; // minutos de retraso
  final TimeOfDay? takenAt;

  MedicineHistory({
    required this.date,
    required this.time,
    required this.medicine,
    required this.dosage,
    required this.status,
    this.delay,
    this.takenAt,
  });
}