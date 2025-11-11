import 'package:flutter/material.dart';
import '../widget/home_widget_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  String _status = 'Sin actualizar aún 💤';

  // Método para enviar la frase al widget
  Future<void> _updateWidget() async {
    final message = _controller.text.trim().isEmpty
        ? 'Respira y sonríe 🌿'
        : _controller.text.trim();

    await HomeWidgetService.updateWidget(message);
    setState(() {
      _status = 'Widget actualizado con: "$message" ';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('ZenMind '),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            const Text(
              'Crea tu frase Zen del día',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Campo de texto para ingresar frase personalizada
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Tu frase motivacional',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.edit, color: Colors.blueAccent),
              ),
            ),
            const SizedBox(height: 20),

            // Botón para actualizar widget
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _updateWidget,
              icon: const Icon(Icons.sync),
              label: const Text(
                'Actualizar widget',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 30),

            // Estado actual del widget
            Text(
              _status,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontStyle: FontStyle.italic,
              ),
            ),

            const Spacer(),

            const Text(
              'El widget ZenMind se actualiza automáticamente en tu pantalla principal.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
