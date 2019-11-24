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
  static Tex getSingleBracketsWidget(String key, Tex arg, {TextStyle style = texTexStyle}) {
    switch(key) {
      case 'overrightarrow': {

      } break;
      case 'underline': {

      } break;
      case 'overline': {

      } break;
      case 'widehat': {

      } break;
      case 'lim': {
        TextStyle limStyle = style.copyWith(
          fontSize: style.fontSize * 0.4
        );
        return TexLim(arg, style: limStyle,);
      } break;
      default: {

      } break;
    }
    return TexText('error', style: style,);
  }

  /// 取得 擁有兩組大括弧參數的widget
  static Tex getDoubleBracketsWidget(String key, Tex arg1, Tex arg2, {TextStyle style = texTexStyle}) {
    switch(key) {
      case 'frac': {
        return TexFrac(arg1, arg2, style: style,);
      } break;
      default: {
        return TexText('$arg1$arg2', style: style,);
      } break;
    }
  }


}