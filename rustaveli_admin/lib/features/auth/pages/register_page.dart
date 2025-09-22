import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:edwall_admin/core/infrastructure/custom_toast.dart';
import 'package:edwall_admin/core/widgets/future_outlined_button.dart';
import 'package:edwall_admin/features/auth/domain/auth_repository.dart';
import 'package:edwall_admin/features/auth/widgets/logo_text.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class RegisterPage extends HookConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final usernameController = useTextEditingController();
    final phoneController = useTextEditingController();
    final passwordController = useTextEditingController();
    var obscurePassword = useState(true);

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
                              'Регистрация',
                              style: Theme.of(context).textTheme.titleMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                hintText: 'Email',
                              ),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: usernameController,
                              decoration: const InputDecoration(
                                hintText: 'Логин',
                              ),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: phoneController,
                              decoration: const InputDecoration(
                                hintText: 'Телефон',
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
                            SizedBox(
                              height: 24,
                              child: Padding(
                                padding: Pad(top: 4),
                                child: Text(
                                  '',
                                  style: Theme.of(context).textTheme.labelMedium
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.error,
                                      ),
                                ),
                              ),
                            ),
                            FutureOutlinedButton(
                              onPressed: () async {
                                final emailTester = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$",
                                );
                                if (!emailTester.hasMatch(
                                  emailController.text,
                                )) {
                                  CustomToast(context).showTextFailureToast(
                                    'Проверьте формат почты!',
                                  );
                                  return;
                                }
                                final notifier = ref.read(
                                  authRepositoryProvider.notifier,
                                );
                                await notifier.register(
                                  UserCreate(
                                    email: emailController.text.trim(),
                                    username: usernameController.text.trim(),
                                    phone: phoneController.text.trim().isEmpty
                                        ? null
                                        : phoneController.text.trim(),
                                    password: passwordController.text,
                                  ),
                                );
                                await notifier.authenticate(
                                  usernameController.text,
                                  passwordController.text,
                                );
                              },
                              child: Text(
                                "ПРОДОЛЖИТЬ",
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Box.gap(16),
                            Text(
                              'При регистрации вы принимаете публичную оферту и правила обработки персональных данных',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleSmall,
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
