import 'package:flutter/material.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/users.dart';
import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import 'like_animation.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool isLikeAnimating = false;
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return GestureDetector(
      onDoubleTap: () async {
        await FirestoreMethods().likePost(
          widget.snap['postId'],
          user.uid,
          widget.snap['likes'],
          isComment: true,
          commentId: widget.snap['commentId'],
        );
        setState(() {
          isLikeAnimating = true;
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 18,
              horizontal: 16,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    widget.snap['profImage'],
                  ),
                  radius: 18,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: widget.snap['username'],
                                style: const TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: ' ${widget.snap['comment_text']}',
                                style: const TextStyle(
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            DateFormat.yMMMd().format(
                              widget.snap['datePublished'].toDate(),
                            ),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      LikeAnimation(
                        isAnimating: widget.snap['likes'].contains(user.uid),
                        smallLike: true,
                        child: IconButton(
                          icon: widget.snap['likes'].contains(user.uid)
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : const Icon(Icons.favorite_border),
                          onPressed: () async {
                            await FirestoreMethods().likePost(
                              widget.snap['postId'],
                              user.uid,
                              widget.snap['likes'],
                              isComment: true,
                              commentId: widget.snap['commentId'],
                            );
                          },
                        ),
                      ),
                      Text(
                        '${widget.snap['likes'].length} likes',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: isLikeAnimating ? 1 : 0,
            child: LikeAnimation(
              child: const Icon(
                Icons.favorite,
                color: Colors.white,
                size: 20,
              ),
              isAnimating: isLikeAnimating,
              duration: const Duration(
                milliseconds: 400,
              ),
              onEnd: () {
                setState(() {
                  isLikeAnimating = false;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
