class User {
  final String name;
  final String surname;
  int keyId;

  User({this.name, this.surname, this.keyId});

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        surname = json['surname'],
        keyId = json['keyId'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['keyId' ]= this.keyId;
    return data;
  }
}