import 'package:auto_route/auto_route.dart';
import 'package:edwall_admin/core/providers/settings.dart';
import 'package:edwall_admin/features/bluetooth/domain/available_devices.dart';
import 'package:edwall_admin/features/bluetooth/domain/bluetooth_device.dart';
import 'package:edwall_admin/features/bluetooth/domain/flashboard_connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

@RoutePage()
class DeviceSelectPage extends HookConsumerWidget {
  final PageRouteInfo? nextRoute;
  const DeviceSelectPage({required this.nextRoute, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devicesAsyncValue = ref.watch(availableDevicesProvider);
    final settings = ref.watch(settingsProvider).requireValue;
    final devices = useState(<BluetoothDevice>{});
    final autoConnectAttempts = useRef(<String>{});
    final futureState = useState<Future<void>?>(null);
    final future = useFuture(futureState.value);
    final localNextRoute = nextRoute;

    final canConnect = [
      ConnectionState.none,
      ConnectionState.done,
    ].contains(future.connectionState);

    void connect(BluetoothDevice device) {
      if (!canConnect) return;
      futureState.value = ref
          .read(flashboardConnectionProvider.notifier)
          .connectToDevice(device);
    }

    void autoConnect({bool? enabled}) {
      if (!(enabled ?? settings.bluetoothAutoConnect) || !canConnect) return;
      for (final device in devices.value) {
        if (autoConnectAttempts.value.add(device.address)) {
          connect(device);
          break;
        }
      }
    }

    ref.listen(flashboardConnectionProvider, (previous, next) {
      if (next.value != null) {
        Logger().d("Connected");
        if (localNextRoute == null) {
          AutoRouter.of(context).maybePop();
        } else {
          AutoRouter.of(context).replace(localNextRoute);
        }
      }
    }, onError: (error, stackTrace) => Logger().e(error));

    ref.listen(availableDevicesProvider, (previous, next) {
      final discoveredDevice = next.value;
      if (discoveredDevice == null) return;
      devices.value = {...devices.value, discoveredDevice};
      autoConnect();
    });

    Widget devicesList() => RefreshIndicator.adaptive(
      onRefresh: () async {
        devices.value = {};
        autoConnectAttempts.value.clear();
        ref.invalidate(availableDevicesProvider);
      },
      child: ListView.builder(
        itemBuilder: (context, index) {
          final device = devices.value.elementAt(index);
          return ListTile(
            title: Text(device.name ?? "Нет имени"),
            subtitle: Text(device.address),
            onTap: canConnect ? () => connect(device) : null,
          );
        },
        itemCount: devices.value.length,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Доступные устройства"),
        actions: [
          const Text("Автоподключение"),
          Switch.adaptive(
            value: settings.bluetoothAutoConnect,
            onChanged: (enabled) async {
              await ref
                  .read(settingsProvider.notifier)
                  .setBluetoothAutoConnect(enabled);
              if (enabled) autoConnect(enabled: true);
            },
          ),
        ],
      ),
      floatingActionButton: localNextRoute == null
          ? null
          : OutlinedButton(
              onPressed: () => AutoRouter.of(context).replace(localNextRoute),
              child: const Text("Пропустить"),
            ),
      body: devicesAsyncValue.when(
        data: (_) => devicesList(),
        error: (error, stackTrace) => Center(
          child: Text(
            error.toString(),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
        loading: () => devices.value.isEmpty
            ? const Center(child: CircularProgressIndicator.adaptive())
            : devicesList(),
      ),
    );
  }
}
