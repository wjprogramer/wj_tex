import 'package:flutter/cupertino.dart';
import 'package:wj_tex/data/data.dart';
import 'package:wj_tex/utils/string_utils.dart';
import 'package:wj_tex/widgets/tex_units/single_unit_widget/tex_over_right_arrow.dart';
import 'package:wj_tex/widgets/tex_units/single_unit_widget/tex_underline.dart';
import 'package:wj_tex/widgets/tex_units/two_units_widget/tex_fraction.dart';
import 'package:wj_tex/widgets/tex_units/single_unit_widget/tex_lim.dart';
import 'package:wj_tex/widgets/tex_units/single_unit_widget/tex_overline.dart';
import 'package:wj_tex/widgets/tex_units/single_unit_widget/tex_plain_text.dart';
import 'package:wj_tex/widgets/tex_units/two_units_widget/tex_sqrt.dart';

class TexUtils {

  static TextStyle get _texTexStyle => TextStyle(
    fontFamily: 'CmuSerifExtra',
  );

  // Parentheses 括號
  // - curly brackets 大括號
  // - square brackets (中/方)括號

  // region 取得括弧內容長度
  /// 大括弧內的內容長度
  ///
  /// '{' 的位置從 [input].index = 0 開始
  ///
  /// [differenceNumber] 代表大括弧配對的相差數量
  static int getSizeInCurlyBrackets(String input) {
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
    return 0;
  }

  /// 中括弧內的內容長度
  ///
  /// '[' 的位置從 [input].index = 0 開始
  ///
  /// [differenceNumber] 代表中括弧配對的相差數量
  static int getSizeInSquareBrackets(String input) {
    int differenceNumber = 0;

    if (input[0] != '[') {
      return 0;
    }

    for (int i = 0; i < input.length; i++) {
      if (input[i] == '[') {
        differenceNumber ++;
      } else if (input[i] == ']') {
        differenceNumber --;
        if (differenceNumber == 0) {
          return i - 1;
        }
      }
    }
    return 0;
  }

  /// 取得大括弧內的字串
  ///
  /// * [input] 輸入字串，格式：`{...}` (以大括弧為開頭)
  /// * [index] 第幾組大括弧（以`0`為起點）
  static String getStringInCurlyBrackets(String input, int index) {
    var result = '';
    var currentIndex = 0;

    for (int i = 0; i <= index; i++) {
      var contentLength = getSizeInCurlyBrackets(input.substring(currentIndex));

      if (i == index) {
        result = input.substring(currentIndex + 1, currentIndex + contentLength + 1);
        break;
      }

      currentIndex += contentLength + 2;
    }
    return result;
  }
  // endregion

  // region 根據 key 取得 widget
  // 例如: key為`frac`，會回傳Widget:TexFrac
  /// 取得 擁有一組大括弧參數的widget
  static Widget getSingleBracketsWidget(String key, String arg, {
    TextStyle? style
  }) {
    final newStyle = style ?? _texTexStyle;

    switch(key) {
      case 'text':
        return TexPlainText(arg, style: newStyle,);
      case 'overrightarrow':
        return TexOverRightArrow(arg, style: newStyle,);
      case 'underline':
        return TexUnderline(arg, style: newStyle,);
      case 'overline':
        return TexOverline(arg, style: newStyle);
      case 'widehat':
        // 暫時未做
        break;
      case 'lim':
        return TexLim(arg, style: newStyle,);
      default: {}
    }
    return Text('[error:$key]', style: newStyle,);
  }

  /// 取得 擁有兩組大括弧參數的widget
  static Widget getDoubleBracketsWidget(String key, String arg1, String arg2, {
    TextStyle? style
  }) {
    final newStyle = style ?? _texTexStyle;

    switch(key) {
      case 'frac':
        return TexFrac(arg1, arg2, style: newStyle,);
      case 'sqrt':
        return TexSqrt(arg2, root: arg1, style: newStyle,);
      default:
        return Text('[error:$key]', style: newStyle,);
    }
  }
  // endregion

  // region 處理 widget
  /// For Row
  static List<Widget> getWidgetListWithSpace(List<Widget> list) {
    List<Widget> result = [];

    for (int i = 0; i < list.length; i++) {
      result.add(list[i]);
      if (i != list.length - 1) {
        result.add(SizedBox(width: 3,));
      }
    }

    return result;
  }
  // endregion

  //region 取得分數深度
  /// 取得分數(分子或分母texString)的深度
  static int getFracDepth(String input) {
    int maxDepth = 0;
    bool hasFraction = false;

    for (int i = 0; i < input.length; i++) {
      if (input[i] == '\\' && getKeyword(i, input) == 'frac') {
        hasFraction = true;

        var arg1 = getStringInCurlyBrackets(input.substring(i + 5), 0);
        var arg2 = getStringInCurlyBrackets(input.substring(i), 1);

        var depth1 = getFracDepth(arg1);
        var depth2 = getFracDepth(arg2);

        var maxArgDepth = depth1 > depth2 ? depth1 : depth2;
        maxDepth = maxDepth > maxArgDepth ? maxDepth : maxArgDepth;

        i += arg1.length + arg2.length + 4;
      }
    }

    if (hasFraction) {
      maxDepth++;
    }

    return maxDepth;
  }

  /// startIndex為反斜線的index
  static String getKeyword(int startIndex, String input) {
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

}