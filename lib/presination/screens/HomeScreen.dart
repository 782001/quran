import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/utils/app_theme_colors.dart';
import '../../core/utils/assets_path.dart';
import '../../core/utils/conestans.dart';
import '../controller/app_cubit.dart';
import '../controller/app_states.dart';
import '../widgets/arabic_sura_num.dart';
import '../widgets/mydrawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'surah_builder.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      drawerScrimColor: Colors.black,
      floatingActionButton: FutureBuilder(
        future: readJson(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Text('Error');
            } else if (snapshot.hasData) {
              return FloatingActionButton(
                tooltip: 'المحفوظ',
                child: const Icon(Icons.bookmark),
                backgroundColor: Colors.green,
                onPressed: () async {
                  fabIsClicked = true;
                  if (await readBookmark() == true) {
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
                },
              );
            } else {
              return const Text('Empty data');
            }
          } else {
            return Text('State: ${snapshot.connectionState}');
          }
        },
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: readJson(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Text('Error');
              } else if (snapshot.hasData) {
                return HomeScreenWidget(snapshot.data, context);
              } else {
                return const Text('Empty data');
              }
            } else {
              return Text('State: ${snapshot.connectionState}');
            }
          },
        ),
      ),
    );
  }

  Widget HomeScreenWidget(quran, context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
            expandedHeight: 30.h,
            backgroundColor: const Color.fromARGB(255, 221, 250, 236),

            // pinned: true,
            floating: true,

            // toolbarHeight: 150,

            flexibleSpace: FlexibleSpaceBar(
              // centerTitle: true,

              background: Container(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(
                      top: 40.0, start: 40, end: 40),
                  child: Row(
                    children: [
                      Text(
                        "القرآن الكريم",
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: me_quranFont),
                      ),
                      Spacer(),
                      Container(
                          height: 27.h,
                          width: 27.w,
                          child: Image.asset(quranImage))
                    ],
                  ),
                ),
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        // AppColors.kTealColor,
                        Color.fromRGBO(56, 98, 65, 0.769),
                        Color.fromARGB(196, 196, 196, 0),
                      ],
                    ),
                    borderRadius: BorderRadiusDirectional.only(
                        bottomStart: Radius.circular(25),
                        bottomEnd: Radius.circular(25))),
              ),
            )),
        BuildSuraName(quran, context),
      ],
    );
  }
}

Widget BuildSuraName(quran, context) {
  return SliverToBoxAdapter(
      child: Container(
    color: const Color.fromARGB(255, 221, 250, 236),
    height: 988.h,
    child: ListView(
      physics: NeverScrollableScrollPhysics(),
      children: [
        for (int i = 0; i < 114; i++)
          Container(
            color: i % 2 == 0
                ? const Color.fromARGB(255, 253, 247, 230)
                : const Color.fromARGB(255, 253, 251, 240),
            child: TextButton(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(end: 15.0, start: 15),
                child: Row(
                  children: [
                    ArabicSuraNumber(i: i),
                    const SizedBox(
                      width: 5,
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [],
                    //   ),
                    // ),
                    Spacer(),
                    Text(
                      arabicName[i]['name'],
                      style: TextStyle(
                          fontSize: 20.sp,
                          color: Colors.black87,
                          fontFamily: me_quranFont,
                          shadows: [
                            Shadow(
                              offset: Offset(.5, .5),
                              blurRadius: 1.0,
                              color: Color.fromARGB(255, 130, 130, 130),
                            )
                          ]),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
              onPressed: () {
                fabIsClicked = false;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SurahBuilder(
                            arabic: quran[0],
                            sura: i,
                            suraName: arabicName[i]['name'],
                            ayah: 0,
                          )),
                );
              },
            ),
          ),
      ],
    ),
  ));
}
