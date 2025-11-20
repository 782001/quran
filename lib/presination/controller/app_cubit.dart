import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_v2/models/surah_model.dart';

import '../../core/utils/conestans.dart';
import 'app_states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  bool view = true;
  void ChangeView() {
    view = !view;

    emit(ChangeViewSuraState());
  }

  void initState(ayah) {
    WidgetsBinding.instance.addPostFrameCallback((_) => jumbToAyah(ayah));
    emit(InitState());
  }

  jumbToAyah(ayah) async {
    if (fabIsClicked) {
      if (itemScrollController.isAttached) {
        itemScrollController.scrollTo(
          index: ayah,
          duration: const Duration(seconds: 2),
          curve: Curves.easeInOutCubic,
        );
      } else {
        // انتظر لحد ما يجهز
        Future.delayed(const Duration(milliseconds: 100), () {
          jumbToAyah(ayah);
        });
        return;
      }
    }

    fabIsClicked = false;
    emit(JumbToState());
  }

  bool isMoshaf = true;
  void ChangeisMoshaf(value) {
    isMoshaf = value;

    emit(ChangeisMoshafSuraState());
  }

  List<Surah> filterSurahList(String searchText) {
    if (searchText.isEmpty) {
      return surahList;
    } else {
      return surahList
          .where((surah) => surah.arabicName.contains(searchText))
          .toList();
    }
  }

  List<Surah> filteredSurahList = [];

  void updateFilteredSurahs(String searchText) {
    filteredSurahList = surahList
        .where((surah) =>
            surah.name.contains(searchText) ||
            surah.arabicName.contains(searchText))
        .toList();
    emit(UpdateFilteredSurahsState());
  }
}
