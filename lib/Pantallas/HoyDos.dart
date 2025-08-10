import 'package:flutter/material.dart';
import '../Pantallas/AgregarMed.dart';

class Medicine {
  final String id;
  final String name;
  final String dosage;
  final String nextDose;
  int remainingPills;
  final int totalPills;
  final String frequency;
  bool taken;
  final int totalDoses;
  int takenDoses;
  final int frequencyHours;
  final String startDate;
  final String endDate;

  Medicine({
    required this.id,
    required this.name,
    required this.dosage,
    required this.nextDose,
    required this.remainingPills,
    required this.totalPills,
    required this.frequency,
    this.taken = false,
    required this.totalDoses,
    required this.takenDoses,
    required this.frequencyHours,
    required this.startDate,
    required this.endDate,
  });
}

//para las tomas
class MedicineHistory {
  final DateTime date;
  final TimeOfDay time;
  final String medicine;
  final String dosage;
  final String status; // "taken", "missed", "late"
  final int? delay; // minutos de retraso
  final TimeOfDay? takenAt; //Minutis de retraso

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

//Contenido de la interfaz Hoy
class HoyDos extends StatefulWidget {
  const HoyDos({super.key});

  @override
  State<HoyDos> createState() => _HoyDosState();
}

//Contenido de cada Medicmento
class _HoyDosState extends State<HoyDos> {
  late DateTime currentTime;

  List<Medicine> medicines = [
    Medicine(
      id: "1",
      name: "Paracetamol",
      dosage: "500mg",
      nextDose: "14:00",
      remainingPills: 8,
      totalPills: 20,
      frequency: "Cada 8 horas",
      taken: false,
      totalDoses: 21,
      takenDoses: 13,
      frequencyHours: 8,
      startDate: "2024-01-01",
      endDate: "2024-01-08",
    ),
    Medicine(
      id: "2",
      name: "Ibuprofeno",
      dosage: "400mg",
      nextDose: "16:30",
      remainingPills: 12,
      totalPills: 15,
      frequency: "Cada 12 horas",
      taken: true,
      totalDoses: 14,
      takenDoses: 3,
      frequencyHours: 12,
      startDate: "2024-01-05",
      endDate: "2024-01-12",
    ),
  ];

  List<MedicineHistory> historyData = [];


  //Para iniciar el timepo real
  @override
  void initState() {
    super.initState();
    currentTime = DateTime.now();
    Future.delayed(Duration.zero, () {
      _startTimer();
    });
  }

