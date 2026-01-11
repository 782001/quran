import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/services.dart';
import 'package:quran_v2/core/shared/components.dart';
import 'package:quran_v2/core/utils/assets_path.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/surah_model.dart';

int bookmarkedAyah = 1;
int bookmarkedSura = 1;
bool fabIsClicked = true;
late String fajrTime;
late String shroukTime;
late String duhrTime;
late String asrTime;
late String maghrbTime;
late String ishaTime;
List<String> favoritesList = []; // Store favorite items

final ItemScrollController itemScrollController = ItemScrollController();
final ItemPositionsListener itemPositionsListener =
    ItemPositionsListener.create();

String arabicFont = 'quran';
String hafs_smart_07Font = "hafs-smart-07";
double arabicFontSize = 28;
double mushafFontSize = 40;

Uri quranAppurl = Uri.parse(
    'https://play.google.com/store/apps/details?id=com.quran.quran_v3');
Uri contacturl = Uri.parse('https://api.whatsapp.com/send?phone=+201281859862');
Uri privacyurl = Uri.parse(
    'https://www.termsfeed.com/live/4121ff19-e482-46ac-8b5e-09ea612effaf');
Uri PlayStoreAcounturl = Uri.parse(
    'https://play.google.com/store/apps/developer?id=Abdullah+El-Awadi');

Future saveSettings() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('arabicFontSize', arabicFontSize.toInt());
  await prefs.setInt('mushafFontSize', mushafFontSize.toInt());
}

Future getSettings() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    arabicFontSize = prefs.getInt('arabicFontSize')!.toDouble();
    mushafFontSize = prefs.getInt('mushafFontSize')!.toDouble();
  } catch (_) {
    arabicFontSize = 28;
    mushafFontSize = 40;
  }
}

saveBookMark(surah, ayah) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt("surah", surah);
  await prefs.setInt("ayah", ayah);
  ShowToust(Text: 'تم حفظ الآيه', state: ToustStates.SUCSESS);
}

readBookmark() async {
  print("read book mark called");
  final prefs = await SharedPreferences.getInstance();
  try {
    bookmarkedAyah = prefs.getInt('ayah')!;
    bookmarkedSura = prefs.getInt('surah')!;
    return true;
  } catch (e) {
    return false;
  }
}

