import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Constants/Constants.dart';
import '../Models/parent.dart';


class DatabaseServices {

  final CollectionReference _feedCollection = FirebaseFirestore.instance.collection('feeds');
  final firestoreInstance = FirebaseFirestore.instance;


  Future<ParentModel?> fetchParentDetails(String? currentUserId) async {
    if (currentUserId != null) {
      try {
        // Replace 'parentCollection' with your actual Firestore collection name
        DocumentSnapshot parentSnapshot = await firestoreInstance.collection('parents').doc(currentUserId).get();

        if (parentSnapshot.exists) {
          // Assuming ParentModel.fromSnapshot is a factory method in ParentModel class
          return ParentModel.fromDoc(parentSnapshot);

        }
      } catch (e) {
        print('Error fetching parent details: $e');
      }
    }
    return null; // Return null if no details found or if currentUserId is null
  }



  Future<void> softDeleteUser(String? userId) async {
    try {
      // Check if the user exists in the 'parents' collection
      DocumentSnapshot parentSnapshot = await FirebaseFirestore.instance
          .collection('parents')
          .doc(userId)
          .get();

      // Check if the user exists in the 'educators' collection
      DocumentSnapshot educatorSnapshot = await FirebaseFirestore.instance
          .collection('educators')
          .doc(userId)
          .get();

      // Perform soft delete based on existence in either collection
      if (parentSnapshot.exists) {
        // User exists in the 'parents' collection, perform soft delete
        await FirebaseFirestore.instance
            .collection('parents')
            .doc(userId)
            .update({'status': 'Deactivate'});
      } else if (educatorSnapshot.exists) {
        // User exists in the 'educators' collection, perform soft delete
        await FirebaseFirestore.instance
            .collection('educators')
            .doc(userId)
            .update({'status': 'Deactivate'});
      } else {
        // Handle the case where the user is not found in either collection
        print('User not found in both parents and educators collections');
      }
    } catch (e) {
      print("Error soft delete: $e");
    }
  }

  Future<void> reactivateAccount(String? userId) async {
    try {
      // Check if the user exists in the 'parents' collection
      DocumentSnapshot parentSnapshot = await FirebaseFirestore.instance
          .collection('parents')
          .doc(userId)
          .get();

      // Check if the user exists in the 'educators' collection
      DocumentSnapshot educatorSnapshot = await FirebaseFirestore.instance
          .collection('educators')
          .doc(userId)
          .get();

      // Log user details
      print('User ID: $userId');
      print('Parent Snapshot: ${parentSnapshot.exists}');
      print('Educator Snapshot: ${educatorSnapshot.exists}');

      // Perform soft delete based on existence in either collection
      if (parentSnapshot.exists) {
        // User exists in the 'parents' collection, perform soft delete
        await FirebaseFirestore.instance
            .collection('parents')
            .doc(userId)
            .update({'status': 'Active'});

        // Log success message
        print('User status updated to Active in parents collection');
      } else if (educatorSnapshot.exists) {
        // User exists in the 'educators' collection, perform soft delete
        await FirebaseFirestore.instance
            .collection('educators')
            .doc(userId)
            .update({'status': 'Active'});

        // Log success message
        print('User status updated to Active in educators collection');
      } else {
        // Handle the case where the user is not found in either collection
        print('User not found in both parents and educators collections');
      }
    } catch (e) {
      // Log error message
      print("Error reactivate account: $e");
    }
  }

}