import 'package:intl/intl.dart';

final wonFormat = NumberFormat("#,###", "ko_KR");

String calcStringToWon(String priceString) {
  if (priceString == "무료나눔") {
    return priceString;
  }

  return "${wonFormat.format(int.parse(priceString))}원";
}

enum LocationType {
  ara("ara", "아라동"),
  ora("ora", "오라동"),
  donam("donam", "도남동"),
  undefined("undefined", "undefined");

  final String code;
  final String displayName;

  const LocationType(this.code, this.displayName);

  factory LocationType.getByCode(String code) {
    return LocationType.values.firstWhere((element) => element.code == code,
        orElse: () => LocationType.undefined);
  }
}
