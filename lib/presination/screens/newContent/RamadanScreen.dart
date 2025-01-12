import 'package:flutter/material.dart';
import 'package:quran_v2/core/utils/media_query_values.dart';
import 'package:quran_v2/presination/widgets/CategoryContent.dart';
import 'package:quran_v2/core/utils/assets_path.dart';

class RamadanScreen extends StatelessWidget {
  const RamadanScreen({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    List<CategoryContentModel> RamadanCategoryContentList = [
      CategoryContentModel(
          id: 1,
          title: "أحكام وفتاوى رمضان المبارك",
          JsonPath: 'assets/رمضان/أحكام وفتاوى رمضان المبارك.json'),
      CategoryContentModel(
          id: 2,
          title: "أدعية لشهر رمضان المبارك",
          JsonPath: 'assets/رمضان/أدعية لشهر رمضان المبارك.json'),
      CategoryContentModel(
          id: 3,
          title: "صحتك في شهر رمضان المبارك",
          JsonPath: 'assets/رمضان/صحتك في شهر رمضان المبارك.json'),
      CategoryContentModel(
          id: 4,
          title: "طرق ختم القران الكريم في رمضان",
          JsonPath: 'assets/رمضان/طرق ختم القران الكريم في رمضان.json'),
      CategoryContentModel(
          id: 5,
          title: "نصائح لشهر رمضان المبارك",
          JsonPath: 'assets/رمضان/نصائح لشهر رمضان المبارك.json'),
    ];

    return Stack(
      children: [
        const RamadanBackGroundWidget(),
        Scaffold(
          backgroundColor: Colors.transparent,
          // appBar: AppBar(
          //   backgroundColor: const Color(0xff592c01),
          //   title: Text(
          //     title,
          //     textAlign: TextAlign.center,
          //     style: TextStyle(
          //       fontFamily: cairoFont,
          //       fontSize: context.width * 0.06,
          //       color: Colors.white,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          //   centerTitle: true,
          //   leading: const SizedBox.shrink(),
          // ),

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
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: context.width * 0.01,
                            mainAxisSpacing: context.width * 0.02,
                            mainAxisExtent: context.height * 0.15,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return CategoryContentCard(
                                RamadanCategoryContentList[index], context);
                          },
                          itemCount: RamadanCategoryContentList.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class RamadanBackGroundWidget extends StatelessWidget {
  const RamadanBackGroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      ramadanbackgroundImage,
      fit: BoxFit.fill,
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
    );
  }
}