List<Map> arabicName = [
  {"surah": "1", "name": "الفاتحة"},
  {"surah": "2", "name": "البقرة"},
  {"surah": "3", "name": "آل عمران"},
  {"surah": "4", "name": "النساء"},
  {"surah": "5", "name": "المائدة"},
  {"surah": "6", "name": "الأنعام"},
  {"surah": "7", "name": "الأعراف"},
  {"surah": "8", "name": "الأنفال"},
  {"surah": "9", "name": "التوبة"},
  {"surah": "10", "name": "يونس"},
  {"surah": "11", "name": "هود"},
  {"surah": "12", "name": "يوسف"},
  {"surah": "13", "name": "الرعد"},
  {"surah": "14", "name": "ابراهيم"},
  {"surah": "15", "name": "الحجر"},
  {"surah": "16", "name": "النحل"},
  {"surah": "17", "name": "الإسراء"},
  {"surah": "18", "name": "الكهف"},
  {"surah": "19", "name": "مريم"},
  {"surah": "20", "name": "طه"},
  {"surah": "21", "name": "الأنبياء"},
  {"surah": "22", "name": "الحج"},
  {"surah": "23", "name": "المؤمنون"},
  {"surah": "24", "name": "النور"},
  {"surah": "25", "name": "الفرقان"},
  {"surah": "26", "name": "الشعراء"},
  {"surah": "27", "name": "النمل"},
  {"surah": "28", "name": "القصص"},
  {"surah": "29", "name": "العنكبوت"},
  {"surah": "30", "name": "الروم"},
  {"surah": "31", "name": "لقمان"},
  {"surah": "32", "name": "السجدة"},
  {"surah": "33", "name": "الأحزاب"},
  {"surah": "34", "name": "سبإ"},
  {"surah": "35", "name": "فاطر"},
  {"surah": "36", "name": "يس"},
  {"surah": "37", "name": "الصافات"},
  {"surah": "38", "name": "ص"},
  {"surah": "39", "name": "الزمر"},
  {"surah": "40", "name": "غافر"},
  {"surah": "41", "name": "فصلت"},
  {"surah": "42", "name": "الشورى"},
  {"surah": "43", "name": "الزخرف"},
  {"surah": "44", "name": "الدخان"},
  {"surah": "45", "name": "الجاثية"},
  {"surah": "46", "name": "الأحقاف"},
  {"surah": "47", "name": "محمد"},
  {"surah": "48", "name": "الفتح"},
  {"surah": "49", "name": "الحجرات"},
  {"surah": "50", "name": "ق"},
  {"surah": "51", "name": "الذاريات"},
  {"surah": "52", "name": "الطور"},
  {"surah": "53", "name": "النجم"},
  {"surah": "54", "name": "القمر"},
  {"surah": "55", "name": "الرحمن"},
  {"surah": "56", "name": "الواقعة"},
  {"surah": "57", "name": "الحديد"},
  {"surah": "58", "name": "المجادلة"},
  {"surah": "59", "name": "الحشر"},
  {"surah": "60", "name": "الممتحنة"},
  {"surah": "61", "name": "الصف"},
  {"surah": "62", "name": "الجمعة"},
  {"surah": "63", "name": "المنافقون"},
  {"surah": "64", "name": "التغابن"},
  {"surah": "65", "name": "الطلاق"},
  {"surah": "66", "name": "التحريم"},
  {"surah": "67", "name": "الملك"},
  {"surah": "68", "name": "القلم"},
  {"surah": "69", "name": "الحاقة"},
  {"surah": "70", "name": "المعارج"},
  {"surah": "71", "name": "نوح"},
  {"surah": "72", "name": "الجن"},
  {"surah": "73", "name": "المزمل"},
  {"surah": "74", "name": "المدثر"},
  {"surah": "75", "name": "القيامة"},
  {"surah": "76", "name": "الانسان"},
  {"surah": "77", "name": "المرسلات"},
  {"surah": "78", "name": "النبإ"},
  {"surah": "79", "name": "النازعات"},
  {"surah": "80", "name": "عبس"},
  {"surah": "81", "name": "التكوير"},
  {"surah": "82", "name": "الإنفطار"},
  {"surah": "83", "name": "المطففين"},
  {"surah": "84", "name": "الإنشقاق"},
  {"surah": "85", "name": "البروج"},
  {"surah": "86", "name": "الطارق"},
  {"surah": "87", "name": "الأعلى"},
  {"surah": "88", "name": "الغاشية"},
  {"surah": "89", "name": "الفجر"},
  {"surah": "90", "name": "البلد"},
  {"surah": "91", "name": "الشمس"},
  {"surah": "92", "name": "الليل"},
  {"surah": "93", "name": "الضحى"},
  {"surah": "94", "name": "الشرح"},
  {"surah": "95", "name": "التين"},
  {"surah": "96", "name": "العلق"},
  {"surah": "97", "name": "القدر"},
  {"surah": "98", "name": "البينة"},
  {"surah": "99", "name": "الزلزلة"},
  {"surah": "100", "name": "العاديات"},
  {"surah": "101", "name": "القارعة"},
  {"surah": "102", "name": "التكاثر"},
  {"surah": "103", "name": "العصر"},
  {"surah": "104", "name": "الهمزة"},
  {"surah": "105", "name": "الفيل"},
  {"surah": "106", "name": "قريش"},
  {"surah": "107", "name": "الماعون"},
  {"surah": "108", "name": "الكوثر"},
  {"surah": "109", "name": "الكافرون"},
  {"surah": "110", "name": "النصر"},
  {"surah": "111", "name": "المسد"},
  {"surah": "112", "name": "الإخلاص"},
  {"surah": "113", "name": "الفلق"},
  {"surah": "114", "name": "الناس"}
];

