import 'package:flutter/material.dart';
import 'package:quran_v2/core/utils/media_query_values.dart';
import 'package:quran_v2/core/utils/strings.dart';
import 'package:quran_v2/presination/widgets/CategoryContent.dart';

class AzkarScreen extends StatelessWidget {
  const AzkarScreen({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    List<CategoryContentModel> AzkarCategoryContentList = [
      CategoryContentModel(
           id: 1,
         title: "أذكار الاستيقاظ ",
          JsonPath: 'assets/اذكار/أذكار الاستيقاظ .json'),
      CategoryContentModel(
        
          id: 2,
          title: "أذكار الصباح ",
          JsonPath: 'assets/اذكار/أذكار الصباح .json'),
      CategoryContentModel(
        
          id: 3,
      title: "أذكار الصلاه ",
          JsonPath: 'assets/اذكار/أذكار الصلاه .json'),
      CategoryContentModel(
       
          id: 4,
          title: "أذكار الطعام ",
          JsonPath: 'assets/اذكار/أذكار الطعام .json'),
      CategoryContentModel(

          id: 5,
        title: "أذكار اللباس الجديد ",
          JsonPath: 'assets/اذكار/أذكار اللباس الجديد .json'),
      CategoryContentModel(
    
          id: 6,
         title: "أذكار المساء ",
          JsonPath: 'assets/اذكار/أذكار المساء .json'),
      CategoryContentModel(
        
          id: 7,
         title: "أذكار المسجد ",
          JsonPath: 'assets/اذكار/أذكار المسجد .json'),
      CategoryContentModel(
        
          id: 8,
         title: "أذكار النوم ",
          JsonPath: 'assets/اذكار/أذكار النوم .json'),
      CategoryContentModel(
        
          id: 9,
        title: "أذكار بعد الصلاة ",
          JsonPath: 'assets/اذكار/أذكار بعد الصلاة .json'),
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
                      crossAxisCount: 3,
                      crossAxisSpacing: context.width * 0.01,
                      mainAxisSpacing: context.width * 0.02,
                      mainAxisExtent: context.height * 0.15,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return CategoryContentCard(
                          AzkarCategoryContentList[index], context);
                    },
                    itemCount: AzkarCategoryContentList.length,
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
