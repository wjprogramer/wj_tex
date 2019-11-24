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

abstract class Tex extends Widget { }

abstract class Parser {
  List<Tex> parser();
}

/// -----------------------------------------------------

/// WIDGET



class TexText extends StatelessWidget implements Tex {
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

/// WIDGET

class TexLim extends StatelessWidget implements Tex {

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

/// WIDGET

class TexFrac extends StatelessWidget implements Tex {
  // 分子
  final Widget numerator;

  // 分母
  final Widget denominator;

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
          new Container(
            decoration: new BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black,
                  width: 1,
                ),
              ),
            ),
            child: Align(
              alignment: Alignment.center,
              child: numerator,
            ),
          ),
          new Container(
            color: Colors.amber,
            child: denominator,
          ),
        ],
      ),
    );
  }
}

/// MAIN WIDGET

class TexView extends StatefulWidget implements Tex {
  final String input;

  final TextStyle style;

  TexView(
    this.input, {
    this.style = texTexStyle
  });

  @override
  _TexViewState createState() => _TexViewState(input, style: style);
}

class _TexViewState extends State<TexView> implements Parser {
  List<Tex> children = List();

  String input;

  TextStyle style;

  _TexViewState(
    this.input, {
    this.style = texTexStyle,
  });

  @override
  void initState() {
    super.initState();
    if (input.isNotEmpty) {
      children = parser();
    }
  }

  @override
  List<Tex> parser() {
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
                // TODO: delete
                // children.add(TexFrac(TexView(arg1), TexView(arg2)));
                children.add(TexUtils.getDoubleBracketsWidget(key, TexView(arg1, style: style,), TexView(arg2, style: style,)));

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
          if (text.isNotEmpty) {
            children.add(TexText(text, style: style,));
            text = '';
          }
        } break;
        //endregion
        case '^': {
          // region 上標 superscript

        } break;
        // endregion
        case '_': {
          // region 下標 Subscript
        } break;
        // endregion
        default: {
          //region 一般字元加入text
          text += input[i];
          if (i == input.length - 1) {
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
//    return Wrap(
//      crossAxisAlignment: WrapCrossAlignment.center,
//      spacing: 3,
//      children: children // TODO: 應該不需要包 Row  或  IntrinsicHeight了?  確認之後刪除
//    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children.map( (child) {
        return Row(
          children: <Widget>[
            child,
            SizedBox(width: 2, height: 5,),
          ],
        );
      }).toList(),
    );
  }
}