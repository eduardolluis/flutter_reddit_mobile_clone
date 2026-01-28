import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constants/firebase_constants.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/providers/firebase_providers.dart';
import 'package:reddit_clone/core/type_defs.dart';
import 'package:reddit_clone/models/post_model.dart';

final postRepositoryProvider = Provider(
  (ref) => PostRepository(firestore: ref.watch(firestoreProvider)),
);

class PostRepository {
  final FirebaseFirestore firestore;
  PostRepository({required FirebaseFirestore firestore})
    : firestore = firestore;

  CollectionReference get _posts =>
      firestore.collection(FirebaseConstants.postsCollection);

  FutureVoid addPost(Post post) async {
    try {
      return right(_posts.doc(post.id).set(post.toMap()));
    } on FirebaseException catch (e) {
      return left(Failure(message: e.message!));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}
