import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galery_tz/app.dart';
import 'package:galery_tz/simple_bloc_observer.dart';

void main() {
  Bloc.observer = const SimpleBlocObserver();
  runApp(App());
}