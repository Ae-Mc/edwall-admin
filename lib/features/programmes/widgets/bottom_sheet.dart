import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Filter {
  final int? levelFrom, levelTo;
  final String? nameContains;

  Filter({this.levelFrom, this.levelTo, this.nameContains});
}

class BottomSheet extends HookWidget {
  final int? initialLevelFrom, initialLevelTo;
  final String? initialNameContains;

  const BottomSheet(
      {super.key,
      this.initialLevelFrom,
      this.initialLevelTo,
      this.initialNameContains});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final levelFrom = useState<int?>(initialLevelFrom);
    final levelTo = useState<int?>(initialLevelTo);
    final nameContainsController =
        useTextEditingController(text: initialNameContains);
    const min = 0;
    const max = 10;

    return SingleChildScrollView(
      child: Padding(
        padding: Pad(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const Pad(all: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: colorScheme.surface,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Фильтры',
                style: textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Уровень сложности программы',
                style: textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              RangeSlider(
                values: RangeValues(
                  (levelFrom.value ?? min).toDouble(),
                  (levelTo.value ?? max).toDouble(),
                ),
                min: min.toDouble(),
                max: max.toDouble(),
                divisions: (max - min).toInt(),
                labels: RangeLabels(
                  levelFrom.value.toString(),
                  levelTo.value.toString(),
                ),
                onChanged: (value) {
                  levelFrom.value = value.start.round();
                  levelTo.value = value.end.round();
                },
              ),
              const SizedBox(height: 8),
              Text(
                'Название',
                style: textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              TextField(controller: nameContainsController),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async => await context.maybePop(Filter(
                  levelFrom: levelFrom.value == min ? null : levelFrom.value,
                  levelTo: levelTo.value == max ? null : levelTo.value,
                  nameContains: nameContainsController.text.isEmpty
                      ? null
                      : nameContainsController.text,
                )),
                child: const Text("Подтвердить"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
