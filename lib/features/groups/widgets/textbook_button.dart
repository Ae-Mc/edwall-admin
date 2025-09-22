import 'package:edwall_admin/features/groups/widgets/labeled_button.dart';
import 'package:flutter/material.dart';

class TextbookButton extends StatelessWidget {
  const TextbookButton({super.key});

  @override
  Widget build(BuildContext context) {
    return LabeledButton(label: 'Учебник', icon: Icons.import_contacts_rounded);
  }
}
