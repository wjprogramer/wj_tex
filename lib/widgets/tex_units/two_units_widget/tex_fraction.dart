import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:wj_tex/widgets/widgets.dart';
import 'package:wj_tex/data/data.dart';
import 'package:wj_tex/utils/tex_utils.dart';

/// TODO: rename to TexFraction
class TexFrac extends StatelessWidget implements TexTwoUnitsView {
  // 分子
  final String numerator;
  // 分母
  final String denominator;

  final TextStyle style;

  TexFrac(
      this.numerator,
      this.denominator,
      {
        TextStyle? style,
      }): this.style = style ?? texTexStyle;

  Widget _emptyColumn(bool isNumerator) {
    var nDepth = TexUtils.getFracDepth(numerator);
    var dDepth = TexUtils.getFracDepth(denominator);

    var maxDepth = math.max(dDepth, nDepth);

    if (maxDepth <= 0) {
      return SizedBox();
    }

    List<Widget> emptyWidgets = List<Widget>.generate(maxDepth + 1, (_) => Text('', style: style,))
      ..add(SizedBox(
        height: (maxDepth - 1) * 3.0,
      ));

    if ((isNumerator && nDepth < dDepth) || (!isNumerator && nDepth > dDepth)) {
      var emptyColumn = Column(
        mainAxisSize: MainAxisSize.min,
        children: emptyWidgets,
      );
      return emptyColumn;
    }
    return SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: <Widget>[
                SizedBox(height: 2,), // 避免 overRightArrow 超出 widget
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TexView(numerator, style: style,),
                      _emptyColumn(true),
                    ],
                  ),
                ),
                SizedBox(height: 3,) // column, sizedBox作用: 避免 underline 會與「分數」(frac) 的線重疊
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TexView(denominator, style: style,),
                _emptyColumn(false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}