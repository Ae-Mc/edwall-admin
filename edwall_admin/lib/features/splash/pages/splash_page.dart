import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:edwall_admin/app/router/app_router.dart';
import 'package:edwall_admin/core/providers/settings.dart';
import 'package:edwall_admin/features/bluetooth/domain/flashboard_connection.dart';
import 'package:edwall_admin/features/groups/widgets/error_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

@RoutePage()
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const Pad(all: 16),
          child: Center(
            child: HookBuilder(
              builder: (context) {
                final rebuildTrigger = useState(0);
                final result = useMemoized(
                  () => () async {
                    final results = <bool>[];
                    results.addAll([
                      await Permission.bluetoothConnect.request().isDenied,
                    ]);
                    return !results.any((element) => element);
                  }(),
                  [rebuildTrigger.value],
                );
                final permissionsState = useFuture(result);
                if (permissionsState.connectionState ==
                    ConnectionState.waiting) {
                  return const CircularProgressIndicator.adaptive();
                } else {
                  if (permissionsState.data == true) {
                    return Consumer(
                      builder: (context, ref, child) {
                        final connection = ref.watch(
                          flashboardConnectionProvider,
                        );
                        final settings = ref.watch(settingsProvider);

                        final isLoading =
                            connection.isLoading || settings.isLoading;
                        if (isLoading) {
                          return const CircularProgressIndicator.adaptive();
                        }

                        if (connection.hasError || settings.hasError) {
                          final error = (connection.error ?? settings.error)!;
                          return ErrorColumn(
                            error: error,
                            onRetry: () {
                              if (connection.hasError) {
                                ref.invalidate(flashboardConnectionProvider);
                              }
                              if (settings.hasError) {
                                ref.invalidate(settingsProvider);
                              }
                            },
                          );
                        }

                        WidgetsBinding.instance.addPostFrameCallback((
                          timeStamp,
                        ) {
                          context.replaceRoute(SelectLoginRoute());
                        });
                        return CircularProgressIndicator.adaptive();
                      },
                    );
                  } else {
                    return IconButton.filled(
                      onPressed: () => rebuildTrigger.value++,
                      icon: const Icon(Icons.refresh),
                      color: Theme.of(context).colorScheme.onPrimary,
                    );
                  }
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
