import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:qcf_quran/qcf_quran.dart';
import 'package:quran/quran.dart' as quran;
import 'package:quran_v2/core/network/local/cashhelper.dart';
import 'package:quran_v2/core/shared/components.dart';
import 'package:quran_v2/core/utils/conestans.dart';
import 'package:quran_v2/main.dart';
import 'package:quran_v2/presination/widgets/sura_audio_player.dart';
import 'package:quran_v2/presination/widgets/to_arabic_no_converter.dart';

class MushafPageViewScreen extends StatefulWidget {
  final void Function(bool)? onToggleUI;
  const MushafPageViewScreen({super.key, this.onToggleUI});

  @override
  State<MushafPageViewScreen> createState() => MushafPageViewScreenState();
}

class MushafPageViewScreenState extends State<MushafPageViewScreen> {
  static const int _minPage = 1;
  static const int _maxPage = 604;

  late final PageController _pageController;
  final ValueNotifier<List<int>> _highlights = ValueNotifier<List<int>>([]);

  int _currentPageNumber = _minPage;
  bool _isDarkMode = false;
  double _mushafFontSize = 49.0;
  bool _showFontSizeSlider = false;
  bool _showUI = false;

  int? _selectedSurah;
  int? _selectedVerse;

  AudioPlayer? _audioPlayer;
  List<dynamic> _tafseerData = [];

  @override
  void initState() {
    super.initState();
    _currentPageNumber =
        CashHelper.GetData(key: 'last_mushaf_page') ?? _minPage;
    // _mushafFontSize =
    //     CashHelper.GetData(key: 'mushaf_font_size')?.toDouble() ?? 40.0;
    _pageController = PageController(initialPage: _currentPageNumber - 1);
    _loadTafseerData();
    _audioPlayer = AudioPlayer();
  }

  Future<void> _loadTafseerData() async {
    try {
      final String response =
          await rootBundle.loadString('assets/tafseer.json');
      setState(() {
        _tafseerData = jsonDecode(response);
      });
    } catch (e) {
      dev.log("Error loading tafseer: $e");
    }
  }

  String _getTafseerText(int surahNumber, int ayaNumber) {
    if (_tafseerData.isEmpty) return 'جاري تحميل التفسير...';
    try {
      final tafseer = _tafseerData.firstWhere(
        (element) =>
            element['number'] == surahNumber.toString() &&
            element['aya'] == ayaNumber.toString(),
        orElse: () => null,
      );
      return tafseer != null ? tafseer['text'] : 'تفسير الآيه غير متاح';
    } catch (e) {
      return 'تفسير الآيه غير متاح';
    }
  }

  Future<void> _playVerseAudio(int surahNumber, int verseNumber) async {
    try {
      final isConnected = await InternetConnectionChecker().hasConnection;
      if (!isConnected) {
        ShowToust(Text: "لا يوجد انترنت", state: ToustStates.ERROR);
        return;
      }

      String audioUrl =
          quran.getAudioURLByVerse(surahNumber, verseNumber, "ar.minshawi");

      Uri assetUri = await getAssetUri('assets/images/quran.png');

      await _audioPlayer?.setAudioSource(AudioSource.uri(
        Uri.parse(audioUrl),
        tag: MediaItem(
          id: '$surahNumber-$verseNumber',
          album: quran.getSurahNameArabic(surahNumber),
          title: "آية رقم $verseNumber",
          artUri: assetUri,
        ),
      ));
      _audioPlayer?.play();
      ShowToust(Text: "جاري التشغيل...", state: ToustStates.SUCSESS);
    } catch (e) {
      dev.log("Error playing audio: $e");
      ShowToust(Text: "خطأ في تشغيل الصوت", state: ToustStates.ERROR);
    }
  }

  void _showVerseActions(int surahNumber, int verseNumber) {
    setState(() {
      _selectedSurah = surahNumber;
      _selectedVerse = verseNumber;
    });

    final Color primary = _isDarkMode ? Colors.white : const Color(0xff592c01);
    final Color surface =
        _isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xffFFFBE8);
    final Color textColor = _isDarkMode ? Colors.white70 : Colors.black;

