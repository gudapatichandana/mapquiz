import 'package:flutter/material.dart';

class ResponsiveLayout {
  // Layout detection methods
  static bool isMobileLayout(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isTabletLayout(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1200;
  }

  static bool isDesktopLayout(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }

  // Get current screen size category
  static ScreenSize getScreenSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 400) return ScreenSize.smallMobile;
    if (width < 600) return ScreenSize.mobile;
    if (width < 900) return ScreenSize.smallTablet;
    if (width < 1200) return ScreenSize.tablet;
    return ScreenSize.desktop;
  }

  // Spacing and padding methods
  static double getSpacing(BuildContext context) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.smallMobile:
        return 8.0;
      case ScreenSize.mobile:
        return 12.0;
      case ScreenSize.smallTablet:
        return 14.0;
      case ScreenSize.tablet:
        return 16.0;
      case ScreenSize.desktop:
        return 20.0;
    }
  }

  static EdgeInsets getPadding(BuildContext context) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.smallMobile:
        return const EdgeInsets.all(8.0);
      case ScreenSize.mobile:
        return const EdgeInsets.all(12.0);
      case ScreenSize.smallTablet:
        return const EdgeInsets.all(16.0);
      case ScreenSize.tablet:
        return const EdgeInsets.all(18.0);
      case ScreenSize.desktop:
        return const EdgeInsets.all(24.0);
    }
  }

  static EdgeInsets getCardPadding(BuildContext context) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.smallMobile:
        return const EdgeInsets.all(10.0);
      case ScreenSize.mobile:
        return const EdgeInsets.all(12.0);
      case ScreenSize.smallTablet:
        return const EdgeInsets.all(14.0);
      case ScreenSize.tablet:
        return const EdgeInsets.all(16.0);
      case ScreenSize.desktop:
        return const EdgeInsets.all(20.0);
    }
  }

  // Typography scaling
  static double getFontSize(BuildContext context, {required double base}) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.smallMobile:
        return base * 0.85;
      case ScreenSize.mobile:
        return base;
      case ScreenSize.smallTablet:
        return base * 1.1;
      case ScreenSize.tablet:
        return base * 1.15;
      case ScreenSize.desktop:
        return base * 1.2;
    }
  }

  // Interactive element sizing
  static double getButtonHeight(BuildContext context) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.smallMobile:
        return 40.0;
      case ScreenSize.mobile:
        return 44.0;
      case ScreenSize.smallTablet:
        return 48.0;
      case ScreenSize.tablet:
        return 52.0;
      case ScreenSize.desktop:
        return 56.0;
    }
  }

  static double getIconSize(BuildContext context, {required double base}) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.smallMobile:
        return base * 0.8;
      case ScreenSize.mobile:
        return base;
      case ScreenSize.smallTablet:
        return base * 1.1;
      case ScreenSize.tablet:
        return base * 1.2;
      case ScreenSize.desktop:
        return base * 1.3;
    }
  }

  // Grid layout calculations
  static int getCrossAxisCount(BuildContext context) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.smallMobile:
        return 1;
      case ScreenSize.mobile:
        return 1;
      case ScreenSize.smallTablet:
        return 2;
      case ScreenSize.tablet:
        return 2;
      case ScreenSize.desktop:
        return 3;
    }
  }

  // Card dimensions
  static double getCardHeight(BuildContext context) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.smallMobile:
        return 160.0;
      case ScreenSize.mobile:
        return 180.0;
      case ScreenSize.smallTablet:
        return 200.0;
      case ScreenSize.tablet:
        return 220.0;
      case ScreenSize.desktop:
        return 240.0;
    }
  }

  // Screen space allocation
  static double getHeaderHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.smallMobile:
        return screenHeight * 0.10;
      case ScreenSize.mobile:
        return screenHeight * 0.12;
      case ScreenSize.smallTablet:
        return screenHeight * 0.14;
      case ScreenSize.tablet:
        return screenHeight * 0.16;
      case ScreenSize.desktop:
        return screenHeight * 0.18;
    }
  }

  static double getContentHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final safeHeight = screenHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.smallMobile:
        return safeHeight * 0.70;
      case ScreenSize.mobile:
        return safeHeight * 0.72;
      case ScreenSize.smallTablet:
        return safeHeight * 0.74;
      case ScreenSize.tablet:
        return safeHeight * 0.76;
      case ScreenSize.desktop:
        return safeHeight * 0.78;
    }
  }
}

enum ScreenSize {
  smallMobile, // < 400
  mobile,      // 400 - 599
  smallTablet, // 600 - 899
  tablet,      // 900 - 1199
  desktop,     // >= 1200
}