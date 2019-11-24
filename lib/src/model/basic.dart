import 'package:flutter/material.dart';
import 'package:wj_tex/src/utils/string_utils.dart';
import 'package:wj_tex/src/utils/tex_utils.dart';


/// -----------------------------------------------------
/// VARIABLES

TextStyle texTexStyle = TextStyle(
  fontSize: 10,
  fontFamily: 'CMU Serif Extra',
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

  TexText(this.input) {
    print('TexText: $input');
  }

  @override
  Widget build(BuildContext context) {
    return Text(input, style: texTexStyle,);
  }
}

/// WIDGET

class TexFrac extends StatelessWidget implements Tex {
  // 分子
  final Widget numerator;

  // 分母
  final Widget denominator;

  TexFrac(this.numerator, this.denominator);

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: new Column(
//        mainAxisSize: MainAxisSize.min,
//        crossAxisAlignment: CrossAxisAlignment.stretch,
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
            child: numerator,
          ),
          new Container(
            child: denominator,
          ),
        ],
      ),
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
  _TexViewState createState() => _TexViewState(input);
}

class _TexViewState extends State<TexView> implements Parser {
  List<Tex> children = List();

  String input;

  _TexViewState(this.input);

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
          if (StringUtils.isNotNullOrEmpty(text)) {
            children.add(TexText(text));
            text = '';
          }

          // 大括弧內的內容長度
          int contentSize = TexUtils.getCorrespondParenthesesContentSize(input.substring(i, input.length));
          i += contentSize + 1; // 1代表後大括弧
          children.add(TexView(input.substring(i+1, i+contentSize+1)));
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
                int numeratorLength = TexUtils.getCorrespondParenthesesContentSize(input.substring(i+key.length+1, input.length));

                int denominatorStartIndex = i + key.length + numeratorLength + 2 + 1;
                int denominatorLength = TexUtils.getCorrespondParenthesesContentSize(input.substring(denominatorStartIndex, input.length));

                String numerator = input.substring(i+key.length+2, i+key.length+numeratorLength+2);
                String denominator = input.substring(denominatorStartIndex+1, denominatorStartIndex+denominatorLength+1);
                children.add(TexFrac(TexView(numerator), TexView(denominator)));

                // 2代表一組大括弧
                i += key.length + numeratorLength + 2;
                i += denominatorLength + 2;
              } break;
            }
          }
        } break;
        default: {
          text += input[i];
          if (i == input.length - 1) {
            children.add(TexText(text));
          }
        } break;
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
    return Wrap(
      children: <Widget>[
        Row(
          children: children,
        ),
      ],
    );
  }
}