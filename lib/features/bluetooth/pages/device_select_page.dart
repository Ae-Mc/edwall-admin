import 'package:auto_route/auto_route.dart';
import 'package:edwall_admin/features/bluetooth/domain/available_devices.dart';
import 'package:edwall_admin/features/bluetooth/domain/flashboard_connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

class DiscoveryResultWrapper {
  final String address;

  const DiscoveryResultWrapper(this.address);

  @override
  int get hashCode => address.hashCode;

  @override
  bool operator ==(Object other) {
    return other is DiscoveryResultWrapper && address == other.address;
  }
}

@RoutePage()
class DeviceSelectPage extends HookConsumerWidget {
  final PageRouteInfo? nextRoute;
  const DeviceSelectPage({required this.nextRoute, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devicesAsyncValue = ref.watch(availableDevicesProvider);
    final devices = useState(<DiscoveryResultWrapper>{});
    final futureState = useState<Future<void>?>(null);
    final future = useFuture(futureState.value);
    final localNextRoute = nextRoute;

    ref.listen(flashboardConnectionProvider, (previous, next) {
      if (next.valueOrNull != null) {
        Logger().d("Connected");
        if (localNextRoute == null) {
          AutoRouter.of(context).maybePop();
        } else {
          AutoRouter.of(context).replace(localNextRoute);
        }
      }
    }, onError: (error, stackTrace) => Logger().e(error));

    return Scaffold(
      appBar: AppBar(title: const Text("Доступные устройства")),
      floatingActionButton: localNextRoute == null
          ? null
          : OutlinedButton(
              onPressed: () => AutoRouter.of(context).replace(localNextRoute),
              child: const Text("Пропустить"),
            ),
      body: devicesAsyncValue.when(
        data: (devicesStream) => RefreshIndicator.adaptive(
          onRefresh: () async => ref.invalidate(availableDevicesProvider),
          child: StreamBuilder<String>(
            stream: devicesStream,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                devices.value = devices.value
                  ..add(DiscoveryResultWrapper(snapshot.data!));
              }

              return ListView.builder(
                itemBuilder: (context, index) {
                  if (index == devices.value.length) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  } else {
                    return ListTile(
                      title: Text(devices.value.elementAt(index).address),
                      subtitle: Text(devices.value.elementAt(index).address),
                      onTap:
                          [
                            ConnectionState.none,
                            ConnectionState.done,
                          ].contains(future.connectionState)
                          ? () => futureState.value = ref
                                .read(flashboardConnectionProvider.notifier)
                                .connectToDevice(
                                  devices.value.elementAt(index).address,
                                )
                          : null,
                    );
                  }
                },
                itemCount:
                    devices.value.length +
                    (snapshot.connectionState == ConnectionState.done ? 0 : 1),
              );
            },
          ),
        ),
        error: (error, stackTrace) => SingleChildScrollView(
          child: Center(
            child: Text(
              error.toString(),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
      ),
    );
  }
}
