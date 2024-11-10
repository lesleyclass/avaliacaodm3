class Contact {
  late String id;
  final String name;
  final String phone;
  final String email;

  Contact({required this.id, required this.name, required this.phone, required this.email});

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
    } as Map<String, Object?>;
  }

  factory Contact.fromJson(Map<String, dynamic> map, String id) {
    return Contact(
      id: id,
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
    );
  }
}