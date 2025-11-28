import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class SlideActionButton extends StatefulWidget {
  final String text;
  final VoidCallback onSlideComplete;
  final double height;
  final Color backgroundColor;
  final Color sliderColor;
  final Color textColor;
  final IconData icon;

  const SlideActionButton({
    super.key,
    required this.text,
    required this.onSlideComplete,
    this.height = 56.0,
    this.backgroundColor = const Color(0xFFF3F4F6),
    this.sliderColor = AppTheme.primaryColor,
    this.textColor = Colors.black,
    this.icon = Icons.arrow_forward_ios_rounded,
  });

  @override
  State<SlideActionButton> createState() => _SlideActionButtonState();
}

class _SlideActionButtonState extends State<SlideActionButton> {
  double _dragValue = 0.0;
  bool _isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final sliderWidth = widget.height - 8; // Padding of 4 on each side
        final maxDrag = maxWidth - sliderWidth - 8;

        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(widget.height / 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Centered Text
              Center(
                child: Opacity(
                  opacity: 1.0 - (_dragValue / maxDrag).clamp(0.0, 1.0),
                  child: Text(
                    widget.text,
                    style: AppTheme.textTheme.bodyLarge?.copyWith(
                      color: widget.textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              // Slider
              Positioned(
                left: 4 + _dragValue,
                top: 4,
                bottom: 4,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    if (_isCompleted) return;

                    setState(() {
                      _dragValue = (_dragValue + details.delta.dx).clamp(
                        0.0,
                        maxDrag,
                      );
                    });
                  },
                  onHorizontalDragEnd: (details) {
                    if (_isCompleted) return;

                    if (_dragValue > maxDrag * 0.8) {
                      // Complete
                      setState(() {
                        _dragValue = maxDrag;
                        _isCompleted = true;
                      });
                      HapticFeedback.mediumImpact();
                      widget.onSlideComplete();
                    } else {
                      // Reset
                      setState(() {
                        _dragValue = 0.0;
                      });
                    }
                  },
                  child: Container(
                    width: sliderWidth,
                    height: sliderWidth,
                    decoration: BoxDecoration(
                      color: widget.sliderColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(widget.icon, color: Colors.black, size: 20),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
