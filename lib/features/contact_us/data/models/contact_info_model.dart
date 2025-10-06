class ContactInfoModel {
  final int id;
  final String facebook;
  final String linkedin;
  final String x;
  final String instagram;
  final String address;
  final String map;
  final String email;
  final String phone1;
  final String phone2;
  final String? createdAt;
  final String? updatedAt;

  ContactInfoModel({
    required this.id,
    required this.facebook,
    required this.linkedin,
    required this.x,
    required this.instagram,
    required this.address,
    required this.map,
    required this.email,
    required this.phone1,
    required this.phone2,
    this.createdAt,
    this.updatedAt,
  });

  factory ContactInfoModel.fromJson(Map<String, dynamic> json) {
    return ContactInfoModel(
      id: json['id'] ?? 0,
      facebook: json['facebook'] ?? '',
      linkedin: json['linkedin'] ?? '',
      x: json['x'] ?? '',
      instagram: json['instegram'] ?? '', // Note: API uses 'instegram'
      address: json['address'] ?? '',
      map: json['map'] ?? '',
      email: json['email'] ?? '',
      phone1: json['phone1'] ?? '',
      phone2: json['phone2'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'facebook': facebook,
      'linkedin': linkedin,
      'x': x,
      'instegram': instagram, // Note: API uses 'instegram'
      'address': address,
      'map': map,
      'email': email,
      'phone1': phone1,
      'phone2': phone2,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
