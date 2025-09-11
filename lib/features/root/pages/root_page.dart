import 'package:auto_route/auto_route.dart';
import 'package:edwall_admin/app/router/app_router.dart';
import 'package:edwall_admin/core/infrastructure/api_client.dart';
import 'package:edwall_admin/core/providers/settings.dart';
import 'package:edwall_admin/features/auth/domain/auth_repository.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class RootPage extends ConsumerWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(settingsProvider);

    return AutoTabsRouter.builder(
      routes: const [
        ProgrammesRoute(),
        RoutesRoute(),
        SandboxRoute(),
        SandboxRoute(),
        SandboxRoute(),
      ],
      builder: (context, children, router) => Scaffold(
        body: IndexedStack(index: router.activeIndex, children: children),
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
                        final ftoast = FToast()..init(context);
                        ftoast.showToast(
                          child: const Text(
                            'Перезапустите приложение для обновления данных с сервера\nНе забудьте отключится от скалодрома!',
                            textAlign: TextAlign.center,
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
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(
            context,
          ).colorScheme.primary.withAlpha(128),
          currentIndex: router.activeIndex,
          onTap: (value) => router.setActiveIndex(value),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_rounded),
              label: "Программы",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_rounded),
              label: "Задания",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.construction_rounded),
              label: "Уроки",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.construction_rounded),
              label: "Учебные планы",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.construction_rounded),
              label: "Скалодром",
            ),
          ],
        ),
      ),
    );
  }
}
