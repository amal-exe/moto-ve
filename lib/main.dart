import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/favourite/favourite_bloc.dart';
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

  runApp( MyApp());
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

      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashPage(),
      ),
    );
  }
}