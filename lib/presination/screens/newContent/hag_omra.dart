
import 'package:flutter/material.dart';
import 'package:quran_v2/core/utils/media_query_values.dart';
import 'package:quran_v2/core/utils/strings.dart';
import 'package:quran_v2/presination/widgets/CategoryContent.dart';

class HagOmraScreen extends StatelessWidget {
  const HagOmraScreen({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    List<CategoryContentModel> HagOmraCategoryContentList = [
      CategoryContentModel(
           id: 1,
         title: "أدعية متنوعة",
          JsonPath: 'assets/الحج والعمره/أدعية متنوعة.json'),
      CategoryContentModel(
        
          id: 2,
 title: "أركان الحج",
          JsonPath: 'assets/الحج والعمره/أركان الحج.json'),
      CategoryContentModel(
        
          id: 3,
 title: "الحج والعمرة",
          JsonPath: 'assets/الحج والعمره/الحج والعمرة.json'),
      CategoryContentModel(
       
          id: 4,
      title: "حجة التمتع",
          JsonPath: 'assets/الحج والعمره/حجة التمتع.json'),
      CategoryContentModel(

          id: 5,
 title: "شروط الحج",
          JsonPath: 'assets/الحج والعمره/شروط الحج.json'),
      CategoryContentModel(
    
          id: 6,
  title: "فضل الحج",
          JsonPath: 'assets/الحج والعمره/فضل الحج.json'),
      CategoryContentModel(
        
          id: 7,
    title: "مبطلات الحج",
          JsonPath: 'assets/الحج والعمره/مبطلات الحج.json'),
      CategoryContentModel(
        
          id: 8,
    title: "وقت الحج",
          JsonPath: 'assets/الحج والعمره/وقت الحج.json'),
   
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
                            HagOmraCategoryContentList[index], context);
                      },
                      itemCount: HagOmraCategoryContentList.length,
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
