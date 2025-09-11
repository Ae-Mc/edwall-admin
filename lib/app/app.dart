import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:edwall_admin/app/router/app_router.dart';
import 'package:edwall_admin/app/theme/theme.dart';
import 'package:edwall_admin/features/auth/domain/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/find_locale.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.watch(appRouterProvider);
    final themeModel = ref.watch(themeProvider);
    final colorScheme = ColorScheme.fromSwatch(
      primarySwatch: themeModel.primary,
      brightness: themeModel.brightness,
      backgroundColor: themeModel.background,
      accentColor: themeModel.secondary,
    ).copyWith(onSurface: themeModel.primary, outline: themeModel.outline);
    ref.listen(authRepositoryProvider, (previous, next) {
      if (!next.isLoading) {
        if (next.hasValue && next.value != previous?.value) {
          if (next.value == null) {
            appRouter.replaceAll([SelectLoginRoute()]);
          } else {
            appRouter.replaceAll([RootRoute()]);
          }
        }
      }
    });
    final primaryVariant = Color.lerp(
      themeModel.primary,
      themeModel.background,
      0.3,
    );

    return FutureBuilder(
      future:
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]).then((value) async {
            await SystemChrome.setEnabledSystemUIMode(
              SystemUiMode.immersiveSticky,
            );
            Intl.defaultLocale = await findSystemLocale();
            await initializeDateFormatting();
          }),
      builder: (context, _) => ToastificationWrapper(
        config: const ToastificationConfig(
          animationDuration: Duration(milliseconds: 500),
        ),
        child: MaterialApp.router(
          title: 'EDWall',
          routerConfig: appRouter.config(),
          themeMode: ThemeMode.light,
          theme: ThemeData(
            fontFamily: themeModel.fontFamily,
            useMaterial3: true,
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: primaryVariant,
              selectionColor: primaryVariant,
              selectionHandleColor: primaryVariant,
            ),
            iconButtonTheme: IconButtonThemeData(
              style: ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(themeModel.primary),
                padding: WidgetStatePropertyAll(Pad.zero),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: Pad(horizontal: 16, vertical: 6),
              fillColor: themeModel.primary,
              filled: true,
              focusColor: Colors.white,
              hintStyle: themeModel.textTheme.bodyLarge?.copyWith(
                color: primaryVariant,
              ),
              iconColor: themeModel.background,
              prefixIconColor: themeModel.background,
              suffixIconColor: themeModel.background,
            ),
            cardTheme: CardThemeData(
              margin: Pad.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: themeModel.primary),
              ),
            ),
            colorScheme: colorScheme,
            textTheme: themeModel.textTheme.apply(
              bodyColor: themeModel.primary,
              displayColor: themeModel.primary,
              decorationColor: themeModel.primary,
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: ButtonStyle(
                side: WidgetStatePropertyAll(
                  BorderSide(color: themeModel.primary),
                ),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(themeModel.background),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                overlayColor: WidgetStatePropertyAll(primaryVariant),
                backgroundColor: WidgetStateColor.resolveWith(
                  (states) => states.contains(WidgetState.disabled)
                      ? themeModel.disabledColor
                      : themeModel.primary,
                ),
              ),
            ),
            extensions: [themeModel],
          ),
        ),
      ),
    );
  }
}
