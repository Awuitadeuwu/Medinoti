import 'package:flutter/material.dart' show Border, BorderRadius, BorderSide, BoxConstraints, BoxDecoration, BuildContext, Builder, Card, Center, CircularProgressIndicator, Colors, Column, ConstrainedBox, Container, CrossAxisAlignment, DropdownButtonFormField, DropdownMenuItem, EdgeInsets, ElevatedButton, Expanded, FontWeight, GestureDetector, Icon, IconButton, Icons, InkWell, InputDecoration, InputDecorator, ListView, MainAxisAlignment, MainAxisSize, Material, Navigator, OutlineInputBorder, OutlinedButton, Padding, RoundedRectangleBorder, Row, ScaffoldMessenger, SingleChildScrollView, Size, SizedBox, SnackBar, State, StatefulWidget, Text, TextAlign, TextEditingController, TextField, TextInputType, TextStyle, TimeOfDay, Widget, Wrap, showDatePicker, showTimePicker;

import 'HoyDos.dart';
//Mostrar los form como modales
class AgregarMed extends StatefulWidget {
  const AgregarMed({super.key, required bool isModal});

  @override
  State<AgregarMed> createState() => _AgregarMedState();
}

class _AgregarMedState extends State<AgregarMed> {
  String step = "scan";
  bool isScanning = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController loteController = TextEditingController();
  DateTime? expiryDate;
  final TextEditingController dosageController = TextEditingController();
  int totalPills = 1;
  final TextEditingController durationValueController = TextEditingController();
  String durationPeriod = 'days';
  final TextEditingController instructionsController = TextEditingController();

  List<TimeOfDay> schedules = [];

  final TextEditingController emergencyNameController = TextEditingController();
  final TextEditingController emergencyPhoneController = TextEditingController();
  final TextEditingController emergencyRelationController = TextEditingController();

  final TextEditingController doctorNameController = TextEditingController();
  final TextEditingController doctorPhoneController = TextEditingController();


  List<int> intervalOptions = [4, 6, 8, 12, 24]; // Opciones de horas
  int selectedIntervalHours = 8; // Valor predeterminado
  List<TimeOfDay> generatedSchedules = [];
  int totalDoses = 0;


