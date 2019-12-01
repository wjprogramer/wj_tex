import 'package:flutter/material.dart';
import 'package:wj_tex/src/utils/string_utils.dart';
import 'package:wj_tex/src/utils/tex_utils.dart';

/// -----------------------------------------------------
/// VARIABLES

const TextStyle texTexStyle = TextStyle(
  fontSize: 15,
  fontFamily: 'CmuSerifExtra',
);

Map specialCharMap = {
  'sigma': '∑',
  'alpha': 'α'
};

/// -----------------------------------------------------
/// ABSTRACT CLASS

/// -----------------------------------------------------

///  最底層 WIDGET

class TexText extends StatelessWidget {
  final String input;

  final TextStyle style;

  TexText(
      this.input, {
        this.style = texTexStyle
      }) {
    print('TexText: $input');
  }

  @override
  Widget build(BuildContext context) {
    return Text(input, style: style,);
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
      //          decoration: new BoxDecoration(
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
      //        decoration: new BoxDecoration(
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
        TexText('lim', style: style,),
        TexText(subscript, style: limStyle,)
      ],
    );
  }
}

/// 兩個參數 WIDGET

///
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

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: new Column(
        // mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            decoration: new BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: <Widget>[
                SizedBox(height: 6,), // 避免 overRightArrow 超出 widget
                Align(
                  alignment: Alignment.center,
                  child: TexView(numerator, style: style,),
                ),
                SizedBox(height: 3,) // column, sizedBox作用: 避免 underline 會與「分數」(frac) 的線重疊
              ],
            ),
          ),
          new Container(
            alignment: Alignment.center,
            child: TexView(denominator, style: style,),
          ),
        ],
      ),
    );
  }
}

/// 兩個參數 (特殊) Widget

///
class TexScripts extends StatelessWidget {
  final String superscript;
  final String subscript;
  final TextStyle style;

  TexScripts({
    this.superscript,
    this.subscript,
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

//  bool pureText = true;

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

  List<Widget> parser() {
    String text = '';

    for (int i = 0; i < input.length; i++) {
      switch(input[i]) {
        case '{': {
          // region 尋找一般分組
          if (text.isNotEmpty) {
            children.add(TexText(text));
            text = '';
          }

          int contentSize = TexUtils.getCorrespondParenthesesContentSize(input.substring(i, input.length));
          i += contentSize + 1; // 1代表後大括弧
          children.add(TexView(input.substring(i+1, i+contentSize+1), style: style,));
        } break;
      // endregion
        case '\\': {
          // region 找關鍵字
          String key = getKeyword(i);

          if (specialCharMap.containsKey(key) || key.length == 1) {
            text += specialCharMap[key] ?? key;

            i += key.length;

            if (i == input.length - 1) {
              children.add(TexText(text, style: style,));
              text = '';
            }
          } else {
            if (text.isNotEmpty) {
              children.add(TexText(text, style: style,));
              text = '';
            }

            switch(key) {
            /// 未來如果有 \key{...}{...} 形式的語法，放到case 'frac' 上面，並且，[TexUtils].getDoubleBracketsWidget也要新增
              case 'frac': {
                //region 屬於包含兩個`{}`參數的key
                int arg1Length = TexUtils.getCorrespondParenthesesContentSize(input.substring(i+key.length+1, input.length));

                int arg2StartIndex = i + key.length + arg1Length + 2 + 1;
                int arg2Length = TexUtils.getCorrespondParenthesesContentSize(input.substring(arg2StartIndex, input.length));

                String arg1 = input.substring(i+key.length+2, i+key.length+arg1Length+2);
                String arg2 = input.substring(arg2StartIndex+1, arg2StartIndex+arg2Length+1);
                children.add(TexUtils.getDoubleBracketsWidget(key, arg1, arg2));

                // 2代表一組大括弧
                i += key.length + arg1Length + 2;
                i += arg2Length + 2;
                //endregion
              } break;
              case 'overrightarrow':
              case 'underline': // TODO: 底線+分數 的時候，會不會有問題? 線疊在一起之類的問題?
              case 'overline':
              case 'widehat':
              case 'lim': {
                // region 屬於包含一個`{}`參數的key
                int argLength = TexUtils.getCorrespondParenthesesContentSize(input.substring(i+key.length+1, input.length));

                String arg = input.substring(i + key.length + 2, i + key.length + argLength+2);
                children.add(TexUtils.getSingleBracketsWidget(key, arg, style: style));

                // 2代表一組大括弧
                i += key.length + argLength + 2;
              } break;
            // endregion
              case 'sqrt': {
              } break;
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
          if (text.isNotEmpty && i == input.length - 1) {
            children.add(TexText(text, style: style,));
            text = '';
          }
        } break;
      //endregion
        case '^': {
          // region 上標 superscript
          if (text.isNotEmpty) {
            children.add(TexText(text, style: style,));
            text = '';
          }

          // arg1:上標, arg2:下標
          int arg1Length = TexUtils.getCorrespondParenthesesContentSize(input.substring(i+1, input.length));

          String superscript = input.substring(i+1+1, i+1+arg1Length+1);
          String subscript = '';

          int arg2StartIndex = i + 1 + arg1Length + 1 + 1; // i(^) + 1({) + content + 1(}) + 1(_)
          if (input[arg2StartIndex] == '_') {
            int arg2Length = TexUtils.getCorrespondParenthesesContentSize(input.substring(arg2StartIndex + 1, input.length));
            subscript = input.substring(arg2StartIndex + 2, arg2StartIndex + 2 + arg2Length);
            i += 1 + arg2Length + 2;
          }

          i += arg1Length + 2;

          children.add(TexScripts(superscript: superscript, subscript: subscript, style: style,));
        } break;
      // endregion
        case '_': {
          // region 下標 Subscript
          if (text.isNotEmpty) {
            children.add(TexText(text, style: style,));
            text = '';
          }

          // arg1:上標, arg2:下標
          int arg1Length = TexUtils.getCorrespondParenthesesContentSize(input.substring(i+1, input.length));

          String subscript = input.substring(i+1+1, i+1+arg1Length+1);
          String superscript = '';

          int arg2StartIndex = i + 1 + arg1Length + 1 + 1; // i(^) + 1({) + content + 1(}) + 1(_)
          if (input[arg2StartIndex] == '^') {
            int arg2Length = TexUtils.getCorrespondParenthesesContentSize(input.substring(arg2StartIndex + 1, input.length));
            superscript = input.substring(arg2StartIndex + 2, arg2StartIndex + 2 + arg2Length);
            i += 1 + arg2Length + 2;
          }

          i += arg1Length + 2;

          children.add(TexScripts(superscript: superscript, subscript: subscript, style: style,));
        } break;
      // endregion
        default: {
          //region 一般字元加入text
          text += input[i];
          if (i == input.length - 1 ) {
            children.add(TexText(text, style: style,));
          }
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
      if (StringUtils.isAlpha(input[i])) {
        key += input[i];
      } else {
        break;
      }
    }
    return key;
  }

  @override
  Widget build(BuildContext context) {
    if (children.length > 1) {
      return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: TexUtils.getWidgetListWithSpace(children)
      );
    } else if (children.length == 1){
      return children[0];
    } else {
      return TexText('[empty]');
    }

  }
}