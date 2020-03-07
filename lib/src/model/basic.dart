import 'dart:math';

import 'package:flutter/material.dart';
import '../utils/string_utils.dart';
import '../utils/tex_utils.dart';

/// -----------------------------------------------------
/// VARIABLES

const TextStyle texTexStyle = TextStyle(
    fontSize: 15,
    fontFamily: 'CMU',
    package: 'wj_tex'
);

Map specialCharMap = {
  ' ' : ' ',
  'Alpha':'Α',
  'alpha':'α',
  'Beta':'Β',
  'beta':'β',
  'Gamma':'Γ',
  'gamma':'γ',
  'Delta':'Δ',
  'delta':'δ',
  'Epsilon':'Ε',
  'epsilon':'ε',
  'Zeta':'Ζ',
  'zeta':'ζ',
  'Eta':'Η',
  'eta':'η',
  'Theta':'Θ',
  'theta':'θ',
  'Iota':'Ι',
  'iota':'ι',
  'Kappa':'Κ',
  'kappa':'κ',
  'Lambda':'Λ',
  'lambda':'λ',
  'Mu':'Μ',
  'mu':'μ',
  'Nu':'Ν',
  'nu':'ν',
  'Xi':'Ξ',
  'xi':'ξ',
  'Omicron':'Ο',
  'omicron':'ο',
  'Pi':'Π',
  'pi':'π',
  'Rho':'Ρ',
  'rho':'ρ',
  'Sigma':'Σ', // Σ?
  'sigma':'σ',
  'Tau':'Τ',
  'tau':'τ',
  'Upsilon':'Υ',
  'upsilon':'υ',
  'Phi':'Φ',
  'phi':'φ',
  'Chi':'Χ',
  'chi':'χ',
  'Psi':'Ψ',
  'psi':'ψ',
  'Omega':'Ω',
  'omega':'ω',
};

/// -----------------------------------------------------

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

/// 一個參數WIDGET
class TexOverRightArrow extends StatelessWidget {
  final String input;
  final TextStyle style;

  TexOverRightArrow(this.input, {this.style = texTexStyle});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _OverRightArrowPainter(),
      child: TexView(input, style: style,),
    );
  }
}

class _OverRightArrowPainter extends CustomPainter {
  Paint _rightArrowPaint;

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

/// 一個參數WIDGET
class TexUnderline extends StatelessWidget {
  final String input;
  final TextStyle style;

  TexUnderline(this.input, {this.style = texTexStyle});

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
  Paint _underlinePaint;

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
  Paint _overlinePaint;

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
        fontSize: style.fontSize * 0.7
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

/// 兩個參數 WIDGET
class TexSqrt extends StatelessWidget {
  final String root;
  final String input;
  final TextStyle style;

  TexSqrt(
      this.input, {
        this.root = '',
        this.style = texTexStyle
      });

