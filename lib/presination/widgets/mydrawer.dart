import 'package:flutter/material.dart';
import 'package:quran_v2/core/utils/media_query_values.dart';
import 'package:quran_v2/core/utils/strings.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/utils/assets_path.dart';
import '../../core/utils/conestans.dart';
import '../screens/settings.dart';
import 'package:auto_size_text/auto_size_text.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                Image.asset(
                  quranImage,
                  height: 9.h,
                ),
                const AutoSizeText(
                  "القرآن الكريم",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: me_quranFont),
                ),
              ],
            ),
          ),
          // ListTile(
          //   leading: const Icon(
          //     Icons.settings,
          //   ),
          //   title: const Text(
          //     'الاعدادات',
          //   ),
          //   onTap: () {
          //     Navigator.pop(context);
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => const Settings()));
          //   },
          // ),
          ListTile(
            leading: const Icon(
              Icons.share,
              color: Color(0xff592c01),
            ),
            title: Text(
              'مشاركه',
              style: TextStyle(
                fontFamily: cairoFont,
                fontSize: context.width * 0.04,
                color: const Color(0xff592c01),
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Share.share(''' القرآن الكريم بدون نت أو اعلانات\n
يمكنك تحميل البرنامج من:$quranAppurl''');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.link_outlined,
              color: Color(0xff592c01),
            ),
            title: Text(
              'مزيد من التطبيقات ',
              style: TextStyle(
                fontFamily: cairoFont,
                fontSize: context.width * 0.04,
                color: const Color(0xff592c01),
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () async {
              if (!await launchUrl(PlayStoreAcounturl,
                  mode: LaunchMode.externalApplication)) {
                throw 'Could not launch $PlayStoreAcounturl';
              }
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.contact_support,
              color: Color(0xff592c01),
            ),
            title: Text(
              'للتواصل',
              style: TextStyle(
                fontFamily: cairoFont,
                fontSize: context.width * 0.04,
                color: const Color(0xff592c01),
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () async {
              if (!await launchUrl(contacturl,
                  mode: LaunchMode.externalApplication)) {
                throw 'Could not launch $contacturl';
              }
            },
          ),
        ],
      ),
    );
  }
}
