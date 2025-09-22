import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:edwall_admin/app/router/app_router.dart';
import 'package:edwall_admin/core/models/settings_model.dart';
import 'package:edwall_admin/core/providers/settings.dart';
import 'package:edwall_admin/core/widgets/card_inner_inkwell.dart';
import 'package:edwall_admin/core/widgets/future_outlined_button.dart';
import 'package:edwall_admin/features/auth/domain/auth_repository.dart';
import 'package:edwall_admin/features/auth/domain/selected_login.dart';
import 'package:edwall_admin/features/auth/widgets/login_card.dart';
import 'package:edwall_admin/features/auth/widgets/logo_text.dart';
import 'package:edwall_admin/features/groups/widgets/error_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class SelectLoginPage extends HookWidget {
  const SelectLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedLogin = useState<SavedLogin?>(null);
    final loginPageShown = useState(false);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const Pad(vertical: 16),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      LogoText(),
                      SizedBox(height: 32),
                      Container(
                        alignment: Alignment.center,
                        height: 228,
                        child: Consumer(
                          builder: (context, ref, child) {
                            final settingsState = ref.watch(settingsProvider);
                            final isLoading = settingsState.isLoading;
                            if (isLoading) {
                              return CircularProgressIndicator.adaptive();
                            }
                            if (settingsState.hasError) {
                              return ErrorColumn(
                                error: settingsState.error!,
                                onRetry: () => ref.invalidate(settingsProvider),
                              );
                            }
                            final settings = settingsState.requireValue;

                            return ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: Pad(horizontal: 32),
                              shrinkWrap: true,
                              itemCount: settings.savedLogins.length + 1,
                              itemBuilder: (context, index) {
                                if (index == settings.savedLogins.length) {
                                  return SizedBox(
                                    width: 180,
                                    child: Card(
                                      child: CardInnerInkwell(
                                        onTap: () async {
                                          loginPageShown.value = true;
                                          await context.pushRoute(LoginRoute());
                                          loginPageShown.value = false;
                                        },
                                        child: Icon(
                                          Icons.add_circle_outline_rounded,
                                          size: 64,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return LoginCard(
                                  login: settings.savedLogins[index],
                                  isSelected:
                                      selectedLogin.value ==
                                      settings.savedLogins[index],
                                  onTap: () {
                                    if (selectedLogin.value ==
                                        settings.savedLogins[index]) {
                                      selectedLogin.value = null;
                                    } else {
                                      selectedLogin.value =
                                          settings.savedLogins[index];
                                    }
                                  },
                                );
                              },
                              separatorBuilder: (context, index) => Box.gap(8),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 32),
                      Center(
                        child: SizedBox(
                          width: 320,
                          child: Consumer(
                            builder: (context, ref, child) {
                              final authState = ref.watch(
                                authRepositoryProvider,
                              );
                              final enabled =
                                  selectedLogin.value != null &&
                                  !authState.isLoading;

                              return FutureOutlinedButton(
                                onPressed: enabled
                                    ? () => continueWithLogin(
                                        ref,
                                        selectedLogin.value!,
                                      )
                                    : null,
                                child: Text('ПРОДОЛЖИТЬ'),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> continueWithLogin(WidgetRef ref, SavedLogin login) async {
    await ref.read(selectedLoginProvider.notifier).selectLogin(login);
    ref.invalidate(authRepositoryProvider);
  }
}
