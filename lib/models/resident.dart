class Resident {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String? bloodGroup;
  final String roomNumber;
  final String medicalConditions;
  final String? allergies;
  final String emergencyContact;
  final String emergencyPhone;
  final String admissionDate;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Resident({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    this.bloodGroup,
    required this.roomNumber,
    required this.medicalConditions,
    this.allergies,
    required this.emergencyContact,
    required this.emergencyPhone,
    required this.admissionDate,
    this.status = 'active',
    required this.createdAt,
    required this.updatedAt,
  });

  factory Resident.fromJson(Map<String, dynamic> json) {
    return Resident(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      bloodGroup: json['blood_group'],
      roomNumber: json['room_number'] ?? '',
      medicalConditions: json['medical_conditions'] ?? '',
      allergies: json['allergies'],
      emergencyContact: json['emergency_contact'] ?? '',
      emergencyPhone: json['emergency_phone'] ?? '',
      admissionDate: json['admission_date'] ?? '',
      status: json['status'] ?? 'active',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'blood_group': bloodGroup,
      'room_number': roomNumber,
      'medical_conditions': medicalConditions,
      'allergies': allergies,
      'emergency_contact': emergencyContact,
      'emergency_phone': emergencyPhone,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
