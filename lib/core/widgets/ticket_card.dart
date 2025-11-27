import 'package:flutter/material.dart';

class TicketCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final double cornerRadius;
  final double punchRadius;
  final double punchY; // Position of the punch from the top

  const TicketCard({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.cornerRadius = 24.0,
    this.punchRadius = 12.0,
    this.punchY =
        0.65, // Default punch position (percentage of height or fixed?)
    // Let's use a fixed height for the top section or pass the split position
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TicketPainter(
        color: color,
        cornerRadius: cornerRadius,
        punchRadius: punchRadius,
        punchY: punchY,
      ),
      child: child,
    );
  }
}

class TicketPainter extends CustomPainter {
  final Color color;
  final double cornerRadius;
  final double punchRadius;
  final double punchY;

  TicketPainter({
    required this.color,
    required this.cornerRadius,
    required this.punchRadius,
    required this.punchY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final punchYPos = size.height * punchY;

    // Top Left Corner
    path.moveTo(0, cornerRadius);
    path.quadraticBezierTo(0, 0, cornerRadius, 0);

    // Top Right Corner
    path.lineTo(size.width - cornerRadius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);

    // Right Side Punch
    path.lineTo(size.width, punchYPos - punchRadius);
    path.arcToPoint(
      Offset(size.width, punchYPos + punchRadius),
      radius: Radius.circular(punchRadius),
      clockwise: false,
    );

    // Bottom Right Corner
    path.lineTo(size.width, size.height - cornerRadius);
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - cornerRadius,
      size.height,
    );

    // Bottom Left Corner
    path.lineTo(cornerRadius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - cornerRadius);

    // Left Side Punch
    path.lineTo(0, punchYPos + punchRadius);
    path.arcToPoint(
      Offset(0, punchYPos - punchRadius),
      radius: Radius.circular(punchRadius),
      clockwise: false,
    );

    path.close();

    // Draw Shadow
    canvas.drawShadow(path, Colors.black.withValues(alpha: 0.1), 10, true);

    canvas.drawPath(path, paint);

    // Draw Dashed Line
    final dashPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.3)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const dashSpace = 5.0;
    double startX = punchRadius + 10;
    final endX = size.width - punchRadius - 10;

    while (startX < endX) {
      canvas.drawLine(
        Offset(startX, punchYPos),
        Offset(startX + dashWidth, punchYPos),
        dashPaint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
