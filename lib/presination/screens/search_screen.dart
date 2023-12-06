import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_v2/core/utils/assets_path.dart';
import 'package:quran_v2/core/utils/conestans.dart';
import 'package:quran_v2/core/utils/media_query_values.dart';
import 'package:quran_v2/presination/controller/app_cubit.dart';
import 'package:quran_v2/presination/controller/app_states.dart';
import 'package:quran_v2/presination/screens/HomeScreen.dart';
import 'package:quran_v2/presination/screens/Sora.dart';
import 'package:quran_v2/presination/screens/surah_builder.dart';
import 'package:quran_v2/presination/surah_model.dart';
import 'package:quran_v2/presination/widgets/arabic_sura_num.dart';

class searchScreen extends StatelessWidget {
  const searchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var searchController = TextEditingController();

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        List<Surah> filteredSurahList =
            AppCubit.get(context).filterSurahList(searchController.text);
        return Scaffold(
          appBar: AppBar(
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.transparent,
                    ),
                    onPressed: () {},
                    // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                  );
                },
              ),
              flexibleSpace: FlexibleSpaceBar(
                // centerTitle: true,

                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        // AppColors.kTealColor,
                        Color(0xff14697B),
                        Color(0xffE95C1F),
                        Color(0xffE95C1F),
                        Color(0xffE95C1F),
                      ],
                    ),
                  ),
                ),
              )),
          body: Container(
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  // AppColors.kTealColor,
                  Color(0xff14697B),
                  Color(0xffE95C1F),
                  Color(0xffE95C1F),
                  Color(0xffE95C1F),
                ],
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[350],
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TextFormField(
                              cursorColor: const Color(0xff14697B),
                              onFieldSubmitted: (value) {
                                cubit.updateFilteredSurahs(value);
                              },
                              onChanged: (value) {
                                cubit.updateFilteredSurahs(value);
                              },
                              keyboardType: TextInputType.text,
                              controller: searchController,
                              decoration: InputDecoration(
                                suffixIcon: const Icon(
                                  Icons.search,
                                  color: Color(0xff14697B),
                                  size: 35,
                                  shadows: [
                                    Shadow(
                                        color: Color(0xff14697B),
                                        blurRadius: 20,
                                        offset: Offset(5, 5))
                                  ],
                                ),
                                labelStyle: const TextStyle(
                                    color: Color(0xff14697B),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                                labelText: "اكتب اسم السوره",
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xff14697B),
                                  ),
                                  gapPadding: 5,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                // errorBorder: OutlineInputBorder(
                                //   borderSide: BorderSide(
                                //     color: Colors.white,
                                //   ),
                                //   gapPadding: 5,
                                //   borderRadius:
                                //       BorderRadius.circular(10),
                                // ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xff14697B),
                                  ),
                                  gapPadding: 5,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xff14697B),
                                  ),
                                  gapPadding: 5,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                // Change the color as desired

                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xff14697B),
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              ),
                            )),
                      ),
                    ),
                  ),
                  // SizedBox(
                  //     height: context.height * 0.7, child: BuildSuraName()),
                  SizedBox(
                    height: context.height * 0.7,
                    child: filteredSurahList.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Container(
                                width: double.infinity,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: const Color(0xffFFFBE8),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    const Icon(
                                      Icons.do_not_disturb_alt_sharp,
                                      size: 60,
                                      color: Color(0xffE95C1F),
                                    ),
                                    const Spacer(
                                        // height: 20,
                                        ),
                                    Text(
                                      "السوره غير موجوده",
                                      style: TextStyle(
                                        fontFamily: quranFont,
                                        fontSize: arabicFontSize,
                                      ),
                                      textDirection: TextDirection.rtl,
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                                color: Colors.white54,
                                borderRadius: BorderRadius.circular(20)),
                            child: Card(
                              child: BuildSearchSuraName(filteredSurahList),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget BuildSearchSuraName(List<Surah> surahList) {
  return BlocConsumer<AppCubit, AppStates>(
    listener: (context, state) {},
    builder: (context, state) {
      var cubit = AppCubit.get(context);
      return ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) => ListTile(
          leading: ArabicSuraNumber(
            i: surahList[index].id - 1,
          )
          //  CircleAvatar(
          //   child: Text(surahList[index].id.toString()),
          // ),
          ,
          title: AutoSizeText(
            surahList[index].name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: AutoSizeText(surahList[index].versesCount.toString()),
          trailing: AutoSizeText(
            surahList[index].arabicName,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: me_quranFont),
          ),
          // onTap: () {
          //   fabIsClicked = false;
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => SurahPage(surah: surahList[index])),
          //   );
          // }
          // ,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => cubit.isMoshaf
                  ? SurahBuilder(
                      arabic: quran[0],
                      // sura: bookmarkedSura - 1,
                      sura: surahList[index].id - 1,
                      // suraName: arabicName[bookmarkedSura - 1]['name'],
                      suraName: arabicName[surahList[index].id - 1]['name'],
                      ayah: bookmarkedAyah,
                    )
                  : SurahPage(
                      surah: surahList[index],
                      sura: surahList[index].id - 1,
                    ),
            ),
          ),
        ),
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemCount: surahList.length,
      );
    },
  );
}
