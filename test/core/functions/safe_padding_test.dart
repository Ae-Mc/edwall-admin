import 'package:edwall_admin/core/functions/safe_padding.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('uses the larger of design and system horizontal padding', (
    tester,
  ) async {
    late EdgeInsets padding;

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(
          padding: EdgeInsets.only(left: 40, right: 12),
        ),
        child: Builder(
          builder: (context) {
            padding = safeHorizontalPadding(
              context,
              const EdgeInsets.fromLTRB(32, 8, 48, 16),
            );
            return const SizedBox();
          },
        ),
      ),
    );

    expect(padding, const EdgeInsets.fromLTRB(48, 8, 48, 16));
  });

  testWidgets('does not add a gap when there is no system inset', (
    tester,
  ) async {
    late EdgeInsets padding;

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(),
        child: Builder(
          builder: (context) {
            padding = safeHorizontalPadding(context, EdgeInsets.zero);
            return const SizedBox();
          },
        ),
      ),
    );

    expect(padding, EdgeInsets.zero);
  });
}
