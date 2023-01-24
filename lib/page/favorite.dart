import 'package:flutter/material.dart';
import 'package:flutter_danggn_ui/repository/contents_repository.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../util.dart';
import 'detail.dart';

class MyDanggn extends StatefulWidget {
  const MyDanggn({Key? key}) : super(key: key);

  @override
  State<MyDanggn> createState() => _MyDanggnState();
}

class _MyDanggnState extends State<MyDanggn> {
  late final ContentsRepository _contentsRepository;

  @override
  void initState() {
    super.initState();

    _contentsRepository = ContentsRepository();
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(
        "관심목록",
        style: TextStyle(fontSize: 15),
      ),
    );
  }

  Widget _body() {
    return FutureBuilder(
      future: _contentsRepository.loadFavoriteContents(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("오류 :("));
        }

        if (!snapshot.hasData) {
          return Center(child: Text("데이터 없음 :("));
        }

        List<Map<String, String>> datas = snapshot.data;
        if (datas.isEmpty) {
          // why??
          return Center(child: Text("데이터 없음 2 :("));
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemBuilder: (BuildContext _context, int index) {
            final imagePath = datas[index]["image"]!;
            final title = datas[index]["title"]!;
            final location = datas[index]["location"]!;
            final price = datas[index]["price"]!;
            final likes = datas[index]["likes"]!;
            final cid = datas[index]["cid"]!;

            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    return DetailContentView(datas[index]);
                  },
                ));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Hero(
                        tag: cid,
                        child: Image.asset(
                          imagePath,
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 20),
                        height: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(fontSize: 15),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 5),
                            Text(
                              location,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black.withOpacity(0.4)),
                            ),
                            SizedBox(height: 5),
                            Text(calcStringToWon(price),
                                style: TextStyle(fontWeight: FontWeight.w500)),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SvgPicture.asset(
                                    "assets/svg/heart_on.svg",
                                    width: 13,
                                    color: Color(0xfff08f4f),
                                  ),
                                  SizedBox(width: 5),
                                  Text(likes),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext _context, int index) {
            return Container(height: 1, color: Colors.black.withOpacity(0.4));
          },
          itemCount: datas.length,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }
}
