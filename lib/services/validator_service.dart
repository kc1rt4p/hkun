class ValidatorService {
  static bool isAddress(String address) {
    RegExp basic = new RegExp(
      r"^(0x)?[0-9a-f]{40}",
      caseSensitive: false,
      multiLine: false,
    );

    RegExp smallCaps = new RegExp(
      r"^(0x)?[0-9a-f]{40}",
      caseSensitive: false,
      multiLine: false,
    );

    RegExp allCaps = new RegExp(
      r"^(0x)?[0-9A-F]{40}",
      caseSensitive: false,
      multiLine: false,
    );
    // function isAddress(address) {
    if (!basic.hasMatch(address)) {
      // check if it has the basic requirements of an address
      return false;
    } else if (smallCaps.hasMatch(address) || allCaps.hasMatch(address)) {
      // If it's all small caps or all all caps, return "true
      return true;
    } else {
      return false;
    }
  }
}
