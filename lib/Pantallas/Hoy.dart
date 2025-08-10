import 'package:flutter/material.dart';
import 'HoyDos.dart'; // Importa la pantalla moderna "HoyDos"
import '../Pantallas/Historial.dart';
import '../Pantallas/Informacion.dart';
import '../Pantallas/yo.dart';

class Hoy extends StatefulWidget {
  const Hoy({super.key});

  @override
  State<Hoy> createState() => _HoyState();
}

class _HoyState extends State<Hoy> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HoyDos(),
    const Historial(medicines: [],),
    const Informacion(),
    const Yo(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<String> _titles = const [
    "Hoy",
    "Historial",
    "Información",
    "Yo",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_selectedIndex])),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Hoy",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "Historial",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: "Información",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Yo",
          ),
        ],
      ),
    );
  }
}
