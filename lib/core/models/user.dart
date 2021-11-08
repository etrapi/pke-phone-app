/*class User {
  final String name;
  final String surname;
  int keyId;
  bool demoMode;

  User({this.name, this.surname, this.keyId, this.demoMode});

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        surname = json['surname'],
        keyId = json['keyId'],
        demoMode = json['demoMode'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['keyId' ]= this.keyId;
    return data;
  }
}*/