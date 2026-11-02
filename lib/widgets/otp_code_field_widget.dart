import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_control.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';

/// Segmented code input (OTP-style boxes), one character per box.
///
/// Numeric by default. Pass [alphanumeric] for codes like `PVF7YI`: it opens
/// the text keyboard and upper-cases input (`pin_code_fields` silently strips
/// letters when [TextInputType.number] is used, so this isn't just cosmetic).
/// Cells shrink to fit narrow widths instead of overflowing.
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
    this.alphanumeric = false,
  });

  final TextEditingController controller;
  final String heading;
  final FormFieldValidator<String> validator;
  final int length;
  final bool alphanumeric;

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
        LayoutBuilder(
          builder: (context, constraints) {
            const spacing = Spacing.sm;
            final fitWidth =
                (constraints.maxWidth - spacing * (length - 1)) / length;
            final cellWidth = fitWidth < ControlToken.height
                ? fitWidth
                : ControlToken.height;
            return MaterialPinFormField(
              length: length,
              initialValue: controller.text,
              keyboardType: alphanumeric
                  ? TextInputType.visiblePassword
                  : TextInputType.number,
              textCapitalization: alphanumeric
                  ? TextCapitalization.characters
                  : TextCapitalization.none,
              inputFormatters: alphanumeric
                  ? [
                      FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),
                      const _UpperCaseFormatter(),
                    ]
                  : null,
              validator: validator,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (value) => controller.text = value,
              formErrorStyle: TextStyle(
                color: context.colors.danger,
                fontSize: 12,
              ),
              theme: MaterialPinTheme(
                shape: MaterialPinShape.outlined,
                cellSize: Size(cellWidth, ControlToken.height * 1.15),
                spacing: spacing,
                borderRadius: BorderRadius.circular(RadiusToken.lg),
                borderColor: context.colors.border,
                focusedBorderColor: context.colors.primary,
                filledBorderColor: context.colors.primary,
                fillColor: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest,
                focusedFillColor: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest,
                filledFillColor: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest,
                errorColor: context.colors.danger,
                entryAnimation: MaterialPinAnimation.scale,
                animationDuration: const Duration(milliseconds: 150),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _UpperCaseFormatter extends TextInputFormatter {
  const _UpperCaseFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) => newValue.copyWith(text: newValue.text.toUpperCase());
}
