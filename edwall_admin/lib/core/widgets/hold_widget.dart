import 'dart:math';

import 'package:edwall_admin/core/const.dart';
import 'package:edwall_admin/core/providers/wall_state.dart';
import 'package:edwall_admin/features/sandbox/domain/hold_color.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HoldWidget extends ConsumerStatefulWidget {
  final double size;
  final bool changeable;
  final int initialState;
  final WallHoldReadWithHold hold;

  const HoldWidget({
    super.key,
    this.changeable = true,
    this.initialState = 0,
    required this.size,
    required this.hold,
  });

  @override
  ConsumerState<HoldWidget> createState() => _HoldWidgetState();
}

class _HoldWidgetState extends ConsumerState<HoldWidget>
    with AutomaticKeepAliveClientMixin<HoldWidget> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final colorScheme = Theme.of(context).colorScheme;
    late final int state;
    final hasImage =
        minHoldImageId <= widget.hold.hold.id &&
        widget.hold.hold.id <= maxHoldImageId;

    if (widget.changeable) {
      final cachedState = ref.watch(
        wallStateProvider(widget.hold.bank, widget.hold.$num),
      );
      if (cachedState.hasValue) {
        state = cachedState.requireValue;
      } else {
        state = widget.initialState;
      }
    } else {
      state = widget.initialState;
    }

    final color = holdTypeToColor[state]!;

    late final BoxDecoration decoration;
    if (hasImage) {
      final holdId = widget.hold.hold.id.toString().padLeft(2, '0');
      decoration = BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("assets/holds/$holdId.png"),
        ),
      );
    } else {
      decoration = BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(),
      );
    }

    return InkWell(
      onTap: widget.changeable ? () => changeHold(ref, state) : null,
      customBorder: const CircleBorder(),
      child: Center(
        child: Transform.rotate(
          angle: (widget.hold.angle.toDouble() - 180) * pi / 180,
          child: Container(
            decoration: decoration,
            width: widget.size,
            height: widget.size,
            alignment: Alignment.center,
            child: Container(
              width: widget.size * 0.8,
              height: widget.size * 0.8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: state != 0
                    ? Border.all(color: colorScheme.primary)
                    : null,
                color: state != 0 ? color.withValues(alpha: 0.2) : null,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void changeHold(WidgetRef ref, int state) {
    final newState = ref.read(holdColorProvider);
    ref
        .read(wallStateProvider(widget.hold.bank, widget.hold.$num).notifier)
        .setLed(state == newState ? 0 : newState);
  }
}
