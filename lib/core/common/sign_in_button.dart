import 'package:flutter/material.dart';
import 'package:reddit_clone/core/constants/constants.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Image.asset(Constants.googlePath, width: 35),
      label: Text('Sign in with Google', style: TextStyle(color: Colors.white)),
    );
  }
}
