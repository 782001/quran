import 'package:flutter/material.dart';
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
          ListTile(
            leading: const Icon(
              Icons.settings,
            ),
            title: const Text(
              'الاعدادات',
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Settings()));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.share,
            ),
            title: const Text(
              'مشاركه',
            ),
            onTap: () {
              Share.share('''* القرآن الكريم*\n
يمكنك تحميل البرنامج من:$quranAppurl''');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.link_outlined,
            ),
            title: const Text(
              'حساب جيت هاب',
            ),
            onTap: () async {
              if (!await launchUrl(GitHuburl,
                  mode: LaunchMode.externalApplication)) {
                throw 'Could not launch ${GitHuburl}';
              }
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.contact_support,
            ),
            title: const Text(
              'للتواصل',
            ),
            onTap: () async {
              if (!await launchUrl(contacturl,
                  mode: LaunchMode.externalApplication)) {
                throw 'Could not launch ${contacturl}';
              }
            },
          ),
        ],
      ),
    );
  }
}
