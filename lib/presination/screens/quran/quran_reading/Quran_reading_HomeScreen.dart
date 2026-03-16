import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran/quran.dart';
import 'package:quran_v2/core/network/local/cashhelper.dart';
import 'package:quran_v2/core/utils/media_query_values.dart';
import 'package:quran_v2/core/utils/strings.dart';
import 'package:quran_v2/presination/controller/app_cubit.dart';
import 'package:quran_v2/presination/controller/app_states.dart';
import 'package:quran_v2/presination/screens/quran/quran_reading/no_book_mark_screen.dart';
import 'package:quran_v2/presination/screens/quran/quran_reading/settings.dart';
import 'package:quran_v2/presination/widgets/sliver_delegate.dart';
import 'package:quran_v2/presination/widgets/to_arabic_no_converter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/shared/components.dart';
import '../../../../core/utils/assets_path.dart';
import '../../../../core/utils/conestans.dart';
import '../../../../models/surah_model.dart';
import 'Sora.dart';
import 'mushaf_page_view_screen.dart';
import 'surah_builder.dart';

class QuranRootScreen extends StatefulWidget {
  const QuranRootScreen({super.key, required this.data});
  final dynamic data;

  @override
  State<QuranRootScreen> createState() => _QuranRootScreenState();
}

class _QuranRootScreenState extends State<QuranRootScreen> {
  int _currentIndex = 0;
  final GlobalKey<MushafPageViewScreenState> _mushafKey = GlobalKey();
  bool _showMainBottomNav = true;

