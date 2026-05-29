import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moto_ve/widget/theme/theme_mode.dart';
import 'bloc/favourite/favourite_bloc.dart';
import 'bloc/navigation/navigation_bloc.dart';
import 'firebase/firebase_options.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/recommendation/recommendation_bloc.dart';
import 'bloc/vehicle/vehicle_bloc.dart';
import 'presentation/screens/splash_screen/splash_page.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [

        BlocProvider(
          create: (_) => VehicleBloc(),
        ),

        BlocProvider(
          create: (_) => PreferenceBloc(),
        ),

        BlocProvider(
          create: (_) => AuthBloc(),
        ),

        BlocProvider(
          create: (_) => FavoriteBloc(),
        ),

        BlocProvider(
          create: (_) => NavBloc(),
        ),

        BlocProvider(
          create: (_) => ThemeCubit(),
        ),
      ],

      child:
      BlocBuilder<ThemeCubit, ThemeMode>(

        builder: (context, themeMode) {

          return MaterialApp(

            debugShowCheckedModeBanner:
            false,

            themeMode: themeMode,

            theme: ThemeData(
              brightness: Brightness.light,

              scaffoldBackgroundColor:
              Colors.white,
            ),

            darkTheme: ThemeData(
              brightness: Brightness.dark,

              scaffoldBackgroundColor:
              const Color(0xFF070B14),
            ),

            home: const SplashPage(),
          );
        },
      ),
    );
  }
}