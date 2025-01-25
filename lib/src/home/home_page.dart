import 'dart:io';

import 'package:flutter/material.dart';
import 'package:payment_tracker/src/month/month_page.dart';
import 'package:payment_tracker/src/profile/profile_page.dart';
import 'package:payment_tracker/src/shared/balance_utils.dart';
import 'package:payment_tracker/src/shared/image_utils.dart';
import 'package:payment_tracker/src/summary/summary_page.dart';

import 'home_module.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  File? _imageFile;
  Image? image;
  late TabController _tabController;
  Widget month = Month(DateTime.now(), true);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      updateNewMonthBalance();
      var resultImage = await loadImage(_imageFile, image);
      setState(() {
        image = resultImage;
      });
    });
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openProfile() async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Profile()));

    if (result != null) {
      var resultImage = await loadImage(_imageFile, image);
      setState(() {
        image = resultImage;
        month = Month(DateTime.now(), true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: const Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.attach_money,
                color: Colors.white,
              ),
              SizedBox(
                  width: 8.0), // Adicione algum espaço entre o ícone e o texto
              Text(
                'MobiFin',
                style: TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                textHeightBehavior: TextHeightBehavior(
                    applyHeightToFirstAscent: false,
                    applyHeightToLastDescent: false),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: image != null
                  ? profileAvatar(image, context)
                  : defaultAvatar(context),
              onPressed: _openProfile,
            ),
          ],
        ),
        body: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                    child: Row(
                  children: [
                    const SizedBox(width: 35),
                    Text(getMonth()),
                    const SizedBox(width: 5),
                    const Icon(Icons.calendar_month),
                  ],
                )),
                const Tab(
                    child: Row(
                  children: [
                    SizedBox(width: 35),
                    Text('Resumo'),
                    SizedBox(width: 5),
                    Icon(Icons.summarize),
                  ],
                )),
              ],
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  month,
                  const SummaryPage(),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
