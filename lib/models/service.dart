class CareService {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category; // medical, recreational, personal care
  final bool available;

  CareService({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.available = true,
  });

  factory CareService.fromJson(Map<String, dynamic> json) {
    return CareService(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      available: json['available'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'available': available,
    };
  }
}
