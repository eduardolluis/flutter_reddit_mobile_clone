import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constants/firebase_constants.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/providers/firebase_providers.dart';
import 'package:reddit_clone/core/type_defs.dart';
import 'package:reddit_clone/models/user_model.dart';

final userProfileRepositoryProvider = Provider(
  (ref) => UserProfileRepository(firestore: ref.watch(firestoreProvider)),
);

class UserProfileRepository {
  final FirebaseFirestore _firestore;

  UserProfileRepository({required FirebaseFirestore firestore})
    : _firestore = firestore;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  FutureVoid editProfile(UserModel user) async {
    try {
      await _users.doc(user.uid).set(user.toMap(), SetOptions(merge: true));
      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure(message: e.message ?? 'Firestore error'));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}
