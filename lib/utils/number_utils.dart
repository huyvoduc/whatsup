class NumberUtils {
  ///
  /// convert int number to K,M,B if the value is over
  ///
  static String handleNumber(String number) {
    final numberVal = int.parse(number);
    if (numberVal > 9999999999) {
      return '${number.substring(0, number.length - 9)}B';
    } else if (numberVal > 999999 && numberVal < 1000000000) {
      return '${number.substring(0, number.length - 6)}M';
    } else if (numberVal > 999 && numberVal < 1000000) {
      return '${number.substring(0, number.length - 3)}K';
    } else if (numberVal < 999) {
      return numberVal.toString();
    }
  }
}
