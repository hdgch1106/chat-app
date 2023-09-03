import 'package:flutter/material.dart';

class LoginLabels extends StatelessWidget {
  final String ruta;
  final String label1;
  final String label2;

  const LoginLabels({
    super.key,
    required this.ruta,
    required this.label1,
    required this.label2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label1,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            if (context.mounted) {
              Navigator.pushReplacementNamed(context, ruta);
            }
          },
          child: Text(
            label2,
            style: TextStyle(
              color: Colors.blue[600],
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
