import 'package:flutter/material.dart';

class Recuperacion extends StatefulWidget {
  const Recuperacion({super.key});

  @override
  State<Recuperacion> createState() => _Recuperacion();
}

class _Recuperacion extends State<Recuperacion> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;
  bool emailSent = false;

  void _handleSubmit() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isLoading = false;
      emailSent = true;
    });
  }

  void _handleResend() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    const colorStart = Color(0xFF3B82F6);
    const colorEnd = Color(0xFF1E40AF);

    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [colorStart, colorEnd],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Recuperar Contraseña',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
                    ),
                    child: const Icon(Icons.medication_outlined,
                        color: colorStart, size: 36),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: emailSent
                          ? Column(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check_circle,
                                color: Colors.green, size: 36),
                          ),
                          const SizedBox(height: 16),
                          const Text('Revisa tu correo',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(emailController.text,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 24),

                          // Instrucciones nuevas aquí
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              border: Border.all(color: Colors.blue.shade200),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Instrucciones:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2563EB), // azul intenso
                                      fontSize: 16),
                                ),
                                SizedBox(height: 8),
                                Text('• Revisa tu bandeja de entrada',
                                    style:
                                    TextStyle(color: Color(0xFF3B82F6))),
                                Text('• Busca también en spam o promociones',
                                    style:
                                    TextStyle(color: Color(0xFF3B82F6))),
                                Text('• Haz clic en el enlace del correo',
                                    style:
                                    TextStyle(color: Color(0xFF3B82F6))),
                                Text('• Crea tu nueva contraseña',
                                    style:
                                    TextStyle(color: Color(0xFF3B82F6))),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: isLoading ? null : _handleResend,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 48),
                              backgroundColor: Colors.transparent,
                              foregroundColor: colorStart,
                              side: const BorderSide(color: colorStart),
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator(
                                color: colorStart)
                                : const Text('Reenviar correo'),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 48),
                              backgroundColor: colorStart,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Volver al inicio de sesión'),
                          )
                        ],
                      )
                          : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            '¿Olvidaste tu contraseña?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Ingresa tu correo electrónico y te enviaremos un enlace para restablecer tu contraseña.',
                            textAlign: TextAlign.center,
                            style:
                            TextStyle(color: Colors.black54, fontSize: 14),
                          ),
                          const SizedBox(height: 24),
                          TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Correo electrónico',
                              prefixIcon: const Icon(Icons.mail_outline),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: isLoading ? null : _handleSubmit,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 48),
                              backgroundColor: colorStart,
                              foregroundColor: Colors.white,
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator(
                                color: Colors.white)
                                : const Text('Enviar enlace de recuperación'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (!emailSent)
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        '¿Recordaste tu contraseña? Inicia sesión',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  const SizedBox(height: 12),
                  const Text(
                    'Si no recibes el correo en unos minutos, verifica que la dirección sea correcta o contacta soporte.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF60A5FA), fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
