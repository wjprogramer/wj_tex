import 'package:flutter/material.dart';
import 'package:wj_tex/src/model/data.dart';

/// 一個參數WIDGET
class TexPlainText extends StatelessWidget {
  final String input;
  final TextStyle style;

  TexPlainText(
      this.input, {
        this.style = texTexStyle
      });

  @override
  Widget build(BuildContext context) {
    return Text(input, style: style.copyWith(fontFamily: DefaultTextStyle.of(context).style.fontFamily),);
  }
}