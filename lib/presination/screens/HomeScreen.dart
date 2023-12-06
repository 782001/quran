import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_v2/core/utils/media_query_values.dart';
import 'package:quran_v2/presination/controller/app_cubit.dart';
import 'package:quran_v2/presination/controller/app_states.dart';
import 'package:quran_v2/presination/screens/no_book_mark_screen.dart';
import 'package:quran_v2/presination/screens/search_screen.dart';
import 'package:quran_v2/presination/widgets/sliver_delegate.dart';
import 'package:sizer/sizer.dart';

import '../../core/shared/components.dart';
import '../../core/utils/assets_path.dart';
import '../../core/utils/conestans.dart';
import '../widgets/arabic_sura_num.dart';
import '../widgets/mydrawer.dart';
import 'Sora.dart';
import 'surah_builder.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
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
            drawer: const MyDrawer(),
            appBar: AppBar(
                elevation: 0,
                leading: Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                    );
                  },
                ),
                actions: [
                  SizedBox(
                    width: context.width * 0.05,
                  ),
                  Switch(
                      onChanged: (value) async {
                        debugPrint('Switch ${cubit.isMoshaf}');
                        cubit.ChangeisMoshaf(value);
                        // setState(() {
                        //   cubit.isMoshaf = value;
                        // });
                        ShowToust(
                            Text:
                                cubit.isMoshaf ? 'وضع المشاف' : 'الوضع العادي',
                            state: ToustStates.SUCSESS);
                        // int valueInt= switchValue ? 1: 0;
                        // await settingsProvider.updateSettings(widget.nameField,valueInt);
                      },
                      value: cubit.isMoshaf,
                      activeColor: const Color(0xff14697B),
                      activeTrackColor: Colors.white,
                      inactiveThumbColor: const Color(0xff14697B),
                      inactiveTrackColor: Colors.white),
                  SizedBox(
                    width: context.width * 0.05,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 25,
                    child: Center(
                      child: IconButton(
                        icon: const Icon(
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
                ],
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
            floatingActionButton: FloatingActionButton(
              tooltip: 'المحفوظ',
              backgroundColor: const Color(0xffE95C1F),
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

            //  FutureBuilder(
            //   future: readJson(),
            //   builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return FloatingActionButton(
            //         tooltip: 'المحفوظ',
            //         backgroundColor: Color(0xffE95C1F),
            //         elevation: 0,
            //         onPressed: () async {},
            //       );
            //     } else if (snapshot.connectionState == ConnectionState.done) {
            //       if (snapshot.hasError) {
            //         return const Text('هناك خطأ ما');
            //       } else if (snapshot.hasData) {
            //         return FloatingActionButton(
            //           tooltip: 'المحفوظ',
            //           child: Icon(Icons.bookmark),
            //           backgroundColor: Color(0xffE95C1F),
            //           onPressed: () async {
            //             fabIsClicked = true;
            //             if (await readBookmark() == true) {
            //               Navigator.push(
            //                   context,
            //                   MaterialPageRoute(
            //                       builder: (context) => SurahBuilder(
            //                             arabic: quran[0],
            //                             sura: bookmarkedSura - 1,
            //                             suraName: arabicName[bookmarkedSura - 1]
            //                                 ['name'],
            //                             ayah: bookmarkedAyah,
            //                           )));
            //             }
            //           },
            //         );
            //       } else {
            //         return const Text('لا يوجد بيانات ');
            //       }
            //     } else {
            //       return Text('State: ${snapshot.connectionState}');
            //     }
            //   },
            // ),
            body: data && surahList.isNotEmpty
                ? const HomeScreenWidgt()
                : const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xff14697B),
                    ),
                  )

            // SafeArea(
            //   child: FutureBuilder(
            //     future: readJson(),
            //     builder:
            //         (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            //       if (snapshot.connectionState == ConnectionState.waiting &&
            //           surahList.isEmpty) {
            //         return SplashScreen();
            //         // color: Color(0xffE95C1F),

            //       } else if (snapshot.connectionState == ConnectionState.done) {
            //         if (snapshot.hasError) {
            //           return const Text('حدث خطأ ما ');
            //         } else if (snapshot.hasData && surahList.isNotEmpty) {
            //           return HomeScreenWidgt();
            //         } else {
            //           return const Text('لا يوجد بيانات');
            //         }
            //       } else {
            //         return Center(
            //           child: CircularProgressIndicator(),
            //         );
            //       }
            //     },
            //   ),
            // ),
            );
      },
    );
  }
}

class HomeScreenWidgt extends StatelessWidget {
  const HomeScreenWidgt({
    super.key,
  });

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
                  maxHeight: context.height * 0.2,
                  minHeight: context.height * 0.05,
                  child: Container(
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
                        borderRadius: BorderRadiusDirectional.only(
                            bottomStart: Radius.circular(25),
                            bottomEnd: Radius.circular(25))),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(
                          top: 40.0, start: 20, end: 20),
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
                  SizedBox(
                      height: context.height * 0.7, child: BuildSuraName()),
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
