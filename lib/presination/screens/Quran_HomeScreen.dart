import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/quran.dart';
import 'package:quran_v2/core/utils/media_query_values.dart';
import 'package:quran_v2/core/utils/strings.dart';
import 'package:quran_v2/presination/controller/app_cubit.dart';
import 'package:quran_v2/presination/controller/app_states.dart';
import 'package:quran_v2/presination/screens/no_book_mark_screen.dart';
import 'package:quran_v2/presination/screens/search_screen.dart';
import 'package:quran_v2/presination/screens/settings.dart';
import 'package:quran_v2/presination/widgets/sliver_delegate.dart';
import 'package:quran_v2/presination/widgets/to_arabic_no_converter.dart';
import 'package:sizer/sizer.dart';

import '../../core/shared/components.dart';
import '../../core/utils/assets_path.dart';
import '../../core/utils/conestans.dart';
import '../widgets/mydrawer.dart';
import 'Sora.dart';
import 'surah_builder.dart';

class QuranHomeScreen extends StatelessWidget {
  const QuranHomeScreen({
    Key? key,
    required this.data,
  }) : super(key: key);
  final data;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
            // drawer: const MyDrawer(),
            appBar: AppBar(
                elevation: 0,
                // leading: Builder(
                //   builder: (BuildContext context) {
                //     return IconButton(
                //       icon: const Icon(
                //         Icons.menu,
                //         color: Colors.white,
                //       ),
                //       onPressed: () {
                //         Scaffold.of(context).openDrawer();
                //       },
                //       // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                //     );
                //   },
                // ),
                leading: Switch(
                    onChanged: (value) async {
                      debugPrint('Switch ${cubit.isMoshaf}');
                      cubit.ChangeisMoshaf(value);
                      // setState(() {
                      //   cubit.isMoshaf = value;
                      // });
                      ShowToust(
                          Text: cubit.isMoshaf ? 'وضع المشاف' : 'الوضع العادي',
                          state: ToustStates.SUCSESS);
                      // int valueInt= switchValue ? 1: 0;
                      // await settingsProvider.updateSettings(widget.nameField,valueInt);
                    },
                    value: cubit.isMoshaf,
                    activeColor: const Color(0xff592c01),
                    activeTrackColor: const Color(0xffFFFBE8),
                    inactiveThumbColor: const Color(0xff592c01),
                    inactiveTrackColor: const Color(0xffFFFBE8)),
                actions: [
                  CircleAvatar(
                    backgroundColor: const Color(0xffFFFBE8),
                    radius: 25,
                    child: Center(
                      child: IconButton(
                        icon: const Icon(
                          Icons.search,
                          color: Color(0xff592c01),
                          size: 35,
                          shadows: [
                            Shadow(
                                color: Color(0xff592c01),
                                blurRadius: 20,
                                offset: Offset(5, 5))
                          ],
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const searchScreen()));
                        },
                        // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: context.width * 0.05,
                  ),
                  SizedBox(
                    width: context.width * 0.05,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Settings()));
                    },
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(start: 10),
                      child: Container(
                        width: context.width * 0.5,
                        height: context.height * 0.05,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: Color(0xffFFFBE8),
                        ),
                        child: Row(children: [
                          const SizedBox(
                            width: 10,
                          ),
                          const Icon(
                            Icons.settings,
                            color: Color(0xff592c01),
                          ),
                          const Spacer(
                              // width: 10,
                              ),
                          Text(
                            "حجم الخط",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: cairoFont,
                              fontSize: context.width * 0.06,
                              color: const Color(0xff592c01),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: context.width * 0.08,
                          ),
                        ]),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: context.width * 0.05,
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  // centerTitle: true,

                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          // AppColors.kTealColor,
                          Color(0xff592c01),
                          Color(0xff592c01),
                          Color(0xff592c01),
                          //    Color(0xff592c01),
                          // Color(0xffE95C1F),
                          // Color(0xffE95C1F),
                          // Color(0xffE95C1F),
                        ],
                      ),
                    ),
                  ),
                )),
            floatingActionButton: FloatingActionButton(
              tooltip: 'المحفوظ',
              backgroundColor: const Color(0xff592c01),
              onPressed: () async {
                fabIsClicked = true;
                if (await readBookmark() == true) {
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SurahBuilder(
                                arabic: quran[0],
                                sura: bookmarkedSura - 1,
                                suraName: arabicName[bookmarkedSura - 1]
                                    ['name'],
                                ayah: bookmarkedAyah,
                              )));
                }
                if (await readBookmark() == false) {
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NoBookMarkScreen()));
                }
              },
              child: const Icon(
                Icons.bookmark,
                color: Colors.white,
              ),
            ),
            body: data && surahList.isNotEmpty
                ? const QuranHomeScreenWidgt()
                : const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xff592c01),
                    ),
                  ));
      },
    );
  }
}

