import 'package:flutter/material.dart';
import 'customer_navbar.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FCFB),
      appBar: AppBar(
        title: const Text('Book Stay'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Guest Information
          _SectionCard(
            title: 'Guest Information',
            children: [
              _Field(label: 'Full Name *', hint: 'Enter guest name', icon: Icons.person_outline),
              _Field(label: 'Age *', hint: 'Enter age', icon: Icons.cake_outlined),
            ],
          ),
          const SizedBox(height: 16),
          // Booking Details
          _SectionCard(
            title: 'Booking Details',
            children: [
              Row(
                children: [
                  Expanded(child: _Field(label: 'Check-in Date *', hint: 'dd/mm/yyyy', icon: Icons.calendar_today)),
                  const SizedBox(width: 8),
                  Expanded(child: _Field(label: 'Check-out Date *', hint: 'dd/mm/yyyy', icon: Icons.calendar_today)),
                ],
              ),
              _Field(label: 'Room Type *', hint: 'Select room type', icon: Icons.meeting_room_outlined),
            ],
          ),
          const SizedBox(height: 16),
          // Emergency Contact
          _SectionCard(
            title: 'Emergency Contact',
            children: [
              _Field(label: 'Contact Name', hint: 'Enter contact name', icon: Icons.person_outline),
              _Field(label: 'Contact Phone', hint: 'Enter phone number', icon: Icons.phone_outlined),
              _Field(label: 'Relationship', hint: 'e.g., Son, Daughter, Spouse', icon: Icons.group_outlined),
            ],
          ),
          const SizedBox(height: 16),
          // Additional Information
          _SectionCard(
            title: 'Additional Information',
            children: [
              _Field(label: 'Medical Information', hint: 'Any medical conditions, medications, or allergies...', icon: Icons.medical_services_outlined, maxLines: 2),
              _Field(label: 'Special Requirements', hint: 'Dietary restrictions, mobility assistance, etc...', icon: Icons.info_outline, maxLines: 2),
            ],
          ),
          const SizedBox(height: 24),
          // Book Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2CB5A8),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Book Now', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomerNavBar(
        currentIndex: 0,
        onTap: (index) {},
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SectionCard({required this.title, required this.children});
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final int maxLines;
  const _Field({required this.label, required this.hint, required this.icon, this.maxLines = 1});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          filled: true,
          fillColor: Colors.white,
        ),
        maxLines: maxLines,
      ),
    );
  }
}
