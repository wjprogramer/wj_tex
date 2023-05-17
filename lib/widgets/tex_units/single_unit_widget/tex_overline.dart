import 'package:flutter/material.dart';
import 'package:wj_tex/src/model/basic.dart';
import 'package:wj_tex/src/model/data.dart';

/// 一個參數WIDGET
class TexOverline extends StatelessWidget {
  final String input;
  final TextStyle style;

  TexOverline(this.input, {this.style = texTexStyle});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      /// @deprecated原始版本 (原本外面還包著一層 padding, top:1)
      //        decoration: BoxDecoration(
      //          border: Border(
      //            top: BorderSide(color: Colors.black, width: 1),
      //          ),
      //        ),
        painter: _OverlinePainter(),
        child: TexView(input, style: style,)
    );
  }
}

class _OverlinePainter extends CustomPainter {
  late Paint _overlinePaint;

  _OverlinePainter() {
    _overlinePaint = Paint()
      ..strokeWidth = 1.2;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(Offset(0, 0), Offset(size.width, 0), _overlinePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

}