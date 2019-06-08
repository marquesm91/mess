import 'package:flutter/foundation.dart';

class Mess {
  String description;
  String userId;
  String groupId;
  DateTime date;

  Mess({
    @required this.userId,
    // TODO: add creation group
    // https://github.com/marquesm91/mess/issues/13
    this.groupId = 'sDl80JSWOq40CdFE0kIy',
    this.description = '',
  }) : date = DateTime.now();

  Mess.fromMap(Map<String, dynamic> mapData)
      : description = mapData["description"],
        userId = mapData["userId"],
        groupId = mapData["groupId"],
        date =
            DateTime.fromMillisecondsSinceEpoch(mapData['date'].seconds * 1000);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map['description'] = description;
    map['userId'] = userId;
    map['groupId'] = groupId;
    map['date'] = date;

    return map;
  }
}
