import 'package:edwall_admin/features/groups/widgets/labeled_button.dart';
import 'package:flutter/material.dart';

class BookmarkButton extends StatelessWidget {
  const BookmarkButton({super.key});

  @override
  Widget build(BuildContext context) {
    return LabeledButton(label: 'Закладки', icon: Icons.bookmark_outline);
  }
}
