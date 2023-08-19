class GlobalConfigs {
  static const pass = "n240705!";

  static bool isEqualPass(String p) {
    if(p == pass) {
      return true;
    } else {
      return false;
    }
  }
}