  void _startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          currentTime = DateTime.now();
        });
        return true;
      }
      return false;
    });
  }

  //Marcar tomado
  void takeMedicine(String id) {
    setState(() {
      final med = medicines.firstWhere((m) => m.id == id);
      if (!med.taken && med.remainingPills > 0) {
        final now = DateTime.now();
        final currentTime = TimeOfDay.fromDateTime(now);

        // hora programada del medicamento
        final nextDoseParts = med.nextDose.split(':');
        final scheduledTime = TimeOfDay(
          hour: int.parse(nextDoseParts[0]),
          minute: int.parse(nextDoseParts[1]),
        );

        // Calcular si está tarde (más de 5 minutos despuus de la hora programada)
        int delayMinutes = 0;
        String status = "taken";

        if (currentTime.hour > scheduledTime.hour ||
            (currentTime.hour == scheduledTime.hour && currentTime.minute > scheduledTime.minute + 5)) {
          status = "late";
          delayMinutes = (currentTime.hour - scheduledTime.hour) * 60 +
              (currentTime.minute - scheduledTime.minute);
        }

        // Registrar en el historial
        historyData.add(MedicineHistory(
          date: now,
          time: scheduledTime,
          medicine: med.name,
          dosage: med.dosage,
          status: status,
          delay: status == "late" ? delayMinutes : null,
          takenAt: currentTime,
        ));

        // Actualizar el estado del medicamento
        med.taken = true;
        med.remainingPills -= 1;
        med.takenDoses += 1;

        // Actualizar el progreso
        final progressPercent = med.takenDoses / med.totalDoses;

        // Si todas las dosis han sido tomadas, marcar como completado
        if (med.takenDoses >= med.totalDoses) {
          med.taken = true;
        }

        // Mostrar confirmacion
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${med.name} registrado como ${status == "taken" ? "tomado" : "tomado tarde"}'),
            backgroundColor: status == "taken" ? Colors.green : Colors.orange,
          ),
        );
      }
    });
  }

  //MostrarHora
  String formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Hoy",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${currentTime.toLocal().weekdayNameEs()}, ${currentTime.day} de ${currentTime.toLocal().monthNameEs()} de ${currentTime.year}",
                        style: const TextStyle(
                          color: Color(0xFFBFDBFE),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    formatTime(currentTime),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Botones
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text("Agregar", style: TextStyle(color: Colors.white)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white70),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.white24,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ).copyWith(
                        overlayColor: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.hovered) || states.contains(WidgetState.pressed)) {
                            return Colors.white.withOpacity(0.4);
                          }
                          return null;
                        }),
                      ),
                      onPressed: () async {
                        final newMed = await showDialog<Medicine>(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              insetPadding: const EdgeInsets.all(16),
                              child: SizedBox(
                                width: double.infinity,
                                height: 600,
                                child: AgregarMed(isModal: true),
                              ),
                            );
                          },
                        );

                        if (newMed != null) {
                          setState(() {
                            medicines.add(newMed);
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                      label: const Text("Escanear", style: TextStyle(color: Colors.white)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white70),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.white24,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ).copyWith(
                        overlayColor: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.hovered) || states.contains(MaterialState.pressed)) {
                            return Colors.white.withOpacity(0.4);
                          }
                          return null;
                        }),
                      ),
                      onPressed: () {
                        // Función escanear aquí
                      },
                    ),
                  ),
                ],
              ),
            ),

            // CONTENIDO PRINCIPAL
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 24),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Progreso de tratamientos", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Color(0xFF1F2937))),
                      const SizedBox(height: 16),
                      Column(
                        children: medicines.map((medicine) {
                          final progressPercent = medicine.takenDoses / medicine.totalDoses;
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${medicine.name} • ${medicine.dosage}",
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                                  const SizedBox(height: 8),
                                  LinearProgressIndicator(
                                    value: progressPercent,
                                    color: const Color(0xFF3B82F6),
                                    backgroundColor: Colors.grey.shade300,
                                    minHeight: 8,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                      "Progreso: ${(progressPercent * 100).round()}% (${medicine.takenDoses}/${medicine.totalDoses} dosis)",
                                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Medicamentos de hoy", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Color(0xFF1F2937))),
                          Container(
                            decoration: BoxDecoration(color: const Color(0xFFBFDBFE), borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: Text("${medicines.where((m) => !m.taken).length} pendientes", style: const TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Column(
                        children: medicines.map((medicine) {
                          return Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: medicine.taken ? Colors.green.shade200 : Colors.grey.shade300)),
                            color: medicine.taken ? Colors.green.shade50 : Colors.white,
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(color: medicine.taken ? Colors.green.shade100 : const Color(0xFFBFDBFE), borderRadius: BorderRadius.circular(100)),
                                    width: 48,
                                    height: 48,
                                    child: Icon(medicine.taken ? Icons.check_circle : Icons.medication, color: medicine.taken ? Colors.green.shade700 : const Color(0xFF2563EB), size: 28),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(medicine.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1F2937))),
                                        const SizedBox(height: 4),
                                        Text("${medicine.dosage} • ${medicine.frequency}", style: const TextStyle(color: Colors.grey, fontSize: 14)),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            const Icon(Icons.access_time, size: 16, color: Colors.grey),
                                            const SizedBox(width: 4),
                                            Text("Próxima: ${medicine.nextDose}", style: const TextStyle(color: Colors.grey, fontSize: 14)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text("${medicine.remainingPills}/${medicine.totalPills} restantes", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                      const SizedBox(height: 6),
                                      medicine.taken
                                          ? Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(8)),
                                        child: const Text("Tomado", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                                      )
                                          : ElevatedButton(
                                        onPressed: () => takeMedicine(medicine.id),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF2563EB),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        ).copyWith(
                                          overlayColor: MaterialStateProperty.all(const Color(0xFF1D4ED8)),
                                        ),
                                        child: const Text("Tomar"),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      Card(
                        color: const Color(0xFFFFF7ED),
                        margin: const EdgeInsets.only(top: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: const [
                              Icon(Icons.warning_amber_rounded, color: Color(0xFFEA580C), size: 32),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "Recordatorio importante\nSi olvidas tomar tu medicamento, se notificará a tu contacto de emergencia.",
                                  style: TextStyle(color: Color(0xFFB45309)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Extensiones para fechas
extension DateExtensions on DateTime {
  String weekdayNameEs() {
    const names = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    return names[this.weekday - 1];
  }

  String monthNameEs() {
    const months = ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'];
    return months[this.month - 1];
  }
}
