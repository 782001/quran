import 'package:flutter/material.dart';
import 'package:quran_v2/core/utils/media_query_values.dart';
import 'package:quran_v2/core/utils/strings.dart';
import 'package:quran_v2/presination/widgets/CategoryContent.dart';

class QssIslamicScreen extends StatelessWidget {
  const QssIslamicScreen({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    List<CategoryContentModel> QssIslamicCategoryContentList = [
      CategoryContentModel(
          id: 1,
          title: "قصص الأنبياء",
          JsonPath: 'assets/قصص اسلاميه/قصص الأنبياء.json'),
      CategoryContentModel(
          id: 2,
          title: "أسماء زوجات الرسل والأنبياء",
          JsonPath: 'assets/قصص اسلاميه/أسماء زوجات الرسل والأنبياء.json'),
      CategoryContentModel(
          id: 3,
          title: "قصص الحيوان",
          JsonPath: 'assets/قصص اسلاميه/قصص الحيوان.json'),
      CategoryContentModel(
          id: 4,
          title: "قصص الصحابة",
          JsonPath: 'assets/قصص اسلاميه/قصص الصحابة.json'),
      CategoryContentModel(
          id: 5,
          title: "قصص الصحابيات",
          JsonPath: 'assets/قصص اسلاميه/قصص الصحابيات.json'),
      CategoryContentModel(
          id: 6,
          title: "قصص القرآن",
          JsonPath: 'assets/قصص اسلاميه/قصص القرآن.json'),
      CategoryContentModel(
          id: 7,
          title: "معجزات الأنبياء",
          JsonPath: 'assets/قصص اسلاميه/معجزات الأنبياء.json'),
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
                        mainAxisExtent: context.height * 0.18,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return CategoryContentCard(
                            QssIslamicCategoryContentList[index], context);
                      },
                      itemCount: QssIslamicCategoryContentList.length,
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
