import 'package:flutter/material.dart';
import 'package:wj_tex/data/data.dart';
import 'package:wj_tex/utils/string_utils.dart';
import 'package:wj_tex/widgets/widgets.dart';

/// 兩個參數 (特殊) Widget
class TexScripts extends StatelessWidget implements TexTwoUnitsView {
  final String superscript;
  final String subscript;
  final TextStyle style;

  TexScripts({
    this.superscript = '',
    this.subscript = '',
    TextStyle? style,
  }): this.style = style ?? texTexStyle;

  @override
  Widget build(BuildContext context) {
    var scriptStyle = style.copyWith(
        fontSize: (style.fontSize ?? 14.0) * 0.5
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
//      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _getSuperscript(scriptStyle: scriptStyle),
        _getSubscript(scriptStyle: scriptStyle),
      ],
    );
  }

  Widget _getSuperscript({ required TextStyle scriptStyle }) {
    if (superscript.isNotEmpty)
      return TexView(superscript, style: scriptStyle,);
    else
      return Text('', style: scriptStyle,);
  }

  Widget _getSubscript({ required TextStyle scriptStyle }) {
    if (subscript.isNotEmpty) {
      return TexView(subscript, style: scriptStyle,);
    } else {
      return Text('', style: scriptStyle,);
    }
  }
}