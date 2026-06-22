class Staff {
  final String id;
  final String name;
  final String role; // nurse, doctor, caregiver, admin
  final String phone;
  final String email;
  final String shift; // morning, evening, night
  final bool active;

  Staff({
    required this.id,
    required this.name,
    required this.role,
    required this.phone,
    required this.email,
    required this.shift,
    this.active = true,
  });

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      shift: json['shift'] ?? '',
      active: json['active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'phone': phone,
      'email': email,
      'shift': shift,
      'active': active,
    };
  }
}
