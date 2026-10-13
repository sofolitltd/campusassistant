# Campus Assistant — Design System v1

> **Status:** Proposal — review and approve before coding.
> **Audience:** Designers, Flutter devs, code reviewers.
> **Scope:** Colors, Typography, Spacing, Border Radius, Elevation, Motion, Components, Dark/Light mode.
> **Goal:** A single source of truth. Every pixel comes from a token. Every screen feels like the same product.

---

## Table of Contents

1. [Core Principles](#1-core-principles)
2. [Color Palette](#2-color-palette)
3. [Typography](#3-typography)
4. [Spacing Scale](#4-spacing-scale)
5. [Border Radius Scale](#5-border-radius-scale)
6. [Elevation Scale](#6-elevation-scale)
7. [Motion & Animation](#7-motion--animation)
8. [Icon Sizes](#8-icon-sizes)
9. [Component Specs](#9-component-specs)
   - 9.1 [Buttons](#91-buttons)
   - 9.2 [Text Inputs & Search Bars](#92-text-inputs--search-bars)
   - 9.3 [Cards & Containers](#93-cards--containers)
   - 9.4 [Dialogs & Bottom Sheets](#94-dialogs--bottom-sheets)
   - 9.5 [Popups & Context Menus](#95-popups--context-menus)
   - 9.6 [Navigation (AppBar / NavBar / Rail / Drawer)](#96-navigation)
   - 9.7 [Tabs](#97-tabs)
   - 9.8 [Dividers](#98-dividers)
   - 9.9 [Progress Indicators](#99-progress-indicators)
   - 9.10 [SnackBars & Toasts](#910-snackbars--toasts)
10. [Token Files — Structure & Conventions](#10-token-files--structure--conventions)
11. [Shared Widgets to Build](#11-shared-widgets-to-build)
12. [Missing Theme Properties](#12-missing-theme-properties)
13. [Issues Inventory](#13-issues-inventory)
14. [Migration Strategy](#14-migration-strategy)
15. [Design Token Cheatsheet](#15-design-token-cheatsheet)

---

## 1. Core Principles

1. **One source of truth.** Every color, size, and shape lives in `lib/core/theme/`. Feature code imports tokens; it never defines its own.
2. **Material 3 with brand personality.** We use M3 components but override with our own semantic color tokens — not random `Colors.teal` or `Colors.grey`.
3. **Light & dark are first-class.** Every token has both values; no feature creates dark-mode workarounds.
4. **No magic numbers.** Every `SizedBox(12)`, every `BorderRadius.circular(8)` comes from a named token.
5. **Code follows the spec; spec follows Dart conventions.** The token API in code uses `camelCase` (Dart style). The spec uses `/` groupings for readability but maps clearly to code.

---

## 2. Color Palette

### 2.1 Naming Convention

Design spec uses `group/token` (e.g. `brand/primary`).  
In Flutter code, these map to:
- **`colorScheme.*`** for built-in M3 slots (primary, surface, etc.)
- **`AppColors.*`** (ThemeExtension) for custom app-specific slots
- **Top-level constants** for notification-type colors (not per-theme)

### 2.2 Brand Colors

| Token | Light | Dark | Code access |
|-------|-------|------|-------------|
| `brand/primary` | `#6C7BFF` | `#7B8AFF` | `colorScheme.primary` |
| `brand/primaryContainer` | `#E8EAFF` | `#2D3154` | `colorScheme.primaryContainer` |
| `brand/onPrimary` | `#FFFFFF` | `#FFFFFF` | `colorScheme.onPrimary` |
| `brand/onPrimaryContainer` | `#1A1A2E` | `#D0D4FF` | `colorScheme.onPrimaryContainer` |
| `brand/secondary` | `#8B9AFF` | `#8B9AFF` | `colorScheme.secondary` |
| `brand/tertiary` | `#6366F1` | `#818CF8` | `colorScheme.tertiary` |

**Decision: Use `ColorScheme.fromSeed(brand/primary)` for both light and dark.**  
No manual `ColorScheme.dark()` with unrelated values. The seed ensures all M3 tones are generated consistently. Only override specific surface/surfaceVariant/outline values that need to match our app's exact neutral palette (see §2.3).

### 2.3 Neutral Surface Palette

| Token | Light | Dark | Code |
|-------|-------|------|------|
| `neutral/surface` | `#FFFFFF` | `#2C2F3A` | `colorScheme.surface` |
| `neutral/background` | `#FAFAFA` | `#252831` | `colorScheme.surfaceContainerLowest` or custom |
| `neutral/surfaceVariant` | `#F5F5F5` | `#363944` | `colorScheme.surfaceContainerHighest` |
| `neutral/onSurface` | `#1A1A1A` | `#E8E9ED` | `colorScheme.onSurface` |
| `neutral/onSurfaceVariant` | `#6B7280` | `#BEC0C8` | `colorScheme.onSurfaceVariant` |
| `neutral/outline` | `#D1D5DB` | `#424550` | `colorScheme.outline` |
| `neutral/outlineVariant` | `#E5E7EB` | `#3A3D48` | `colorScheme.outlineVariant` |

### 2.4 Semantic Colors

| Token | Light | Dark | Code |
|-------|-------|------|------|
| `semantic/success` | `#22C55E` | `#4ADE80` | `colorScheme.tertiary` (if not used) or custom |
| `semantic/warning` | `#F59E0B` | `#FBBF24` | custom |
| `semantic/error` | `#EF4444` | `#FF6B6B` | `colorScheme.error` |
| `semantic/info` | `#3B82F6` | `#60A5FA` | custom |

**Where to put these:** Add `successColor`, `warningColor`, `infoColor` to the `AppColors` ThemeExtension.

### 2.5 Notification Category Colors

One static map, not per-theme (colors are same in light & dark):

```dart
// lib/core/theme/notification_colors.dart
enum NotificationCategory { calendar, book, message, reply, premium, alert, medical, graduation, announcement, trophy, users }

const Map<NotificationCategory, Color> kNotificationColors = {
  NotificationCategory.calendar:    Color(0xFF6C7BFF),
  NotificationCategory.book:        Color(0xFF22C55E),
  NotificationCategory.message:     Color(0xFF3B82F6),
  NotificationCategory.reply:       Color(0xFF8B5CF6),
  NotificationCategory.premium:     Color(0xFFF59E0B),
  NotificationCategory.alert:       Color(0xFFEF4444),
  NotificationCategory.medical:     Color(0xFFE11D48),
  NotificationCategory.graduation:  Color(0xFF14B8A6),
  NotificationCategory.announcement: Color(0xFFF97316),
  NotificationCategory.trophy:      Color(0xFFFACC15),
  NotificationCategory.users:       Color(0xFFEC4899),
};
```

**Why not ThemeExtension:** These don't change with theme. A single map avoids duplication and is simpler.

### 2.6 Category Card Colors

| Token | Value | Code |
|-------|-------|------|
| `category/card1` | `#95E1D3` | Top-level constant (unchanged from legacy) |
| `category/card2` | `#EAFFD0` | Top-level constant |
| `category/card3` | `#FCE38A` | Top-level constant |
| `category/card4` | `#FFCCCC` | Top-level constant |

These are design-system aware decoratives (not interactive), so top-level constants are appropriate.

### 2.7 Legacy Colors to Delete

| Constant | Reason | Replace with |
|----------|--------|--------------|
| `kPrimaryColor = Color(0xFFFFFFFF)` | Misnamed — it's white | `colorScheme.surface` |
| `kSecondaryColor = Color(0xFF000000)` | Misnamed — it's black | `colorScheme.onSurface` |
| `kContentLightColor = Color(0xFFE88F8F)` | Unused / inconsistently used | `semantic/error` |
| `kContentDarkColor = Color(0xFF1587EE)` | Unused / inconsistently used | `semantic/info` |
| `kCardColor1-4` | Keep but → rename → `kCategoryCard1` etc. |

---

## 3. Typography

### 3.1 Font Stacks

| Role | Family | Notes |
|------|--------|-------|
| Primary (UI) | `Outfit` | Google Font — use `GoogleFonts.outfit()` in theme only |
| Secondary (Bangla) | `Hind Siliguri` / `Tiro Bangla` | Feature-level, only for user-generated Bengali text |

**Performance rule:** `GoogleFonts.outfit()` is called **once** at theme construction and cached. No inline `GoogleFonts.outfit()` calls in widget build methods.

### 3.2 Type Scale

Matches Material 3 naming for `textTheme` access. `label/badge` and `overline` are extensions.

| Code name | Size | Weight | Height | Usage |
|-----------|------|--------|--------|-------|
| `displayLarge` | 32 | Bold 700 | 40 | Hero titles |
| `displayMedium` | 28 | Bold 700 | 36 | Page titles |
| `headlineLarge` | 24 | Bold 700 | 32 | Screen titles |
| `headlineMedium` | 20 | Bold 700 | 28 | Section headers |
| `headlineSmall` | 18 | Bold 700 | 24 | Card titles, AppBar title |
| `titleLarge` | 16 | SemiBold 600 | 24 | List item titles |
| `titleMedium` | 14 | SemiBold 600 | 20 | Subheadings, field labels |
| `titleSmall` | 13 | SemiBold 600 | 18 | Drawer items, small headings |
| `bodyLarge` | 16 | Regular 400 | 24 | Long-form content |
| `bodyMedium` | 14 | Regular 400 | 20 | Primary body text |
| `bodySmall` | 13 | Regular 400 | 18 | Descriptions, metadata |
| `labelLarge` | 14 | Medium 500 | 20 | Button text |
| `labelMedium` | 12 | Medium 500 | 16 | Chips, tabs |
| `labelSmall` | 11 | Medium 500 | 16 | Badges, timestamps, captions |
| — | 9 | Bold 700 | 12 | Badge numbers on cards (weight override only, no separate token) |

**No separate `badge` or `overline` tokens.** Badge numbers use `labelSmall` with `fontWeight: FontWeight.bold`. For sizes below `labelSmall`, use `.copyWith(fontSize: 9)`. This avoids type-scale bloat for edge cases.

### 3.3 Usage Rules

| ✅ Do | ❌ Don't |
|-------|----------|
| `Theme.of(context).textTheme.titleMedium?.copyWith(...)` | `TextStyle(fontSize: 14, fontWeight: FontWeight.bold)` |
| `theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)` for secondary text | `TextStyle(color: Colors.grey)` |
| Named extensions for repeated patterns (e.g. `static TextStyle get sectionTitle => ...`) | Inline `fontSize: 8`, `fontSize: 13`, etc. |

---

## 4. Spacing Scale

### 4.1 Token Definitions

```dart
// lib/core/theme/tokens/app_spacing.dart
abstract final class Spacing {
  static const double xxs  = 2;
  static const double xs   = 4;
  static const double sm   = 8;
  static const double md   = 12;
  static const double lg   = 16;
  static const double xl   = 20;
  static const double xxl  = 24;
  static const double xxxl = 32;
  static const double xxxxl = 48;
}
```

| Token | Value | Typical usage |
|-------|-------|---------------|
| `Spacing.xxs` | 2 | Icon-text gaps, tiny margins |
| `Spacing.xs` | 4 | Badge padding, small gaps |
| `Spacing.sm` | 8 | Between items, small padding |
| `Spacing.md` | 12 | Default horizontal padding |
| `Spacing.lg` | 16 | Section gaps, card margins |
| `Spacing.xl` | 20 | Large gaps |
| `Spacing.xxl` | 24 | Screen edge padding, large sections |
| `Spacing.xxxl` | 32 | Major section gaps |
| `Spacing.xxxxl` | 48 | Page top margins |

**Naming rationale:** `Sm`/`Md`/`Lg` is familiar from CSS/Material 3. `Xs`/`Xxl` follow the same pattern. No Hungarian `k` prefix — `Spacing.sm` reads cleaner than `kSpacing.sm`.

**Type:** `double`, so `EdgeInsets.all(Spacing.sm)` compiles directly. No wrapping needed.

### 4.2 Current → Token Map

| Current raw | Replace with |
|-------------|--------------|
| `SizedBox(height: 2)` | `SizedBox(height: Spacing.xxs)` |
| `SizedBox(height: 4)` | `SizedBox(height: Spacing.xs)` |
| `SizedBox(height: 8)` | `SizedBox(height: Spacing.sm)` |
| `SizedBox(height: 10)` | `SizedBox(height: Spacing.sm)` (round down) or `Spacing.md` (round up) — case-by-case |
| `SizedBox(height: 12)` | `SizedBox(height: Spacing.md)` |
| `SizedBox(height: 16)` | `SizedBox(height: Spacing.lg)` |
| `SizedBox(height: 20)` | `SizedBox(height: Spacing.xl)` |
| `SizedBox(height: 24)` | `SizedBox(height: Spacing.xxl)` |
| `SizedBox(height: 38)` | **No token — use 36 or 40.** 38 is arbitrary. |
| `EdgeInsets.symmetric(h:16, v:8)` | `EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: Spacing.sm)` |

---

## 5. Border Radius Scale

### 5.1 Token Definitions

```dart
// lib/core/theme/tokens/app_radius.dart
abstract final class RadiusToken {
  static const double xs   = 4;
  static const double sm   = 6;
  static const double md   = 8;    // default for cards, buttons, dialogs
  static const double lg   = 12;   // section cards, featured containers
  static const double xl   = 16;   // hero cards, emergency contacts
  static const double xxl  = 20;   // floating search bars
  static const double full = 999;  // circular / pills

  // Convenience
  static BorderRadius circular(double r) => BorderRadius.circular(r);
}
```

| Token | Value | Usage |
|-------|-------|-------|
| `RadiusToken.xs` | 4 | Badges, tags, small decorations |
| `RadiusToken.sm` | 6 | Grid items, tab pills |
| `RadiusToken.md` | 8 | **Default** — cards, buttons, dialogs, containers |
| `RadiusToken.lg` | 12 | Section cards, profile cards |
| `RadiusToken.xl` | 16 | Featured cards, emergency contacts |
| `RadiusToken.xxl` | 20 | Floating search bars |
| `RadiusToken.full` | 999 | Avatars, pill chips |

**Why `RadiusToken` and not `Radius`:** Flutter already has a `Radius` class. `RadiusToken` avoids name collision while being self-documenting.

**Usage:** `BorderRadius.circular(RadiusToken.md)` or `RadiusToken.circular(RadiusToken.lg)`.

---

## 6. Elevation Scale

### 6.1 Token Definitions

```dart
// lib/core/theme/tokens/app_elevation.dart
abstract final class ElevationToken {
  static const double none  = 0;
  static const double xs    = 1;    // subtle dividers
  static const double sm    = 2;    // search bars, light cards
  static const double md    = 4;    // default card elevation
  static const double lg    = 8;    // dialogs, bottom sheets
  static const double xl    = 12;   // FABs, popups, dropdowns
}
```

| Token | Value | Usage |
|-------|-------|-------|
| `ElevationToken.none` | 0 | Flat surfaces |
| `ElevationToken.xs` | 1 | Subtle dividers |
| `ElevationToken.sm` | 2 | Search bars, light cards |
| `ElevationToken.md` | 4 | **Default** — standard cards |
| `ElevationToken.lg` | 8 | Dialogs, bottom sheets |
| `ElevationToken.xl` | 12 | FABs, popups, menus |

**Why `ElevationToken` and not `Elevation`:** Flutter's `Material` widget has an `elevation` property, and there's no `Elevation` class — but name collision is still possible. `ElevationToken` is unambiguous.

**Shadow BoxDecoration values** (for custom containers not using `Card`):

| Token | elevation | blur | offset | opacity (light) |
|-------|-----------|------|--------|-----------------|
| `ElevationToken.xs` | 1 | 3 | (0, 1) | 5% |
| `ElevationToken.sm` | 2 | 6 | (0, 2) | 8% |
| `ElevationToken.md` | 4 | 10 | (0, 4) | 10% |
| `ElevationToken.lg` | 8 | 16 | (0, 4) | 12% |
| `ElevationToken.xl` | 12 | 24 | (0, 8) | 15% |

---

## 7. Motion & Animation

### 7.1 Durations

| Token | Value | Usage |
|-------|-------|-------|
| `Duration.fast` | 150ms | Micro-interactions (press, hover, ripple) |
| `Duration.medium` | 300ms | Standard transitions (page transitions, dialogs) |
| `Duration.slow` | 500ms | Expressive transitions (hero, shared element) |

### 7.2 Curves

| Token | Value | Usage |
|-------|-------|-------|
| `Curves.linear` | — | Progress bars |
| `Curves.easeOutCubic` | cubic-bezier 0.33, 1, 0.68, 1 | Elements leaving screen |
| `Curves.easeInOutCubic` | cubic-bezier 0.65, 0, 0.35, 1 | Standard easing |

**Implementation:** Define as extension or top-level constants:

```dart
const pageTransitionDuration = Duration(milliseconds: 300);
const pageTransitionCurve    = Curves.easeInOutCubic;
```

---

## 8. Icon Sizes

| Token | Value | Usage |
|-------|-------|-------|
| `IconSize.sm` | 16 | Inline with small text, trailing arrows |
| `IconSize.md` | 20 | Inline with body text |
| `IconSize.lg` | 24 | Nav bar, list leading icons (default Flutter) |
| `IconSize.xl` | 32 | Section headers, feature icons |
| `IconSize.xxl` | 40 | Avatar placeholder icons |

```dart
// lib/core/theme/tokens/app_icon_sizes.dart
abstract final class IconSize {
  static const double sm  = 16;
  static const double md  = 20;
  static const double lg  = 24;
  static const double xl  = 32;
  static const double xxl = 40;
}
```

---

## 9. Component Specs

### 9.1 Buttons

All buttons use `VisualDensity.compact`, `minimumSize: Size(48, 48)` (accessibility minimum).

#### 9.1.1 ElevatedButton (Primary)

| Property | Light | Dark |
|----------|-------|------|
| Background | `colorScheme.primary` | `colorScheme.primary` |
| Text color | `colorScheme.onPrimary` | `colorScheme.onPrimary` |
| Border radius | `RadiusToken.md` (8) | `RadiusToken.md` (8) |
| Font | `textTheme.labelLarge` | `textTheme.labelLarge` |
| Elevation | `ElevationToken.sm` (2) | `ElevationToken.sm` (2) |

**⚠ Current bug:** Light theme uses `Colors.black` background. Should be `colorScheme.primary`.

#### 9.1.2 OutlinedButton (Secondary)

| Property | Light | Dark |
|----------|-------|------|
| Text color | `colorScheme.primary` | `colorScheme.primary` |
| Border | `colorScheme.outline` | `colorScheme.outline` |
| Border radius | `RadiusToken.md` (8) | `RadiusToken.md` (8) |
| Font | `textTheme.labelLarge` | `textTheme.labelLarge` |

**⚠ Current bug:** Light theme uses `Colors.black` text. Should be `colorScheme.primary`.

#### 9.1.3 TextButton (Tertiary / Ghost)

| Property | Light | Dark |
|----------|-------|------|
| Text color | `colorScheme.primary` | `colorScheme.primary` |
| Border radius | `RadiusToken.md` (8) | `RadiusToken.md` (8) |
| Font | `textTheme.labelLarge` | `textTheme.labelLarge` |

**⚠ Current bugs:** Light theme uses `Colors.black` text. Dark theme has no `shape` property — add `borderRadius: RadiusToken.md`.

#### 9.1.4 IconButton

| Property | Value |
|----------|-------|
| Visual density | `compact` |
| Min size | 40×40 (compact default) |

No theme override needed for IconButton itself. **Remove** all feature-level `IconButton.styleFrom(...)` overrides.

#### 9.1.5 Button Disabled States

| Button | Disabled bg | Disabled text |
|--------|-------------|---------------|
| Elevated | `colorScheme.onSurface.withAlpha(38)` | `colorScheme.onSurface.withAlpha(97)` |
| Outlined | transparent | `colorScheme.onSurface.withAlpha(97)` |
| Text | transparent | `colorScheme.onSurface.withAlpha(97)` |

---

### 9.2 Text Inputs & Search Bars

#### 9.2.1 Form TextField (shared `AppTextField` widget)

| Property | Light | Dark |
|----------|-------|------|
| Fill | `transparent` (unfilled) | `colorScheme.surfaceContainerHighest` (filled) |
| Border | `colorScheme.outline` 0.5px | `colorScheme.outline` 0.5px |
| Border radius | `RadiusToken.md` (8) | `RadiusToken.md` (8) |
| Content padding | `EdgeInsets.symmetric(vertical: Spacing.md, horizontal: Spacing.md)` | same |
| Label color | `colorScheme.onSurfaceVariant` | `colorScheme.onSurfaceVariant` |
| Disabled text color | `colorScheme.onSurfaceVariant` | `colorScheme.onSurfaceVariant` |
| Focused border | `colorScheme.primary` 1px | `colorScheme.primary` 1px |

**⚠ Current bug:** `common_text_field_widget.dart` uses `vertical: 14, horizontal: 8`. Theme says `vertical: 10, horizontal: 12`. **Unify to `Spacing.md` (12) × `Spacing.md` (12)**.

#### 9.2.2 Search Bars — Two Variants

The app uses two distinct search bar patterns: **Floating Search Bar** (bottom-mounted with backdrop blur) and **Inline Search Bar** (integrated into page content). Both should be single shared widgets, not 5+ copies.

---

##### 9.2.2.1 FloatingSearchBar — Bottom-Mounted Pill

Used in: Research, Library, Questions, Alumni pages.

**Layout & Positioning**

| Property | Value |
|----------|-------|
| Position | `Positioned(bottom: 24, left: 16, right: 16)` |
| Height | 52px (44px currently → 52px for better touch target) |
| Shape | Pill — `RadiusToken.xxl` (20) |
| Base layer | `BackdropFilter` with `ImageFilter.blur(sigmaX: 10, sigmaY: 10)` |

**Background (frosted glass)**

| | Light | Dark |
|---|---|---|
| Surface | `colorScheme.surface` → alpha 0.85 | `colorScheme.surfaceContainerHighest` → alpha 0.85 |
| Border | `colorScheme.outlineVariant` 0.5px | `colorScheme.outlineVariant` 0.5px |
| Shadow | `ElevationToken.md` (4) | `ElevationToken.md` (4) |

**Search Input (left side)**

| Property | Value |
|----------|-------|
| Icon | Leading: `LucideIcons.search`, `colorScheme.onSurfaceVariant`, 20px |
| Text style | `textTheme.bodyMedium` (14/400) |
| Hint text | `colorScheme.onSurfaceVariant` |
| Clear button | Trailing: `LucideIcons.x` (circle variant), shown when text is not empty |
| Debounce | 500ms |

**Filter Chip (right side — optional)**

| Property | Value |
|----------|-------|
| Separator | `VerticalDivider` — `colorScheme.outlineVariant`, 0.5px, height 28px, centered |
| Filter button | `LucideIcons.filter` + label text, `colorScheme.onSurfaceVariant` |
| Active filter | When a filter is selected, the label turns `colorScheme.primary`, and a small `circleX` clear button appears |
| Bottom sheet | Tapping filter calls a `showFilterSheet` callback (parent provides the sheet content) |

**Widget API (proposed)**

```dart
// lib/core/widgets/floating_search_bar.dart
FloatingSearchBar({
  required String hintText,
  required ValueChanged<String> onChanged,
  String? initialValue,
  Widget? filterChip,       // Optional: pass a filter widget for the right side
  
  // Styling overrides (rarely needed)
  double? bottom,
  EdgeInsets? margin,
})
```

**⚠ Current bugs:**
1. Height is 44px — **increase to 52px** (modern search bars are taller; 44px feels cramped)
2. All 4 implementations write to different Riverpod providers directly — **migrate to a generic `onChanged` callback** so the widget is provider-agnostic
3. Hardcoded `BackdropFilter` setup should come from the widget, not each page

---

##### 9.2.2.2 InlineSearchBar — In-Content Filter

Used in: Study page (semester filter).

| Property | Value |
|----------|-------|
| Position | Inline in content column (not floating) |
| Height | 40px |
| Shape | `RadiusToken.md` (8) |
| Background | `colorScheme.surface` (light) / `colorScheme.surfaceContainerHighest` (dark) |
| Border | `colorScheme.outline` 0.5px, focused → `colorScheme.primary` 1px |
| Icon | Leading: `LucideIcons.search`, 16px |
| Padding | `EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm)` |
| Debounce | 300ms (shorter than floating — inline is for quick local filtering) |

**Widget API (proposed)**

```dart
// lib/core/widgets/inline_search_bar.dart
InlineSearchBar({
  required String hintText,
  required ValueChanged<String> onChanged,
  String? initialValue,
  double? height,           // default 40
})
```

---

##### 9.2.2.3 Search Bar Placement Decision Guide

| Page / Context | Variant | Why |
|---------------|---------|-----|
| Research, Library, Questions | **FloatingSearchBar** | Content-heavy pages; search is secondary — keep it accessible but out of the way |
| Alumni | **FloatingSearchBar** (with filter) | Same as above + needs org filter |
| Inbox | **FloatingSearchBar** | Chat-centric page; bottom position is natural |
| Study (semester filter) | **InlineSearchBar** | Quick local filter under a section header; floating would be overkill |
| Any page with local list filtering | **InlineSearchBar** | Under the section title, not at page bottom |

---

### 9.3 Cards & Containers

#### 9.3.1 Default Material Card (`CardTheme`)

| Property | Light | Dark |
|----------|-------|------|
| Fill | `colorScheme.surface` | `colorScheme.surface` |
| Elevation | `ElevationToken.md` (4) | `ElevationToken.md` (4) |
| Border radius | `RadiusToken.md` (8) | `RadiusToken.md` (8) |
| Margin | `EdgeInsets.zero` | `EdgeInsets.zero` |

#### 9.3.2 Section Card (shared `SectionCard` widget)

| Property | Light | Dark |
|----------|-------|------|
| Fill | `colorScheme.surface` | `colorScheme.surface` |
| Border radius | `RadiusToken.lg` (12) | `RadiusToken.lg` (12) |
| Border | `colorScheme.outlineVariant` 0.5px | `colorScheme.outlineVariant` 0.5px |
| Shadow | `ElevationToken.sm` (2) | `ElevationToken.sm` (2) |

**The inline pattern repeated 10×:**

```dart
// BAD — 10 copy-pastes of this:
Container(
  decoration: BoxDecoration(
    color: isDark ? Theme.of(context).cardColor : Colors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: Offset(0, 4))],
  ),
)
```

Replace with:

```dart
// GOOD — one shared widget:
SectionCard(
  margin: EdgeInsets.symmetric(horizontal: Spacing.lg),
  padding: EdgeInsets.all(Spacing.lg),
  child: ...,
)
```

**API design:** `SectionCard` takes optional `margin`, `padding`, `customColor`, `onTap`. Renders as a `Material` with `type: MaterialType.card` or a decorated `Container`.

---

### 9.4 Dialogs & Bottom Sheets

#### 9.4.1 AlertDialog

| Property | Light | Dark |
|----------|-------|------|
| Background | `colorScheme.surface` | `colorScheme.surface` |
| Border radius | `RadiusToken.lg` (12) | `RadiusToken.lg` (12) |
| Elevation | `ElevationToken.lg` (8) | `ElevationToken.lg` (8) |
| Title style | `textTheme.headlineSmall` (18/Bold) | same |
| Content style | `textTheme.bodyMedium` (14/400) | same |
| Action buttons | `TextButton` (theme) | same |

**Current → proposed:** Theme sets `RadiusToken.md` (8). **Upgrade to `RadiusToken.lg` (12)** — more modern M3 feel.

#### 9.4.2 BottomSheet

| Property | Light | Dark |
|----------|-------|------|
| Background | `colorScheme.surface` | `colorScheme.surface` |
| Top border radius | `RadiusToken.lg` (12) | `RadiusToken.lg` (12) |
| Elevation | `ElevationToken.lg` (8) | `ElevationToken.lg` (8) |
| Handle | `colorScheme.outlineVariant`, 32×4 rounded pill | same |

**Current:** No `BottomSheetThemeData` at all. **Add to both themes** — then remove inline sheet styles.

---

### 9.5 Popups & Context Menus

#### 9.5.1 PopupMenuButton

| Property | Light | Dark |
|----------|-------|------|
| Shape | `RoundedRectangleBorder(RadiusToken.md)` | same |
| Elevation | `ElevationToken.lg` (8) | same |
| Item padding | `EdgeInsets.symmetric(h: Spacing.lg, v: Spacing.sm)` | same |
| Item text | `textTheme.titleMedium` (14/600) | same |

**Additional:** Add `MenuThemeData` to the theme so `PopupMenuButton` uses the shape automatically instead of requiring per-call `.shape()`.

**Duplicate popup code:** `content_card.dart` and `resource_card.dart` have nearly identical `PopupMenuButton` setups. Extract to a shared `ContextMenu` widget (or at minimum a shared list of `PopupMenuEntry`s).

---

### 9.6 Navigation

#### 9.6.1 AppBar

| Property | Light | Dark |
|----------|-------|------|
| Background | `colorScheme.surface` | `colorScheme.surfaceContainerHighest` |
| Surface tint | `colorScheme.surface` | `Colors.transparent` |
| Elevation | 0 | 0 |
| Center title | `false` (default) | `false` (default) |
| Title style | `textTheme.headlineSmall` (18/Bold) | same |
| Icon color | `colorScheme.onSurface` | `colorScheme.onSurface` |

**`centerTitle` rule:** Default = `false`. Only override to `true` for single-title screens (settings, about, etc.). Current 8+ overrides should be audited.

#### 9.6.2 NavigationBar (Bottom)

| Property | Light | Dark |
|----------|-------|------|
| Background | `colorScheme.surface` | `colorScheme.surfaceContainerHighest` |
| Indicator | `colorScheme.outlineVariant` | `colorScheme.surfaceContainerHighest` |
| Height | 64 | 64 |
| Selected icon | `colorScheme.primary` | `colorScheme.primary` |
| Unselected icon | `colorScheme.onSurfaceVariant` | `colorScheme.onSurfaceVariant` |
| Top border | `colorScheme.outlineVariant` 0.5px | `colorScheme.outlineVariant` 0.5px |

**Current:** The `NavigationBar` in `scaffold_with_navbar.dart` wraps in a `Container` with `Border(top: BorderSide(color: Colors.grey.shade200))` — move this border to `NavigationBarThemeData` instead.

#### 9.6.3 NavigationRail (Side)

| Property | Light | Dark |
|----------|-------|------|
| Background | `colorScheme.surface` | `colorScheme.surfaceContainerHighest` |
| Indicator | Same as NavBar | Same as NavBar |
| Label type | `all` | `all` |

**⚠ Current bug:** Dark theme has no `navigationRailTheme`. Add it.

#### 9.6.4 Drawer

| Property | Value |
|----------|-------|
| Shape | `RoundedRectangleBorder(RadiusToken.md)` on right edge |
| Width | 300 (large screen) |
| Background | `colorScheme.surface` |

**Drawer has ~10 hardcoded colors** (`Colors.pink.shade100`, `Colors.orange[100]`, `Colors.blue.shade100`, `Colors.green`, `Colors.red`, `Colors.blue`). Replace all with:
- Avatar background → `colorScheme.primaryContainer`
- Tag labels → `colorScheme.primaryContainer` / `colorScheme.tertiaryContainer`
- Icon buttons → `colorScheme.primary` / `colorScheme.secondary`
- Text → `colorScheme.onSurface` / `colorScheme.onSurfaceVariant`

---

### 9.7 Tabs — Two Patterns

The app uses two tab patterns: **Material TabBar** (standard scrollable tabs) and **Pill Tabs** (custom segmented-control style). Pill tabs are currently implemented as 3 near-identical widgets — consolidate to one.

---

#### 9.7.1 Material TabBar (Standard)

For screens using Flutter's built-in `TabBar` with `TabBarView`.

| Property | Light / Dark |
|----------|--------------|
| Indicator color | `colorScheme.primary` |
| Indicator thickness | 3px |
| Unselected label | `colorScheme.onSurfaceVariant` |
| Selected label | `colorScheme.primary` |
| Label style | `textTheme.labelMedium` (12/500) |
| Indicator animation | `TabIndicatorAnimation.linear` |

---

#### 9.7.2 Pill Tabs (Segmented Control Style)

Currently 3 duplicated widgets: `SmoothTabControl` (core), `AlumniTabControl` (alumni), `CommunityTabs` (community). All three are structurally identical. Consolidate into one shared `PillTabBar` widget.

**Design Rationale:** Pill tabs work well for 3–5 short labels where you want a visual "toggle" feel. They're more prominent than Material tabs — good for content switching in profile sections and filtered lists.

**Visual Spec**

| Property | Value |
|----------|-------|
| Outer container radius | `RadiusToken.sm` (6) |
| Outer container fill | Light: `neutral/outlineVariant` (20% alpha) / Dark: `colorScheme.surfaceContainerHighest` |
| Outer container padding | `EdgeInsets.all(Spacing.xs)` (4) |
| Pill height | 34px |
| Pill radius | `RadiusToken.sm` (6) |
| Pill padding h | `Spacing.lg` (16) |
| Pill animation | Opacity + color lerp, 200ms |
| Spacing between pills | `Spacing.sm` (8) |
| Margin | `EdgeInsets.fromLTRB(Spacing.lg, Spacing.md, Spacing.lg, Spacing.sm)` |

**Color States**

| State | Pill background | Pill text |
|-------|----------------|-----------|
| ✅ Selected (light) | `colorScheme.primary` | `colorScheme.onPrimary` |
| ✅ Selected (dark) | `colorScheme.primary` | `colorScheme.onPrimary` |
| ❌ Unselected (light) | `Colors.transparent` | `colorScheme.onSurfaceVariant` |
| ❌ Unselected (dark) | `Colors.transparent` | `colorScheme.onSurfaceVariant` |

**Font**

| State | Weight | Size |
|-------|--------|------|
| Selected | `FontWeight.w600` (SemiBold) | `labelMedium` (12px) |
| Unselected | `FontWeight.w500` (Medium) | `labelMedium` (12px) |

**Animation** — interpolate between unselected/selected on tab switch (same lerp approach as current, but with brand colors instead of black/white):

```dart
final Color pillColor = Color.lerp(Colors.transparent, colorScheme.primary, progress)!;
final Color textColor = Color.lerp(colorScheme.onSurfaceVariant, colorScheme.onPrimary, progress)!;
```

**⚠ Current bugs in all 3 implementations:**
1. Active color = `Colors.black` (light) / `Colors.white` (dark) → should be `colorScheme.primary`
2. Active text color = `Colors.white` (light) / `Colors.black` (dark) → should be `colorScheme.onPrimary`
3. Inactive text = `Colors.grey.shade600` → should be `colorScheme.onSurfaceVariant`
4. Container bg = `Colors.grey.shade100` / `Colors.white(0.05)` → should use tokens
5. `GoogleFonts.outfit()` called inline in `CommunityTabs` → should use theme font
6. `AlumniTabControl` and `CommunityTabs` have hardcoded labels — should accept dynamic `List<String>`

**Widget API (proposed)**

```dart
// lib/core/widgets/pill_tab_bar.dart
PillTabBar({
  required TabController controller,
  required List<String> labels,
  ValueChanged<int>? onTap,
  bool scrollable = false,    // For many tabs that overflow
})
```

This single widget replaces `SmoothTabControl` (already close), `AlumniTabControl`, and `CommunityTabs`.

**Comparison — When to use which:**

| Context | Pattern | Why |
|---------|---------|-----|
| Profile tabs, Club tabs, Screen-level switching | **PillTabBar** | More prominent, better for 3–5 items, works with scroll |
| Inline content tabs (e.g. community sub-filter) | **PillTabBar** | Same reason |
| Standard `TabBarView` with many tabs | **Material TabBar** | Flutter's built-in infinite scroll, full-width labels |
| `TabBar` inside AppBar | **Material TabBar** | Standard integration — can't use custom there |

---

### 9.8 Dividers

| Property | Light | Dark |
|----------|-------|------|
| Color | `colorScheme.outlineVariant` | `colorScheme.outlineVariant` |
| Thickness | 0.5 | 0.5 |
| Start indent | `Spacing.lg` (16) | `Spacing.lg` |

**Add `DividerThemeData` to both themes** (currently only `dividerColor` is set in dark theme — inconsistently).

---

### 9.9 Progress Indicators

| Property | Light | Dark |
|----------|-------|------|
| Linear color | `colorScheme.primary` | `colorScheme.primary` |
| Circular color | `colorScheme.primary` | `colorScheme.primary` |

**Add `ProgressIndicatorThemeData` to both themes.** Currently loading spinners use raw `Theme.of(context).colorScheme.primary` in many files — should be handled by theme.

---

### 9.10 SnackBars & Toasts

| Property | Light | Dark |
|----------|-------|------|
| Background | `colorScheme.onSurface` | `colorScheme.onSurface` |
| Text color | `colorScheme.surface` | `colorScheme.surface` |
| Behavior | `SnackBarBehavior.floating` | same |
| Border radius | `RadiusToken.md` (8) | `RadiusToken.md` (8) |

**Add `SnackBarThemeData` to both themes.**

---

## 10. Token Files — Structure & Conventions

### 10.1 File Layout

```
lib/core/theme/
├── app_colors.dart           # AppColors ThemeExtension
├── app_theme.dart            # buildLightTheme() + buildDarkTheme()
├── notification_colors.dart  # Static notification category color map
└── tokens/                   # Design tokens as Dart constants
    ├── app_spacing.dart      # Spacing (abstract final class)
    ├── app_radius.dart       # RadiusToken (abstract final class)
    ├── app_elevation.dart    # ElevationToken (abstract final class)
    └── app_icons.dart        # IconSize (abstract final class)
```

### 10.2 Naming Conventions

| Context | Convention | Example |
|---------|------------|---------|
| Token classes | `PascalCase` | `Spacing`, `RadiusToken`, `ElevationToken` |
| Token members | `camelCase` | `Spacing.md`, `RadiusToken.lg` |
| Custom ThemeExtension | `AppColors` | `AppColors` (existing, keep) |
| Theme function | `buildLightTheme` | (existing, keep) |
| Shared widgets | `PascalCase` | `SectionCard`, `PillTabBar`, `FloatingSearchBar` |
| Color hex in spec | Lowercase for readability | `#6c7bff` |

### 10.3 Why `abstract final class`?

```dart
abstract final class Spacing {
  static const double sm = 8;
  static const double md = 12;
}
```

- `abstract` — prevent instantiation (it's a namespace, not a value)
- `final` — prevent subclassing (Dart 3+)
- `static const` — compile-time constants, zero runtime cost
- `double` — works directly with Flutter APIs (`EdgeInsets.all(Spacing.sm)`)

### 10.4 Why NOT `k` Prefix?

| Reason | Detail |
|--------|--------|
| Outdated convention | `k` prefix was a workaround before Dart had `const` + top-level constants. Dart 3 doesn't need it. |
| Visual noise | `Spacing.md` reads more naturally than `kSpacing.md` |
| Flutter ecosystem | Material 3 examples, Flutter team code, and popular packages (flutter_lints) don't use `k` |
| Semantic clarity | The class name already tells you what it is: `Spacing`, `RadiusToken`, `ElevationToken` |

**Exception:** `kNotificationColors` — top-level map (not a class), so `k` disambiguates it as a constant.

### 10.5 Widget Naming Decisions

| Proposed name | Rationale |
|--------------|-----------|
| `SectionCard` | Short, clear. No `Campus` prefix needed — everything is in this package. |
| `PillTabBar` | Describes what it is: pill-shaped tabs. `TabBar` suffix indicates it wraps a `TabController`. |
| `FloatingSearchBar` | Self-documenting — floats at bottom with backdrop blur. |
| `InlineSearchBar` | Self-documenting — sits inside content, not floating. |
| `ContextMenu` | More semantic than `CampusPopupMenu`. Describes what it is, not where it lives. |
| (no sheet widget) | Theme data + `showModalBottomSheet` is sufficient. |

---

## 11. Shared Widgets to Build

| Widget | Path | Replaces |
|--------|------|----------|
| `SectionCard` | `lib/core/widgets/section_card.dart` | 10× repeated section card pattern (profile, home, club, etc.) |
| `PillTabBar` | `lib/core/widgets/pill_tab_bar.dart` | 3× duplicated pill tab widgets: `SmoothTabControl`, `AlumniTabControl`, `CommunityTabs` |
| `FloatingSearchBar` | `lib/core/widgets/floating_search_bar.dart` | 4× floating search bars (research, library, questions, alumni) |
| `InlineSearchBar` | `lib/core/widgets/inline_search_bar.dart` | 1× inline search bar (study page) + future inline search uses |
| `ContextMenu` | `lib/core/widgets/context_menu.dart` | Duplicate PopupMenuButton code in content_card + resource_card |

**Note:** No bottom sheet widget needed. Fix via `BottomSheetThemeData` only.

---

## 12. Missing Theme Properties

These all need adding to both `buildLightTheme()` and `buildDarkTheme()`:

| Property | Why |
|----------|-----|
| `DividerThemeData` | Color, thickness, indent — currently only has `dividerColor` in dark |
| `BottomSheetThemeData` | Background, shape, elevation — currently all inline |
| `NavigationRailThemeData` (dark) | Missing entirely in dark mode |
| `MenuThemeData` | Shape for popup menus |
| `ListTileThemeData` | Icon color, title style |
| `ChipThemeData` | Shape, color for filter chips |
| `ProgressIndicatorThemeData` | Color for loading spinners |
| `SnackBarThemeData` | Background, behavior, shape |
| `TooltipThemeData` | Text style, decoration |
| `TextButtonThemeData` (dark `shape`) | Currently missing `shape` property |

---

## 13. Issues Inventory

### 🔴 Critical — visible design inconsistency

| # | Issue | File | Fix |
|---|-------|------|-----|
| 1 | Light theme buttons use `Colors.black` instead of brand primary | `app_theme.dart:34,50,64` | Use `colorScheme.primary` |
| 2 | `ColorScheme.fromSeed(seedColor: Colors.white)` produces unusable scheme | `app_theme.dart:7-9` | Seed with `Color(0xFF6C7BFF)` |
| 3 | FAB uses `Colors.teal` — unrelated to brand | `app_theme.dart:107` | Use `colorScheme.primary` |
| 4 | Dark `NavigationRailTheme` missing | `app_theme.dart` (dark) | Add `navigationRailTheme` |
| 5 | Dark `TextButtonTheme` missing `shape` | `app_theme.dart:181-190` | Add `shape` with `RadiusToken.md` |

### 🟡 High — duplicated code, hardcoded colors

| # | Issue | Files | Fix |
|---|-------|-------|-----|
| 6 | Notification icon colors duplicated in 2 files | `notification_detail_screen.dart`, `notification_tile.dart` | Extract to `kNotificationColors` |
| 7 | Section card BoxDecoration repeated ~10× | Profile, home, club, etc. | Create `SectionCard` widget |
| 8 | Pill tab implementations duplicated 3× with hardcoded colors | `SmoothTabControl`, `AlumniTabControl`, `CommunityTabs` | Create single `PillTabBar` with brand color tokens |
| 9 | Floating search bars duplicated 4× with hardcoded providers | `research_page.dart`, `questions_page.dart`, `library_page.dart`, `alumni` > `floating_search_bar.dart` | Create `FloatingSearchBar` with generic `onChanged` callback |
| 10 | Inline search bar has raw styling in study page | `study_page.dart:322-352` | Create `InlineSearchBar` |
| 11 | `content_card.dart` + `resource_card.dart` near-duplicates | study + resource | Extract shared popup code to `ContextMenu` |
| 12 | Inbox uses own dark colors `#1F2C33`, `#111B21` | `chat_page.dart`, `message_bubble.dart` | Use theme `colorScheme.surface` |
| 13 | Drawer has 10+ hardcoded Material colors | `custom_drawer.dart` | Replace with semantic tokens |

### 🟢 Medium — minor / cleanup

| # | Issue | Files | Fix |
|---|-------|-------|-----|
| 14 | `common_text_field_widget.dart` padding differs from theme (14,8 vs 10,12) | `common_text_field_widget.dart:74-77` | Unify to `Spacing.md` |
| 15 | Legacy `kPrimaryColor = White`, `kSecondaryColor = Black` | `constants.dart:6-7` | Remove after migration |
| 16 | 8+ screens override `centerTitle: true` | Various | Audit, standardize |
| 17 | Raw spacing numbers everywhere | Entire project | Migrate to `Spacing.*` |
| 18 | Raw radius numbers everywhere | Entire project | Migrate to `RadiusToken.*` |
| 19 | `GoogleFonts.outfit()` called repeatedly in theme | `app_theme.dart` | Cache to one variable |
| 20 | NavBar top border in container, not theme | `scaffold_with_navbar.dart:123-128` | Move to `NavigationBarTheme` |
| 21 | No `SnackBarThemeData` | — | Add |
| 22 | No `ProgressIndicatorThemeData` | — | Add |

---

## 14. Migration Strategy

### Phase 1: Theme Foundation  *(no visible change to users)*

1. Create token files: `tokens/app_spacing.dart`, `tokens/app_radius.dart`, `tokens/app_elevation.dart`, `tokens/app_icons.dart`
2. Fix `ColorScheme.fromSeed` seed → `Color(0xFF6C7BFF)`
3. Fix all button foreground colors → `colorScheme.primary`
4. Add missing theme properties (Divider, BottomSheet, NavRail dark, Menu, ListTile, Chip, ProgressIndicator, SnackBar, Tooltip, TextButton shape)
5. Cache `GoogleFonts.outfit()` to a local variable
6. Fix FAB color

### Phase 2: Shared Widgets

1. Create `PillTabBar` — replaces 3× duplicated pill tab widgets
2. Create `FloatingSearchBar` + `InlineSearchBar` — replaces 5× search implementations
3. Create `SectionCard` — replaces 10× inline section cards
4. Create `ContextMenu` — replaces duplicate popup menu code

### Phase 3: Feature Migration

1. Unify `common_text_field_widget.dart` padding with theme
2. Replace drawer hardcoded colors with semantic tokens
3. Extract notification color map → `kNotificationColors`
4. Update inbox feature to use theme colors (remove `#1F2C33`/`#111B21`)
5. Remove legacy color constants from `constants.dart` + rename `kCardColor1-4`
6. Remove `boxStyle` from `constants.dart` (use `SectionCard`)
7. Move NavBar border from `Container` to `NavigationBarThemeData`
8. Audit and standardize `centerTitle` across all AppBars

### Phase 4: Token Sweep

1. Replace raw spacing numbers with `Spacing.*` across all 50+ files
2. Replace raw radius numbers with `RadiusToken.*` across all 50+ files
3. Remove all inline `styleFrom(...)` button overrides in feature files
4. Remove all inline `Colors.grey`/`Colors.black` text color references
5. Final audit — no hardcoded design values remain in `lib//features//`

---

## 15. Design Token Cheatsheet

### Colors (via `colorScheme` and `AppColors`)

```dart
// Built-in M3 slots (auto-generated from seed):
Theme.of(context).colorScheme.primary          // brand primary (#6C7BFF)
Theme.of(context).colorScheme.surface           // card bg (#FFFFFF / #2C2F3A)
Theme.of(context).colorScheme.onSurface        // primary text (#1A1A1A / #E8E9ED)
Theme.of(context).colorScheme.onSurfaceVariant // secondary text (#6B7280 / #BEC0C8)
Theme.of(context).colorScheme.outline           // borders (#D1D5DB / #424550)
Theme.of(context).colorScheme.outlineVariant    // subtle borders (#E5E7EB / #3A3D48)
Theme.of(context).colorScheme.error             // errors (#EF4444 / #FF6B6B)

// Custom slots (ThemeExtension):
Theme.of(context).appColors.successColor        // #22C55E / #4ADE80
Theme.of(context).appColors.warningColor        // #F59E0B / #FBBF24
Theme.of(context).appColors.infoColor           // #3B82F6 / #60A5FA

// Static (unchanged by theme):
kNotificationColors[NotificationCategory.calendar] // #6C7BFF
kCategoryCard1                                   // #95E1D3
```

### Spacing

```dart
Spacing.xxs  // 2   Size / EdgeInsets / SizedBox
Spacing.xs   // 4
Spacing.sm   // 8
Spacing.md   // 12
Spacing.lg   // 16
Spacing.xl   // 20
Spacing.xxl  // 24
Spacing.xxxl // 32
Spacing.xxxxl // 48
```

### Border Radius

```dart
RadiusToken.xs   // 4   BorderRadius.circular(...)
RadiusToken.sm   // 6
RadiusToken.md   // 8  (default)
RadiusToken.lg   // 12
RadiusToken.xl   // 16
RadiusToken.xxl  // 20
RadiusToken.full // 999
```

### Elevation

```dart
ElevationToken.none // 0   Card / ElevatedButton / custom shadows
ElevationToken.xs   // 1
ElevationToken.sm   // 2
ElevationToken.md   // 4  (default)
ElevationToken.lg   // 8
ElevationToken.xl   // 12
```

### Icon Sizes

```dart
IconSize.sm  // 16
IconSize.md  // 20
IconSize.lg  // 24  (default Flutter icon size)
IconSize.xl  // 32
IconSize.xxl // 40
```

---

> **Next step:** Review and approve Design System v1. Once approved, I'll code Phase 1 — token files + theme foundation.