List<int> noOfVerses = [
  7,
  286,
  200,
  176,
  120,
  165,
  206,
  75,
  129,
  109,
  123,
  111,
  43,
  52,
  99,
  128,
  111,
  110,
  98,
  135,
  112,
  78,
  118,
  64,
  77,
  227,
  93,
  88,
  69,
  60,
  34,
  30,
  73,
  54,
  45,
  83,
  182,
  88,
  75,
  85,
  54,
  53,
  89,
  59,
  37,
  35,
  38,
  29,
  18,
  45,
  60,
  49,
  62,
  55,
  78,
  96,
  29,
  22,
  24,
  13,
  14,
  11,
  11,
  18,
  12,
  12,
  30,
  52,
  52,
  44,
  28,
  28,
  20,
  56,
  40,
  31,
  50,
  40,
  46,
  42,
  29,
  19,
  36,
  25,
  22,
  17,
  19,
  26,
  30,
  20,
  15,
  21,
  11,
  8,
  8,
  19,
  5,
  8,
  8,
  11,
  11,
  8,
  3,
  9,
  5,
  4,
  7,
  3,
  6,
  3,
  5,
  4,
  5,
  6
];

List arabic = [];
// List malayalam = [];
List quran = [];

Future readJson() async {
  final String response = await rootBundle.loadString(quranJson);
  final data = json.decode(response);
  arabic = data["quran"];
  // malayalam = data["malayalam"];
  return quran = [arabic];
  // return quran = [arabic, malayalam];
}

List<Surah> surahList = [];
Future<void> readSuraNameJson() async {
  final String response = await rootBundle.loadString('assets/surah.json');
  final data = await json.decode(response);
  for (var item in data["chapters"]) {
    surahList.add(Surah.fromMap(item));
  }
}

class JsonFileReader {
  final String jsonPath;

  JsonFileReader(this.jsonPath);

  Future<List<Map<String, dynamic>>> readJson() async {
    try {
      final String jsonString = await rootBundle.loadString(jsonPath);
      final List<dynamic> jsonResponse = jsonDecode(jsonString);
      return jsonResponse.map((item) => item as Map<String, dynamic>).toList();
    } catch (e) {
      print("Error reading JSON file: $e");
      return [];
    }
  }
}

