import 'package:flutter/material.dart';
import 'colors.dart';

class DuoButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const DuoButton({super.key, required this.text, required this.onPressed});

  @override
  State<DuoButton> createState() => _DuoButtonState();
}

class _DuoButtonState extends State<DuoButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        margin: EdgeInsets.only(top: _isPressed ? 4 : 0), // Se hunde al presionar
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.primaryPurple,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (!_isPressed)
              const BoxShadow(
                color: AppColors.primaryOrange,
                offset: Offset(0, 4), // La "sombra" 3D
              ),
          ],
        ),
        child: Text(
          widget.text.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}