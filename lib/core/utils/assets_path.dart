const String imageAssetsRoot = "assets/images/";
const String TextAssetsRoot = "assets/text/";
const String me_quranFont = "me_quran";
const String quranFont = "quran";

String quranImage = _getAssetsImagePath('quran.png');
String SplashImage = _getAssetsImagePath('splash.png');
String doaaImage = _getAssetsImagePath('doaa.png');
String azkarImage = _getAssetsImagePath('azkar.png');
String islamicImage = _getAssetsImagePath('islamic.png');
String sephaImage = _getAssetsImagePath('sepha.png');
String ahadesImage = _getAssetsImagePath('ahades.png');
String hag_omraImage = _getAssetsImagePath('hag_omra.png');
String qssIslamicImage = _getAssetsImagePath('qssIslamic.png');
String seraNabweyaImage = _getAssetsImagePath('seraNabweya.jpg');

String quranJson = _getAssetsTextPath('hafs_smart_v8.json');

String _getAssetsImagePath(String fileName) {
  return imageAssetsRoot + fileName;
}

String _getAssetsTextPath(String fileName) {
  return TextAssetsRoot + fileName;
}
