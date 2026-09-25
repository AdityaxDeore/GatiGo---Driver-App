import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    this.length = 6,
    this.onChanged,
  }) : assert(controllers.length == length && focusNodes.length == length,
            'Controllers and focusNodes length must match length parameter');

  void _distributeCode(String code, BuildContext context, {int startIndex = 0}) {
    final digits = code.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return;

    final start = (digits.length >= length || startIndex >= length) ? 0 : startIndex;

    for (int i = 0; i < digits.length && (start + i) < length; i++) {
      controllers[start + i].text = digits[i];
    }

    final targetIndex = (start + digits.length < length) ? start + digits.length : length - 1;
    FocusScope.of(context).requestFocus(focusNodes[targetIndex]);

    if (start + digits.length >= length) {
      focusNodes[length - 1].unfocus();
    }

    if (onChanged != null) {
      final fullCode = controllers.map((c) => c.text).join();
      onChanged!(fullCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(length, (index) {
          final boxWidth = length > 4 ? 46.0 : 56.0;
          return SizedBox(
            width: boxWidth,
            child: Focus(
              onKeyEvent: (node, event) {
                if (event is KeyDownEvent &&
                    event.logicalKey == LogicalKeyboardKey.backspace &&
                    controllers[index].text.isEmpty &&
                    index > 0) {
                  controllers[index - 1].clear();
                  FocusScope.of(context).requestFocus(focusNodes[index - 1]);
                  if (onChanged != null) {
                    final otpCode = controllers.map((c) => c.text).join();
                    onChanged!(otpCode);
                  }
                  return KeyEventResult.handled;
                }
                return KeyEventResult.ignored;
              },
              child: TextField(
                controller: controllers[index],
                focusNode: focusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                autofillHints: const [AutofillHints.oneTimeCode],
                style: TextStyle(
                  fontSize: length > 4 ? 20 : 24,
                  fontWeight: FontWeight.bold,
                  color: PinkAppTheme.accentPurple,
                ),
                decoration: InputDecoration(
                  counterText: "",
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: PinkAppTheme.primaryPink, width: 2.0),
                  ),
                ),
                onChanged: (value) {
                  final digits = value.replaceAll(RegExp(r'\D'), '');

                  if (digits.length > 1) {
                    _distributeCode(digits, context, startIndex: index);
                    return;
                  }

                  if (digits.isNotEmpty) {
                    controllers[index].text = digits;
                    if (index < length - 1) {
                      FocusScope.of(context).requestFocus(focusNodes[index + 1]);
                    } else {
                      focusNodes[index].unfocus();
                    }
                  } else {
                    controllers[index].clear();
                    if (index > 0) {
                      FocusScope.of(context).requestFocus(focusNodes[index - 1]);
                    }
                  }

                  if (onChanged != null) {
                    final otpCode = controllers.map((c) => c.text).join();
                    onChanged!(otpCode);
                  }
                },
              ),
            ),
          );
        }),
      ),
    );
  }
}
