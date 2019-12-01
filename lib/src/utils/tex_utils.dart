import 'package:flutter/cupertino.dart';
import 'package:wj_tex/wj_tex.dart';


class TexUtils {

  /// 大括弧內的內容長度
  ///
  /// '{' 的位置從 [input].index = 0 開始
  ///
  /// [differenceNumber] 代表大括弧的相差數量
  static int getCorrespondParenthesesContentSize(String input) {
    print('getCorrespondParenthesesContentSize: $input');

    int differenceNumber = 0;
    for (int i = 0; i < input.length; i++) {
      if (input[i] == '{') {
        differenceNumber ++;
      } else if (input[i] == '}') {
        differenceNumber --;
        if (differenceNumber == 0) {
          return i - 1;
        }
      }
    }
    return -1;
  }

  /// 取得 擁有一組大括弧參數的widget
  static Widget getSingleBracketsWidget(String key, String arg, {TextStyle style = texTexStyle}) {
    switch(key) {
      case 'overrightarrow': {
        return TexOverRightArrow(arg, style: style,);
      } break;
      case 'underline': {
        return TexUnderline(arg, style: style,);
      } break;
      case 'overline': {
        return TexOverline(arg, style: style);
      } break;
      case 'widehat': {

      } break;
      case 'lim': {
        return TexLim(arg, style: style,);
      } break;
      default: {}
    }
    return TexText('[error] $key', style: style,);
  }

  /// 取得 擁有兩組大括弧參數的widget
  static Widget getDoubleBracketsWidget(String key, String arg1, String arg2, {TextStyle style = texTexStyle}) {
    switch(key) {
      case 'frac': {
        return TexFrac(arg1, arg2, style: style,);
      } break;
      default: {
        return TexText('$arg1$arg2', style: style,);
      } break;
    }
  }

  static List<Widget> getWidgetListWithSpace(List<Widget> list) {
    List<Widget> result = List();

    for (int i = 0; i < list.length; i++) {
      result.add(list[i]);
      if (i != list.length - 1) {
        result.add(SizedBox(width: 3,));
      }
    }

    return result;
  }

}