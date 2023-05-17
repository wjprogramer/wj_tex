import 'package:flutter/material.dart';
import 'package:wj_tex/data/data.dart';
import 'package:wj_tex/widgets/widgets.dart';

class TexPlainText extends StatelessWidget implements TexSingleUnitView {
  final String input;
  final TextStyle style;

  TexPlainText(
      this.input, {
        TextStyle? style,
      }): this.style = style ?? texTexStyle;

  @override
  Widget build(BuildContext context) {
    return Text(input, style: style.copyWith(fontFamily: DefaultTextStyle.of(context).style.fontFamily),);
  }
}