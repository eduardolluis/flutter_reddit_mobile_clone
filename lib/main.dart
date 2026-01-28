import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/router.dart';
import 'package:reddit_clone/theme/pallete.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:routemaster/routemaster.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(authStateChangeProvider)
        .when(
          data: (data) {
            if (data != null) {
              final userAsyncValue = ref.watch(getUserDataProvider(data.uid));
              return userAsyncValue.when(
                data: (userModel) {
                  Future.microtask(
                    () => ref
                        .read(userProvider.notifier)
                        .update((state) => userModel),
                  );

                  return MaterialApp.router(
                    debugShowCheckedModeBanner: false,
                    title: 'Reddit',
                    theme: ref.watch(themeNotifierProvider),
                    routerDelegate: RoutemasterDelegate(
                      routesBuilder: (context) => loggedInRoute,
                    ),
                    routeInformationParser: const RoutemasterParser(),
                  );
                },
                error: (error, stackTrace) =>
                    ErrorText(error: error.toString()),
                loading: () => const Loader(),
              );
            }

            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'Reddit',
              theme: Pallete.darkModeAppTheme,
              routerDelegate: RoutemasterDelegate(
                routesBuilder: (context) => loggedOutRoute,
              ),
              routeInformationParser: const RoutemasterParser(),
            );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
