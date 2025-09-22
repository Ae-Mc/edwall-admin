import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Filter {
  final int? numberOfModulesFrom, numberOfModulesTo;
  final String? nameContains;

  Filter({this.numberOfModulesFrom, this.numberOfModulesTo, this.nameContains});
}

class BottomSheet extends HookWidget {
  final int? initialNumberOfModulesFrom, initialNumberOfModulesTo;
  final String? initialNameContains;

  const BottomSheet({
    super.key,
    this.initialNumberOfModulesFrom,
    this.initialNumberOfModulesTo,
    this.initialNameContains,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final modulesCountFrom = useState<int?>(initialNumberOfModulesFrom);
    final modulesCountTo = useState<int?>(initialNumberOfModulesTo);
    final nameContainsController = useTextEditingController(
      text: initialNameContains,
    );
    const min = 0;
    const max = 4;

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
              Text('Фильтры', style: textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text('Количество модулей', style: textTheme.labelLarge),
              const SizedBox(height: 8),
              RangeSlider(
                values: RangeValues(
                  (modulesCountFrom.value ?? min).toDouble(),
                  (modulesCountTo.value ?? max).toDouble(),
                ),
                min: min.toDouble(),
                max: max.toDouble(),
                divisions: (max - min).toInt(),
                labels: RangeLabels(
                  (modulesCountFrom.value ?? min).toString(),
                  (modulesCountTo.value ?? max).toString(),
                ),
                onChanged: (value) {
                  modulesCountFrom.value = value.start.round();
                  modulesCountTo.value = value.end.round();
                },
              ),
              const SizedBox(height: 8),
              Text('Название', style: textTheme.labelLarge),
              const SizedBox(height: 8),
              TextField(
                controller: nameContainsController,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async => await context.maybePop(
                  Filter(
                    numberOfModulesFrom: modulesCountFrom.value == min
                        ? null
                        : modulesCountFrom.value,
                    numberOfModulesTo: modulesCountTo.value == max
                        ? null
                        : modulesCountTo.value,
                    nameContains: nameContainsController.text.isEmpty
                        ? null
                        : nameContainsController.text,
                  ),
                ),
                child: const Text("Подтвердить"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
