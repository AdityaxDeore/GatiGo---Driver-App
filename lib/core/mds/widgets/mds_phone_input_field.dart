import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/theme.dart';

class MdsPhoneInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final String countryCode;
  final String? errorText;
  final ValueChanged<String>? onSubmitted;

  const MdsPhoneInputField({
    super.key,
    required this.controller,
    this.hintText = "",
    this.labelText = "Mobile Number",
    this.countryCode = "+91",
    this.errorText,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        _PhoneInputFormatter(),
      ],
      onSubmitted: onSubmitted,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      ),
      decoration: InputDecoration(
        hintText: hintText.isEmpty ? null : hintText,
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        errorText: errorText,
        contentPadding: const EdgeInsets.symmetric(vertical: 18.0),
        prefixIcon: Container(
          padding: const EdgeInsets.only(left: 16.0, right: 12.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                countryCode,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: PinkAppTheme.textDark,
                ),
              ),
              const SizedBox(width: 12),
              Container(width: 1.5, height: 22, color: Colors.grey.shade300),
            ],
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      ),
    );
  }
}

class _PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(' ', '');
    if (text.length > 10) return oldValue;

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if (i == 4 && text.length > 5) {
        buffer.write(' ');
      }
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
