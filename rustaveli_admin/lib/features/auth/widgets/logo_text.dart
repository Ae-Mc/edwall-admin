import 'package:flutter/material.dart';

class LogoText extends StatelessWidget {
  const LogoText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 172,
      alignment: Alignment.center,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "Rustaveli",
              style: TextStyle(fontSize: 96, fontFamily: "Oi", height: 0.8),
            ),
            TextSpan(
              text: "\nУчебный скалодром",
              style: TextStyle(
                fontSize: 36,
                fontFamily: "Alumni Sans",
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        style: TextStyle(color: Theme.of(context).primaryColor),
        textAlign: TextAlign.center,
      ),
    );
  }
}
