import 'package:flutter/material.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';

/// The resting outline for search fields: 1px [AppColors.borderStrong], the
/// same stroke as the filter button beside them. Pass as `enabledBorder`;
/// the focused border still comes from the theme.
OutlineInputBorder searchOutline(BuildContext context) => OutlineInputBorder(
  borderRadius: BorderRadius.circular(RadiusToken.lg),
  borderSide: BorderSide(color: context.colors.borderStrong, width: 1),
);
