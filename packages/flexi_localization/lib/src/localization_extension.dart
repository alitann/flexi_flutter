import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'localization_cubit.dart';
import 'localization_service.dart';

extension LocalizationExtension on BuildContext {
  LocalizationService get tr => LocalizationService();
  LocalizationCubit get localeManager =>
      BlocProvider.of<LocalizationCubit>(this);
}
