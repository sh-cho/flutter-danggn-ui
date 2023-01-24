import 'package:flutter/material.dart';
import 'package:flutter_danggn_ui/page/favorite.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'home.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late int _currentPageIndex;

  @override
  void initState() {
    _currentPageIndex = 0;
    super.initState();
  }

  ///

  Widget _bodyWidget() {
    switch (_currentPageIndex) {
      case 0:
        return Home();

      case 1:
        return Container();

      case 2:
        return Container();

      case 3:
        return Container();

      case 4:
        return MyDanggn();

      default: //err
        return Container();
    }
  }

  BottomNavigationBarItem _bottomNavigationBarItem(
      String iconName, String label) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: SvgPicture.asset("assets/svg/${iconName}_off.svg", width: 22),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: SvgPicture.asset("assets/svg/${iconName}_on.svg", width: 22),
      ),
      label: label,
    );
  }

  BottomNavigationBar _bottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        setState(() {
          _currentPageIndex = index;
        });
      },
      currentIndex: _currentPageIndex,
      selectedItemColor: Colors.black,
      selectedFontSize: 12,
      // selectedLabelStyle: TextStyle(color: Colors.black),
      items: [
        _bottomNavigationBarItem("home", "홈"),
        _bottomNavigationBarItem("notes", "동네생활"),
        _bottomNavigationBarItem("location", "내 근처"),
        _bottomNavigationBarItem("chat", "채팅"),
        _bottomNavigationBarItem("user", "나의 당근"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: _buildAppBar(),
      body: _bodyWidget(),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }
}
