import 'package:edwall_admin/core/const.dart';
import 'package:flutter/material.dart';

class LogoText extends StatelessWidget {
  const LogoText({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 172,
      width: double.infinity,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: appConfig.logoText,
                style: const TextStyle(
                  fontSize: 96,
                  fontFamily: "Oi",
                  height: 0.8,
                ),
              ),
              const TextSpan(
                text: "\nШКОЛЬНЫЙ СКАЛОДРОМ",
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
      ),
    );
  }
}
