import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Yo extends StatefulWidget {
  const Yo({super.key});

  @override
  State<Yo> createState() => _YoState();
}

class _YoState extends State<Yo> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController doctorNameController = TextEditingController();
  final TextEditingController doctorPhoneController = TextEditingController();

  final TextEditingController tempEmergencyNameController = TextEditingController();
  final TextEditingController tempEmergencyPhoneController = TextEditingController();
  final TextEditingController tempEmergencyRelationController = TextEditingController();

  bool isEditing = false;
  List<Map<String, String>> emergencyContacts = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      emailController.text = user.email ?? '';
      passwordController.text = ''; // No se puede obtener la contraseña real

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        doctorNameController.text = data['doctorName'] ?? '';
        doctorPhoneController.text = data['doctorPhone'] ?? '';

        final List<dynamic>? contacts = data['emergencyContacts'];
        if (contacts != null) {
          emergencyContacts = contacts.map<Map<String, String>>((c) {
            return {
              'name': c['name'] ?? '',
              'phone': c['phone'] ?? '',
              'relation': c['relation'] ?? '',
            };
          }).toList();
        }
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // HEADER con fondo azul
          Container(
            width: double.infinity,
            color: const Color(0xFF3B82F6),
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Mi Perfil",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Gestiona tu información personal",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFBFDBFE),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Informacion Personal
                  const Text("Información Personal",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Correo electrónico',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    enabled: false, // No editable
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Nueva contraseña',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                      helperText: 'Dejar vacío para no cambiar',
                    ),
                    obscureText: true,
                    enabled: isEditing,
                  ),
                  const SizedBox(height: 24),

                  //  Contactos de Emergencia
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Contactos de emergencia",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      if (isEditing)
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline,
                              color: Colors.blue, size: 28),
                          onPressed: () => _showEmergencyContactDialog(null),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (emergencyContacts.isEmpty && !isEditing)
                    const Center(
                        child: Text("No hay contactos de emergencia registrados")),

                  ...emergencyContacts.map((contact) => Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 3,
                    color: Colors.orange[50],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.orange.shade200),
                    ),
                    child: ListTile(
                      title: Text(contact['name'] ?? 'Sin nombre'),
                      subtitle: Text(
                          "Relación: ${contact['relation'] ?? 'Sin relación'}\nTeléfono: ${contact['phone'] ?? 'Sin teléfono'}"),
                      leading:
                      const Icon(Icons.person, color: Colors.orange),
                      trailing: isEditing
                          ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit,
                                color: Colors.blue),
                            onPressed: () =>
                                _showEmergencyContactDialog(contact),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.red),
                            onPressed: () =>
                                _confirmDeleteContact(contact),
                          ),
                        ],
                      )
                          : null,
                    ),
                  )),

                  const SizedBox(height: 24),

                  // Contacto Medico
                  const Text("Contacto médico",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
                          if (isEditing) ...[
                            TextFormField(
                              controller: doctorNameController,
                              decoration: const InputDecoration(
                                labelText: 'Nombre del médico',
                                prefixIcon: Icon(Icons.medical_services),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: doctorPhoneController,
                              decoration: const InputDecoration(
                                labelText: 'Teléfono del médico',
                                prefixIcon: Icon(Icons.phone),
                              ),
                              keyboardType: TextInputType.phone,
                            ),
                          ] else
                            ListTile(
                              title: Text(
                                  doctorNameController.text.isEmpty
                                      ? 'Sin nombre registrado'
                                      : doctorNameController.text),
                              subtitle: Text(
                                  doctorPhoneController.text.isEmpty
                                      ? 'Sin teléfono registrado'
                                      : "Teléfono: ${doctorPhoneController.text}"),
                              leading: const Icon(Icons.medical_services,
                                  color: Colors.purple),
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  //Guardar Cambios
                  if (isEditing)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _saveChanges,
                        child: const Text(
                          'GUARDAR CAMBIOS',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                  const SizedBox(height: 12),

                  // Cerrar Sesion/Cancelar
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        if (isEditing) {
                          setState(() => isEditing = false);
                        } else {
                          await _auth.signOut();
                          Navigator.of(context).pushReplacementNamed('/login');
                        }
                      },
                      child: Text(
                        isEditing ? 'CANCELAR' : 'CERRAR SESIÓN',
                        style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  if (!isEditing) const SizedBox(height: 16),

                  if (!isEditing)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => setState(() => isEditing = true),
                        child: const Text(
                          'EDITAR PERFIL',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEmergencyContactDialog(Map<String, String>? contact) {
    if (contact != null) {
      tempEmergencyNameController.text = contact['name'] ?? '';
      tempEmergencyPhoneController.text = contact['phone'] ?? '';
      tempEmergencyRelationController.text = contact['relation'] ?? '';
    } else {
      tempEmergencyNameController.clear();
      tempEmergencyPhoneController.clear();
      tempEmergencyRelationController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(contact == null ? 'Agregar contacto' : 'Editar contacto'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: tempEmergencyNameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre completo',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: tempEmergencyRelationController,
                decoration: const InputDecoration(
                  labelText: 'Relación',
                  prefixIcon: Icon(Icons.group),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: tempEmergencyPhoneController,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3B82F6)),
            onPressed: () {
              if (tempEmergencyNameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('El nombre es requerido')));
                return;
              }

              setState(() {
                if (contact != null) {
                  final index = emergencyContacts.indexWhere(
                          (c) => c['name'] == contact['name'] && c['phone'] == contact['phone']);
                  if (index != -1) {
                    emergencyContacts[index] = {
                      'name': tempEmergencyNameController.text,
                      'relation': tempEmergencyRelationController.text,
                      'phone': tempEmergencyPhoneController.text,
                    };
                  }
                } else {
                  emergencyContacts.add({
                    'name': tempEmergencyNameController.text,
                    'relation': tempEmergencyRelationController.text,
                    'phone': tempEmergencyPhoneController.text,
                  });
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Guardar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteContact(Map<String, String> contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar contacto'),
        content: Text('¿Estás seguro de eliminar a ${contact['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() => emergencyContacts.remove(contact));
              Navigator.pop(context);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _saveChanges() async {
    final user = _auth.currentUser;
    if (user == null) return;

    if (doctorNameController.text.isEmpty || doctorPhoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa los datos del médico'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Actualizar contraseña solo si se llena
      if (passwordController.text.isNotEmpty) {
        await user.updatePassword(passwordController.text);
      }

      // Guardar datos en Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'doctorName': doctorNameController.text,
        'doctorPhone': doctorPhoneController.text,
        'emergencyContacts': emergencyContacts,
      }, SetOptions(merge: true));

      setState(() => isEditing = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cambios guardados exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar cambios: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