  void simulateScan() {
    setState(() => isScanning = true);
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        nameController.text = "Paracetamol";
        loteController.text = "LOT2024A001";
        expiryDate = DateTime(2025, 12, 31);
        dosageController.text = "1 tableta (500mg)";
        totalPills = 10;
        durationValueController.text = "7";
        durationPeriod = "days";
        isScanning = false;
        step = "form";
      });
    });
  }

  //corregir estaen ingles elcalendario
  Future<void> pickExpiryDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: expiryDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => expiryDate = picked);
  }

  //corregir esta en ingles la horas dias
  Future<void> pickScheduleTime(int index) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: schedules.isNotEmpty ? schedules[index] : const TimeOfDay(hour: 8, minute: 0),
    );
    if (picked != null) {
      setState(() {
        if (index < schedules.length) {
          schedules[index] = picked;
        }
      });
    }
  }

  void addSchedule() {
    setState(() {
      schedules.add(const TimeOfDay(hour: 8, minute: 0));
    });
  }

  void removeSchedule(int index) {
    setState(() {
      schedules.removeAt(index);
    });
  }

  //  Para llenar Todos los campos del form
  void _openAgregarMed() {
    final startDate = DateTime.now();

    // Calcular endDate basado en la duración ingresada
    DateTime endDate;
    final durationValue = int.tryParse(durationValueController.text) ?? 0;

    switch (durationPeriod) {
      case 'days':
        endDate = startDate.add(Duration(days: durationValue));
        break;
      case 'weeks':
        endDate = startDate.add(Duration(days: durationValue * 7));
        break;
      case 'months':
        endDate = startDate.add(Duration(days: durationValue * 30)); // Aproximación
        break;
      case 'finish':
      default:
      // Si es "hasta terminar", calculamos basado en las pastillas restantes y la frecuencia
        endDate = startDate.add(Duration(days: (totalPills * selectedIntervalHours / 24).ceil()));
    }

    // Calcular el numero total de dosis basado en la frecuencia
    final freqHours = selectedIntervalHours;
    final totalHours = endDate.difference(startDate).inHours;
    final totalDoses = (totalHours / freqHours).ceil();

    final newMedicine = Medicine(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: nameController.text,
      dosage: dosageController.text,
      nextDose: schedules.isNotEmpty ? schedules.first.format(context) : "00:00",
      remainingPills: totalPills,
      totalPills: totalPills,
      frequency: "Cada $selectedIntervalHours horas",
      taken: false,
      totalDoses: totalDoses,
      takenDoses: 0,
      frequencyHours: selectedIntervalHours,
      startDate: startDate.toString().substring(0, 10),
      endDate: endDate.toString().substring(0, 10),
    );

    Navigator.pop(context, newMedicine);
  }

  List<DropdownMenuItem<int>> quantityOptions() => List.generate(
    10,
        (i) => DropdownMenuItem(
      value: i + 1,
      child: Text("${i + 1} ${(i == 0) ? "unidad" : "unidades"}"),
    ),
  );


  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420, maxHeight: 600),
        child: Material(
          elevation: 20,
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Encabezado con botón de cerrar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Agregar Medicamento",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Cuerpo: contenido de pasos
                Expanded(
                  child: Builder(
                    builder: (_) {
                      switch (step) {
                        case "scan":
                          return buildScanStep();
                        case "form":
                          return buildFormStep();
                        case "schedules":
                          return buildSchedulesStep();
                        case "contacts":
                          return buildContactsStep();
                        case "summary":
                          return buildSummaryStep();
                        default:
                          return const Center(child: Text("Paso desconocido"));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildScanStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: isScanning
                ? Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 12),
                Text("Escaneando código de barras..."),
              ],
            )
                : Icon(Icons.camera_alt, size: 60, color: Colors.grey[600]),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          isScanning
              ? "Mantén el código de barras centrado"
              : "Coloca el código de barras del medicamento frente a la cámara",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 32),
        ElevatedButton.icon(
          icon: const Icon(Icons.qr_code_scanner),
          label: Text(isScanning ? "Escaneando..." : "Iniciar Escaneo"),
          onPressed: isScanning ? null : simulateScan,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            backgroundColor: Colors.blue[600],
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => setState(() => step = "form"),
          style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
          child: const Text("Agregar Manualmente"),
        ),
      ],
    );
  }

  Widget buildFormStep() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Nombre del medicamento *", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Ej: Paracetamol",
            ),
          ),
          const SizedBox(height: 16),
          const Text("Lote *", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          TextField(
            controller: loteController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Ej: LOT2024A001",
            ),
          ),
          const SizedBox(height: 16),
          const Text("Fecha de caducidad *", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          InkWell(
            onTap: () => pickExpiryDate(context),
            child: InputDecorator(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              child: Text(
                expiryDate == null
                    ? "Selecciona fecha"
                    : "${expiryDate!.day}/${expiryDate!.month}/${expiryDate!.year}",
                style: TextStyle(
                  color: expiryDate == null ? Colors.grey[600] : Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text("Dosis por toma *", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          TextField(
            controller: dosageController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Ej: 1 tableta (500mg)",
            ),
          ),
          const SizedBox(height: 16),
          const Text("Cantidad total de unidades *", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          DropdownButtonFormField<int>(
            value: totalPills,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: quantityOptions(),
            onChanged: (value) {
              if (value != null) setState(() => totalPills = value);
            },
          ),
          const SizedBox(height: 16),
          const Text("Duración del tratamiento *", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Row(
            children: [
              SizedBox(
                width: 80,
                child: TextField(
                  controller: durationValueController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "7",
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: durationPeriod,
                  items: const [
                    DropdownMenuItem(value: 'days', child: Text('Días')),
                    DropdownMenuItem(value: 'weeks', child: Text('Semanas')),
                    DropdownMenuItem(value: 'months', child: Text('Meses')),
                    DropdownMenuItem(value: 'finish', child: Text('Hasta terminar')),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => durationPeriod = value);
                  },
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text("Instrucciones especiales", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          TextField(
            controller: instructionsController,
            maxLines: 3,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Ej: Tomar con alimentos, evitar alcohol...",
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancelar"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => setState(() => step = "schedules"),
                  child: const Text("Siguiente"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSchedulesStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Horarios de toma", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 12),

        const Text("Frecuencia entre tomas", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),

        DropdownButtonFormField<int>(
          value: selectedIntervalHours,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          items: intervalOptions
              .map((hour) => DropdownMenuItem(value: hour, child: Text("Cada $hour horas")))
              .toList(),
          onChanged: (value) {
            if (value != null) setState(() => selectedIntervalHours = value);
          },
        ),

        const SizedBox(height: 16),

        const Text("Generar horarios automáticamente", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),

        OutlinedButton.icon(
          icon: Icon(Icons.schedule, color: Colors.blue.shade600),
          label: Text("Seleccionar hora de inicio y generar", style: TextStyle(color: Colors.blue.shade600)),
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            minimumSize: const Size(double.infinity, 48),
            side: BorderSide(color: Colors.blue.shade200),
          ),
          onPressed: () async {
            final pickedTime = await showTimePicker(
              context: context,
              initialTime: const TimeOfDay(hour: 8, minute: 0),
            );

            if (pickedTime != null) {
              final freq = selectedIntervalHours;
              int duration = int.tryParse(durationValueController.text) ?? 0;

              if (duration == 0 && totalPills == 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Ingresa una duración o el total de pastillas válidas.")),
                );
                return;
              }

              int totalHours;
              if (durationPeriod == 'dias') {
                totalHours = duration * 24;
              } else if (durationPeriod == 'Semanas') {
                totalHours = duration * 7 * 24;
              } else if (durationPeriod == 'Meses') {
                totalHours = duration * 30 * 24;
              } else {
                totalHours = totalPills * freq;
              }

              totalDoses = (totalHours / freq).floor();

              List<TimeOfDay> generated = [];
              int hour = pickedTime.hour;
              int minute = pickedTime.minute;

              for (int i = 0; i < totalDoses; i++) {
                generated.add(TimeOfDay(hour: hour % 24, minute: minute));
                hour += freq;
              }

              setState(() {
                schedules = generated;
              });
            }
          },
        ),

        const SizedBox(height: 12),

        if (schedules.isNotEmpty && selectedIntervalHours > 0)
          Builder(
            builder: (_) {
              int dosisPorDia = (24 / selectedIntervalHours).floor();
              int dias = 1;

              if (durationPeriod == 'days') {
                dias = int.tryParse(durationValueController.text) ?? 1;
              } else if (durationPeriod == 'weeks') {
                dias = (int.tryParse(durationValueController.text) ?? 1) * 7;
              } else if (durationPeriod == 'months') {
                dias = (int.tryParse(durationValueController.text) ?? 1) * 30;
              }

              int totalDosis = dosisPorDia * dias;

              return Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Horarios generados automáticamente:",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: schedules.map((t) {
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(t.format(context), style: const TextStyle(color: Colors.blue)),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Tomarás $dosisPorDia dosis por día durante $dias días. Total: $totalDosis dosis.",
                      style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              );
            },
          ),

        const SizedBox(height: 16),

        Expanded(
          child: Card(
            elevation: 3,
            color: Colors.blue[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.blue.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: schedules.isEmpty
                  ? Center(child: Text("No hay horarios agregados.", style: TextStyle(color: Colors.blue.shade700)))
                  : ListView.builder(
                itemCount: schedules.length,
                itemBuilder: (_, index) {
                  final time = schedules[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Icon(Icons.access_time, size: 18, color: Colors.grey[400]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => pickScheduleTime(index),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.white,
                              ),
                              child: Text(time.format(context)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(36, 36),
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: () => removeSchedule(index),
                          child: Icon(Icons.delete_outline, size: 18, color: Colors.blue.shade600),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => step = "form"),
                child: const Text("Atrás"),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: schedules.isEmpty ? null : () => setState(() => step = "contacts"),
                child: const Text("Siguiente"),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildContactsStep() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Contacto de emergencia", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 12),
          Card(
            elevation: 3,
            color: Colors.orange[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.orange.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  TextField(
                    controller: emergencyNameController,
                    decoration: const InputDecoration(
                      labelText: "Nombre completo",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: emergencyPhoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "Teléfono",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: emergencyRelationController,
                    decoration: const InputDecoration(
                      labelText: "Relación",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text("Contacto médico", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 12),
          Card(
            elevation: 3,
            color: Colors.purple[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.purple.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  TextField(
                    controller: doctorNameController,
                    decoration: const InputDecoration(
                      labelText: "Nombre completo",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: doctorPhoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "Teléfono",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => step = "schedules"),
                  child: const Text("Atrás"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => setState(() => step = "summary"),
                  child: const Text("Siguiente"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSummaryStep() {
    int horariosPorDia = selectedIntervalHours > 0 ? (24 / selectedIntervalHours).floor() : 0;

    int dias = 1;
    if (durationPeriod == 'dia') {
      dias = int.tryParse(durationValueController.text) ?? 1;
    } else if (durationPeriod == 'Semana') {
      dias = (int.tryParse(durationValueController.text) ?? 1) * 7;
    } else if (durationPeriod == 'Mes') {
      dias = (int.tryParse(durationValueController.text) ?? 1) * 30;
    }

    int totalDosis = horariosPorDia * dias;

    Widget buildAdviceCard(String text) {
      return Card(
        elevation: 3,
        color: Colors.yellow[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.yellow.shade200),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            "• $text",
            style: TextStyle(color: Colors.yellow.shade700),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        color: Colors.green[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.green.shade200),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text("Resumen del tratamiento:",
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.green.shade800)),
                  const SizedBox(height: 8),

                  if (nameController.text.isNotEmpty)
                    Text("Medicamento: ${nameController.text}", style: TextStyle(color: Colors.green.shade700)),
                  if (loteController.text.isNotEmpty)
                    Text("Lote: ${loteController.text}", style: TextStyle(color: Colors.green.shade700)),
                  if (expiryDate != null)
                    Text("Caduca: ${expiryDate!.day}/${expiryDate!.month}/${expiryDate!.year}", style: TextStyle(color: Colors.green.shade700)),
                  if (dosageController.text.isNotEmpty)
                    Text("Dosis por toma: ${dosageController.text}", style: TextStyle(color: Colors.green.shade700)),
                  if (durationValueController.text.isNotEmpty)
                    Text("Duración: ${durationValueController.text} $durationPeriod", style: TextStyle(color: Colors.green.shade700)),

                  if (horariosPorDia > 0)
                    Text("Horarios por día: $horariosPorDia", style: TextStyle(color: Colors.green.shade700)),

                  if (totalDosis > 0)
                    Text("Total estimado de dosis: $totalDosis", style: TextStyle(color: Colors.green.shade700)),

                  const SizedBox(height: 8),
                  if (schedules.isNotEmpty)
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: schedules.map((schedule) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            schedule.format(context),
                            style: TextStyle(
                              color: Colors.green[700],
                              fontSize: 12,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Tarjetas de consejo
          if (durationPeriod == 'days' && int.tryParse(durationValueController.text) != null)
            buildAdviceCard(
              int.parse(durationValueController.text) <= 7
                  ? "Para tratamientos cortos, se recomienda tomar cada 6-8 horas"
                  : "Para tratamientos largos, considera horarios que se adapten a tu rutina diaria",
            ),
          if (durationPeriod == 'weeks')
            buildAdviceCard("Para tratamientos semanales, mantén horarios consistentes todos los días"),
          if (durationPeriod == 'months')
            buildAdviceCard("Para tratamientos prolongados, elige horarios que puedas mantener a largo plazo"),
          if (durationPeriod == 'finish')
            buildAdviceCard("Hasta terminar: Sigue las indicaciones médicas sobre la frecuencia"),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => step = "contacts"),
                  child: const Text("Atrás"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _openAgregarMed,
                  child: const Text("Guardar"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


