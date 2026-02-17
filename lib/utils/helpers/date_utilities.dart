class DateUtilities {
  static String getTimeString(DateTime dateTime) {
    return '${dateTime.hour}:${dateTime.minute}';
  }

  static String getDateString(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month}-${dateTime.day}';
  }

  static String getDateTimeString(DateTime dateTime) {
    return '${getDateString(dateTime)} ${getTimeString(dateTime)}';
  }

  /// Returns a DateTime object from a string in the format 'dd-mm-yyyy hh:mm'.
  static DateTime getDateTimeFromString(String dateTimeString) {
    final dateTimeList = dateTimeString.split(' ');

    if (dateTimeList.isEmpty || dateTimeList.length > 2) {
      throw Exception(
        'Invalid date time string. expected format is \'dd-mm-yyyy hh:mm\'',
      );
    }

    final dateString = dateTimeList[0];
    final timeString = dateTimeList.length == 2 ? dateTimeList[1] : '00:00';

    final dateList = dateString.split('-');
    final timeList = timeString.split(':');

    return DateTime(
      int.parse(dateList[2]),
      int.parse(dateList[1]),
      int.parse(dateList[0]),
      int.parse(timeList[0]),
      int.parse(timeList[1]),
    );
  }
}