class QuranHomeScreenWidgt extends StatefulWidget {
  const QuranHomeScreenWidgt({
    super.key,
  });

  @override
  State<QuranHomeScreenWidgt> createState() => _QuranHomeScreenWidgtState();
}

class _QuranHomeScreenWidgtState extends State<QuranHomeScreenWidgt> {
  TextEditingController textEditingController = TextEditingController();
  var searchQuery = "";
  var ayatFiltered;
  @override
  Widget build(BuildContext context) {
    ScrollController? scrollController;

    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return CustomScrollView(
            controller: scrollController,
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              SliverPersistentHeader(
                floating: false,
                pinned: false,
                delegate: SliverAppBarDelegate(
                  maxHeight: context.height * 0.15,
                  minHeight: context.height * 0.05,
                  child: Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            // AppColors.kTealColor,
                            Color(0xff592c01),
                            Color(0xff592c01),
                            Color(0xff592c01),
                            //    Color(0xff592c01),
                            // Color(0xffE95C1F),
                            // Color(0xffE95C1F),
                            // Color(0xffE95C1F),
                          ],
                        ),
                        borderRadius: BorderRadiusDirectional.only(
                            bottomStart: Radius.circular(25),
                            bottomEnd: Radius.circular(25))),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(
                          top: 10.0, start: 20, end: 20),
                      child: Row(
                        children: [
                          const AutoSizeText(
                            "القرآن الكريم",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: me_quranFont),
                          ),
                          const Spacer(),
                          SizedBox(
                              height: 40.h,
                              width: 40.w,
                              child: Image.asset(SplashImage))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 253, 247, 230),
                                borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.0.w),
                                    child: TextFormField(
                                      textDirection: TextDirection.rtl,
                                      controller: textEditingController,
                                      cursorColor: const Color(0xff592c01),
                                      onChanged: (value) {
                                        setState(() {
                                          searchQuery = value;
                                        });

                                        /*https://api.alquran.cloud/v1/search/%D8%A7%D8%A8%D8%B1%D8%A7%D9%87%D9%8A%D9%85/all/ar*/

                                        if (searchQuery.length > 3 ||
                                            searchQuery
                                                .toString()
                                                .contains(" ")) {
                                          setState(() {
                                            ayatFiltered = [];
                                            searchQuery = value;

                                            ayatFiltered =
                                                searchWords(searchQuery);
                                          });
                                        }
                                      },
                                      style: const TextStyle(
                                        fontFamily: cairoFont,
                                        color: Color(0xff592c01),
                                      ),
                                      decoration: const InputDecoration(
                                        hintText: 'ابحث عن ايه',
                                        hintStyle: TextStyle(
                                          fontFamily: cairoFont,
                                          color: Color(0xff592c01),
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (searchQuery.isNotEmpty) {
                                      textEditingController.clear();
                                      setState(() {
                                        searchQuery = "";
                                        ayatFiltered = null;
                                        ayatFiltered = [];
                                      });
                                    }
                                  },
                                  child: searchQuery.isNotEmpty
                                      ? const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.close,
                                              color: Color(0xff592c01),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.search,
                                              color: Color(0xff592c01),
                                            ),
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
              (searchQuery.length > 3 || searchQuery.toString().contains(" "))
                  ? SliverList(
                      delegate: SliverChildListDelegate([
                      SizedBox(
                        height: context.height * 0.65,
                        child: ListView.builder(
                          // physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: ayatFiltered["occurences"],
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: GestureDetector(
                                onTap: () {
                                  fabIsClicked = true;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          SurahBuilder(
                                        arabic: quran[0],
                                        // sura: bookmarkedSura - 1,
                                        sura: ayatFiltered["result"][index]
                                                ["surah"] -
                                            1,
                                        // suraName: arabicName[bookmarkedSura - 1]['name'],
                                        suraName: arabicName[
                                            ayatFiltered["result"][index]
                                                    ["surah"] -
                                                1]['name'],
                                        ayah: ayatFiltered["result"][index]
                                                ["verse"] -
                                            1,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  // color: Colors.white70,
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 253, 247, 230),
                                      borderRadius: BorderRadius.circular(14)),

                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Column(
                                      children: [
                                        AutoSizeText(
                                          "سورة ${getSurahNameArabic(ayatFiltered["result"][index]["surah"])} -\n\n ${getVerse(ayatFiltered["result"][index]["surah"], ayatFiltered["result"][index]["verse"], verseEndSymbol: false)}${"\uFD3F${(ayatFiltered["result"][index]["verse"]).toString().toArabicNumbers}\uFD3E"}\n",
                                          textDirection: TextDirection.rtl,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            // fontFamily: "uthmanic",
                                            fontSize: 20,
                                            fontFamily: me_quranFont,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ]))
                  : SliverList(
                      delegate: SliverChildListDelegate([
                        SizedBox(
                            height: context.height * 0.65,
                            child: BuildSuraName()),
                        SizedBox(
                          height: context.height * 0.06,
                        )
                      ]),
                    )
            ],
          );
        });
  }
}

Widget BuildSuraName() {
  return BlocConsumer<AppCubit, AppStates>(
    listener: (context, state) {},
    builder: (context, state) {
      var cubit = AppCubit.get(context);
      return ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) => ListTile(
          // leading: ArabicSuraNumber(
          //   i: surahList[index].id - 1,
          // )
          leading: CircleAvatar(
            backgroundColor: const Color(0xff592c01),
            child: Text(
              (surahList[index].id).toString(),
              style: const TextStyle(color: Colors.white),
            ),
          ),

          title: AutoSizeText(
            surahList[index].name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Row(
            children: [
              SizedBox(
                  width: 30,
                  child: AutoSizeText(surahList[index].versesCount.toString())),
              const SizedBox(
                width: 3,
              ),
              surahList[index].revelationPlace.toString() == "makkah"
                  ? Image.asset(
                      "assets/images/makkah.png",
                      height: 35,
                      width: 35,
                    )
                  : Image.asset(
                      "assets/images/madinah.png",
                      height: 35,
                      width: 35,
                    )
              //  (surahList[index].revelationPlace.toString()),
            ],
          ),
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

// Widget BuildSuraName(quran, context) {
//   return Container(
//     color: const Color.fromARGB(255, 221, 250, 236),
//     height: 65.h,
//     child: ListView(
//       physics: NeverScrollableScrollPhysics(),
//       children: [
//         for (int i = 0; i < 114; i++)
//           Container(
//             color: i % 2 == 0
//                 ? const Color.fromARGB(255, 253, 247, 230)
//                 : const Color.fromARGB(255, 253, 251, 240),
//             child: TextButton(
//               child: Padding(
//                 padding: const EdgeInsetsDirectional.only(end: 15.0, start: 15),
//                 child: Row(
//                   children: [
//                     ArabicSuraNumber(i: i),
//                     const SizedBox(
//                       width: 5,
//                     ),
//                     // Padding(
//                     //   padding: const EdgeInsets.all(8.0),
//                     //   child: Column(
//                     //     crossAxisAlignment: CrossAxisAlignment.start,
//                     //     children: [],
//                     //   ),
//                     // ),
//                     Spacer(),
//                     Text(
//                       arabicName[i]['name'],
//                       style: TextStyle(
//                           fontSize: 20,
//                           color: Colors.black87,
//                           fontFamily: me_quranFont,
//                           shadows: [
//                             Shadow(
//                               offset: Offset(.5, .5),
//                               blurRadius: 1.0,
//                               color: Color.fromARGB(255, 130, 130, 130),
//                             )
//                           ]),
//                       textDirection: TextDirection.rtl,
//                     ),
//                   ],
//                 ),
//               ),
//               onPressed: () {
//                 fabIsClicked = false;
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => SurahBuilder(
//                             arabic: quran[0],
//                             sura: i,
//                             suraName: arabicName[i]['name'],
//                             ayah: 0,
//                           )),
//                 );
//               },
//             ),
//           ),
//       ],
//     ),
//   );
// }
