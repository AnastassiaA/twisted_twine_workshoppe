import 'package:flutter/material.dart';
import 'knitting_needle_type_page.dart';

import 'craft_type_page.dart';

class MiscellaneousPage extends StatelessWidget {
  const MiscellaneousPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Miscellaneous"),
          actions: const [],
        ),
        body: ListView(
          children: [
            const ListTile(
              title: Text("Brands"),
            ),
            const ListTile(
              title: Text("Sellers"),
            ),
            ListTile(
              title: const Text("Knitting Needle Type"),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const KnittingNeedleTypePage())),
            ),
            ListTile(
              title: const Text("Craft Types"),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CraftTypePage())),
            ),
            const ListTile(
              title: Text("Infographics and Charts"),
            ),
          ],
        ));
  }
}