  List<Widget> _getRoot() {
    var rootStyle = style.copyWith(fontSize: style.fontSize * 0.7);

    if (StringUtils.isNotNullOrEmpty(root)) {
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

/// 兩個參數 WIDGET
class TexFrac extends StatelessWidget {
  // 分子
  final String numerator;
  // 分母
  final String denominator;

  final TextStyle style;

  TexFrac(
      this.numerator,
      this.denominator, {
        this.style = texTexStyle
      }
      );

  _emptyColumn(bool isNumerator) {
    var nDepth = TexUtils.getFracDepth(numerator);
    var dDepth = TexUtils.getFracDepth(denominator);

    var maxDepth = max(dDepth, nDepth);

    if (maxDepth <= 0) {
      return SizedBox();
    }

    List<Widget> emptyWidgets = List<Widget>.generate(maxDepth, (_) => Text('', style: style,))
      ..add(SizedBox(
        height: (dDepth - 1) * 3.0,
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

/// 兩個參數 (特殊) Widget
class TexScripts extends StatelessWidget {
  final String superscript;
  final String subscript;
  final TextStyle style;

  TexScripts({
    this.superscript = '',
    this.subscript = '',
    this.style = texTexStyle
  });

  @override
  Widget build(BuildContext context) {
    var scriptStyle = style.copyWith(
        fontSize: style.fontSize * 0.5
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

  Widget _getSuperscript({TextStyle scriptStyle}) {
    if (StringUtils.isNotNullOrEmpty(superscript))
      return TexView(superscript, style: scriptStyle,);
    else
      return Text('', style: scriptStyle,);
  }

  Widget _getSubscript({TextStyle scriptStyle}) {
    if (StringUtils.isNotNullOrEmpty(subscript)) {
      return TexView(subscript, style: scriptStyle,);
    } else {
      return Text('', style: scriptStyle,);
    }
  }
}

/// -----------------------------------------------------
/// MAIN WIDGET

class TexView extends StatefulWidget {
  final String input;
  final TextStyle style;

  TexView(
      this.input, {
        this.style = texTexStyle
      });

  @override
  _TexViewState createState() => _TexViewState(input, style: style);
}

class _TexViewState extends State<TexView> {
  List<Widget> children = List();
  String input;
  TextStyle style;

  _TexViewState(
    this.input, {
      this.style = texTexStyle,
    });

  @override
  void initState() {
    super.initState();
    if (StringUtils.isNotNullOrEmpty(input)) {
      children = parser();
    }
  }

  String _processText(String text, {bool isLast = false}) {
    if (text.isNotEmpty || isLast) {
      children.add(Text(text, style: style,));
      text = '';
    }
    return text;
  }

  List<Widget> parser() {
    String text = '';

    for (int i = 0; i < input.length; i++) {
      switch(input[i]) {
        case '{': {
          // region 尋找一般分組
          text = _processText(text);
          int contentSize = TexUtils.getSizeInCurlyBrackets(input.substring(i, input.length));
          children.add(TexView(input.substring(i+1, i+contentSize+1), style: style,));
          i += contentSize + 1; // 1代表後大括弧
        } break;
      // endregion
        case '\\': {
          // region 找關鍵字
          String key = getKeyword(i);

          if (specialCharMap.containsKey(key) || key.length == 1) {
            text += specialCharMap[key] ?? key;
            i += key.length;
            text = _processText(text, isLast: i == input.length - 1);
          } else {
            text = _processText(text);

            switch(key) {
            /// 未來如果有 \key{...}{...} 形式的語法，放到case 'frac' 上面，並且，[TexUtils].getDoubleBracketsWidget也要新增
              case 'frac': {
                //region 包含兩個`{}`參數widget的key
                int arg1Length = TexUtils.getSizeInCurlyBrackets(input.substring(i+key.length+1, input.length));

                int arg2StartIndex = i + key.length + arg1Length + 2 + 1;
                int arg2Length = TexUtils.getSizeInCurlyBrackets(input.substring(arg2StartIndex, input.length));

                String arg1 = input.substring(i+key.length+2, i+key.length+arg1Length+2);
                String arg2 = input.substring(arg2StartIndex+1, arg2StartIndex+arg2Length+1);
                children.add(TexUtils.getDoubleBracketsWidget(key, arg1, arg2, style: style));

                // 2代表一組大括弧
                i += key.length + arg1Length + 2;
                i += arg2Length + 2;
                //endregion
              } break;
              case 'text':
              case 'overrightarrow':
              case 'underline': // TODO: 底線+分數 的時候，會不會有問題? 線疊在一起之類的問題?
              case 'overline':
              case 'widehat':
              case 'lim': {
                // region 包含一個`{}`參數widget的key
                int argLength = TexUtils.getSizeInCurlyBrackets(input.substring(i+key.length+1, input.length));

                String arg = input.substring(i + key.length + 2, i + key.length + argLength+2);
                children.add(TexUtils.getSingleBracketsWidget(key, arg, style: style));

                // 2代表一組大括弧
                i += key.length + argLength + 2;
              } break;
            // endregion
              case 'sqrt': {
                // region [特殊: 中括弧+大括弧]
                text = _processText(text);

                String arg1 = '';
                bool hasRoot = true;

                int arg1Length = TexUtils.getSizeInSquareBrackets(input.substring(i+key.length+1, input.length));
                hasRoot = (arg1Length != 0);

                int arg2StartIndex = i + key.length + arg1Length + 1;
                if (hasRoot) {
                  arg2StartIndex += 2;
                }
                int arg2Length = TexUtils.getSizeInCurlyBrackets(input.substring(arg2StartIndex, input.length));

                arg1 = input.substring(i+key.length+2, i+key.length+arg1Length+2);
                String arg2 = input.substring(arg2StartIndex+1, arg2StartIndex+arg2Length+1);
                children.add(TexUtils.getDoubleBracketsWidget(key, arg1, arg2));

                if (hasRoot) { i += arg1Length + 2; /* 2代表一組括弧 */ }
                i += key.length;
                i += arg2Length + 2;
              } break;
            // endregion
              default: {
                // FIXME: 目前還沒有判斷 ，如果不是預設的key、也不是 special char 的情況
                // region 如果沒輸入錯的話，照理來說不會到這邊
                // endregion
              } break;
            }
          }
        } break;
      // endregion
        case ' ': {
          //region 空白不加入text
          text = _processText(text);
        } break;
      //endregion
        case '^': {
          // region 上標 superscript
          text = _processText(text);

          // arg1:上標, arg2:下標
          int arg1Length = TexUtils.getSizeInCurlyBrackets(input.substring(i+1, input.length));

          String superscript = input.substring(i+1+1, i+1+arg1Length+1);
          String subscript = '';

          int arg2StartIndex = i + 1 + arg1Length + 1; // i(^) + 1({) + content.len + 1(})
          if (arg2StartIndex + 1 <= input.length - 1 && input[arg2StartIndex + 1] == '_') {
            int arg2Length = TexUtils.getSizeInCurlyBrackets(input.substring(arg2StartIndex + 2, input.length));
            subscript = input.substring(arg2StartIndex + 3, arg2StartIndex + 3 + arg2Length);
            i += 1 + arg2Length + 2;
          }

          i += arg1Length + 2;

          children.add(TexScripts(superscript: superscript, subscript: subscript, style: style,));
        } break;
      // endregion
        case '_': {
          // region 下標 Subscript
          text = _processText(text);

          // arg1:上標, arg2:下標
          int arg1Length = TexUtils.getSizeInCurlyBrackets(input.substring(i+1, input.length));

          String subscript = input.substring(i+1+1, i+1+arg1Length+1);
          String superscript = '';

          int arg2StartIndex = i + 1 + arg1Length + 1; // i(^) + 1({) + content + 1(})
          if (arg2StartIndex + 1 <= input.length - 1 && input[arg2StartIndex + 1] == '^') {
            int arg2Length = TexUtils.getSizeInCurlyBrackets(input.substring(arg2StartIndex + 2, input.length));
            superscript = input.substring(arg2StartIndex + 3, arg2StartIndex + 3 + arg2Length);
            i += 1 + arg2Length + 2;
          }

          i += arg1Length + 2;

          children.add(TexScripts(superscript: superscript, subscript: subscript, style: style,));
        } break;
      // endregion
        default: {
          //region 一般字元加入text
          text += input[i];
          bool isLast = i == input.length - 1;
          if (isLast) { text = _processText(text, isLast: isLast); }
        } break;
      //endregion
      }
    }
    return children;
  }

  // startIndex為反斜線的index
  String getKeyword(int startIndex) {
    String key = '';

    for (int i = startIndex + 1; i < input.length; i++) {
      if (StringUtils.isAlphas(input[i])) {
        key += input[i];
      } else {
        break;
      }
    }
    return key;
  }

  @override
  Widget build(BuildContext context) {
    if (children.length > 0) {
      return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: TexUtils.getWidgetListWithSpace(children)
      );
    } else {
      return Text('');
    }
  }
}