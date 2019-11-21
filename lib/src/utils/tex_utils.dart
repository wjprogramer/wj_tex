class TexUtils {

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
}