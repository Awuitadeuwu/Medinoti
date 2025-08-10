import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medinoti/firebase_options.dart';

// Importa tus pantallas
import 'Login/InicioSesion.dart';
import 'Login/Registro.dart';
import 'Login/Recuperacion.dart';
import 'Login/SplashPantallaL.dart';

import 'Pantallas/Bienvenida.dart';
import 'Pantallas/Hoy.dart';
import 'Pantallas/AgregarMed.dart';
import 'Pantallas/Campanita.dart';
import 'Pantallas/Historial.dart';
import 'Pantallas/HoyDos.dart';
import 'Pantallas/Informacion.dart';
import 'Pantallas/MedicinaPro.dart';
import 'Pantallas/yo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recordatorio de Medicamentos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',  // Ruta inicial (SplashScreen)
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const InicioSesion(),
        '/registro': (context) => const Registro(),
        '/recuperacion': (context) => const Recuperacion(),
        '/bienvenida': (context) => const Bienvenida(),
        '/hoy': (context) => const Hoy(),
        '/hoyDos': (context) => const HoyDos(),
        '/informacion': (context) => const Informacion(),
        '/yo': (context) => const Yo(),
      },
    );
  }
}
