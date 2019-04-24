import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/page/ui/home/home_page.dart';
import 'package:flutter_wanandroid/page/utils/constant.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _selectedTab = 0;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.titles[_selectedTab]),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
          SizedBox(
            width: 10.0,
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          _buildTabContent(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFFd0d0d0),
            blurRadius: 3.0,
            spreadRadius: 2.0,
            offset: Offset(-1.0, -1.0),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Theme.of(context).primaryColor,
        ),
        child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedTab,
            onTap: _tabSelected,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home,
                      color: _selectedTab == 0 ? Colors.white : Colors.white30),
                  title: Text("首页",
                      style: TextStyle(
                          color: _selectedTab == 0
                              ? Colors.white
                              : Colors.white30))),
              BottomNavigationBarItem(
                  icon: Icon(Icons.folder_shared,
                      color: _selectedTab == 1 ? Colors.white : Colors.white30),
                  title: Text("项目",
                      style: TextStyle(
                          color: _selectedTab == 1
                              ? Colors.white
                              : Colors.white30))),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings,
                      color: _selectedTab == 2 ? Colors.white : Colors.white30),
                  title: Text("设置",
                      style: TextStyle(
                          color: _selectedTab == 2
                              ? Colors.white
                              : Colors.white30)))
            ]),
      ),
    );
  }

  void _tabSelected(int value) {
    setState(() {
      _selectedTab = value;
      _tabController.index = value;
    });
  }

  Widget _buildTabContent() {
    return Positioned.fill(
      child: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          HomePage(),
          Center(child: Text("项目", style: TextStyle(fontSize: 20.0))),
          Center(child: Text("设置", style: TextStyle(fontSize: 20.0))),
        ],
      ),
    );
  }
}
