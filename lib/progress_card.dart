import 'package:flutter/material.dart';
import 'responsive_layout.dart';

class ProgressCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const ProgressCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveLayout.isMobileLayout(context) ? 12 : 16),
      constraints: const BoxConstraints(
        minHeight: 100,
        maxHeight: 140,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: ResponsiveLayout.getIconSize(context, base: 20), // Reduced base size
          ),
          SizedBox(height: ResponsiveLayout.isMobileLayout(context) ? 4 : 8),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                      fontSize: ResponsiveLayout.getFontSize(context, base: 18), // Reduced base size
                    ),
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ),
          ),
          SizedBox(height: ResponsiveLayout.isMobileLayout(context) ? 2 : 4),
          Flexible(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF6B7280),
                    fontSize: ResponsiveLayout.getFontSize(context, base: 11), // Reduced base size
                  ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}