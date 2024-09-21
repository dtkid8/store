import 'package:intl/intl.dart';

extension IntExtension on int {
  String format() {
    NumberFormat format =
        NumberFormat.currency(locale: "id", symbol: "", decimalDigits: 0);
    return format.format(this);
  }
}

extension DoubleExtension on double {
  String format() {
    NumberFormat format =
        NumberFormat.currency(locale: "id", symbol: "", decimalDigits: 0);
    return format.format(this);
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${substring(0, 1).toUpperCase()}${substring(1).toLowerCase()}";
  }

  String capitalizeEachWord() {
    return split(" ").isNotEmpty
        ? split(" ").map((e) => e.capitalize()).toList().join(" ")
        : capitalize();
  }
}
