import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:city_care/presentation/router/app_router.dart';
import 'package:city_care/presentation/bloc/report/report_bloc.dart';
import 'package:city_care/presentation/bloc/form/form_bloc.dart';
import 'package:city_care/data/repositories/report_repository_impl.dart';
import 'package:city_care/data/datasources/database_helper.dart';
import 'package:city_care/data/datasources/firebase_service.dart';
import 'package:city_care/data/datasources/gemini_service.dart';
import 'package:city_care/data/datasources/location_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }

  await initializeDateFormatting('id_ID', null);

  // Initialize Firebase (Mocked here since no google-services.json)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final databaseHelper = DatabaseHelper();
  final firebaseService = FirebaseService();
  final geminiService = GeminiService();
  final locationService = LocationService();

  final reportRepository = ReportRepositoryImpl(
    databaseHelper: databaseHelper,
    firebaseService: firebaseService,
    geminiService: geminiService,
    locationService: locationService,
  );

  runApp(CityCareApp(repository: reportRepository));
}

class CityCareApp extends StatelessWidget {
  final ReportRepositoryImpl repository;

  const CityCareApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ReportBloc(repository)),
        BlocProvider(create: (_) => FormBloc(repository)),
      ],
      child: MaterialApp.router(
        title: 'CityCare',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        routerConfig: router,
      ),
    );
  }
}
