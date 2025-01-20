String getPrayArabicName(String pray) {
  String prayName = "";
  if (pray == "fajr") {
    prayName = "الفجر";
  }
  if (pray == "sunrise") {
    prayName = "الشروق";
  }
  if (pray == "dhuhr") {
    prayName = "الظهر";
  }
  if (pray == "asr") {
    prayName = "العصر";
  }
  if (pray == "maghrib") {
    prayName = "المغرب";
  }
  if (pray == "isha") {
    prayName = "العشاء";
  }

  return prayName;
}
