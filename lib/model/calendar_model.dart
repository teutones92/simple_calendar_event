class CalendarModel {
  final int id;
  final String name;
  final String accountName;
  final String ownerName;
  final String displayName;

  CalendarModel({
    required this.id,
    required this.name,
    required this.accountName,
    required this.ownerName,
    required this.displayName,
  });

  factory CalendarModel.fromJson(Map json) {
    return CalendarModel(
      id: json.cast<String, dynamic>()['id'],
      name: json.cast<String, dynamic>()['name'],
      accountName: json.cast<String, dynamic>()['accountName'],
      ownerName: json.cast<String, dynamic>()['ownerName'],
      displayName: json.cast<String, dynamic>()['displayName'],
    );
  }
}
