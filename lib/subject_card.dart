import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'responsive_layout.dart';

class SubjectCard extends StatefulWidget {
  final Map<String, dynamic> subject;
  final VoidCallback onTap;

  const SubjectCard({
    super.key,
    required this.subject,
    required this.onTap,
  });

  @override
  State<SubjectCard> createState() => _SubjectCardState();
}

class _SubjectCardState extends State<SubjectCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isHovered = false;
  bool _isTapped = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isTapped = true);
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isTapped = false);
    _animationController.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() => _isTapped = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobileLayout(context);
    final screenSize = ResponsiveLayout.getScreenSize(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Animate(
        effects: [
          ScaleEffect(
            duration: 400.ms,
            curve: Curves.easeOutBack,
            begin: const Offset(0.9, 0.9),
          ),
          FadeEffect(duration: 400.ms),
        ],
        child: GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            constraints: BoxConstraints(
              minHeight: 180,
              maxHeight: screenSize == ScreenSize.smallMobile ? 220 : 260,
            ),
            transform: Matrix4.identity()
              ..scale(_isHovered && !isMobile ? 1.03 : 1.0)
              ..translate(0.0, _isHovered && !isMobile ? -4.0 : 0.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                if (_isHovered && !isMobile)
                  BoxShadow(
                    color: (widget.subject['color'] as Color).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  )
                else
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: widget.onTap,
                child: Container(
                  padding: ResponsiveLayout.getCardPadding(context),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _isHovered && !isMobile
                          ? (widget.subject['color'] as Color).withOpacity(0.3)
                          : Colors.grey.shade100,
                      width: _isHovered && !isMobile ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Enhanced Image Container with responsive height
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        height: _getImageHeight(context),
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: (widget.subject['color'] as Color).withOpacity(0.1),
                          image: widget.subject['image'] != null
                              ? DecorationImage(
                                  image: AssetImage(widget.subject['image']),
                                  fit: BoxFit.contain,
                                  scale: _getImageScale(context),
                                )
                              : null,
                          boxShadow: [
                            if (_isHovered && !isMobile)
                              BoxShadow(
                                color: (widget.subject['color'] as Color).withOpacity(0.2),
                                blurRadius: 15,
                                offset: const Offset(0, 4),
                              )
                          ],
                        ),
                        child: widget.subject['image'] == null
                            ? Center(
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  transform: Matrix4.identity()
                                    ..scale(_isHovered && !isMobile ? 1.2 : 1.0),
                                  child: Icon(
                                    widget.subject['icon'] as IconData,
                                    color: (widget.subject['color'] as Color).withOpacity(0.6),
                                    size: _getIconSize(context),
                                  ),
                                ),
                              )
                            : AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                transform: Matrix4.identity()
                                  ..scale(_isHovered && !isMobile ? 1.1 : 1.0),
                                child: Container(),
                              ),
                      ),

                      // Subject name and icon with animation
                      Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: (widget.subject['color'] as Color)
                                  .withOpacity(_isHovered && !isMobile ? 0.2 : 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              widget.subject['icon'] as IconData,
                              color: widget.subject['color'] as Color,
                              size: ResponsiveLayout.getIconSize(context, base: 14),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 300),
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF1F2937),
                                    fontSize: ResponsiveLayout.getFontSize(context, base: 14),
                                  ) ?? const TextStyle(),
                              child: Text(
                                widget.subject['name'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      // Full name with fade animation
                      Flexible(
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: _isHovered && !isMobile ? 0.8 : 1.0,
                          child: Text(
                            widget.subject['fullName'],
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFF6B7280),
                                  fontSize: ResponsiveLayout.getFontSize(context, base: 12),
                                  height: 1.3,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Quiz details and duration with slide animation
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        transform: Matrix4.identity()
                          ..translate(_isHovered && !isMobile ? 4.0 : 0.0),
                        child: Row(
                          children: [
                            // Duration badge
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: _isHovered && !isMobile
                                    ? (widget.subject['color'] as Color).withOpacity(0.1)
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 10,
                                    color: _isHovered && !isMobile
                                        ? widget.subject['color'] as Color
                                        : Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    widget.subject['duration'],
                                    style: TextStyle(
                                      fontSize: ResponsiveLayout.getFontSize(context, base: 10),
                                      color: _isHovered && !isMobile
                                          ? widget.subject['color'] as Color
                                          : Colors.grey.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const Spacer(),
                            
                            // Questions count
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: _isHovered && !isMobile ? 0.7 : 1.0,
                              child: Text(
                                widget.subject['questions'],
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: const Color(0xFF6B7280),
                                      fontSize: ResponsiveLayout.getFontSize(context, base: 11),
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Start Quiz Button with enhanced animations
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        width: double.infinity,
                        height: ResponsiveLayout.getButtonHeight(context) * 0.7,
                        decoration: BoxDecoration(
                          color: _isHovered && !isMobile
                              ? widget.subject['color'] as Color
                              : (widget.subject['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _isHovered && !isMobile
                                ? widget.subject['color'] as Color
                                : (widget.subject['color'] as Color).withOpacity(0.3),
                            width: _isHovered && !isMobile ? 2 : 1,
                          ),
                          boxShadow: _isHovered && !isMobile
                              ? [
                                  BoxShadow(
                                    color: (widget.subject['color'] as Color).withOpacity(0.4),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  )
                                ]
                              : [],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 300),
                              style: TextStyle(
                                color: _isHovered && !isMobile ? Colors.white : widget.subject['color'] as Color,
                                fontWeight: FontWeight.w600,
                                fontSize: ResponsiveLayout.getFontSize(context, base: 11),
                              ),
                              child: const Text('Start Quiz'),
                            ),
                            const SizedBox(width: 4),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              transform: Matrix4.identity()
                                ..translate(_isHovered && !isMobile ? 4.0 : 0.0),
                              child: Icon(
                                Icons.arrow_forward,
                                size: ResponsiveLayout.getIconSize(context, base: 12),
                                color: _isHovered && !isMobile ? Colors.white : widget.subject['color'] as Color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _getImageHeight(BuildContext context) {
    final screenSize = ResponsiveLayout.getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.smallMobile:
        return 70;
      case ScreenSize.mobile:
        return 80;
      case ScreenSize.smallTablet:
        return 90;
      case ScreenSize.tablet:
        return 100;
      case ScreenSize.desktop:
        return 110;
    }
  }

  double _getImageScale(BuildContext context) {
    final screenSize = ResponsiveLayout.getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.smallMobile:
        return 1.5;
      case ScreenSize.mobile:
        return 1.4;
      case ScreenSize.smallTablet:
        return 1.3;
      case ScreenSize.tablet:
        return 1.2;
      case ScreenSize.desktop:
        return 1.1;
    }
  }

  double _getIconSize(BuildContext context) {
    final screenSize = ResponsiveLayout.getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.smallMobile:
        return 30;
      case ScreenSize.mobile:
        return 32;
      case ScreenSize.smallTablet:
        return 36;
      case ScreenSize.tablet:
        return 38;
      case ScreenSize.desktop:
        return 40;
    }
  }
}