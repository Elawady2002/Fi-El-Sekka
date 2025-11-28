import 'package:flutter/material.dart';

enum TicketPart { full, top, bottom }

class TicketCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final double cornerRadius;
  final double punchRadius;
  final double punchY; // Position of the punch from the top (only for full)
  final TicketPart part;

  const TicketCard({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.cornerRadius = 24.0,
    this.punchRadius = 12.0,
    this.punchY = 0.65,
    this.part = TicketPart.full,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TicketPainter(
        color: color,
        cornerRadius: cornerRadius,
        punchRadius: punchRadius,
        punchY: punchY,
        part: part,
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
  final TicketPart part;

  TicketPainter({
    required this.color,
    required this.cornerRadius,
    required this.punchRadius,
    required this.punchY,
    required this.part,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    if (part == TicketPart.full) {
      _drawFullTicket(path, size);
    } else if (part == TicketPart.top) {
      _drawTopTicket(path, size);
    } else {
      _drawBottomTicket(path, size);
    }

    path.close();

    // Draw Shadow
    canvas.drawShadow(path, Colors.black.withValues(alpha: 0.1), 10, true);

    canvas.drawPath(path, paint);

    // Draw Dashed Line
    if (part == TicketPart.full) {
      _drawDashedLine(canvas, size, size.height * punchY);
    } else if (part == TicketPart.top) {
      _drawDashedLine(canvas, size, size.height);
    } else {
      _drawDashedLine(canvas, size, 0);
    }
  }

  void _drawFullTicket(Path path, Size size) {
    final punchYPos = size.height * punchY;

    path.moveTo(0, cornerRadius);
    path.quadraticBezierTo(0, 0, cornerRadius, 0);
    path.lineTo(size.width - cornerRadius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);
    path.lineTo(size.width, punchYPos - punchRadius);
    path.arcToPoint(
      Offset(size.width, punchYPos + punchRadius),
      radius: Radius.circular(punchRadius),
      clockwise: false,
    );
    path.lineTo(size.width, size.height - cornerRadius);
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - cornerRadius,
      size.height,
    );
    path.lineTo(cornerRadius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - cornerRadius);
    path.lineTo(0, punchYPos + punchRadius);
    path.arcToPoint(
      Offset(0, punchYPos - punchRadius),
      radius: Radius.circular(punchRadius),
      clockwise: false,
    );
  }

  void _drawTopTicket(Path path, Size size) {
    path.moveTo(0, cornerRadius);
    path.quadraticBezierTo(0, 0, cornerRadius, 0);
    path.lineTo(size.width - cornerRadius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);

    // Bottom Right Punch (Half)
    path.lineTo(size.width, size.height - punchRadius);
    path.arcToPoint(
      Offset(size.width - punchRadius, size.height),
      radius: Radius.circular(punchRadius),
      clockwise: false,
    );

    // Bottom Left Punch (Half)
    path.lineTo(punchRadius, size.height);
    path.arcToPoint(
      Offset(0, size.height - punchRadius),
      radius: Radius.circular(punchRadius),
      clockwise: false,
    );
  }

  void _drawBottomTicket(Path path, Size size) {
    // Top Left Punch (Half)
    path.moveTo(0, punchRadius);
    path.arcToPoint(
      Offset(punchRadius, 0),
      radius: Radius.circular(punchRadius),
      clockwise: false,
    );

    // Top Right Punch (Half)
    path.lineTo(size.width - punchRadius, 0);
    path.arcToPoint(
      Offset(size.width, punchRadius),
      radius: Radius.circular(punchRadius),
      clockwise: false,
    );

    path.lineTo(size.width, size.height - cornerRadius);
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - cornerRadius,
      size.height,
    );
    path.lineTo(cornerRadius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - cornerRadius);
  }

  void _drawDashedLine(Canvas canvas, Size size, double yPos) {
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
        Offset(startX, yPos),
        Offset(startX + dashWidth, yPos),
        dashPaint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant TicketPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.part != part ||
      oldDelegate.punchY != punchY;
}
