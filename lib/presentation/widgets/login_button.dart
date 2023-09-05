import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;

  const LoginButton({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: Colors.blue,
          //elevation: 2,
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
