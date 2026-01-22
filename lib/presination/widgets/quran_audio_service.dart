import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class QuranAudioService {
  static final QuranAudioService _instance = QuranAudioService._internal();
  factory QuranAudioService() => _instance;
  QuranAudioService._internal();

  Future<String> _baseDir() async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/quran_audio';
  }

  Future<String> getSurahPath({
    required String reciterName,
    required int surahNumber,
  }) async {
    final base = await _baseDir();
    final reciterDir = Directory('$base/$reciterName');

    if (!await reciterDir.exists()) {
      await reciterDir.create(recursive: true);
    }

    final sura = surahNumber.toString().padLeft(3, '0');
    return '${reciterDir.path}/$sura.mp3';
  }

  Future<bool> isDownloaded({
    required String reciterName,
    required int surahNumber,
  }) async {
    final path = await getSurahPath(
      reciterName: reciterName,
      surahNumber: surahNumber,
    );
    return File(path).exists();
  }

  Future<void> downloadSurah({
    required String url,
    required String reciterName,
    required int surahNumber,
    required Function(double) onProgress,
  }) async {
    final path = await getSurahPath(
      reciterName: reciterName,
      surahNumber: surahNumber,
    );

    await Dio().download(
      url,
      path,
      onReceiveProgress: (rec, total) {
        if (total > 0) onProgress(rec / total);
      },
    );
  }

  /// ===== دالة جديدة =====
  /// ترجع كل السور المحملة على الجهاز
  Future<List<Map<String, dynamic>>> getAllDownloadedSurahs() async {
    final base = await _baseDir();
    final baseDir = Directory(base);
    if (!await baseDir.exists()) return [];

    final List<Map<String, dynamic>> downloaded = [];

    final reciters = baseDir.listSync(); // كل مجلدات الشيوخ
    for (var reciterDir in reciters) {
      if (reciterDir is Directory) {
        final reciterName = reciterDir.path.split('/').last;

        final files = reciterDir.listSync();
        for (var file in files) {
          if (file is File && file.path.endsWith('.mp3')) {
            // اسم السورة من رقم الملف
            final fileName = file.path.split('/').last; // مثال: 001.mp3
            final suraNumber = int.tryParse(fileName.replaceAll('.mp3', '')) ?? 0;
            final suraName = suraNameFromNumber(suraNumber); // تابع لتحويل الرقم لاسم السورة

            downloaded.add({
              "suraNumber": suraNumber,
              "suraName": suraName,
              "reciterName": reciterName,
              "path": file.path,
            });
          }
        }
      }
    }

    return downloaded;
  }

  /// دالة مساعدة لتحويل رقم السورة لاسمه
  String suraNameFromNumber(int number) {
    const suraNames = [
      "", // لتخطي index 0
      "الفاتحة",
      "البقرة",
      "آل عمران",
      "النساء",
      "المائدة",
      "الأنعام",
      "الأعراف",
      "الأنفال",
      "التوبة",
      "يونس",
      "هود",
      "يوسف",
      "الرعد",
      "إبراهيم",
      "الحجر",
      "النحل",
      "الإسراء",
      "الكهف",
      "مريم",
      "طه",
      "الأنبياء",
      "الحج",
      "المؤمنون",
      "النّور",
      "الفرقان",
      "الشعراء",
      "النمل",
      "القصص",
      "العنكبوت",
      "الروم",
      "لقمان",
      "السجدة",
      "الأحزاب",
      "سبأ",
      "فاطر",
      "يس",
      "الصافات",
      "ص",
      "الزمر",
      "غافر",
      "فصلت",
      "الشورى",
      "الزخرف",
      "الدخان",
      "الجاثية",
      "الأحقاف",
      "محمد",
      "الفتح",
      "الحجرات",
      "ق",
      "الذاريات",
      "الطور",
      "النجم",
      "القمر",
      "الرحمن",
      "الواقعة",
      "الحديد",
      "المجادلة",
      "الحشر",
      "الممتحنة",
      "الصف",
      "الجمعة",
      "المنافقون",
      "التغابن",
      "الطلاق",
      "التحريم",
      "الملك",
      "القلم",
      "الحاقة",
      "المعارج",
      "نوح",
      "الجن",
      "المزمل",
      "المدثر",
      "القيامة",
      "الإنسان",
      "المرسلات",
      "النبأ",
      "النازعات",
      "عبس",
      "التكوير",
      "الإنفطار",
      "المطففين",
      "الإنشقاق",
      "البروج",
      "الطارق",
      "الأعلى",
      "الغاشية",
      "الفجر",
      "البلد",
      "الشمس",
      "الليل",
      "الضحى",
      "الشرح",
      "التين",
      "العلق",
      "القدر",
      "البينة",
      "الزلزلة",
      "العاديات",
      "القارعة",
      "التكاثر",
      "العصر",
      "الهمزة",
      "الفيل",
      "قريش",
      "الماعون",
      "الكوثر",
      "الكافرون",
      "النصر",
      "المسد",
      "الإخلاص",
      "الفلق",
      "الناس"
    ];

    if (number > 0 && number < suraNames.length) {
      return suraNames[number];
    }
    return "سورة غير معروفه";
  }
}
