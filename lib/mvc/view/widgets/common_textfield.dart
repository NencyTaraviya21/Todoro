import 'package:todoro/import_export/todoro_import_export.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFF404040),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF999999),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: Colors.white,
            size: 20,
          ),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
      ),
    );
  }
}

class TodoChecklistPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Clipboard background
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill;
    final clipboardRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
          size.width * 0.15,
          size.height * 0.1,
          size.width * 0.7,
          size.height * 0.8
      ),
      const Radius.circular(8),
    );
    canvas.drawRRect(clipboardRect, paint);

    // Clipboard clip at top
    paint.color = const Color(0xFF666666);
    final clipRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
          size.width * 0.4,
          size.height * 0.05,
          size.width * 0.2,
          size.height * 0.1
      ),
      const Radius.circular(4),
    );
    canvas.drawRRect(clipRect, paint);

    // Todo items (checkboxes and lines)
    paint.strokeWidth = 2;

    // First todo item (completed)
    paint.color = const Color(0xFF4CAF50);
    paint.style = PaintingStyle.stroke;
    final checkbox1 = Rect.fromLTWH(
        size.width * 0.25,
        size.height * 0.25,
        size.width * 0.08,
        size.height * 0.08
    );
    canvas.drawRect(checkbox1, paint);

    // Checkmark
    paint.style = PaintingStyle.fill;
    final checkPath = Path();
    checkPath.moveTo(size.width * 0.27, size.height * 0.29);
    checkPath.lineTo(size.width * 0.29, size.height * 0.31);
    checkPath.lineTo(size.width * 0.32, size.height * 0.27);
    paint.strokeWidth = 3;
    paint.style = PaintingStyle.stroke;
    paint.strokeCap = StrokeCap.round;
    canvas.drawPath(checkPath, paint);

    // Line for completed item (struck through)
    paint.color = const Color(0xFF999999);
    paint.strokeWidth = 2;
    canvas.drawLine(
      Offset(size.width * 0.4, size.height * 0.29),
      Offset(size.width * 0.7, size.height * 0.29),
      paint,
    );

    // Second todo item (pending)
    paint.color = const Color(0xFF666666);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;
    final checkbox2 = Rect.fromLTWH(
        size.width * 0.25,
        size.height * 0.4,
        size.width * 0.08,
        size.height * 0.08
    );
    canvas.drawRect(checkbox2, paint);

    // Line for pending item
    paint.color = const Color(0xFF333333);
    canvas.drawLine(
      Offset(size.width * 0.4, size.height * 0.44),
      Offset(size.width * 0.7, size.height * 0.44),
      paint,
    );

    // Third todo item (pending)
    paint.color = const Color(0xFF666666);
    paint.style = PaintingStyle.stroke;
    final checkbox3 = Rect.fromLTWH(
        size.width * 0.25,
        size.height * 0.55,
        size.width * 0.08,
        size.height * 0.08
    );
    canvas.drawRect(checkbox3, paint);

    // Line for pending item
    paint.color = const Color(0xFF333333);
    canvas.drawLine(
      Offset(size.width * 0.4, size.height * 0.59),
      Offset(size.width * 0.7, size.height * 0.59),
      paint,
    );

    // Fourth todo item (pending)
    paint.color = const Color(0xFF666666);
    paint.style = PaintingStyle.stroke;
    final checkbox4 = Rect.fromLTWH(
        size.width * 0.25,
        size.height * 0.7,
        size.width * 0.08,
        size.height * 0.08
    );
    canvas.drawRect(checkbox4, paint);

    // Line for pending item
    paint.color = const Color(0xFF333333);
    canvas.drawLine(
      Offset(size.width * 0.4, size.height * 0.74),
      Offset(size.width * 0.6, size.height * 0.74),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}