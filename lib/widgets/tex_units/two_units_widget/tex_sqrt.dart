import 'package:flutter/material.dart';
import 'package:wj_tex/widgets/widgets.dart';
import 'package:wj_tex/data/data.dart';
import 'package:wj_tex/utils/string_utils.dart';

class TexSqrt extends StatelessWidget implements TexTwoUnitsView {
  final String root;
  final String input;
  final TextStyle style;

  TexSqrt(
      this.input, {
        this.root = '',
        TextStyle? style,
      }): this.style = style ?? texTexStyle;

  List<Widget> _getRoot() {
    var rootStyle = style.copyWith(fontSize: (style.fontSize ?? 14)! * 0.7);

    if (root.isNotEmpty) {
      return [
        Spacer(flex: 1,),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TexView(root, style: rootStyle,),
            SizedBox(width: 7,)
          ],
        ),
        SizedBox(height: 5,)
      ];
    } else {
      return [
        SizedBox(width: 10,)
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: <Widget>[
          Container(
            child: Column(
              children: _getRoot(),
            ),
          ),
          CustomPaint(
            painter: _SqrtPainter(),
            child: TexView(input, style: style,),
          )
        ],
      ),
    );
  }
}

class _SqrtPainter extends CustomPainter {
  var _sqrtPaint;

  _SqrtPainter() {
    _sqrtPaint = Paint()
      ..strokeWidth = 1.2;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(Offset(0, -3), Offset(size.width, -3), _sqrtPaint);
    canvas.drawLine(Offset(0, -3), Offset(-5, size.height), _sqrtPaint);
    canvas.drawLine(Offset(-5, size.height), Offset(-10, size.height - 5), _sqrtPaint);
    canvas.drawLine(Offset(0, 0), Offset(0, 0), _sqrtPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

}