import 'package:auto_route/auto_route.dart';
import 'package:edwall_admin/core/infrastructure/api_client.dart';
import 'package:edwall_admin/core/providers/settings.dart';
import 'package:edwall_admin/features/auth/domain/auth_repository.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:toastification/toastification.dart';

@RoutePage()
class RootPage extends ConsumerWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(settingsProvider);

    return AutoRouter(
      builder: (context, child) => Scaffold(
        body: child,
        drawer: Drawer(
          child: HookConsumer(
            builder: (context, ref, child) {
              final logoutFuture = useState<Future?>(null);
              final snapshot = useFuture(logoutFuture.value);
              final user = useState<UserRead?>(null);
              defaultHandler() {
                final future = ref
                    .read(authRepositoryProvider.notifier)
                    .logout();
                logoutFuture.value = future;
                return future;
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (user.value?.isSuperuser == true)
                    ListTile(
                      leading: const Icon(Icons.sync),
                      title: const Text("Синхронизировать базу"),
                      onTap: () async {
                        Toastification().show(
                          type: ToastificationType.info,
                          style: ToastificationStyle.minimal,
                          title: const Text(
                            'Перезапустите приложение для обновления данных с сервера\nНе забудьте отключится от скалодрома!',
                          ),
                        );
                        await (await ref.read(
                          apiClientProvider.future,
                        )).apiV1SynchronizationSynchronizePost();
                      },
                    ),
                  ListTile(
                    leading: const Icon(Icons.logout_rounded),
                    title: const Text("Выход"),
                    trailing: switch (snapshot.connectionState) {
                      ConnectionState.waiting =>
                        const CircularProgressIndicator.adaptive(),
                      _ => null,
                    },
                    onTap: switch (snapshot.connectionState) {
                      ConnectionState.waiting => null,
                      _ => defaultHandler,
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
