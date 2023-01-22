import 'package:intl/intl.dart';

final wonFormat = NumberFormat("#,###", "ko_KR");

String calcStringToWon(String priceString) {
  return "${wonFormat.format(int.parse(priceString))}원";
}
