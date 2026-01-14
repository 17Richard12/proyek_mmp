import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:city_care/presentation/pages/splash_page.dart';
import 'package:city_care/presentation/pages/home_page.dart';
import 'package:city_care/presentation/pages/create_report_page.dart';
import 'package:city_care/presentation/pages/detail_report_page.dart';
import 'package:city_care/presentation/pages/profile_page.dart';
import 'package:city_care/domain/entities/report.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/create',
      builder: (context, state) => const CreateReportPage(),
    ),
    GoRoute(
      path: '/detail',
      builder: (context, state) {
        final report = state.extra as Report;
        return DetailReportPage(report: report);
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfilePage(),
    ),
  ],
);
