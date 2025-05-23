import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A widget that wraps the app to maintain a mobile-like experience on web platform.
/// It enforces a 9:16 aspect ratio for the app and fills the extra space with a background color.
/// It also ensures the app maintains a reasonable width in landscape mode.
class ResponsiveAppWrapper extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final double minWidth;
  final double maxWidth;
  final double idealAspectRatio;
  final double minAspectRatio;
  final double maxAspectRatio;
  final bool enableDebugOutline;

  const ResponsiveAppWrapper({
    super.key,
    required this.child,
    this.backgroundColor = const Color(
      0xFFFFFFFF,
    ), // Default to app primary color
    this.minWidth = 390.0, // Increased minimum width to prevent overflow
    this.maxWidth = 480.0, // Maximum width for landscape mode
    this.idealAspectRatio = 9 / 16, // Mobile-like aspect ratio (width/height)
    this.minAspectRatio =
    0.8, // Increased minimum aspect ratio to prevent too narrow UI
    this.maxAspectRatio = 0.85, // Maximum aspect ratio for very wide screens
    this.enableDebugOutline = false, // Set to true to see container boundaries
  });

  @override
  Widget build(BuildContext context) {
    // Only apply the wrapper for web platform
    if (!kIsWeb) {
      return child;
    }

    return ColoredBox(
      color: backgroundColor,
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // On landscape orientation (width > height)
            if (constraints.maxWidth > constraints.maxHeight) {
              // For landscape mode, prioritize a good width first
              // Start with the minimum width as a baseline
              double appliedWidth = minWidth;

              // Calculate width based on height and minimum aspect ratio to ensure UI isn't too narrow
              final minWidthFromRatio = constraints.maxHeight * minAspectRatio;

              // Use the larger of minWidth and minWidthFromRatio
              if (minWidthFromRatio > appliedWidth) {
                appliedWidth = minWidthFromRatio;
              }

              // If we have room, try to use the ideal aspect ratio
              final idealWidth = constraints.maxHeight * idealAspectRatio;
              if (idealWidth > appliedWidth && idealWidth <= maxWidth) {
                appliedWidth = idealWidth;
              }

              // For very wide screens, use maxAspectRatio to prevent UI from being too wide
              final maxWidthFromRatio = constraints.maxHeight * maxAspectRatio;
              if (constraints.maxWidth > maxWidth * 1.5 &&
                  maxWidthFromRatio > appliedWidth) {
                // Only apply if screen is significantly wider than our maxWidth
                appliedWidth = maxWidthFromRatio;
              }

              // Cap at maxWidth
              if (appliedWidth > maxWidth) {
                appliedWidth = maxWidth;
              }

              // Final check: ensure we don't exceed available width
              if (appliedWidth > constraints.maxWidth) {
                appliedWidth = constraints.maxWidth;
              }

              // Create a container with the calculated dimensions
              Widget container = SizedBox(
                height: constraints.maxHeight,
                width: appliedWidth,
                child: child,
              );

              // Add debug outline if enabled
              if (enableDebugOutline) {
                container = Container(
                  height: constraints.maxHeight,
                  width: appliedWidth,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 2.0),
                  ),
                  child: child,
                );
              }

              return container;
            }
            // On portrait orientation, enforce maximum width based on aspect ratio
            else {
              // Calculate width based on height and ideal aspect ratio
              final idealWidth = constraints.maxHeight * idealAspectRatio;

              // Start with the ideal width
              double appliedWidth = idealWidth;

              // Ensure minimum width
              if (appliedWidth < minWidth && constraints.maxWidth >= minWidth) {
                appliedWidth = minWidth;
              }

              // Ensure we don't exceed available width
              if (appliedWidth > constraints.maxWidth) {
                appliedWidth = constraints.maxWidth;
              }

              // Create a container with the calculated dimensions
              Widget container = SizedBox(width: appliedWidth, child: child);

              // Add debug outline if enabled
              if (enableDebugOutline) {
                container = Container(
                  width: appliedWidth,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 2.0),
                  ),
                  child: child,
                );
              }

              return container;
            }
          },
        ),
      ),
    );
  }
}
