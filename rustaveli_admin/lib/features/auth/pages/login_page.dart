import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:edwall_admin/app/router/app_router.dart';
import 'package:edwall_admin/features/auth/domain/auth_repository.dart';
import 'package:edwall_admin/features/auth/widgets/logo_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usernameController = useTextEditingController();
    final passwordController = useTextEditingController();
    var obscurePassword = useState(true);

    final pendingAuthorization = useState<Future<void>?>(null);
    final snapshot = useFuture(pendingAuthorization.value);
    String? errorMessage = snapshot.error?.toString();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const Pad(all: 16),
                child: Center(
                  child: Column(
                    children: [
                      LogoText(),
                      FractionallySizedBox(
                        widthFactor: 1 / 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Войти',
                              style: Theme.of(context).textTheme.titleMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Ввведите почту или логин',
                              style: Theme.of(context).textTheme.titleSmall,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: usernameController,
                              decoration: const InputDecoration(
                                hintText: 'Email или логин',
                              ),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: passwordController,
                              obscureText: obscurePassword.value,
                              decoration: InputDecoration(
                                hintText: 'Пароль',
                                suffixIcon: IconButton(
                                  onPressed: () => obscurePassword.value =
                                      !obscurePassword.value,
                                  icon: Icon(
                                    obscurePassword.value
                                        ? Icons.lock_outlined
                                        : Icons.lock_open_outlined,
                                  ),
                                ),
                              ),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            if (errorMessage != null && errorMessage.isNotEmpty)
                              Padding(
                                padding: Pad(top: 4),
                                child: Text(
                                  errorMessage,
                                  style: Theme.of(context).textTheme.labelMedium
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.error,
                                      ),
                                  maxLines: 2,
                                ),
                              ),
                            OutlinedButton(
                              onPressed: switch (snapshot.connectionState) {
                                ConnectionState.waiting => () {},
                                _ => () {
                                  final future = ref
                                      .read(authRepositoryProvider.notifier)
                                      .authenticate(
                                        usernameController.text.trim(),
                                        passwordController.text,
                                      );
                                  pendingAuthorization.value = future;
                                },
                              },
                              child: switch (snapshot.connectionState) {
                                ConnectionState.waiting =>
                                  const SizedBox.square(
                                    dimension: 24,
                                    child: CircularProgressIndicator.adaptive(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                _ => const Text("ПРОДОЛЖИТЬ"),
                              },
                            ),
                            SizedBox(height: 64),
                            Text(
                              'Нет аккаунта?',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            OutlinedButton(
                              onPressed: () =>
                                  context.pushRoute(RegisterRoute()),
                              child: Text('РЕГИСТРАЦИЯ'),
                            ),
                          ],
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
}