    showModalBottomSheet(
      context: context,
      backgroundColor: surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "سورة ${quran.getSurahNameArabic(surahNumber)} - آية ${verseNumber.toArabicNumbers}",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: Icon(Icons.comment, color: primary),
                  title: Text('تفسير الآية',
                      style: TextStyle(fontFamily: 'Cairo', color: textColor)),
                  onTap: () {
                    Navigator.pop(context);
                    _showTafsirDialog(surahNumber, verseNumber);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.play_arrow, color: primary),
                  title: Text('استماع للآية',
                      style: TextStyle(fontFamily: 'Cairo', color: textColor)),
                  onTap: () {
                    Navigator.pop(context);
                    _playVerseAudio(surahNumber, verseNumber);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.copy, color: primary),
                  title: Text('نسخ الآية',
                      style: TextStyle(fontFamily: 'Cairo', color: textColor)),
                  onTap: () async {
                    Navigator.pop(context);
                    String textToCopy = quran.getVerse(surahNumber, verseNumber,
                        verseEndSymbol: true);
                    await Clipboard.setData(ClipboardData(text: textToCopy));
                    ShowToust(Text: "تم النسخ", state: ToustStates.SUCSESS);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.bookmark_add, color: primary),
                  title: Text('حفظ في العلامات',
                      style: TextStyle(fontFamily: 'Cairo', color: textColor)),
                  onTap: () {
                    Navigator.pop(context);
                    saveBookMark(surahNumber, verseNumber);
                  },
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      setState(() {
        _selectedSurah = null;
        _selectedVerse = null;
      });
    });
  }

  void _showTafsirDialog(int surahNumber, int verseNumber) {
    final tafseerText = _getTafseerText(surahNumber, verseNumber);
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: const Color(0xff592c01),
          title: const Text(
            'تفسير الآية',
            style: TextStyle(
              fontFamily: 'Cairo',
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Text(
              tafseerText,
              style: const TextStyle(
                fontFamily: 'Cairo',
                color: Colors.white70,
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إغلاق',
                  style: TextStyle(color: Colors.white, fontFamily: 'Cairo')),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _highlights.dispose();
    _audioPlayer?.dispose();
    super.dispose();
  }

  String get _pageInfoText {
    try {
      final pageData = quran.getPageData(_currentPageNumber);
      if (pageData.isEmpty) return '';
      final int surah = pageData.first['surah'];
      final int verse = pageData.first['start'];

      final int juz = quran.getJuzNumber(surah, verse);
      final hizbData = QuranData.getHizbAndQuarter(surah, verse);
      final int hizb = hizbData['hizb']!;
      final int quarter = hizbData['quarter']!;

      return "الجزء $juz   |   الحزب $hizb  |  الربع $quarter";
    } catch (e) {
      return '';
    }
  }

  void jumpToPage(int pageNumber) {
    final int target = pageNumber.clamp(_minPage, _maxPage);
    _pageController.jumpToPage(target - 1);
    setState(() => _currentPageNumber = target);
  }

  @override
  Widget build(BuildContext context) {
    final Color primary = _isDarkMode ? Colors.white : const Color(0xff592c01);
    final Color surface =
        _isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xffFFFBE8);
    final Color textColor = _isDarkMode ? Colors.white70 : Colors.black;
    final Color verseNumberColor =
        _isDarkMode ? const Color(0xffFFFBE8) : primary;

    return Material(
      color: surface,
      child: Stack(
        children: [
          // Main Content Area (Fullscreen)
          Positioned.fill(
            child: SafeArea(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  setState(() {
                    _showUI = !_showUI;
                    if (_showUI == false) {
                      _showFontSizeSlider = false;
                    }
                  });
                  widget.onToggleUI?.call(_showUI);
                },
                child: Stack(
                  children: [
                    PageviewQuran(
                      sp: (_mushafFontSize / 50.0).clamp(0.5, 1.5),
                      controller: _pageController,
                      initialPageNumber: _currentPageNumber,
                      h: (_mushafFontSize / 50.0).clamp(0.5, 1.5),
                      onPageChanged: (int pageNumber) {
                        setState(() {
                          _currentPageNumber = pageNumber;
                        });
                        CashHelper.SaveData(
                            key: 'last_mushaf_page', value: pageNumber);
                      },
                      onLongPress: (int surahNumber, int verseNumber) {
                        // Keep Ayah actions on single tap as per previous requirement
                        setState(() {
                          _selectedSurah = surahNumber;
                          _selectedVerse = verseNumber;
                        });
                        _showVerseActions(surahNumber, verseNumber);
                      },
                      verseBackgroundColor: (int surah, int verse) {
                        if (surah == _selectedSurah &&
                            verse == _selectedVerse) {
                          return Colors.deepOrange.withOpacity(0.25);
                        }
                        return null;
                      },
                      theme: QcfThemeData(
                        pageBackgroundColor: surface,
                        verseTextColor: textColor,
                        verseNumberColor: verseNumberColor,
                        basmalaColor: textColor,
                        headerTextColor: Colors.black,
                      ),
                    ),

                    // Floating Font Size Control
                    if (_showFontSizeSlider && _showUI)
                      Positioned(
                        bottom: 100,
                        left: 20,
                        right: 20,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 300),
                          builder: (context, value, child) {
                            return Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: Opacity(
                                opacity: value,
                                child: child,
                              ),
                            );
                          },
                          child: Material(
                            elevation: 12,
                            borderRadius: BorderRadius.circular(20),
                            color: surface,
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border:
                                    Border.all(color: primary.withOpacity(0.1)),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.text_fields,
                                              color: primary, size: 20),
                                          const SizedBox(width: 8),
                                          Text(
                                            "حجم الخط",
                                            style: TextStyle(
                                                fontFamily: 'Cairo',
                                                color: primary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        icon: Icon(Icons.close,
                                            color: primary, size: 20),
                                        onPressed: () => setState(
                                            () => _showFontSizeSlider = false),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Slider(
                                    value: _mushafFontSize,
                                    min: 30.0,
                                    max: 90.0,
                                    activeColor: primary,
                                    inactiveColor: primary.withOpacity(0.2),
                                    onChanged: (value) {
                                      setState(() {
                                        _mushafFontSize = value;
                                      });
                                      CashHelper.SaveData(
                                          key: 'mushaf_font_size',
                                          value: value.toInt());
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Custom Top Bar (Animated)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: _showUI ? 0 : -100,
            left: 0,
            right: 0,
            child: Material(
              elevation: 4,
              color: surface,
              child: SafeArea(
                bottom: false,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () =>
                            setState(() => _isDarkMode = !_isDarkMode),
                        icon: Icon(
                          _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                          color: primary,
                          size: 22,
                        ),
                      ),
                      Container(
                        height: 35,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: primary.withOpacity(0.07),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: quran
                                .getPageData(_currentPageNumber)
                                .first['surah'],
                            hint: Text(
                              "السورة",
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                color: primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            icon: Icon(Icons.keyboard_arrow_down,
                                color: primary, size: 18),
                            dropdownColor: surface,
                            items: List.generate(114, (index) {
                              int surahNumber = index + 1;
                              return DropdownMenuItem(
                                value: surahNumber,
                                child: Text(
                                  quran.getSurahNameArabic(surahNumber),
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    color: primary,
                                    fontSize: 15,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                              );
                            }),
                            onChanged: (val) {
                              if (val != null) {
                                int startPage = quran.getPageNumber(val, 1);
                                jumpToPage(startPage);
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.format_size, color: primary, size: 22),
                        onPressed: () => setState(
                            () => _showFontSizeSlider = !_showFontSizeSlider),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            color: primary.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              _pageInfoText,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                color: primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Page Navigation Bar (Indicator) (Animated)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: _showUI ? 0 : -100,
            left: 0,
            right: 0,
            child: Material(
              elevation: 4,
              color: surface,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  border:
                      Border(top: BorderSide(color: primary.withOpacity(0.1))),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => jumpToPage(_currentPageNumber + 1),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: primary.withOpacity(0.05),
                          shape: BoxShape.circle,
                        ),
                        child:
                            Icon(Icons.chevron_left, color: primary, size: 30),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          "صفحة ${_currentPageNumber.toArabicNumbers} من ${_maxPage.toArabicNumbers}",
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                            color: primary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => jumpToPage(_currentPageNumber - 1),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: primary.withOpacity(0.05),
                          shape: BoxShape.circle,
                        ),
                        child:
                            Icon(Icons.chevron_right, color: primary, size: 30),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
