import 'package:flutter/material.dart';
import 'package:flutter_danggn_ui/page/detail.dart';
import 'package:flutter_danggn_ui/repository/contents_repository.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../util.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String currentLocation = "ara";
  final ContentsRepository contentsRepository = ContentsRepository();

  @override
  void initState() {
    super.initState();
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: GestureDetector(
        onTap: () {
          print("click");
        },
        onLongPress: () {
          print("long press");
        },
        child: PopupMenuButton<String>(
          offset: Offset(0, 20),
          shape: ShapeBorder.lerp(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            1,
          ),
          onSelected: (String selected) {
            print(selected);
            setState(() {
              currentLocation = selected;
            });
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(value: "ara", child: Text("아라동")),
              PopupMenuItem(value: "ora", child: Text("오라동")),
              PopupMenuItem(value: "donam", child: Text("도남동")),
            ];
          },
          child: Row(
            children: [
              Text(LocationType.getByCode(currentLocation).displayName),
              Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
      elevation: 1,
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.search)),
        IconButton(onPressed: () {}, icon: Icon(Icons.tune)),
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(
            "assets/svg/bell.svg",
            width: 22,
          ),
        ),
      ],
    );
  }

  _loadContents() {
    return contentsRepository.loadContentsFromLocation(currentLocation);
  }

  Widget _bodyWidget() {
    return FutureBuilder(
      future: _loadContents(),
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
                                    "assets/svg/heart_off.svg",
                                    width: 13,
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
          itemCount: 10,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _bodyWidget(),
    );
  }
}
