import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class MdsOtpInput extends StatelessWidget {
  final int length;
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final ValueChanged<String>? onChanged;

  const MdsOtpInput({
    super.key,
    required this.controllers,
    required this.focusNodes,
    this.length = 4,
    this.onChanged,
  }) : assert(controllers.length == length && focusNodes.length == length,
            'Controllers and focusNodes length must match length parameter');

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(length, (index) {
        return SizedBox(
          width: 60,
          child: TextField(
            controller: controllers[index],
            focusNode: focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: PinkAppTheme.accentPurple,
            ),
            decoration: InputDecoration(
              counterText: "",
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                if (index < length - 1) {
                  FocusScope.of(context).requestFocus(focusNodes[index + 1]);
                } else {
                  focusNodes[index].unfocus();
                }
              } else if (index > 0) {
                FocusScope.of(context).requestFocus(focusNodes[index - 1]);
              }
              if (onChanged != null) {
                final otpCode = controllers.map((c) => c.text).join();
                onChanged!(otpCode);
              }
            },
          ),
        );
      }),
    );
  }
}
