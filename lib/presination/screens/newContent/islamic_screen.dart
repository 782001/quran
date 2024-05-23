import 'package:flutter/material.dart';
import 'package:quran_v2/core/utils/media_query_values.dart';
import 'package:quran_v2/core/utils/strings.dart';
import 'package:quran_v2/presination/widgets/CategoryContent.dart';

class IslamicScreen extends StatelessWidget {
  const IslamicScreen({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    List<CategoryContentModel> IslamicCategoryContentList = [
      CategoryContentModel(
           id: 1,
         title: "55 وصية من النبى",
          JsonPath: 'assets/اسلاميات/55 وصية من النبى.json'),
      CategoryContentModel(
        
          id: 2,
        title: "الإيمان بالله تعالى",
          JsonPath: 'assets/اسلاميات/الإيمان بالله تعالى.json'),
      CategoryContentModel(
        
          id: 3,
   title: "الجنة ماهى وما درجاتها ووصفها",
          JsonPath: 'assets/اسلاميات/الجنة ماهى وما درجاتها ووصفها.json'),
      CategoryContentModel(
       
          id: 4,
        title: "الرقية الشرعية",
          JsonPath: 'assets/اسلاميات/الرقية الشرعية.json'),
      CategoryContentModel(

          id: 5,
    title: "رياض الصالحين",
          JsonPath: 'assets/اسلاميات/رياض الصالحين.json'),
      CategoryContentModel(
    
          id: 6,
    title: "سنن مؤكدة",
          JsonPath: 'assets/اسلاميات/سنن مؤكدة.json'),
      CategoryContentModel(
        
          id: 7,
      title: "علمنى شيء فى الإسلام",
          JsonPath: 'assets/اسلاميات/علمنى شيء فى الإسلام.json'),
      CategoryContentModel(
        
          id: 8,
      title: "فرص ذهبية",
          JsonPath: 'assets/اسلاميات/فرص ذهبية.json'),
      CategoryContentModel(
        
          id: 9,
          title: "فضائل الاعمال عند الله تعالى",
          JsonPath: 'assets/اسلاميات/فضائل الاعمال عند الله تعالى.json'),
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
                          IslamicCategoryContentList[index], context);
                    },
                    itemCount: IslamicCategoryContentList.length,
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
