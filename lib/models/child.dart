import 'package:cloud_firestore/cloud_firestore.dart';

class Child {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String avatar;
  final String qr;
  final DocumentReference parent;

  Child({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.avatar,
    required this.qr,
    required this.parent,
  });

  factory Child.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Handle parent field - it might be a DocumentReference or a string path
    DocumentReference parentRef;
    if (data['parent'] is DocumentReference) {
      parentRef = data['parent'] as DocumentReference;
    } else if (data['parent'] is String) {
      String path = data['parent'] as String;
      parentRef = FirebaseFirestore.instance.doc(path);
    } else {
      // Fallback to a default parent reference
      parentRef =
          FirebaseFirestore.instance.collection('Parents').doc('parent001');
    }

    return Child(
      id: doc.id,
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      email: data['email'] ?? '',
      avatar: data['avatar'] ?? '',
      qr: data['QR'] ?? '',
      parent: parentRef,
    );
  }

  String get fullName => '$firstName $lastName'.trim();
}
