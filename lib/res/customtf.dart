import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final TextEditingController? textController;
  final Color textColor;
  final Color borderColor;
  final Color inputColor;
  final IconData? icon;

  const CustomTextField({
    super.key,
    required this.hint,
    this.textController,
    required this.textColor,
    required this.borderColor,
    required this.inputColor,
    this.icon,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textController,
      cursorColor: Colors.black,
      style: TextStyle(color: widget.inputColor),
      decoration: InputDecoration(
        prefixIcon: widget.icon != null
            ? Icon(widget.icon, color: widget.textColor)
            : null, // Use Icon directly for proper alignment
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.0),
          borderSide: BorderSide(
            color: widget.borderColor,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.0),
          borderSide: BorderSide(
            color: widget.borderColor,
            width: 1.5,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.0),
          borderSide: BorderSide(
            color: widget.borderColor,
          ),
        ),
        hintText: widget.hint,
        hintStyle: TextStyle(
          color: widget.textColor,
          fontSize: 14.0,
        ),
      ),
    );
  }
}
