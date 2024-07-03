import 'package:flutter/material.dart';
import 'main.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class FlightTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flights',
      theme: ThemeData(
        primaryColor: Colors.white,
        fontFamily: 'Pretendard',
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          color: Colors.white,
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  final List<Map<String, dynamic>> items = [
    {
      'icon': 'assets/logos/1KoreanAir.png',
      'url': 'https://www.koreanair.com/?hl=ko',
      'text': '대한항공'
    },
    {
      'icon': 'assets/logos/2Asiana.png',
      'url': 'https://flyasiana.com/C/KR/KO/index',
      'text': '아시아나항공'
    },
    {
      'icon': 'assets/logos/3JEJUair.png',
      'url': 'https://www.jejuair.net/ko/main/base/index.do',
      'text': '제주항공'
    },
    {
      'icon': 'assets/logos/4JinAir.png',
      'url': 'https://www.jinair.com/booking/index',
      'text': '진에어'
    },
    {
      'icon': 'assets/logos/5tway.png',
      'url': 'https://www.twayair.com/app/main',
      'text': '티웨이항공'
    },
    {
      'icon': 'assets/logos/6AirSeoul.png',
      'url': 'https://flyairseoul.com/CW/ko/main.do',
      'text': '에어서울'
    },
    {
      'icon': 'assets/logos/7Eastar.png',
      'url': 'https://www.eastarjet.com/newstar/PGWHC00001',
      'text': '이스타항공'
    },
    {
      'icon': 'assets/logos/8AirBusan.png',
      'url': 'https://m.airbusan.com/mc/common/home',
      'text': '에어부산'
    },
    {
      'icon': 'assets/logos/9AirPREMIA.png',
      'url': 'https://www.airpremia.com/',
      'text': '에어프리미어항공'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Text(
            'Ticket',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/appBar.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(175, 173, 248, 1),
                  Color.fromRGBO(175, 173, 248, 0.7),
                  Color.fromRGBO(175, 173, 248, 0.1),
                ],
              ),
            ),
            padding: EdgeInsets.all(3.0),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 112.0),
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 5.0, bottom: 5.0, left: 30.0, right: 30.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(54.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black38,
                                  blurRadius: 2.0,
                                  spreadRadius: 1.0,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  //Text('data'),
                                  IconButton(
                                    icon: Image.asset(
                                      items[index]['icon'],
                                      width: 150.0,
                                    ),
                                    onPressed: () => _launchURL(items[index]['url']),
                                  ),
                                  Text(
                                    items[index]['text'],
                                    style: TextStyle(
                                      color: Colors.black38,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500,
                                      height: 0.5,
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.94,
                    child: DraggableScrollableSheet(
                      initialChildSize: 0.2,
                      minChildSize: 0.2,
                      maxChildSize: 0.93,
                      builder: (BuildContext context, ScrollController scrollController) {
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16.0),
                                topRight: Radius.circular(16.0),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 6.0,
                                  spreadRadius: 1.0,
                                ),
                              ],
                              image: DecorationImage(
                                image: AssetImage('assets/BoardingPass.png'),
                                fit: BoxFit.cover,
                                alignment: Alignment.topCenter,
                              )
                          ),
                          child: SingleChildScrollView(
                            controller: scrollController,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}