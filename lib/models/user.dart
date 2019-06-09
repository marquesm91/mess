class User {
  String userId;
  String displayName;
  String photoUrl;

  User({this.displayName, this.userId, this.photoUrl});

  User.fromMap(Map<String, dynamic> mapData)
      : userId = mapData["userId"],
        displayName = mapData["displayName"],
        photoUrl = mapData["photoUrl"];

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map['userId'] = userId;
    map['displayName'] = displayName;
    map['photoUrl'] = photoUrl;

    return map;
  }
}
