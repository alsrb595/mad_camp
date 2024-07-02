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
          )
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  void _launchURL(String url) async {
    //const url = 'https://www.koreanair.com/?hl=ko';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  final List<Map<String, dynamic>> items = [
    {'icon': 'assets/logos/1KoreanAir.png', 'url': 'https://www.koreanair.com/?hl=ko', 'text': '대한항공'},
    {'icon': 'assets/logos/2Asiana.png', 'url': 'https://flyasiana.com/C/KR/KO/index', 'text': '아시아나항공'},
    {'icon': 'assets/logos/3JEJUair.png', 'url': 'https://www.jejuair.net/ko/main/base/index.do', 'text': '제주항공'},
    {'icon': 'assets/logos/4JinAir.png', 'url': 'https://www.jinair.com/booking/index', 'text': '진에어'},
    {'icon': 'assets/logos/5tway.png', 'url': 'https://www.twayair.com/app/main', 'text': '티웨이항공'},
    {'icon': 'assets/logos/6AirSeoul.png', 'url': 'https://flyairseoul.com/CW/ko/main.do', 'text': '에어서울'},
    {'icon': 'assets/logos/7Eastar.png', 'url': 'https://www.eastarjet.com/newstar/PGWHC00001', 'text': '이스타항공'},
    {'icon': 'assets/logos/8AirBusan.png', 'url': 'https://m.airbusan.com/mc/common/home', 'text': '에어부산'},
    {'icon': 'assets/logos/9AirPREMIA.png', 'url': 'https://www.airpremia.com/', 'text': '에어프리미어항공'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              'Ticket',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 120.0),
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 5.0,
                        bottom: 10.0,
                        left: 50.0,
                        right: 50.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        // border: Border.all(
                        //     color: Colors.black,
                        //     width: 3.0,
                        // ),
                        borderRadius: BorderRadius.circular(54.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 3.0,
                            spreadRadius: 1.0,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 10.0
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Image.asset(
                                  items[index]['icon'],
                                  width: 150.0,
                              ),
                              onPressed: () => _launchURL(items[index]['url']),
                            ),
                            //SizedBox(height: 0.0),
                            Text(
                              items[index]['text'],
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w600,
                              ),
                            ),
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
              width: MediaQuery.of(context).size.width *0.94,
              child: DraggableScrollableSheet(
                initialChildSize: 0.2, // 초기 크기
                minChildSize: 0.2, // 최소 크기
                maxChildSize: 0.98, // 최대 크기 (전체 화면)
                builder: (BuildContext context, ScrollController scrollController) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
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
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 30,
                          child: Center(
                            child: Icon(
                              Icons.drag_handle,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: Container(
                              color: Colors.deepPurple,
                              height: 400,
                            ),
                          ),
                        ),
                        // 패딩이 들어간 이미지
                        // Expanded(
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(16.0),
                        //     child: Image.asset(
                        //         'assets/logos/',
                        //         width: 200,
                        //         height: 200,
                        //         fit: BoxFit.cover,
                        //       ),
                        //     ),
                        //   ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
