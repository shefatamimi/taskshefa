import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_shefa/group_task/group_model/group_model.dart';

class GroupService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add Group
  Future<void> addGroup(GroupModel group) async {
    final docRef =
    await _firestore.collection('groups').add(group.toMap());

    await docRef.update({
      'id': docRef.id,
    });
  }

  // Update Group
  Future<void> updateGroup(
      String id,
      GroupModel group,
      ) async {
    await _firestore
        .collection('groups')
        .doc(id)
        .set(group.toMap(), SetOptions(merge: true));
  }

  // Delete Group
  Future<void> deleteGroup(String id) async {
    await _firestore.collection('groups').doc(id).delete();
  }

  // Get Groups
  Stream<List<GroupModel>> getGroups(String userId) {
    return _firestore
        .collection('groups')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        return GroupModel.fromJson({
          ...data,
          'id': doc.id,
        });
      }).toList();
    });
  }
}