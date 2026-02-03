import 'package:flutter/material.dart';

/// App spacing system with consistent padding/margin values
/// Based on 4px base unit: 4, 8, 16, 24, 32, 48, 64
class AppSpacing {
  AppSpacing._();

  // ============ RAW VALUES ============

  /// 4px - Minimal spacing
  static const double xxs = 4.0;

  /// 8px - Extra small spacing
  static const double xs = 8.0;

  /// 12px - Small spacing
  static const double sm = 12.0;

  /// 16px - Medium spacing (base)
  static const double md = 16.0;

  /// 24px - Large spacing
  static const double lg = 24.0;

  /// 32px - Extra large spacing
  static const double xl = 32.0;

  /// 48px - 2x Extra large spacing
  static const double xxl = 48.0;

  /// 64px - 3x Extra large spacing
  static const double xxxl = 64.0;

  // ============ EDGE INSETS - ALL SIDES ============

  /// EdgeInsets with 4px on all sides
  static const EdgeInsets paddingAllXxs = EdgeInsets.all(xxs);

  /// EdgeInsets with 8px on all sides
  static const EdgeInsets paddingAllXs = EdgeInsets.all(xs);

  /// EdgeInsets with 12px on all sides
  static const EdgeInsets paddingAllSm = EdgeInsets.all(sm);

  /// EdgeInsets with 16px on all sides
  static const EdgeInsets paddingAllMd = EdgeInsets.all(md);

  /// EdgeInsets with 24px on all sides
  static const EdgeInsets paddingAllLg = EdgeInsets.all(lg);

  /// EdgeInsets with 32px on all sides
  static const EdgeInsets paddingAllXl = EdgeInsets.all(xl);

  /// EdgeInsets with 48px on all sides
  static const EdgeInsets paddingAllXxl = EdgeInsets.all(xxl);

  // ============ EDGE INSETS - HORIZONTAL ============

  /// EdgeInsets with 4px horizontal padding
  static const EdgeInsets paddingHorizontalXxs = EdgeInsets.symmetric(horizontal: xxs);

  /// EdgeInsets with 8px horizontal padding
  static const EdgeInsets paddingHorizontalXs = EdgeInsets.symmetric(horizontal: xs);

  /// EdgeInsets with 12px horizontal padding
  static const EdgeInsets paddingHorizontalSm = EdgeInsets.symmetric(horizontal: sm);

  /// EdgeInsets with 16px horizontal padding
  static const EdgeInsets paddingHorizontalMd = EdgeInsets.symmetric(horizontal: md);

  /// EdgeInsets with 24px horizontal padding
  static const EdgeInsets paddingHorizontalLg = EdgeInsets.symmetric(horizontal: lg);

  /// EdgeInsets with 32px horizontal padding
  static const EdgeInsets paddingHorizontalXl = EdgeInsets.symmetric(horizontal: xl);

  // ============ EDGE INSETS - VERTICAL ============

  /// EdgeInsets with 4px vertical padding
  static const EdgeInsets paddingVerticalXxs = EdgeInsets.symmetric(vertical: xxs);

  /// EdgeInsets with 8px vertical padding
  static const EdgeInsets paddingVerticalXs = EdgeInsets.symmetric(vertical: xs);

  /// EdgeInsets with 12px vertical padding
  static const EdgeInsets paddingVerticalSm = EdgeInsets.symmetric(vertical: sm);

  /// EdgeInsets with 16px vertical padding
  static const EdgeInsets paddingVerticalMd = EdgeInsets.symmetric(vertical: md);

  /// EdgeInsets with 24px vertical padding
  static const EdgeInsets paddingVerticalLg = EdgeInsets.symmetric(vertical: lg);

  /// EdgeInsets with 32px vertical padding
  static const EdgeInsets paddingVerticalXl = EdgeInsets.symmetric(vertical: xl);

  // ============ SIZED BOXES - VERTICAL ============

  /// SizedBox with 4px height
  static const SizedBox verticalXxs = SizedBox(height: xxs);

  /// SizedBox with 8px height
  static const SizedBox verticalXs = SizedBox(height: xs);

  /// SizedBox with 12px height
  static const SizedBox verticalSm = SizedBox(height: sm);

  /// SizedBox with 16px height
  static const SizedBox verticalMd = SizedBox(height: md);

  /// SizedBox with 24px height
  static const SizedBox verticalLg = SizedBox(height: lg);

  /// SizedBox with 32px height
  static const SizedBox verticalXl = SizedBox(height: xl);

  /// SizedBox with 48px height
  static const SizedBox verticalXxl = SizedBox(height: xxl);

  /// SizedBox with 64px height
  static const SizedBox verticalXxxl = SizedBox(height: xxxl);

  // ============ SIZED BOXES - HORIZONTAL ============

  /// SizedBox with 4px width
  static const SizedBox horizontalXxs = SizedBox(width: xxs);

  /// SizedBox with 8px width
  static const SizedBox horizontalXs = SizedBox(width: xs);

  /// SizedBox with 12px width
  static const SizedBox horizontalSm = SizedBox(width: sm);

  /// SizedBox with 16px width
  static const SizedBox horizontalMd = SizedBox(width: md);

  /// SizedBox with 24px width
  static const SizedBox horizontalLg = SizedBox(width: lg);

  /// SizedBox with 32px width
  static const SizedBox horizontalXl = SizedBox(width: xl);

  /// SizedBox with 48px width
  static const SizedBox horizontalXxl = SizedBox(width: xxl);

  // ============ SCREEN PADDING ============

  /// Standard screen padding for mobile (16px horizontal, 16px vertical)
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: md,
    vertical: md,
  );

  /// Wide screen padding (24px horizontal, 16px vertical)
  static const EdgeInsets screenPaddingWide = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );

  /// Safe area padding with extra bottom padding for FAB
  static const EdgeInsets screenPaddingWithFab = EdgeInsets.only(
    left: md,
    right: md,
    top: md,
    bottom: xxl + xl, // Extra space for FAB
  );

  // ============ COMPONENT PADDING ============

  /// Card content padding
  static const EdgeInsets cardPadding = EdgeInsets.all(md);

  /// Card content padding - large
  static const EdgeInsets cardPaddingLarge = EdgeInsets.all(lg);

  /// Button padding
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: sm,
  );

  /// Input field content padding
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );

  /// List item padding
  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );

  /// Dialog content padding
  static const EdgeInsets dialogPadding = EdgeInsets.all(lg);

  /// Chip padding
  static const EdgeInsets chipPadding = EdgeInsets.symmetric(
    horizontal: sm,
    vertical: xxs,
  );
}
