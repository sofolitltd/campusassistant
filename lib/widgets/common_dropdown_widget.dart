import 'package:flutter/material.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';

class CommonDropDownWidget extends StatelessWidget {
  const CommonDropDownWidget({
    super.key,
    required this.heading,
    required this.hint,
    required this.value,
    required this.itemList,
    required this.onChanged,
  });

  final String heading;
  final String hint;
  final String? value;
  final List<String> itemList;
  final Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Text(
          heading,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
            fontWeight: .w500,
            color: context.colors.textMuted,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        ButtonTheme(
          alignedDropdown: true,
          child: DropdownButtonFormField(
            isExpanded: true,
            initialValue: value,
            hint: Text(hint),
            decoration: InputDecoration(),
            onChanged: (String? value) => onChanged(value),
            validator: (value) => value == null ? "Select something" : null,
            items: itemList.map((String val) {
              return DropdownMenuItem(
                value: val,
                child: Text(val, overflow: .ellipsis),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
