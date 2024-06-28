import 'package:flutter/material.dart';
import 'phone_tab.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget { //stateless 한번 쓰이면 변화 없음
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget { // stateful 상호작용에 따라 상태가 변하는 위젯
  @override
  _HomeScreenState createState() => _HomeScreenState(); // createState 메서드는 StatefulWidget 클래스에서 반드시 구현해야 하는 메서드
// StatefulWidget의 상태를 관리할 State 객체를 생성하고 반환
//createState 메서드가 반환한 State 객체가 StatefulWidget과 연결되어 상태를 관리
// createState() => _HomeScreenState();는 createState 메서드가 _HomeScreenState의 인스턴스를 반환한다는 의미
}

class _HomeScreenState extends State<HomeScreen> { //State<HomeScreen> :  StatefulWidget의 상태를 나타내는 클래스입 상태를 관리하고, 상태가 변경될 때 <HomeScreen> 위젯을 다시 빌드
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          PhoneTab(),
          Center(child: Text("My")),
          Center(child: Text("Menu")),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.phone), label: 'Phone'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_rounded), label: 'My'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, //onTap 콜백 함수는 사용자가 BottomNavigationBarItem을 탭할 때마다 호출, 이 콜백 함수는 탭된 아이템의 인덱스를 인수로 받아옴.
      ),
    );
  }
}
