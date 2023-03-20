import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/conestans.dart';

import 'home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());
  static HomeCubit get(context) => BlocProvider.of(context);
  // bool view = true;
  bool isMoshaf = false;
  void ChangeisMoshaf(value) {
    isMoshaf = value;

    emit(ChangeisMoshafSuraState());
  }
}
