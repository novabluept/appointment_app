
class Validators{

  /// Checks if a given string has a minimum and maximum number of characters and only allows specific characters.
  ///
  /// This function checks whether the provided string matches a regular expression pattern that enforces the following conditions:
  /// - The string must have a minimum length of 3 characters.
  /// - The string must have a maximum length of 15 characters.
  /// - The string must consist of only letters from A to z, including diacritics like À-ú (case insensitive).
  ///
  /// Parameters:
  /// - `value`: The string to be checked.
  ///
  /// Returns:
  /// - `true` if the string matches the criteria, otherwise `false`.
  static bool hasMinimumAndMaxCharacters(String value){
    final regex = RegExp(r"^[A-zÀ-ú]{3,15}$", caseSensitive: false);
    return regex.hasMatch(value);
  }

  /// Checks if a given string is a valid email address.
  ///
  /// This function uses a regular expression pattern to validate whether the provided string matches the format of a valid email address.
  ///
  /// Parameters:
  /// - `value`: The string to be checked.
  ///
  /// Returns:
  /// - `true` if the string is a valid email address, otherwise `false`.
  static bool isEmailValid(String value){
    final regex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$");
    return regex.hasMatch(value);
  }

  /// Checks if a given string is a valid phone number.
  ///
  /// This function uses a regular expression pattern to validate whether the provided string matches the format of a valid phone number.
  ///
  /// Parameters:
  /// - `value`: The string to be checked.
  ///
  /// Returns:
  /// - `true` if the string is a valid phone number, otherwise `false`.
  static bool isPhoneValid(String value){
    final regex = RegExp(r"^9[1236][0-9]{7}$");
    return regex.hasMatch(value);
  }

  /// Checks if a given string is a valid password.
  ///
  /// This function uses a regular expression pattern to validate whether the provided string meets the minimum length requirement for a valid password.
  ///
  /// Parameters:
  /// - `value`: The string to be checked.
  ///
  /// Returns:
  /// - `true` if the string is a valid password, otherwise `false`.
  static bool isPasswordValid(String value){
    final regex = RegExp(r"^.{6,}$");
    return regex.hasMatch(value);
  }
}