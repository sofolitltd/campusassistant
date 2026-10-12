import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_control.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';

/// Segmented numeric code input (OTP-style boxes), one digit per box.
///
/// Built on `pin_code_fields`' [MaterialPinFormField], which extends
/// [FormField] directly — it registers with the surrounding [Form] on its
/// own, so passing [validator] here is enough for the existing
/// `_globalKey.currentState!.validate()` call elsewhere to pick it up.
/// [controller] (the plain [TextEditingController] the rest of the form
/// reads from) is kept in sync via `onChanged`.
class OtpCodeFieldWidget extends StatelessWidget {
  const OtpCodeFieldWidget({
    super.key,
    required this.controller,
    required this.heading,
    required this.validator,
    this.length = 6,
  });

  final TextEditingController controller;
  final String heading;
  final FormFieldValidator<String> validator;
  final int length;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          heading,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        MaterialPinFormField(
          length: length,
          initialValue: controller.text,
          keyboardType: TextInputType.number,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (value) => controller.text = value,
          formErrorStyle: TextStyle(color: context.colors.danger, fontSize: 12),
          theme: MaterialPinTheme(
            shape: MaterialPinShape.outlined,
            cellSize: Size(ControlToken.height, ControlToken.height * 1.15),
            spacing: Spacing.sm,
            borderRadius: BorderRadius.circular(RadiusToken.lg),
            borderColor: context.colors.border,
            focusedBorderColor: context.colors.primary,
            filledBorderColor: context.colors.primary,
            fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            focusedFillColor: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest,
            filledFillColor: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest,
            errorColor: context.colors.danger,
            entryAnimation: MaterialPinAnimation.scale,
            animationDuration: const Duration(milliseconds: 150),
          ),
        ),
      ],
    );
  }
}
