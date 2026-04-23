import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/auth/auth_service.dart';
import 'core/routing/app_router.dart';
import 'data/repositories/listings_repository.dart';
import 'features/auth/auth_bloc.dart';
import 'features/marketplace/listings/listings_bloc.dart';
import 'state/global_state_bloc.dart';
import 'ui/theme/glass_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flippa/l10n/app_localizations.dart';

class FlippaApp extends StatelessWidget {
  const FlippaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthService()),
        RepositoryProvider(create: (context) => ListingsRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthBloc(context.read<AuthService>())),
          BlocProvider(create: (context) => ListingsBloc(context.read<ListingsRepository>())),
          BlocProvider(create: (context) => GlobalBloc()),
        ],
        child: BlocBuilder<GlobalBloc, GlobalState>(
          builder: (context, state) {
            return MaterialApp.router(
              title: 'Flippa',
              debugShowCheckedModeBanner: false,
              theme: GlassTheme.lightTheme,
              routerConfig: AppRouter.router,
              locale: state.locale,
              supportedLocales: const [
                Locale('en', 'US'),
                Locale('hi', 'IN'),
                Locale('es', 'ES'),
                Locale('fr', 'FR'),
                Locale('de', 'DE'),
              ],
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
            );
          },
        ),
      ),
    );
  }
}
