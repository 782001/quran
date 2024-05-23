import 'package:flutter/material.dart';
import 'package:quran_v2/core/utils/media_query_values.dart';
import 'package:quran_v2/core/utils/strings.dart';
import 'package:quran_v2/presination/widgets/CategoryContent.dart';

class AhadesScreen extends StatelessWidget {
  const AhadesScreen({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    List<CategoryContentModel> AhadesCategoryContentList = [
      CategoryContentModel(
          title: "أحاديث عامة",
          id: 1,
          JsonPath: 'assets/احاديث/أحاديث عامة.json'),
      CategoryContentModel(
          title: "أحاديث عن الصداقة",
          id: 2,
          JsonPath: 'assets/احاديث/أحاديث عن الصداقة.json'),
      CategoryContentModel(
          title: "أحاديث عن الصدق",
          id: 3,
          JsonPath: 'assets/احاديث/أحاديث عن الصدق.json'),
      CategoryContentModel(
          title: "أحاديث عن العلم",
          id: 4,
          JsonPath: 'assets/احاديث/أحاديث عن العلم.json'),
      CategoryContentModel(
          title: "أحاديث عن الماء",
          id: 5,
          JsonPath: 'assets/احاديث/أحاديث عن الماء.json'),
      CategoryContentModel(
          title: "أحاديث عن النظافة",
          id: 6,
          JsonPath: 'assets/احاديث/أحاديث عن النظافة.json'),
      CategoryContentModel(
          title: "أحاديث مبوبة",
          id: 7,
          JsonPath: 'assets/احاديث/أحاديث مبوبة.json'),
      CategoryContentModel(
          title: "الأربعون النووية",
          id: 8,
          JsonPath: 'assets/احاديث/الأربعون النووية.json'),
      CategoryContentModel(
          title: "العشرة المبشرين بالجنة",
          id: 9,
          JsonPath: 'assets/احاديث/العشرة المبشرين بالجنة.json'),
    ];

    return Scaffold(
      backgroundColor: const Color(0xffFFFBE8),
      appBar: AppBar(
        backgroundColor: const Color(0xff592c01),
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: cairoFont,
            fontSize: context.width * 0.06,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: const SizedBox.shrink(),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: context.height * 0.1,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: context.width * 0.01,
                        mainAxisSpacing: context.width * 0.02,
                        mainAxisExtent: context.height * 0.15,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return CategoryContentCard(
                            AhadesCategoryContentList[index], context);
                      },
                      itemCount: AhadesCategoryContentList.length,
                    ),
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
