import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  final String uid;

  const UserProfileScreen({super.key, required this.uid});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ref
          .watch(getUserDataProvider(widget.uid))
          .when(
            data: (user) => NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 250,
                    floating: true,
                    snap: true,
                    flexibleSpace: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(user.banner, fit: BoxFit.cover),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            alignment: Alignment.bottomLeft,
                            padding: const EdgeInsets.all(
                              20,
                            ).copyWith(bottom: 70),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(user.profilePic),
                              radius: 45,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.all(20),
                          child: OutlinedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                              ),
                            ),
                            child: const Text("Edit Profile"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'u/${user.name}',
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text("${user.karma} karma"),
                        ),
                        const SizedBox(height: 10),
                        const Divider(thickness: 2),
                      ]),
                    ),
                  ),
                ];
              },
              body: const Text("Displaying posts"),
            ),
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
