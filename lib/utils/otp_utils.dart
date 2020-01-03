import 'dart:math';

class OtpUtil {
  getRandomOtp() {
    int min = 100000; //min and max values act as your 6 digit range
    int max = 999999;
    var randomizer = new Random();
    var rNum = min + randomizer.nextInt(max - min);
    return rNum.toString();
  }
}
