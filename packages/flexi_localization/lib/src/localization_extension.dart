import 'package:flexi_localization/src/localization_cubit.dart';
import 'package:flexi_localization/src/localization_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension LocalizationExtension on BuildContext {
  LocalizationService get tr => LocalizationService();
  LocalizationCubit get localeManager =>
      BlocProvider.of<LocalizationCubit>(this);
}
