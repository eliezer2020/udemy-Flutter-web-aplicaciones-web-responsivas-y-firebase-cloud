String getCustomDate() {
  String _customDate;

  _customDate = DateTime.now().day.toString() +
      "/" +
      DateTime.now().month.toString() +
      "/" +
      DateTime.now().year.toString() +
      ":" +
      DateTime.now().hour.toString() +
      ":" +
      DateTime.now().minute.toString();

  return _customDate;

  // 02 / 12 / 21 : 03 : 45
}
