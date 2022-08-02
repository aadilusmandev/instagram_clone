import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_flutter/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

import '../models/comment.dart';
import '../models/post.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload post
  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = "some error occurred";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );

      await _firestore.collection('posts').doc(postId).set(
            post.toJson(),
          );

      res = "success";
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  //upload Comment
  Future<String> uploadComment(
    String comment_text,
    String uid,
    String username,
    String profImage,
    String postId,
  ) async {
    String res = "some error occurred";
    try {
      String commentId = const Uuid().v1();
      Comment comment = Comment(
        comment_text: comment_text,
        uid: uid,
        username: username,
        commentId: commentId,
        datePublished: DateTime.now(),
        profImage: profImage,
        likes: [],
        postId: postId,
      );

      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .set(
            comment.toJson(),
          );
      res = "success";
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  //LIKE and UNLIKE post
  Future<void> likePost(
    String postId,
    String uid,
    List likes, {
    bool isComment = false,
    String commentId = '',
  }) async {
    try {
      DocumentReference<Map<String, dynamic>> like_locate =
          _firestore.collection('posts').doc(postId);

      if (isComment) {
        like_locate = like_locate.collection('comments').doc(commentId);
      }

      if (likes.contains(uid)) {
        await like_locate.update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await like_locate.update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {}
  }

  //delete post
  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {}
  }

  //follow or unfollow users
  Future<void> followUser(
    String uid,
    String followid,
  ) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['followings'];

      if (following.contains(followid)) {
        //remove followid(as "followings" for current user) from current user
        await _firestore.collection('users').doc(uid).update({
          'followings': FieldValue.arrayRemove([followid])
        });

        //remove uid(as "followers" for followid user) from followid user
        await _firestore.collection('users').doc(followid).update({
          'followers': FieldValue.arrayRemove([uid])
        });
      } else {
        //add followid(as "followings" for current user) to current user
        await _firestore.collection('users').doc(uid).update({
          'followings': FieldValue.arrayUnion([followid])
        });

        //add uid(as "followers" for followid user) to followid user
        await _firestore.collection('users').doc(followid).update({
          'followers': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {}
  }
}
