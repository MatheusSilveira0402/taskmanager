import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final Future<void> Function() onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isLoading = false;
  bool _isSuccess = false;

  Future<void> _handlePressed() async {
    setState(() {
      _isLoading = true;
      _isSuccess = false;
    });

    try {
      await widget.onPressed();
      setState(() {
        _isSuccess = true;
      });
      // Mostrar check por 2 segundos antes de voltar ao normal
      await Future.delayed(const Duration(seconds: 2));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isSuccess = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: const Color(0xFF52B2AD),
        ),
        onPressed: (_isLoading || _isSuccess) ? null : _handlePressed,
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : _isSuccess
                ? const Icon(Icons.check, color: Colors.white)
                : Text(
                    widget.text,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
      ),
    );
  }
}
