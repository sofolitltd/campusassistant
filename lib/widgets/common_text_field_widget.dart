import 'package:flutter/material.dart';

import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';

class CommonTextFieldWidget extends StatefulWidget {
  const CommonTextFieldWidget({
    super.key,
    required this.controller,
    required this.heading,
    required this.hintText,
    required this.keyboardType,
    required this.validator,
    this.obscureText = false,
    this.enabled = true,
    this.textCapitalization,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final String heading;
  final String hintText;
  final TextInputType keyboardType;
  final Function(String?) validator;
  final bool? obscureText;
  final bool? enabled;
  final TextCapitalization? textCapitalization;

  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;

  @override
  State<CommonTextFieldWidget> createState() => _CommonTextFieldWidgetState();
}

class _CommonTextFieldWidgetState extends State<CommonTextFieldWidget> {
  bool? _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText!;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.heading,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
            fontWeight: FontWeight.w500,
            color: cs.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          textInputAction: widget.textInputAction ?? TextInputAction.next,
          onFieldSubmitted: widget.onFieldSubmitted,
          keyboardType: widget.keyboardType,
          textCapitalization: widget.textCapitalization == null
              ? TextCapitalization.none
              : widget.textCapitalization!,
          obscureText: _obscureText!,
          validator: (value) => widget.validator(value),
          style: TextStyle(
            color: widget.enabled! ? null : cs.onSurfaceVariant,
          ),
          decoration: InputDecoration(
            isDense: true,
            filled: widget.enabled! ? false : true,
            visualDensity: VisualDensity.compact,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: Spacing.sm,
            ),
            hintText: widget.hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(RadiusToken.sm),
              borderSide: BorderSide(color: cs.outline, width: 0.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(RadiusToken.sm),
              borderSide: BorderSide(color: cs.primary, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(RadiusToken.sm),
              borderSide: BorderSide(color: cs.outlineVariant, width: 0.5),
            ),
            suffixIcon: widget.obscureText!
                ? IconButton(
                    style: IconButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText!;
                      });
                    },
                    icon: Icon(
                      _obscureText!
                          ? Icons.visibility_off_outlined
                          : Icons.remove_red_eye_outlined,
                      color: cs.onSurfaceVariant,
                    ),
                  )
                : null,
          ),
          enabled: widget.enabled!,
        ),
      ],
    );
  }
}
