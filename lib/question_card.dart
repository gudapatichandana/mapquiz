import 'package:flutter/material.dart';
import 'quiz_question.dart';
import 'responsive_layout.dart';

class QuestionCard extends StatelessWidget {
  final QuizQuestion question;
  final int selectedAnswer;
  final Function(int) onAnswerSelected;

  const QuestionCard({
    super.key,
    required this.question,
    required this.selectedAnswer,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question text
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF3B82F6).withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Text(
              question.text,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                    height: 1.4,
                    fontSize: ResponsiveLayout.getFontSize(context, base: 18),
                  ),
            ),
          ),

          SizedBox(height: ResponsiveLayout.getSpacing(context) * 2),

          // Options
          Column(
            children: question.options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              final isSelected = selectedAnswer == index;
              final optionLabel = String.fromCharCode(65 + index); // A, B, C, D

              return Container(
                margin: EdgeInsets.only(
                    bottom: ResponsiveLayout.getSpacing(context)),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onAnswerSelected(index),
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF3B82F6).withOpacity(0.1)
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF3B82F6)
                              : Colors.grey.shade200,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Option indicator
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF3B82F6)
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF3B82F6)
                                    : Colors.grey.shade400,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                optionLabel,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey.shade700,
                                  fontSize: ResponsiveLayout.getFontSize(
                                      context,
                                      base: 14),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: ResponsiveLayout.getSpacing(context)),

                          // Option text
                          Expanded(
                            child: Text(
                              option,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: isSelected
                                        ? const Color(0xFF1F2937)
                                        : const Color(0xFF374151),
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    fontSize: ResponsiveLayout.getFontSize(
                                        context,
                                        base: 16),
                                    height: 1.3,
                                  ),
                            ),
                          ),

                          // Selection indicator
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: const Color(0xFF3B82F6),
                              size: ResponsiveLayout.getIconSize(context,
                                  base: 20),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Hint text
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.amber.shade200,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: ResponsiveLayout.getIconSize(context, base: 16),
                  color: Colors.amber.shade700,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Select the best answer from the options above',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.amber.shade800,
                          fontSize:
                              ResponsiveLayout.getFontSize(context, base: 12),
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}