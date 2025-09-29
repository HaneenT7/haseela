import 'package:cloud_firestore/cloud_firestore.dart';

class TestDataCreator {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> createTestData() async {
    try {
      print('=== CREATING TEST DATA ===');

      // Create parent document
      await _firestore.collection('Parents').doc('parent001').set({
        'firstName': 'Ahmed',
        'lastName': 'Al-Rashid',
        'email': 'ahmed@example.com',
        'phoneNumber': '+966501234567',
        'username': 'ahmed_rashid',
        'avatar': '',
      });
      print('✅ Created parent document: parent001');

      // Create child document
      await _firestore
          .collection('Parents')
          .doc('parent001')
          .collection('Children')
          .doc('child001')
          .set({
        'firstName': 'Nouf',
        'lastName': 'Al-Rashid',
        'email': 'nouf@example.com',
        'avatar': '',
        'QR': 'QR_CODE_123',
        'parent': _firestore.collection('Parents').doc('parent001'),
      });
      print('✅ Created child document: child001');

      // Create wallet document
      await _firestore
          .collection('Parents')
          .doc('parent001')
          .collection('Children')
          .doc('child001')
          .collection('Wallet')
          .doc('wallet001')
          .set({
        'totalBalance': 50.0,
        'savingsBalance': 30.0,
        'spendingsBalance': 20.0,
        'streakCount': 5,
        'lastUpdated': Timestamp.now(),
      });
      print('✅ Created wallet document: wallet001');

      // Create sample tasks
      List<Map<String, dynamic>> tasks = [
        {
          'taskName': 'Clean your room',
          'allowance': 15.0,
          'status': 'assigned',
          'priority': 'medium',
          'dueDate': Timestamp.fromDate(DateTime.now().add(Duration(days: 2))),
          'createdAt': Timestamp.now(),
          'AssignedBy': _firestore.collection('Parents').doc('parent001'),
        },
        {
          'taskName': 'Complete math homework',
          'allowance': 20.0,
          'status': 'assigned',
          'priority': 'high',
          'dueDate': Timestamp.fromDate(DateTime.now().add(Duration(days: 1))),
          'createdAt': Timestamp.now(),
          'AssignedBy': _firestore.collection('Parents').doc('parent001'),
        },
        {
          'taskName': 'Water the plants',
          'allowance': 10.0,
          'status': 'completed',
          'priority': 'low',
          'dueDate':
              Timestamp.fromDate(DateTime.now().subtract(Duration(days: 1))),
          'createdAt':
              Timestamp.fromDate(DateTime.now().subtract(Duration(days: 3))),
          'completedDate':
              Timestamp.fromDate(DateTime.now().subtract(Duration(hours: 2))),
          'AssignedBy': _firestore.collection('Parents').doc('parent001'),
        },
        {
          'taskName': 'Read for 30 minutes',
          'allowance': 12.0,
          'status': 'pending',
          'priority': 'medium',
          'dueDate': Timestamp.fromDate(DateTime.now().add(Duration(days: 3))),
          'createdAt': Timestamp.now(),
          'AssignedBy': _firestore.collection('Parents').doc('parent001'),
        },
      ];

      for (int i = 0; i < tasks.length; i++) {
        await _firestore
            .collection('Parents')
            .doc('parent001')
            .collection('Children')
            .doc('child001')
            .collection('Tasks')
            .add(tasks[i]);
        print('✅ Created task ${i + 1}: ${tasks[i]['taskName']}');
      }

      print('🎉 ALL TEST DATA CREATED SUCCESSFULLY!');
      print('You can now restart the app to see the tasks.');
    } catch (e) {
      print('❌ Error creating test data: $e');
    }
  }

  static Future<void> deleteTestData() async {
    try {
      print('=== DELETING TEST DATA ===');

      // Delete tasks
      QuerySnapshot tasksSnapshot = await _firestore
          .collection('Parents')
          .doc('parent001')
          .collection('Children')
          .doc('child001')
          .collection('Tasks')
          .get();

      for (QueryDocumentSnapshot doc in tasksSnapshot.docs) {
        await doc.reference.delete();
      }
      print('✅ Deleted all tasks');

      // Delete wallet
      await _firestore
          .collection('Parents')
          .doc('parent001')
          .collection('Children')
          .doc('child001')
          .collection('Wallet')
          .doc('wallet001')
          .delete();
      print('✅ Deleted wallet');

      // Delete child
      await _firestore
          .collection('Parents')
          .doc('parent001')
          .collection('Children')
          .doc('child001')
          .delete();
      print('✅ Deleted child');

      // Delete parent
      await _firestore.collection('Parents').doc('parent001').delete();
      print('✅ Deleted parent');

      print('🗑️ ALL TEST DATA DELETED!');
    } catch (e) {
      print('❌ Error deleting test data: $e');
    }
  }
}
