import 'package:auto_route/auto_route.dart';
import 'package:edwall_admin/app/router/app_router.dart';
import 'package:edwall_admin/features/bluetooth/domain/flashboard_connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BluetoothButton extends ConsumerStatefulWidget {
  const BluetoothButton({super.key});

  @override
  ConsumerState<BluetoothButton> createState() => _BluetoothButtonState();
}

class _BluetoothButtonState extends ConsumerState<BluetoothButton> {
  bool pressed = false;
  @override
  Widget build(BuildContext context) {
    final connection = ref.watch(flashboardConnectionProvider);
    return IconButton(
      onPressed: pressed
          ? null
          : (() async {
              setState(() => pressed = true);
              if (connection.valueOrNull != null) {
                await ref
                    .read(flashboardConnectionProvider.notifier)
                    .disconnect();
              } else {
                await AutoRouter.of(
                  context,
                ).push(DeviceSelectRoute(nextRoute: null));
              }
              setState(() => pressed = false);
            }),
      icon: const Icon(Icons.bluetooth_connected_rounded),
      color: connection.valueOrNull != null
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).disabledColor,
    );
  }
}