List zikrNotfications = [
  "(ﷺ  صلي علي محمد)",
  "(لَبَّيْكَ اللَّهُمَّ لَبَّيْكَ، لَبَّيْكَ لاَ شَرِيكَ لَكَ لَبَّيْكَ، إِنَّ الْحَمْدَ، وَالنِّعْمَةَ، لَكَ وَالْمُلْكَ، لاَ شَرِيكَ لَكَ)",
  "(ربِّ اغفِرْ لي خطيئتي يومَ الدِّينَ)",
  "(أَحَبُّ الْكَلاَمِ إِلَى اللَّهِ أَرْبَعٌ: سُبْحَانَ اللَّهِ، وَالْحَمْدُ لِلَّهِ، وَلاَ إِلَهَ إِلاَّ اللَّهُ، وَاللَّهُ أَكْبَرُ، لاَ يَضُرُّكَ بِأَيِّهِنَّ بَدَأتَ)",
  "(اللَّهُمَّ اغْفِرِ لِي، وَارْحَمْنِي، وَاهْدِنِي، وَعَافِنِي وَارْزُقْنِي)",
  "(اللَّهُمَّ إنِّي أَسْأَلُكَ الهُدَى وَالتُّقَى، وَالْعَفَافَ وَالْغِنَى)",
  "(اللَّهُمَّ اهْدِنِي وَسَدِّدْنِي)",
  "(اللَّهُمَّ آتِنَا في الدُّنْيَا حَسَنَةً وفي الآخِرَةِ حَسَنَةً، وَقِنَا عَذَابَ النَّارِ)",
  "(اللَّهُمَّ إنِّي أَعُوذُ بكَ مِن زَوَالِ نِعْمَتِكَ، وَتَحَوُّلِ عَافِيَتِكَ، وَفُجَاءَةِ نِقْمَتِكَ، وَجَمِيعِ سَخَطِكَ)",
  "(اللَّهمَّ إنِّي أعوذُ بِك من شرِّ ما عَمِلتُ، ومن شرِّ ما لم أعمَلْ)",
  "(اللهم إني أعوذُ بكَ منَ الهمِّ والحزَنِ، وأعوذُ بكَ منَ العجزِ والكسلِ، وأعوذُ بكَ منَ الجُبنِ والبخلِ، وأعوذُ بكَ مِن غلبةِ الدَّينِ وقهرِ الرجالِ)",
  "(اللَّهُمَّ اغْفِرْ لي وَارْحَمْنِي وَاهْدِنِي وَارْزُقْنِي)",
  "ﷺ  صلي علي محمد",
  "(اللَّهُمَّ مُصَرِّفَ القُلُوبِ صَرِّفْ قُلُوبَنَا علَى طَاعَتِكَ)",
  "(اللهم انفَعْني بما علَّمتَني وعلِّمْني ما ينفَعُني وزِدْني عِلمًا).",
  "(اللَّهُمَّ إنِّي ظَلَمْتُ نَفْسِي ظُلْمًا كَثِيرًا، ولَا يَغْفِرُ الذُّنُوبَ إلَّا أنْتَ، فَاغْفِرْ لي مِن عِندِكَ مَغْفِرَةً إنَّكَ أنْتَ الغَفُورُ الرَّحِيمُ)",
  "(اللهمَّ إنَّي أعوذُ بك من شرِّ سمْعي، ومن شرِّ بصري، ومن شرِّ لساني، ومن شرِّ قلْبي، ومن شرِّ منيَّتي)",
  "(اللَّهمَّ إني أعوذُ بكَ من مُنكراتِ الأخلاقِ والأعمالِ والأَهواءِ والأدواءِ)",
  "(سبحان الله - الحمدلله - لا اله الا الله - الله اكبر)",
  "(لا اله الا انت سبحانك اني كنت من الظالمين)",
  "(اذكر الله)",
  "(اللهم أنت ربي لا إله إلا أنت، خلقتني وأنا عبدك، وأنا على عهدك، ووعدك ما استطعت، أعوذ بك من شر ما صنعت، أبوء لك بنعمتك علي، وأبوء بذنبي فاغفر لي فإنه لا يغفر الذنوب إلا أنت)",
  "(استغفر الله)",
  "(ﷺ  صلي علي محمد)",
  "(اللهم اعني)",
  "(اللهم نجني)",
  "(اللهم اغفرلي)",
  "(ﷺ  صلي علي محمد)",
  "(لا حول ولا قوة الا بالله)",
  "(اشهد ان لا اله الا الله واشهد ان محمد رسول الله)",
  "(ﷺ  صلي علي محمد)",
  "(رَبِّ اجْعَلْنِي مُقِيمَ الصَّلَاةِ وَمِن ذُرِّيَّتِي ۚ رَبَّنَا وَتَقَبَّلْ دُعَاءِ)",
  "(اللَّهمَّ إنِّي أسألُكَ مِنَ الخيرِ كلِّهِ عاجلِهِ وآجلِهِ، ما عَلِمْتُ منهُ وما لم أعلَمْ، وأعوذُ بِكَ منَ الشَّرِّ كلِّهِ عاجلِهِ وآجلِهِ، ما عَلِمْتُ منهُ وما لم أعلَمْ، اللَّهمَّ إنِّي أسألُكَ من خيرِ ما سألَكَ عبدُكَ ونبيُّكَ، وأعوذُ بِكَ من شرِّ ما عاذَ بِهِ عبدُكَ ونبيُّكَ، اللَّهمَّ إنِّي أسألُكَ الجنَّةَ وما قرَّبَ إليها من قَولٍ أو عملٍ، وأعوذُ بِكَ منَ النَّارِ وما قرَّبَ إليها من قولٍ أو عملٍ، وأسألُكَ أن تجعلَ كلَّ قَضاءٍ قضيتَهُ لي خيرًا)",
  "(رَبِّ أَوْزِعْنِي أَنْ أَشْكُرَ نِعْمَتَكَ الَّتِي أَنْعَمْتَ عَلَيَّ وَعَلَى وَالِدَيَّ وَأَنْ أَعْمَلَ صَالِحًا تَرْضَاهُ وَأَدْخِلْنِي بِرَحْمَتِكَ فِي عِبَادِكَ الصَّالِحِينَ)",
  "(رَبَّنَا لاَ تُؤَاخِذْنَا إِن نَّسِينَا أَوْ أَخْطَأْنَا رَبَّنَا وَلاَ تَحْمِلْ عَلَيْنَا إِصْرًا كَمَا حَمَلْتَهُ عَلَى الَّذِينَ مِن قَبْلِنَا رَبَّنَا وَلاَ تُحَمِّلْنَا مَا لاَ طَاقَةَ لَنَا بِهِ وَاعْفُ عَنَّا وَاغْفِرْ لَنَا وَارْحَمْنَا أَنتَ مَوْلاَنَا فَانصُرْنَا عَلَى الْقَوْمِ الْكَافِرِينَ)",
  "(رَّبِّ اغْفِرْ لِي وَلِوَالِدَيَّ)",
];

