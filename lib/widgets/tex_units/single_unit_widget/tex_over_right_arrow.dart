import 'package:flutter/material.dart';
import 'package:wj_tex/widgets/widgets.dart';
import 'package:wj_tex/data/data.dart';

class TexOverRightArrow extends StatelessWidget implements TexSingleUnitView {
  final String input;
  final TextStyle style;

  TexOverRightArrow(this.input, {
    TextStyle? style
  }): this.style = style ?? texTexStyle;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _OverRightArrowPainter(),
      child: TexView(input, style: style,),
    );
  }
}

class _OverRightArrowPainter extends CustomPainter {
  late Paint _rightArrowPaint;

  _OverRightArrowPainter() {
    _rightArrowPaint = Paint()
      ..strokeWidth = 1.2;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(Offset(0, -2), Offset(size.width, -2), _rightArrowPaint);
    canvas.drawLine(Offset(size.width - 5, -5), Offset(size.width, -2), _rightArrowPaint);
    canvas.drawLine(Offset(size.width - 5, 1), Offset(size.width, -2), _rightArrowPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

}