class QuranAudioModel {
  final List<SurahAudio> suras;

  QuranAudioModel({required this.suras});

  factory QuranAudioModel.fromJson(Map<String, dynamic> json) {
    return QuranAudioModel(
      suras: (json['suras'] as List)
          .map((surah) => SurahAudio.fromJson(surah))
          .toList(),
    );
  }
}

class SurahAudio {
  final String surahId;
  final String surahNameAr;
  final List<ReciterAudio> reciters;

  SurahAudio({
    required this.surahId,
    required this.surahNameAr,
    required this.reciters,
  });

  factory SurahAudio.fromJson(Map<String, dynamic> json) {
    return SurahAudio(
      surahId: json['surah_id'],
      surahNameAr: json['surah_name_ar'],
      reciters: (json['reciters'] as List)
          .map((reciter) => ReciterAudio.fromJson(reciter))
          .toList(),
    );
  }
}

class ReciterAudio {
  final String reciterId;
  final String reciterName;
  final String audioUrl;

  ReciterAudio({
    required this.reciterId,
    required this.reciterName,
    required this.audioUrl,
  });

  factory ReciterAudio.fromJson(Map<String, dynamic> json) {
    return ReciterAudio(
      reciterId: json['reciter_id'],
      reciterName: json['reciter_name'],
      audioUrl: json['audio_url'],
    );
  }
}
