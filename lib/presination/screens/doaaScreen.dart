import 'package:flutter/material.dart';
import 'package:quran_v2/core/utils/media_query_values.dart';
import 'package:quran_v2/core/utils/strings.dart';
import 'package:quran_v2/presination/widgets/CategoryContent.dart';

class DoaaScreen extends StatelessWidget {
  const DoaaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<CategoryContentModel> DoaaCategoryContentList = [
      CategoryContentModel(
          title: "آداب وشروط الدعاء",
          id: 1,
          JsonPath: "assets/ادعيه/آداب وشروط الدعاء.json"),
      CategoryContentModel(
          title: "ادعية الرزق والبركة",
          id: 2,
          JsonPath: "assets/ادعيه/ادعية الرزق والبركة.json"),
      CategoryContentModel(
          title: "ادعية المتوفى",
          id: 3,
          JsonPath: "assets/ادعيه/ادعية المتوفى.json"),
      CategoryContentModel(
          title: "ادعية المغفرة والتوبة",
          id: 4,
          JsonPath: "assets/ادعيه/ادعية المغفرة والتوبة.json"),
      CategoryContentModel(
          title: "ادعية ختم القران",
          id: 5,
          JsonPath: "assets/ادعيه/ادعية ختم القران.json"),
      CategoryContentModel(
          title: "ادعية ذهاب الهم",
          id: 6,
          JsonPath: "assets/ادعيه/ادعية ذهاب الهم.json"),
      CategoryContentModel(
          title: "ادعية طلب العلم",
          id: 7,
          JsonPath: "assets/ادعيه/ادعية طلب العلم.json"),
      CategoryContentModel(
          title: "ادعية قرآنية",
          id: 8,
          JsonPath: "assets/ادعيه/ادعية قرآنية.json"),
      CategoryContentModel(
          title: "ادعية نبوية",
          id: 9,
          JsonPath: "assets/ادعيه/ادعية نبوية.json"),
      CategoryContentModel(
          title: "الدعاء المستجاب",
          id: 10,
          JsonPath: "assets/ادعيه/الدعاء المستجاب.json"),
      CategoryContentModel(
          title: "الدعاء المنهى عنه",
          id: 11,
          JsonPath: "assets/ادعيه/الدعاء المنهى عنه.json"),
      CategoryContentModel(
          title: "أوقات استجابة الدعاء",
          id: 12,
          JsonPath: "assets/ادعيه/أوقات استجابة الدعاء.json"),
      CategoryContentModel(
          title: "فضل الدعاء",
          id: 13,
          JsonPath: "assets/ادعيه/فضل الدعاء.json"),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff592c01),
        title: Text(
          "سبحان الله العظيم وبحمده",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: cairoFont,
            fontSize: context.width * 0.04,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: const SizedBox.shrink(),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              // SizedBox(
              //   height: context.height * 0.15,
              // ),
              // SizedBox(
              //   height: context.height * 0.05,
              // ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    height: context.height * 0.8,
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
                            DoaaCategoryContentList[index], context);
                      },
                      itemCount: DoaaCategoryContentList.length,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
