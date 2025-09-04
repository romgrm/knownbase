import 'package:flutter/material.dart';

/// Social login button widget
class SocialLoginButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isLoading;

  const SocialLoginButton({
    super.key,
    required this.text,
    required this.icon,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text("Waiting");
    // return ActionButton(
    //   label: text,
    //   icon: icon,
    //   onPressed: onPressed ?? () {},
    //   isLoading: isLoading,
    //   height: 48,
    // );
  }
}
