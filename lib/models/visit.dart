class Visit {
  final String id;
  final String residentId;
  final String visitorId;
  final DateTime scheduledAt;
  final String? purpose;
  final String status; // scheduled, completed, cancelled
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final DateTime createdAt;

  Visit({
    required this.id,
    required this.residentId,
    required this.visitorId,
    required this.scheduledAt,
    this.purpose,
    this.status = 'scheduled',
    this.checkInTime,
    this.checkOutTime,
    required this.createdAt,
  });

  factory Visit.fromJson(Map<String, dynamic> json) {
    return Visit(
      id: json['id'] ?? '',
      residentId: json['resident_id'] ?? '',
      visitorId: json['visitor_id'] ?? '',
      scheduledAt: json['scheduled_at'] != null 
          ? DateTime.parse(json['scheduled_at'])
          : DateTime.now(),
      purpose: json['purpose'],
      status: json['status'] ?? 'scheduled',
      checkInTime: json['check_in_time'] != null 
          ? DateTime.parse(json['check_in_time']) 
          : null,
      checkOutTime: json['check_out_time'] != null 
          ? DateTime.parse(json['check_out_time']) 
          : null,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'resident_id': residentId,
      'visitor_id': visitorId,
      'scheduled_at': scheduledAt.toIso8601String(),
      'purpose': purpose,
      'status': status,
      'check_in_time': checkInTime?.toIso8601String(),
      'check_out_time': checkOutTime?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
