import 'package:flutter/material.dart';

/// App border radius system with consistent values
class AppBorderRadius {
  AppBorderRadius._();

  // ============ RAW VALUES ============

  /// No radius - 0px
  static const double none = 0.0;

  /// Extra small radius - 4px
  static const double xs = 4.0;

  /// Small radius - 8px
  static const double sm = 8.0;

  /// Medium radius - 12px
  static const double md = 12.0;

  /// Large radius - 16px
  static const double lg = 16.0;

  /// Extra large radius - 24px
  static const double xl = 24.0;

  /// 2x Extra large radius - 32px
  static const double xxl = 32.0;

  /// Full/Circular radius - 9999px
  static const double full = 9999.0;

  // ============ BORDER RADIUS - ALL CORNERS ============

  /// BorderRadius with no radius
  static const BorderRadius radiusNone = BorderRadius.zero;

  /// BorderRadius with 4px on all corners
  static const BorderRadius radiusXs = BorderRadius.all(Radius.circular(xs));

  /// BorderRadius with 8px on all corners
  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(sm));

  /// BorderRadius with 12px on all corners
  static const BorderRadius radiusMd = BorderRadius.all(Radius.circular(md));

  /// BorderRadius with 16px on all corners
  static const BorderRadius radiusLg = BorderRadius.all(Radius.circular(lg));

  /// BorderRadius with 24px on all corners
  static const BorderRadius radiusXl = BorderRadius.all(Radius.circular(xl));

  /// BorderRadius with 32px on all corners
  static const BorderRadius radiusXxl = BorderRadius.all(Radius.circular(xxl));

  /// BorderRadius with circular/pill shape
  static const BorderRadius radiusFull = BorderRadius.all(Radius.circular(full));

  // ============ BORDER RADIUS - TOP ONLY ============

  /// BorderRadius with 12px on top corners only
  static const BorderRadius radiusTopMd = BorderRadius.only(
    topLeft: Radius.circular(md),
    topRight: Radius.circular(md),
  );

  /// BorderRadius with 16px on top corners only
  static const BorderRadius radiusTopLg = BorderRadius.only(
    topLeft: Radius.circular(lg),
    topRight: Radius.circular(lg),
  );

  /// BorderRadius with 24px on top corners only
  static const BorderRadius radiusTopXl = BorderRadius.only(
    topLeft: Radius.circular(xl),
    topRight: Radius.circular(xl),
  );

  // ============ BORDER RADIUS - BOTTOM ONLY ============

  /// BorderRadius with 12px on bottom corners only
  static const BorderRadius radiusBottomMd = BorderRadius.only(
    bottomLeft: Radius.circular(md),
    bottomRight: Radius.circular(md),
  );

  /// BorderRadius with 16px on bottom corners only
  static const BorderRadius radiusBottomLg = BorderRadius.only(
    bottomLeft: Radius.circular(lg),
    bottomRight: Radius.circular(lg),
  );

  /// BorderRadius with 24px on bottom corners only
  static const BorderRadius radiusBottomXl = BorderRadius.only(
    bottomLeft: Radius.circular(xl),
    bottomRight: Radius.circular(xl),
  );

  // ============ BORDER RADIUS - LEFT ONLY ============

  /// BorderRadius with 12px on left corners only
  static const BorderRadius radiusLeftMd = BorderRadius.only(
    topLeft: Radius.circular(md),
    bottomLeft: Radius.circular(md),
  );

  /// BorderRadius with 16px on left corners only
  static const BorderRadius radiusLeftLg = BorderRadius.only(
    topLeft: Radius.circular(lg),
    bottomLeft: Radius.circular(lg),
  );

  // ============ BORDER RADIUS - RIGHT ONLY ============

  /// BorderRadius with 12px on right corners only
  static const BorderRadius radiusRightMd = BorderRadius.only(
    topRight: Radius.circular(md),
    bottomRight: Radius.circular(md),
  );

  /// BorderRadius with 16px on right corners only
  static const BorderRadius radiusRightLg = BorderRadius.only(
    topRight: Radius.circular(lg),
    bottomRight: Radius.circular(lg),
  );

  // ============ ROUNDED RECTANGLE BORDERS ============

  /// RoundedRectangleBorder with 8px radius
  static const RoundedRectangleBorder shapeSm = RoundedRectangleBorder(
    borderRadius: radiusSm,
  );

  /// RoundedRectangleBorder with 12px radius
  static const RoundedRectangleBorder shapeMd = RoundedRectangleBorder(
    borderRadius: radiusMd,
  );

  /// RoundedRectangleBorder with 16px radius
  static const RoundedRectangleBorder shapeLg = RoundedRectangleBorder(
    borderRadius: radiusLg,
  );

  /// RoundedRectangleBorder with 24px radius
  static const RoundedRectangleBorder shapeXl = RoundedRectangleBorder(
    borderRadius: radiusXl,
  );

  /// StadiumBorder for pill-shaped buttons
  static const StadiumBorder shapePill = StadiumBorder();

  /// CircleBorder for circular shapes
  static const CircleBorder shapeCircle = CircleBorder();

  // ============ COMPONENT-SPECIFIC RADIUS ============

  /// Card border radius
  static const BorderRadius card = radiusMd;

  /// Button border radius
  static const BorderRadius button = radiusSm;

  /// Input field border radius
  static const BorderRadius input = radiusSm;

  /// Chip border radius
  static const BorderRadius chip = radiusFull;

  /// Bottom sheet border radius (top only)
  static const BorderRadius bottomSheet = radiusTopXl;

  /// Dialog border radius
  static const BorderRadius dialog = radiusLg;

  /// Avatar/profile image border radius (circular)
  static const BorderRadius avatar = radiusFull;

  /// Image border radius
  static const BorderRadius image = radiusMd;

  /// Tooltip border radius
  static const BorderRadius tooltip = radiusSm;
}