  Future<void> _openBookmarks(BuildContext context) async {
    final int? lastPage = CashHelper.GetData(key: 'last_mushaf_page');
    setState(() {
      _currentIndex = 1;
      _showMainBottomNav = false;
    });

    if (lastPage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mushafKey.currentState?.jumpToPage(lastPage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = <Widget>[
      const QuranHomeScreenWidgt(),
      MushafPageViewScreen(
        key: _mushafKey,
        onToggleUI: (isShown) {
          setState(() {
            _showMainBottomNav = isShown;
          });
        },
      ),
      Center(
        child: Text(
          'المحفوظ',
          style: TextStyle(
            fontFamily: cairoFont,
            fontSize: context.width * 0.06,
            color: const Color(0xff592c01),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ];

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          appBar: (_currentIndex == 0)
              ? AppBar(
                  elevation: 0,
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Switch(
                        onChanged: (value) async {
                          debugPrint('Switch ${cubit.isMoshaf}');
                          cubit.ChangeisMoshaf(value);
                          ShowToust(
                              Text: cubit.isMoshaf
                                  ? 'وضع المشاف'
                                  : 'الوضع العادي',
                              state: ToustStates.SUCSESS);
                        },
                        value: cubit.isMoshaf,
                        activeThumbColor: const Color(0xff592c01),
                        activeTrackColor: const Color(0xffFFFBE8),
                        inactiveThumbColor: const Color(0xff592c01),
                        inactiveTrackColor: const Color(0xffFFFBE8)),
                  ),
                  actions: [
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
                            const Spacer(),
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
                    background: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xff592c01),
                            Color(0xff592c01),
                            Color(0xff592c01),
                          ],
                        ),
                      ),
                    ),
                  ))
              : null,
          body: widget.data && surahList.isNotEmpty
              ? tabs[_currentIndex]
              : const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xff592c01),
                  ),
                ),
          floatingActionButton: (_currentIndex == 0)
              ? FloatingActionButton(
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
                )
              : null,
          bottomNavigationBar: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: _showMainBottomNav ? 60 : 0,
            child: Wrap(
              children: [
                BottomNavigationBar(
                  currentIndex: _currentIndex,
                  selectedLabelStyle: const TextStyle(
                    fontFamily: cairoFont,
                    color: Color(0xff592c01),
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontFamily: cairoFont,
                    color: Color(0xff592c01),
                    fontWeight: FontWeight.bold,
                  ),
                  selectedItemColor: const Color(0xff592c01),
                  unselectedItemColor: const Color(0xff592c01).withOpacity(0.6),
                  backgroundColor: const Color(0xffFFFBE8),
                  onTap: (int index) async {
                    if (index == 2) {
                      await _openBookmarks(context);
                      return;
                    }
                    setState(() {
                      _currentIndex = index;
                      if (index == 1) {
                        _showMainBottomNav = false;
                      } else {
                        _showMainBottomNav = true;
                      }
                    });
                  },
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'الرئيسية',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.menu_book_rounded),
                      label: 'المصحف',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.bookmark),
                      label: 'المحفوظ',
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class QuranHomeScreen extends StatelessWidget {
  const QuranHomeScreen({
    Key? key,
    required this.data,
  }) : super(key: key);
  final dynamic data;
  @override
  Widget build(BuildContext context) {
    return QuranRootScreen(data: data);
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
  late AudioPlayer _audioPlayer;
  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;
  Timer? _debounce;

  Stream<PossitionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PossitionData>(
          _audioPlayer.positionStream,
          _audioPlayer.bufferedPositionStream,
          _audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PossitionData(
              position, bufferedPosition, duration ?? Duration.zero));
  String audioUrl = "";
  void playSuraAudio(int suraNumper) {
    audioUrl = getAudioURLBySurah(suraNumper, "ar.minshawi");
    print(audioUrl);
    _audioPlayer = AudioPlayer()..setUrl(audioUrl);
    _audioPlayer.positionStream;
    _audioPlayer.bufferedPositionStream;
    _audioPlayer.durationStream;
    // _audioPlayer.play;
  }

  @override
  void initState() {
    super.initState();
    // getConnectivity();
    _audioPlayer = AudioPlayer();
    _surahFiltered = surahList;
  }

  List<Surah> _surahFiltered = [];

  @override
  void dispose() {
    _audioPlayer.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScrollController? scrollController;

    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return CustomScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
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
                          const Spacer(),
                          const AutoSizeText(
                            "القرآن نور",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: cairoFont),
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
                                          _surahFiltered = surahList
                                              .where((s) =>
                                                  s.name
                                                      .contains(searchQuery) ||
                                                  s.arabicName
                                                      .contains(searchQuery))
                                              .toList();
                                        });

                                        if (_debounce?.isActive ?? false) {
                                          _debounce?.cancel();
                                        }

                                        _debounce = Timer(
                                            const Duration(milliseconds: 500),
                                            () {
                                          if (searchQuery.length > 3 ||
                                              searchQuery
                                                  .toString()
                                                  .contains(" ")) {
                                            setState(() {
                                              ayatFiltered =
                                                  searchWords(searchQuery);
                                            });
                                          } else {
                                            setState(() {
                                              ayatFiltered = null;
                                            });
                                          }
                                        });
                                      },
                                      style: const TextStyle(
                                        fontFamily: cairoFont,
                                        color: Color(0xff592c01),
                                      ),
                                      decoration: const InputDecoration(
                                        hintText: 'ابحث عن آية أو سورة',
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
                                        _surahFiltered = surahList;
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
                                      : const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.search,
                                            color: Color(0xff592c01),
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
              if (searchQuery.isNotEmpty) ...[
                if (_surahFiltered.isNotEmpty) ...[
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(
                          start: 16.0, end: 16.0, top: 16, bottom: 8),
                      child: Text(
                        "نتائج السور : ",
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: Color(0xff592c01),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: cairoFont,
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => buildSurahTile(context,
                          _surahFiltered[index], AppCubit.get(context)),
                      childCount: _surahFiltered.length,
                    ),
                  ),
                ],
                if (ayatFiltered != null && ayatFiltered["occurences"] > 0) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(
                          start: 16.0, end: 16.0, top: 16, bottom: 8),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          const Text(
                            "نتائج الآيات (عدد النتائج: ",
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              color: Color(0xff592c01),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: cairoFont,
                            ),
                          ),
                          Text(
                            (ayatFiltered["occurences"])
                                .toString()
                                .toArabicNumbers,
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(
                              color: Color(0xff592c01),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: cairoFont,
                            ),
                          ),
                          const Text(
                            ") : ",
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              color: Color(0xff592c01),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: cairoFont,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildAyahResultItem(context, index),
                      childCount: ayatFiltered["occurences"],
                    ),
                  ),
                ] else if (searchQuery.length > 3 && _surahFiltered.isEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(
                        child: Text(
                          "لا توجد نتائج",
                          style: TextStyle(
                              fontFamily: cairoFont,
                              fontSize: 18,
                              color: Color(0xff592c01)),
                        ),
                      ),
                    ),
                  ),
              ] else
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index.isOdd) {
                          return const Divider(height: 1);
                        }
                        final surahIndex = index ~/ 2;
                        return buildSurahTile(context, surahList[surahIndex],
                            AppCubit.get(context));
                      },
                      childCount: surahList.length * 2 - 1,
                    ),
                  ),
                ),
            ],
          );
        });
  }

  Widget buildSurahTile(BuildContext context, Surah surah, AppCubit cubit) {
    return Container(
      color: const Color.fromARGB(255, 253, 247, 230),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xff592c01),
          child: Text(
            "${surah.id}",
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          surah.name,
          style: const TextStyle(
            fontSize: 17,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontFamily: cairoFont,
          ),
        ),
        subtitle: Row(
          children: [
            Text(
              "عدد الآيات: ${surah.versesCount}",
              style: const TextStyle(
                fontFamily: cairoFont,
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
            const SizedBox(width: 10),
            surah.revelationPlace == "Makkah"
                ? Image.asset(
                    "assets/images/makkah.png",
                    height: 25,
                    width: 25,
                  )
                : Image.asset(
                    "assets/images/madinah.png",
                    height: 25,
                    width: 25,
                  )
          ],
        ),
        trailing: RichText(
          text: TextSpan(
            text: surahList[surah.id - 1].id.toString(),
            style: TextStyle(
                // fontWeight: FontWeight.bold,
                color: Colors.black, //fontWeight: FontWeight.bold,
                fontSize: 28.sp, // Text color
                fontFamily: arFont),
          ),
        ),
        onTap: () {
          fabIsClicked = false;
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => cubit.isMoshaf
                  ? SurahBuilder(
                      arabic: quran[0],
                      sura: surah.id - 1,
                      suraName: arabicName[surah.id - 1]['name'],
                      ayah: bookmarkedAyah,
                    )
                  : SurahPage(
                      surah: surah,
                      sura: surah.id - 1,
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAyahResultItem(BuildContext context, int index) {
    final result = ayatFiltered["result"][index];
    final surahNum = result["surah"];
    final verseNum = result["verse"];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: () {
          fabIsClicked = true;
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => SurahBuilder(
                arabic: quran[0],
                sura: surahNum - 1,
                suraName: arabicName[surahNum - 1]['name'],
                ayah: verseNum - 1,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 253, 247, 230),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xff592c01).withOpacity(0.1)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "آية ${verseNum.toString().toArabicNumbers}",
                      style: const TextStyle(
                        color: Color(0xff592c01),
                        fontSize: 12,
                        fontFamily: cairoFont,
                      ),
                    ),
                    Text(
                      "سورة ${getSurahNameArabic(surahNum)}",
                      style: const TextStyle(
                        color: Color(0xff592c01),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: cairoFont,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "${getVerse(surahNum, verseNum, verseEndSymbol: false)} ${verseNum.toString().toArabicNumbers}",
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Colors.black,
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
  }
}
