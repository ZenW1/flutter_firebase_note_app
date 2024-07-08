import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jong_jam/l10n/l10n.dart';
import 'package:jong_jam/todo/view/doing_status_page.dart';

import '../../bloc/todo/todo_bloc.dart';
import '../../shared/constant/dimensions.dart';
import 'home_page_view.dart';

class HomeMainPage extends StatefulWidget {
  const HomeMainPage({super.key});

  @override
  State<HomeMainPage> createState() => _HomeMainPageState();
}

class _HomeMainPageState extends State<HomeMainPage> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: TabBar(
                physics: const NeverScrollableScrollPhysics(),
                isScrollable: false,
                tabs: [
                  Tab(text: AppLocalizations.of(context).todo),
                  Tab(text: AppLocalizations.of(context).doing),
                  Tab(text: AppLocalizations.of(context).done),
                ],
              ),
            ),
            const Expanded(
              flex: 11,
              child: TabBarView(
                physics:  NeverScrollableScrollPhysics(),
                children: [
                  HomePageView(),
                  DoingStatusPage(),
                  HomePageView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
