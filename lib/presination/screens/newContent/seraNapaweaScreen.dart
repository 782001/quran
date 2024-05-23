import 'package:flutter/material.dart';
import 'package:quran_v2/core/utils/media_query_values.dart';
import 'package:quran_v2/core/utils/strings.dart';
import 'package:quran_v2/presination/widgets/CategoryContent.dart';

class SeraNapaweaScreen extends StatelessWidget {
  const SeraNapaweaScreen({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    List<CategoryContentModel> SeraNapaweaCategoryContentList = [
      CategoryContentModel(
          id: 1,
          title: "حياة الرسول صلى الله عليه وسلم",
          JsonPath:
              'assets/السيره النبويه/حياة الرسول صلى الله عليه وسلم.json'),
      CategoryContentModel(
          id: 2,
          title: "سيرة زوجات وأولاد الرسول صلى الله عليه وسلم",
          JsonPath:
              'assets/السيره النبويه/سيرة زوجات وأولاد الرسول صلى الله عليه وسلم.json'),
      CategoryContentModel(
          id: 3,
          title: "غزوات الرسول صلى الله عليه وسلم",
          JsonPath:
              'assets/السيره النبويه/غزوات الرسول صلى الله عليه وسلم.json'),
      CategoryContentModel(
          id: 4,
          title: "نبذة عن حياة الرسول صلى الله عليه وسلم",
          JsonPath:
              'assets/السيره النبويه/نبذة عن حياة الرسول صلى الله عليه وسلم.json'),
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
          child: Column(
            children: [
              SizedBox(
                height: context.height * 0.15,
              ),
              SizedBox(
                height: context.height * 0.05,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: context.width * 0.01,
                      mainAxisSpacing: context.width * 0.02,
                      mainAxisExtent: context.height * 0.15,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return CategoryContentCard(
                          SeraNapaweaCategoryContentList[index], context);
                    },
                    itemCount: SeraNapaweaCategoryContentList.length,
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
