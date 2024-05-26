import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

const Color KidSafeColor = Color(0xffccbfe3);
const Color KidSafeColor2 = Color(0xffb29cdc);

final _fireStore = FirebaseFirestore.instance;

final storageRef = FirebaseStorage.instance.ref();

final parentRef = _fireStore.collection("parents");

