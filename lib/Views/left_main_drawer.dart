import 'package:flutter/material.dart';
import 'package:twisted_twine_workshopppe/Views/Views/backup_and_restore_page.dart';
import 'package:twisted_twine_workshopppe/Views/Views/crochet_hook_page.dart';
import 'package:twisted_twine_workshopppe/Views/Views/fabric_page.dart';
import 'package:twisted_twine_workshopppe/Views/Views/history_page.dart';
import 'package:twisted_twine_workshopppe/Views/Views/idea_page.dart';
import 'package:twisted_twine_workshopppe/Views/Views/other_fibres_page.dart';
import 'package:twisted_twine_workshopppe/Views/Views/pattern_library_page.dart';
import 'package:twisted_twine_workshopppe/Views/Views/product_catalogue_page.dart';
import 'package:twisted_twine_workshopppe/Views/Views/settings_page.dart';
import 'package:twisted_twine_workshopppe/Views/Views/timer_page.dart';
import 'package:twisted_twine_workshopppe/Views/Views/trimmings_page.dart';

import 'Views/accounting_page.dart';
import 'Views/crochet_thread_page.dart';
import 'Views/home_page.dart';
import 'Views/knitting_needle_page.dart';
import 'Views/miscellaneous_page.dart';
import 'Views/commissions_page.dart';
import 'Views/projects_page.dart';
import 'Views/todo_page.dart';
import 'Views/tools_page.dart';
import 'Views/yarn_page.dart';

class LeftMainDrawer extends StatelessWidget {
  const LeftMainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xffe7d0f5),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/ttc_image.jpg"), fit: BoxFit.cover),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Twisted Twine Workshoppe',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),

            title: const Text('Home'),
            //tileColor: const Color(0xffE9DCE5),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.alarm),

            title: const Text('Timer'),
            //tileColor: const Color(0xffE9DCE5),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TimerPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.format_list_bulleted),

            title: const Text('Commissions'),
            //tileColor: const Color(0xffE9DCE5),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CommissionsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.checklist_rounded),
            title: const Text('Projects'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProjectsPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.sticky_note_2_outlined),
            title: const Text('Ideas'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const IdeaPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('History'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HistoryPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.check),
            title: const Text('To Do'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const TodoPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.grass_rounded),
            title: const Text('Yarn'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const YarnPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.grass),
            title: const Text('Crochet Thread'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CrochetThreadPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.grass_sharp),
            title: const Text('Other Fibres'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OtherFibresPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.air_rounded),
            title: const Text('Fabrics'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const FabricsPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.auto_awesome_rounded),
            title: const Text('Knitting Needles'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const KnittingNeedlePage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.auto_awesome),
            title: const Text('Crochet Hooks'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CrochetHookPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.content_cut),
            title: const Text('Trimmings'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TrimmingsPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.build_outlined),
            title: const Text('Tools List'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ToolsPage()));
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.collections_bookmark_outlined),
            title: const Text('Product Catalogue'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProductCataloguePage()));
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.library_books_outlined),
          //   title: const Text('Pattern Library'),
          //   onTap: () {
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => const PatternLibraryPage()));
          //   },
          // ),
          ListTile(
            leading: const Icon(Icons.miscellaneous_services),
            title: const Text('Miscellaneous'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MiscellaneousPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_outlined),
            title: const Text('Accounting'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AccountingPage()));
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.backup_outlined),
          //   title: const Text('Backup and Restore'),
          //   onTap: () {
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => BackupAndRestorePage()));
          //   },
          // ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsPage()));
            },
          ),
        ],
      ),
    );
  }
}
