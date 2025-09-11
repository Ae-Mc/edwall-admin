import 'dart:async';
import 'dart:collection';
import 'dart:isolate';
import 'dart:math';

import 'package:bluetooth_classic_multiplatform/bluetooth_classic_multiplatform.dart';
import 'package:edwall_admin/core/const.dart';
import 'package:edwall_admin/core/util/color_extension.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'flashboard_connection.g.dart';

@Riverpod(keepAlive: true)
class FlashboardConnection extends _$FlashboardConnection {
  BluetoothConnection? _connection;
  Isolate? _queueIsolate;
  final _isolateRespondPort = ReceivePort();
  SendPort? _isolateControlPort;
  final bluetooth = BluetoothClassicMultiplatform();

  @override
  Future<BluetoothConnection?> build() async {
    final localConnection = _connection;
    if (_queueIsolate == null) {
      _queueIsolate = await Isolate.spawn(
        _isolateEntryPoint,
        _isolateRespondPort.sendPort,
      );
      _isolateRespondPort.listen(_isolateRespondHandler);
    }
    if (localConnection != null) {
      localConnection.input?.listen(_connectionInputHandler);
      // ref.onCancel(() async {
      //   Logger().d("onCancel called");
      //   _disconnect();
      // });
    }

    return localConnection;
  }

  void _isolateRespondHandler(message) {
    switch (message) {
      case Uint8List bytes:
        _connection?.output.add(bytes);
      case SendPort sendPort:
        _isolateControlPort = sendPort;
    }
  }

  void _connectionInputHandler(Uint8List event) {
    if (event.first == 107) {
      _isolateControlPort?.send(true);
    }
  }

  Future<void> connectToDevice(String address) async {
    late final bool? bondResult;
    try {
      bondResult = await bluetooth.bondDevice(address);
    } on PlatformException {
      // Device already bonded
      bondResult = true;
    }
    if (bondResult == true) {
      _connection = await bluetooth.connect(address);

      ref.invalidateSelf();
    }
  }

  static Future<void> _isolateEntryPoint(SendPort sendPort) async {
    final receivePort = ReceivePort();
    bool running = true;
    final queue = Queue<Uint8List>();
    final okQueue = Queue<bool>();

    receivePort.listen((message) {
      switch (message) {
        case Uint8List bytes:
          queue.add(bytes);
        case bool ok: // OK/Not OK
          okQueue.add(ok);
      }
    }, onDone: () => Logger().d("Isolate control port closed"));
    sendPort.send(receivePort.sendPort);

    while (running) {
      if (queue.isEmpty) {
        // To allow event loop handle messages from receive port queue
        // DON'T DELETE!
        await Future.delayed(const Duration(microseconds: 5));
        continue;
      }
      final bytes = queue.removeFirst();

      okQueue.clear();
      for (int i = 0; i < bytes.length; i += 6) {
        final subsequence = bytes.sublist(i, min(i + 6, bytes.length));
        sendPort.send(subsequence);
        final start = DateTime.now();
        bool ok = false;
        await Future.doWhile(() async {
          await Future.delayed(const Duration(microseconds: 5));
          if (DateTime.now().difference(start) >
              const Duration(milliseconds: 500)) {
            return false;
          }
          if (okQueue.isNotEmpty) {
            ok = okQueue.removeFirst();
            return false;
          }
          return true;
        });

        if (!ok) {
          i -= 6;
        }
      }
    }
  }

  final Uint8List _clearCommandBytes = Uint8List.fromList([
    0x6E,
    ...List.filled(5, 0),
  ]);

  Uint8List _setLedCommandBytes(
    int bank,
    int ledNumber, [
    int red = 0xFF,
    int green = 0xFF,
    int blue = 0xFF,
  ]) => Uint8List.fromList([0x6C, bank, ledNumber, red, green, blue]);

  final Uint8List _applyCommandBytes = Uint8List.fromList([
    0x73,
    ...List.filled(5, 0),
  ]);

  void setLeds(List<(int, int)> ledsList, int state) {
    final color = holdTypeToColor[state]!;
    for (final (bank, led) in ledsList) {
      _isolateControlPort?.send(
        _setLedCommandBytes(bank, led, color.rb, color.gb, color.bb),
      );
    }
  }

  void showRoute(RouteRead route) {
    // _isolateControlPort?.send(_clearCommandBytes);
    for (final hold in route.holds) {
      final color = holdTypeToColor[hold.type]!;
      _isolateControlPort?.send(
        _setLedCommandBytes(
          hold.wallhold.bank,
          hold.wallhold.$num,
          color.rb,
          color.gb,
          color.bb,
        ),
      );
    }
    _isolateControlPort?.send(_applyCommandBytes);
  }

  void setLed(int bank, int ledNumber, int state) {
    final color = holdTypeToColor[state]!;
    _isolateControlPort?.send(
      _setLedCommandBytes(bank, ledNumber, color.rb, color.gb, color.bb),
    );
    _isolateControlPort?.send(_applyCommandBytes);
  }

  void clear() {
    _isolateControlPort?.send(_clearCommandBytes);
    _isolateControlPort?.send(_applyCommandBytes);
  }

  Future<void> _disconnect() async {
    await _connection?.finish();
    _connection = null;
    Logger().d("Disconnected");
  }

  Future<void> disconnect() async {
    await _disconnect();
    ref.invalidateSelf();
  }
}
