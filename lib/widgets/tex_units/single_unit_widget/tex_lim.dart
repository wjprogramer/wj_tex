import 'package:flutter/material.dart';
import 'package:wj_tex/data/data.dart';
import 'package:wj_tex/widgets/widgets.dart';

class TexLim extends StatelessWidget implements TexSingleUnitView {

  final String subscript;

  final TextStyle style;

  TexLim(this.subscript, {
    TextStyle? style,
  }): this.style = style ?? texTexStyle;

  @override
  Widget build(BuildContext context) {
    var limStyle = style.copyWith(
      fontSize: style.fontSize! * 0.7,
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