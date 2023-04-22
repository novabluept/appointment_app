
class Validators{

  /*
  * Rules:
  * - ^ matches the start of the string.
  * - [A-zÀ-ú] matches the alphabet with accents
  * - .{min,max} matches any character (represented by the .) between min and max times. This is a quantifier that specifies the minimum and maximum number of characters to match.
  * - $ matches the end of the string.
  *
  * */
  static bool hasMinimumAndMaxCharacters(String value){
    final regex = RegExp(r"^[A-zÀ-ú]{3,15}$");
    return regex.hasMatch(value);
  }

  /*
  *
  * - The username (before the "@") can include letters, digits, periods, underscores, percent signs, plus signs, hyphens or apostrophes.
  * - The "@" symbol is mandatory.
  * - The domain name (after the "@") can include letters or digits.
  * - A period (".") is mandatory between the domain name and the top-level domain (TLD).
  * - The TLD can include letters only and must be at least one character long.
  *
  * */
  static bool isEmailValid(String value){
    final regex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$");
    return regex.hasMatch(value);
  }


  /*
  *
  * +351-9YY-XXXXXXX, where YY is the two-digit mobile network operator (MNO)
  *
  * Rules:
  * - ^ matches the start of the string
  * - \+351-9 matches the country code (+351) followed by the digit 9, which is the prefix for mobile phone numbers in Portugal
  * - [1236] matches one of the four MNO codes currently in use in Portugal: 1 (NOS), 2 (Vodafone), 3 (MEO), or 6 (LycaMobile)
  * - [0-9]{7} matches any seven digits between 0 and 9
  * - $ matches the end of the string.
  *
  * Example:
  * Case 1: 123456 - TRUE
  * Case 2: 123456 - FALSE
  *
  * */
  static bool isPhoneValid(String value){
    final regex = RegExp(r"^9[1236][0-9]{7}$");
    return regex.hasMatch(value);
  }

  /*
  *
  * Rules:
  * - ^ matches the start of the string
  * - .{6,} matches any character (except for newline) with a minimum length of 6
  * - $ matches the end of the string.
  *
  * Exemple:
  * Case 1: 123456 - True
  * Case 2: 123456 - False
  *
  * */
  static bool
  isPasswordValid(String value){
    final regex = RegExp(r"^.{6,}$");
    return regex.hasMatch(value);
  }




}