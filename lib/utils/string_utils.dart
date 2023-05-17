
class StringUtils {

  // static bool isAlpha(String input) => RegExp(r'^[a-zA-Z]+$').hasMatch(input);

  static bool isAlphas(String input) => RegExp(r'[a-zA-Z]').hasMatch(input);

  // static bool isAlphanumeric(String input) => RegExp(r'^[a-zA-Z0-9]+$').hasMatch(input);
  //
  // static bool nonContainNumber(String input) => RegExp(r'^\D+$').hasMatch(input);
  //
  // static String reverse(String s) => String.fromCharCodes(s.runes.toList().reversed);
  //
  // static int countChars(String s, String char, {bool caseSensitive = true}) {
  //   int count = 0;
  //   s.codeUnits.toList().forEach((i) {
  //     if (caseSensitive) {
  //       if (i == char.runes.first) {
  //         count++;
  //       }
  //     } else {
  //       if (i == char.toLowerCase().runes.first ||
  //           i == char.toUpperCase().runes.first) {
  //         count++;
  //       }
  //     }
  //   });
  //   return count;
  // }

// --- string.function 既有的
// 1. bool startsWith(Pattern pattern, [int index = 0]);
//    string.startsWith('D');
//    string.startsWith(RegExp(r'[A-Z][a-z]'));
//    string.startsWith(RegExp(r'art'), int startIndex);
}