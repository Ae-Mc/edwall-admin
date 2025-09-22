import 'package:edwall_admin/features/groups/widgets/labeled_button.dart';
import 'package:flutter/material.dart';

class InfoButton extends StatelessWidget {
  const InfoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return LabeledButton(label: 'Справка', icon: Icons.info_outline);
  }
}
