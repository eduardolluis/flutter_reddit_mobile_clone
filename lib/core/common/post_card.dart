import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/posts/controller/post_controller.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/theme/pallete.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  void deletePost(WidgetRef ref, BuildContext context) async {
    ref.read(postControllerProvider.notifier).deletePost(post, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'image';
    final isTypeLink = post.type == 'link';
    final isTypeText = post.type == 'text';

    final user = ref.watch(userProvider);

    if (user == null) {
      return const AlertDialog(
        title: Text('You must be logged in to view posts.'),
      );
    }

    final theme = ref.watch(themeNotifierProvider);

    return Container(
      color: theme.drawerTheme.backgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(post.communityProfilePic),
                  radius: 16,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "r/${post.communityName}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "u/${post.username}",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                const Spacer(),
                if (post.uid == user.uid)
                  IconButton(
                    onPressed: () => deletePost(ref, context),
                    icon: Icon(Icons.delete, color: Pallete.redColor),
                  ),
              ],
            ),

            const SizedBox(height: 10),

            // Title
            Text(
              post.title,
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),

            if (isTypeImage) ...[
              const SizedBox(height: 10),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                child: Image.network(post.link ?? '', fit: BoxFit.cover),
              ),
            ],

            if (isTypeLink) ...[
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: AnyLinkPreview(
                  displayDirection: UIDirection.uiDirectionHorizontal,
                  link: post.link!,
                ),
              ),
            ],
            if (isTypeText) ...[
              Container(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    post.description!,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.comment)),
                  Text(
                    '${post.commentCount == 0 ? 'Comment' : post.commentCount}',
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
