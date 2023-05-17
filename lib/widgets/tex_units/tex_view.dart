import 'package:flutter/material.dart';
import 'package:wj_tex/data/data.dart';
import 'package:wj_tex/utils/string_utils.dart';
import 'package:wj_tex/utils/tex_utils.dart';
import 'package:wj_tex/widgets/tex_units/two_units_widget/tex_scripts.dart';

class TexView extends StatefulWidget {
  final String input;
  final TextStyle style;

  TexView(this.input, {
    TextStyle? style,
  }): this.style = style ?? texTexStyle;

  @override
  _TexViewState createState() => _TexViewState();
}

class _TexViewState extends State<TexView> {
  List<Widget> _children = [];
  String get _input => widget.input;
  TextStyle get _style => widget.style;

  @override
  void initState() {
    super.initState();
    if (_input.isNotEmpty) {
      _children = parser();
    }
  }

  String _processText(String text, {bool isLast = false}) {
    if (text.isNotEmpty || isLast) {
      _children.add(Text(text, style: _style,));
      text = '';
    }
    return text;
  }

  List<Widget> parser() {
    var text = '';

    for (int i = 0; i < _input.length; i++) {
      switch(_input[i]) {
        case '{':
          // 尋找一般分組
          text = _processText(text);
          int contentSize = TexUtils.getSizeInCurlyBrackets(_input.substring(i, _input.length));
          _children.add(TexView(_input.substring(i+1, i+contentSize+1), style: _style,));
          i += contentSize + 1; // 1代表後大括弧
          break;
        case '\\':
          // 找關鍵字
          final key = getKeyword(i);

          if (specialCharMap.containsKey(key) || key.length == 1) {
            text += specialCharMap[key] ?? key;
            i += key.length;
            text = _processText(text, isLast: i == _input.length - 1);
          } else {
            text = _processText(text);

            switch(key) {
              // 未來如果有 \key{...}{...} 形式的語法，放到case 'frac' 上面，並且，[TexUtils].getDoubleBracketsWidget也要新增
              case 'frac':
                // 包含兩個`{}`參數widget的key
                int arg1Length = TexUtils.getSizeInCurlyBrackets(_input.substring(i+key.length+1, _input.length));

                int arg2StartIndex = i + key.length + arg1Length + 2 + 1;
                int arg2Length = TexUtils.getSizeInCurlyBrackets(_input.substring(arg2StartIndex, _input.length));

                String arg1 = _input.substring(i+key.length+2, i+key.length+arg1Length+2);
                String arg2 = _input.substring(arg2StartIndex+1, arg2StartIndex+arg2Length+1);
                _children.add(TexUtils.getDoubleBracketsWidget(key, arg1, arg2, style: _style));

                // 2代表一組大括弧
                i += key.length + arg1Length + 2;
                i += arg2Length + 2;
                break;
              case 'text':
              case 'overrightarrow':
              case 'underline': // TODO: 底線+分數 的時候，會不會有問題? 線疊在一起之類的問題?
              case 'overline':
              case 'widehat':
              case 'lim':
                // 包含一個`{}`參數widget的key
                int argLength = TexUtils.getSizeInCurlyBrackets(_input.substring(i+key.length+1, _input.length));

                String arg = _input.substring(i + key.length + 2, i + key.length + argLength+2);
                _children.add(TexUtils.getSingleBracketsWidget(key, arg, style: _style));

                // 2代表一組大括弧
                i += key.length + argLength + 2;
                break;
              case 'sqrt':
                // [特殊: 中括弧+大括弧]
                text = _processText(text);

                String arg1 = '';
                bool hasRoot = true;

                int arg1Length = TexUtils.getSizeInSquareBrackets(_input.substring(i+key.length+1, _input.length));
                hasRoot = (arg1Length != 0);

                int arg2StartIndex = i + key.length + arg1Length + 1;
                if (hasRoot) {
                  arg2StartIndex += 2;
                }
                int arg2Length = TexUtils.getSizeInCurlyBrackets(_input.substring(arg2StartIndex, _input.length));

                arg1 = _input.substring(i+key.length+2, i+key.length+arg1Length+2);
                String arg2 = _input.substring(arg2StartIndex+1, arg2StartIndex+arg2Length+1);
                _children.add(TexUtils.getDoubleBracketsWidget(key, arg1, arg2));

                if (hasRoot) { i += arg1Length + 2; /* 2代表一組括弧 */ }
                i += key.length;
                i += arg2Length + 2;
                break;
              default:
                // FIXME: 目前還沒有判斷 ，如果不是預設的key、也不是 special char 的情況
                // 如果沒輸入錯的話，照理來說不會到這邊
                break;
            }
          }
          break;
        case ' ':
          // 空白不加入text
          text = _processText(text);
          break;
        case '^':
          // 上標 superscript
          text = _processText(text);

          // arg1:上標, arg2:下標
          int arg1Length = TexUtils.getSizeInCurlyBrackets(_input.substring(i+1, _input.length));

          String superscript = _input.substring(i+1+1, i+1+arg1Length+1);
          String subscript = '';

          int arg2StartIndex = i + 1 + arg1Length + 1; // i(^) + 1({) + content.len + 1(})
          if (arg2StartIndex + 1 <= _input.length - 1 && _input[arg2StartIndex + 1] == '_') {
            int arg2Length = TexUtils.getSizeInCurlyBrackets(_input.substring(arg2StartIndex + 2, _input.length));
            subscript = _input.substring(arg2StartIndex + 3, arg2StartIndex + 3 + arg2Length);
            i += 1 + arg2Length + 2;
          }

          i += arg1Length + 2;

          _children.add(TexScripts(superscript: superscript, subscript: subscript, style: _style,));
          break;
        case '_':
          // 下標 Subscript
          text = _processText(text);

          // arg1:上標, arg2:下標
          int arg1Length = TexUtils.getSizeInCurlyBrackets(_input.substring(i+1, _input.length));

          String subscript = _input.substring(i+1+1, i+1+arg1Length+1);
          String superscript = '';

          int arg2StartIndex = i + 1 + arg1Length + 1; // i(^) + 1({) + content + 1(})
          if (arg2StartIndex + 1 <= _input.length - 1 && _input[arg2StartIndex + 1] == '^') {
            int arg2Length = TexUtils.getSizeInCurlyBrackets(_input.substring(arg2StartIndex + 2, _input.length));
            superscript = _input.substring(arg2StartIndex + 3, arg2StartIndex + 3 + arg2Length);
            i += 1 + arg2Length + 2;
          }

          i += arg1Length + 2;

          _children.add(TexScripts(superscript: superscript, subscript: subscript, style: _style,));
          break;
        default:
          // 一般字元加入text
          text += _input[i];
          bool isLast = i == _input.length - 1;
          if (isLast) {
            text = _processText(text, isLast: isLast);
          }
          break;
      }
    }
    return _children;
  }

  // startIndex為反斜線的index
  String getKeyword(int startIndex) {
    String key = '';

    for (int i = startIndex + 1; i < _input.length; i++) {
      if (StringUtils.isAlphas(_input[i])) {
        key += _input[i];
      } else {
        break;
      }
    }
    return key;
  }

  @override
  Widget build(BuildContext context) {
    if (_children.length == 0) {
      return Text('');
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: TexUtils.getWidgetListWithSpace(_children),
    );
  }
}