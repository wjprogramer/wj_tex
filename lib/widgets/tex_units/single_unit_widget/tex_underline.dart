import 'package:flutter/material.dart';
import 'package:wj_tex/widgets/widgets.dart';
import 'package:wj_tex/data/data.dart';

class TexUnderline extends StatelessWidget implements TexSingleUnitView {
  final String input;
  final TextStyle style;

  TexUnderline(this.input, {TextStyle? style,
  }): this.style = style ?? texTexStyle;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      /// @deprecated 原始版本 (原本外面還包著一層 padding, top:1)
      //          decoration: BoxDecoration(
      //            border: Border(
      //              bottom: BorderSide(color: Colors.black, width: 1),
      //            ),
      //          ),
        painter: _UnderlinePainter(),
        child: TexView(input, style: style,)
    );
  }
}

class _UnderlinePainter extends CustomPainter {
  late Paint _underlinePaint;

  _UnderlinePainter() {
    _underlinePaint = Paint()
      ..strokeWidth = 1.2;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), _underlinePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}