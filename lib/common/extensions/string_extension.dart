extension StringExtensions on String {
  String allWordsCapitilize() {
    return split(' ').map((word) {
      final leftText = (word.length > 1) ? word.substring(1, word.length) : '';
      return word[0].toUpperCase() + leftText;
    }).join(' ');
  }

  String allWordsCapitilizeAndtoUpperCase() {
    return toLowerCase().split(' ').map((word) {
      final leftText = (word.length > 1) ? word.substring(1, word.length) : '';
      return word[0].toUpperCase() + leftText;
    }).join(' ');
  }

  bool isNullOrEmpty() {
    return this == null || isEmpty;
  }

  String toPhoneWithCountryCode() {
    if (startsWith('+84')) {
      return this;
    } else {
      return replaceFirst('0', '+84');
    }
  }
}
