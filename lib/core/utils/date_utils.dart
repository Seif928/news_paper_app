class DateUtilsApp {
  DateUtilsApp._();

  static DateTime? parseDate(String? date) {
    if (date == null || date.isEmpty) {
      return null;
    }

    return DateTime.tryParse(date);
  }

  static String? formatDate(DateTime? date) {
    if (date == null) {
      return null;
    }

    return '${date.day.toString().padLeft(2, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.year.toString().padLeft(4, '0')}';
  }
}
