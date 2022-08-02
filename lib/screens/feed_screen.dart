import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_flutter/widgets/post_card.dart';

import '../utils/colors.dart';

class FeedScreen extends StatefulWidget {
  final bool isFavorite;
  const FeedScreen({
    Key? key,
    this.isFavorite = false,
  }) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset(
          'assets/ic_instagram.svg',
          color: primaryColor,
          height: 52,
        ),
      ),
      body: StreamBuilder(
        stream: widget.isFavorite
            ? FirebaseFirestore.instance
                .collection('posts')
                .orderBy(
                  'datePublished',
                  descending: true,
                )
                .where('likes',
                    arrayContains: FirebaseAuth.instance.currentUser!.uid)
                .snapshots()
            : FirebaseFirestore.instance
                .collection('posts')
                .orderBy(
                  'datePublished',
                  descending: true,
                )
                .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          }

          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) => PostCard(
                snap: snapshot.data!.docs[index].data(),
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
