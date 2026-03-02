import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:edwall_admin/core/widgets/current_time_widget.dart';
import 'package:edwall_admin/core/widgets/outlined_back_button.dart';
import 'package:flutter/material.dart';

class DefaultAppBar extends StatelessWidget {
  final Widget title;

  const DefaultAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const Pad(left: 30, top: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OutlinedBackButton(),
          Box.gap(16),
          Expanded(
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.titleLarge ?? TextStyle(),
              child: title,
            ),
          ),
          CurrentTimeWidget(),
        ],
      ),
    );
  }
}
