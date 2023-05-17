import 'package:flutter/material.dart';
import 'package:wj_tex/src/model/basic.dart';
import 'package:wj_tex/src/model/data.dart';

/// 一個參數WIDGET
class TexLim extends StatelessWidget {

  final String subscript;

  final TextStyle style;

  TexLim(
      this.subscript, {
        this.style = texTexStyle
      });

  @override
  Widget build(BuildContext context) {
    var limStyle = style.copyWith(
        fontSize: style.fontSize! * 0.7
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('lim', style: style,),
        TexView(subscript, style: limStyle,)
      ],
    );
  }
}