///goodcolor const Color quranPagesColor = Color(0xff276277);
///const Color quranPagesColor = Color(0xff4B919E);
///old green const Color quranPagesColor = Color.fromARGB(255, 85, 179, 101); //0xff457b9d
///const primaryC=Color(0xff795547);
///const primaryC=Color(0xff488395); //

// const Color primaryDarkColor = Color(0xFF2980B9);
// const Color accentDarkColor = Color(0xFFC0392B);
// const Color backgroundDarkColor = Color(0xFF2C3E50);
// const Color textDarkColor = Color(0xFFECF0F1);
// const Color headingDarkColor = Color(0xFFBDC3C7);
// const Color buttonDarkColor = Color(0xFF27AE60);
// const Color borderDarkColor = Color(0xFF34495E);
const List indexes = [
  [1, 2, 3, 4],
  [5, 6, 7, 8],
  [9, 10, 11, 12],
  [13, 14, 15, 16],
  [17, 18, 19, 20],
  [21, 22, 23, 24],
  [25, 26, 27, 28],
  [29, 30, 31, 32],
  [33, 34, 35, 36],
  [37, 38, 39, 40],
  [41, 42, 43, 44],
  [45, 46, 47, 48],
  [49, 50, 51, 52],
  [53, 54, 55, 56],
  [57, 58, 59, 60],
  [61, 62, 63, 64],
  [65, 66, 67, 68],
  [69, 70, 71, 72],
  [73, 74, 75, 76],
  [77, 78, 79, 80],
  [81, 82, 83, 84],
  [85, 86, 87, 88],
  [89, 90, 91, 92],
  [93, 94, 95, 96],
  [97, 98, 99, 100],
  [101, 102, 103, 104],
  [105, 106, 107, 108],
  [109, 110, 111, 112],
  [113, 114, 115, 116],
  [117, 118, 119, 120],
  [121, 122, 123, 124],
  [125, 126, 127, 128],
  [129, 130, 131, 132],
  [133, 134, 135, 136],
  [137, 138, 139, 140],
  [141, 142, 143, 144],
  [145, 146, 147, 148],
  [149, 150, 151, 152],
  [153, 154, 155, 156],
  [157, 158, 159, 160],
  [161, 162, 163, 164],
  [165, 166, 167, 168],
  [169, 170, 171, 172],
  [173, 174, 175, 176],
  [177, 178, 179, 180],
  [181, 182, 183, 184],
  [185, 186, 187, 188],
  [189, 190, 191, 192],
  [193, 194, 195, 196],
  [197, 198, 199, 200],
  [201, 202, 203, 204],
  [205, 206, 207, 208],
  [209, 210, 211, 212],
  [213, 214, 215, 216],
  [217, 218, 219, 220],
  [221, 222, 223, 224],
  [225, 226, 227, 228],
  [229, 230, 231, 232],
  [233, 234, 235, 236],
  [237, 238, 239, 240]
];

const List<String> fontFamilies = [
  "UthmanicHafs13",
  "AmiriQuran",
  "Taha",
  "me",
  "qaloon", //shows verse end sympol good
  "pdsm",
  "noor ehuda",
  "hafs-nastaleeq-ver10-org",
  "hafs-smart-07",
  "jomhuria-regular-full-org",
  "mada-regular-full",
  "markazi-text-regular-full-org",
  "noto-kufi-arabic-regular-full",
  "qumbul-v7-full",
  "qur-std",
  "shorooq-full-org",
];
