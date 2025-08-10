import 'package:flutter/material.dart';

class Informacion extends StatelessWidget {
  const Informacion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Sin AppBar para que el header quede pegado arriba
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 0, right: 0, bottom: 16), // sin top padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                width: double.infinity,
                color: Colors.blue.shade50,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Información',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Recursos y consejos sobre tus medicamentos',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),


              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    _buildSectionTitle('Medicamentos actuales', 3),
                    const SizedBox(height: 10),
                    _buildInfoCard(
                      icon: Icons.local_hospital,
                      iconColor: Colors.blue.shade400,
                      title: 'Paracetamol - Información',
                      subtitle1: 'Analgésico y antipirético seguro',
                      subtitle2: 'Reduce dolor y fiebre. Tomar con alimentos.',
                    ),
                    const SizedBox(height: 10),
                    _buildInfoCard(
                      icon: Icons.error_outline,
                      iconColor: Colors.orange.shade400,
                      title: 'Efectos secundarios',
                      subtitle1: 'Qué vigilar durante el tratamiento',
                      subtitle2: 'Náuseas leves, evitar alcohol.',
                    ),
                    const SizedBox(height: 10),
                    _buildInfoCard(
                      icon: Icons.block,
                      iconColor: Colors.pink.shade300,
                      title: 'Interacciones',
                      subtitle1: 'Medicamentos que debes evitar',
                      subtitle2: 'No combinar con otros analgésicos.',
                    ),

                    const SizedBox(height: 30),

                    _buildSectionTitle('Consejos de salud', 3),
                    const SizedBox(height: 10),
                    _buildInfoCard(
                      icon: Icons.access_time,
                      iconColor: Colors.green.shade400,
                      title: 'Mejores momentos para tomar medicamentos',
                      subtitle1: 'Optimiza la efectividad de tu tratamiento',
                      subtitle2: 'Con el estómago vacío o lleno según indicación.',
                    ),
                    const SizedBox(height: 10),
                    _buildInfoCard(
                      icon: Icons.inventory,
                      iconColor: Colors.green.shade400,
                      title: 'Almacenamiento seguro',
                      subtitle1: 'Mantén tus medicamentos en buen estado',
                      subtitle2: 'Lugar fresco y seco, lejos de niños.',
                    ),
                    const SizedBox(height: 10),
                    _buildInfoCard(
                      icon: Icons.verified,
                      iconColor: Colors.green.shade400,
                      title: 'Adherencia al tratamiento',
                      subtitle1: 'Importancia de seguir las indicaciones',
                      subtitle2: 'Completa el tratamiento aunque te sientas mejor.',
                    ),

                    const SizedBox(height: 30),

                    _buildSectionTitle('Recursos oficiales', 2),
                    const SizedBox(height: 10),
                    _buildInfoCard(
                      icon: Icons.link,
                      iconColor: Colors.purple.shade400,
                      title: 'COFEPRIS - Información de medicamentos',
                      subtitle1: 'Base de datos oficial de medicamentos',
                      subtitle2: 'Consulta información verificada oficialmente.',
                    ),
                    const SizedBox(height: 10),
                    _buildInfoCard(
                      icon: Icons.link,
                      iconColor: Colors.purple.shade400,
                      title: 'Secretaría de Salud',
                      subtitle1: 'Guías y recomendaciones médicas',
                      subtitle2: 'Recursos educativos sobre medicamentos.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, int badgeCount) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            badgeCount.toString(),
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        )
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle1,
    required String subtitle2,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(1, 2),
                ),
              ],
            ),
            child: Icon(icon, size: 32, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle1,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle2,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
