import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:edwall_admin/app/theme/models/theme_model.dart';
import 'package:edwall_admin/core/models/settings_model.dart';
import 'package:edwall_admin/core/providers/settings.dart';
import 'package:edwall_admin/core/widgets/card_inner_inkwell.dart';
import 'package:edwall_admin/core/widgets/future_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginCard extends StatelessWidget {
  final SavedLogin login;
  final bool isSelected;
  final void Function() onTap;

  const LoginCard({
    super.key,
    required this.login,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 180,
      height: 228,
      child: Card(
        color: isSelected ? theme.colorScheme.primary : null,
        child: CardInnerInkwell(
          onTap: onTap,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Container(
                            alignment: Alignment.center,
                            margin: Pad(top: 12, horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10000),
                              color: theme
                                  .extension<ThemeModel>()
                                  ?.loginIconBackground,
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: OverflowBox(
                              maxWidth: double.infinity,
                              maxHeight: double.infinity,
                              child: Icon(
                                Icons.account_circle_outlined,
                                size: constraints.biggest.shortestSide * 1.15,
                                color: theme.extension<ThemeModel>()?.loginIcon,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Box.gap(8),
                  Padding(
                    padding: const Pad(horizontal: 8),
                    child: Text(
                      login.username,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.tertiary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Box.gap(8),
                ],
              ),
              if (isSelected)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Consumer(
                    builder: (context, ref, child) {
                      return FutureIconButton(
                        onPressed: () => ref
                            .read(settingsProvider.notifier)
                            .removeSavedLogin(login),
                        icon: Icon(
                          Icons.delete_forever_outlined,
                          color: theme.colorScheme.onPrimary,
                        ),
                        indicatorColor: theme.colorScheme.onPrimary,
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
