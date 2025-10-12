import 'package:flutter/material.dart';
import 'responsive_layout.dart';

class AchievementBadge extends StatelessWidget {
  final Map<String, dynamic> achievement;
  final bool isUnlocked;

  const AchievementBadge({
    super.key,
    required this.achievement,
    required this.isUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showAchievementDetails(context);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUnlocked
              ? achievement['color'].withOpacity(0.1)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUnlocked
                ? achievement['color'].withOpacity(0.3)
                : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isUnlocked
                    ? achievement['color'].withOpacity(0.2)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                achievement['icon'],
                color: isUnlocked ? achievement['color'] : Colors.grey.shade500,
                size: ResponsiveLayout.getIconSize(context, base: 20),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              achievement['title'],
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isUnlocked
                        ? achievement['color']
                        : Colors.grey.shade600,
                    fontSize: ResponsiveLayout.getFontSize(context, base: 10),
                  ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (isUnlocked) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: achievement['color'],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'UNLOCKED',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showAchievementDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isUnlocked
                      ? achievement['color'].withOpacity(0.1)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  achievement['icon'],
                  color:
                      isUnlocked ? achievement['color'] : Colors.grey.shade500,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                achievement['title'],
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isUnlocked
                          ? achievement['color']
                          : Colors.grey.shade700,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                achievement['description'],
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF6B7280),
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isUnlocked
                      ? Colors.green.shade100
                      : Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  isUnlocked ? 'UNLOCKED' : 'LOCKED',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isUnlocked
                        ? Colors.green.shade700
                        : Colors.orange.shade700,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}