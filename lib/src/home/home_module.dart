import 'package:payment_tracker/src/shared/date_utils.dart';

String getMonth() {
  DateTime now = DateTime.now();
  return getMonthNameFromInt(now.month);
}
