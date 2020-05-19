

class ValidationUtils {
  static bool isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  static bool isValidPhoneNumber(String phone) {
    try {
      final value = phone.trim();
      const phonePrefix = '091, 094, 083, 084, 085, 081, 082 088 '
          '098, 097, 096, 039, 038, 037, 036, 035, 034, 033, 032 '
          '090 – 093 – 089 – 070 – 079 – 077- 076 – 078 '
          '092, 058, 056';

      return value.length == 10
          && value.startsWith('0')
          && phonePrefix.contains(value.substring(0,2));
    } catch (e) {
      return false;
    }
  }
}