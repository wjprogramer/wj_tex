import 'package:flutter/material.dart';
import 'package:wj_tex/src/utils/string_utils.dart';
import 'package:wj_tex/src/utils/tex_utils.dart';


/// -----------------------------------------------------
/// VARIABLES

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

  TexText(this.input) {
    print('TexText: $input');
  }

  @override
  Widget build(BuildContext context) {
    return Text(input);
  }
}

/// WIDGET

class TexFrac extends StatelessWidget implements Tex {

  // 分子
  final Widget numerator;

  // 分母
  final Widget denominator;

  TexFrac(this.numerator, this.denominator) {
    print('TexFrac: $numerator / $denominator');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        numerator,
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.black,
                width: 1,
              ),
            ),
          ),
          child: denominator,
        ),
      ],
    );
  }
}

/// WIDGET

class TexView extends StatefulWidget implements Tex {
  final String input;

  TexView(this.input) {
    print('TexView: $input');
  }

  @override
  _TexViewState createState() => _TexViewState();
}

class _TexViewState extends State<TexView> implements Parser {
  List<Tex> children = List();

  _TexViewState() {
    if (widget.input.isNotEmpty) {
      children = parser();
    }
  }

  @override
  void initState() {
    // 需初始化
    super.initState();
  }

  @override
  List<Tex> parser() {
    List<Tex> result = List();
    String text = '';

    for (int i = 0; i < widget.input.length; i++) {
      switch(widget.input[i]) {
        case '{': {
          if (StringUtils.isNotNullOrEmpty(text)) {
            children.add(TexText(text));
            text = '';
          }

          // 大括弧內的內容長度
          int contentSize = TexUtils.getCorrespondParenthesesContentSize(widget.input.substring(i, widget.input.length));
          i += contentSize + 1; // 1代表後大括弧
          children.add(TexView(widget.input.substring(i+1, i+contentSize+1)));
        } break;
        case '\\': {
          String key = getKeyword(i);

          if (specialCharMap.containsKey(key) || key.length == 1) {
            text += specialCharMap[key] ?? key;
            i += key.length;
          } else {
            if (StringUtils.isNotNullOrEmpty(text)) {
              children.add(TexText(text));
              text = '';
            }

            switch(key) {
              case 'frac': {
                int numeratorLength = TexUtils.getCorrespondParenthesesContentSize(widget.input.substring(i+key.length+1, widget.input.length));

                int denominatorStartIndex = i + key.length + numeratorLength + 2 + 1;
                int denominatorLength = TexUtils.getCorrespondParenthesesContentSize(widget.input.substring(denominatorStartIndex, widget.input.length));

                String numerator = widget.input.substring(i+key.length+2, i+key.length+numeratorLength+1);
                String denominator = widget.input.substring(denominatorStartIndex+1, denominatorStartIndex+denominatorLength+1);
                result.add(TexFrac(TexView(numerator), TexView(denominator)));

                // 2代表一組大括弧
                i += key.length + numeratorLength + 2;
                i += denominatorLength + 2;
              } break;
            }
            // TODO: i += len
          }
        } break;
        default: {
          text += widget.input[i];
          if (i == widget.input.length - 1) {
            children.add(TexText(text));
          }
        } break;
      }
    }
    return result;
  }

  // startIndex為反斜線的index
  String getKeyword(int startIndex) {
    String key = '';

    for (int i = startIndex + 1; i < widget.input.length; i++) {
      if (StringUtils.isAlpha(widget.input[i])) {
        key += widget.input[i];
      } else {
        break;
      }
    }
    return key;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        Row(
          children: children,
        ),
      ],
    );
  }

// build => wrap > row > itemBuilder > children
}