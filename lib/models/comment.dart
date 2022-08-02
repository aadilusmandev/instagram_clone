import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String comment_text;
  final String uid;
  final String username;
  final String commentId;
  final datePublished;
  final String profImage;
  final likes;
  final postId;

  const Comment({
    required this.comment_text,
    required this.uid,
    required this.username,
    required this.commentId,
    required this.datePublished,
    required this.profImage,
    required this.likes,
    required this.postId,
  });

  Map<String, dynamic> toJson() => {
        "comment_text": comment_text,
        "uid": uid,
        "username": username,
        "commentId": commentId,
        "datePublished": datePublished,
        "profImage": profImage,
        "likes": likes,
        "postId": postId,
      };

  static Comment fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Comment(
      comment_text: snapshot['comment_text'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      commentId: snapshot['commentId'],
      datePublished: snapshot['datePublished'],
      profImage: snapshot['profImage'],
      likes: snapshot['likes'],
      postId: snapshot['postId'],
    );
  }
}
