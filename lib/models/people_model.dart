class PeopleModel {
  final int id;
  final String name;
  final String gender;
  final String address;
  final String photo;

  PeopleModel({
    required this.id,
    required this.name,
    required this.gender,
    required this.address,
    required this.photo,
  });

  factory PeopleModel.fromJson(Map<String, dynamic> json) {
    return PeopleModel(
      id: json['id'] as int,
      name: json['name'] as String,
      gender: json['gender'] as String,
      address: json['address'] as String,
      photo: json['photo'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'address': address,
      'photo': photo,
    };
  }
}
