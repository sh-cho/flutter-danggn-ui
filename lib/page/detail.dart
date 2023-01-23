import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danggn_ui/component/manner_temperature.dart';

class DetailContentView extends StatefulWidget {
  final Map<String, String> data;

  const DetailContentView(this.data, {Key? key}) : super(key: key);

  @override
  State<DetailContentView> createState() => _DetailContentViewState();
}

class _DetailContentViewState extends State<DetailContentView> {
  late List<String> imgList;
  int _current = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    imgList = List.generate(5, (index) => widget.data["image"]!);
  }

  AppBar _appbarWidget() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white)),
      actions: [
        IconButton(
            onPressed: () {}, icon: Icon(Icons.share, color: Colors.white)),
        IconButton(
            onPressed: () {}, icon: Icon(Icons.more_vert, color: Colors.white)),
      ],
    );
  }

  Stack _makeSlider() {
    return Stack(
      children: [
        Hero(
          tag: widget.data["cid"]!,
          child: CarouselSlider(
            items: imgList
                .map((url) =>
                    Image.asset(url, width: double.infinity, fit: BoxFit.fill))
                .toList(),
            options: CarouselOptions(
              // height: 400,
              aspectRatio: 1,
              initialPage: 0,
              enableInfiniteScroll: false,
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
          ),
        ),
        Positioned(
          bottom: 0,

          /// Center는 못씀. l r == 0이면 센터
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imgList.asMap().entries.map((entry) {
              return GestureDetector(
                // onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 10.0,
                  height: 10.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white
                          .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _sellerSimpleInfo() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: Image.asset("assets/images/user.png").image,
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "판매자1",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text("제주시 도담동"),
            ],
          ),
          Expanded(child: MannerTemperature(40.5)),
        ],
      ),
    );
  }

  Widget _bodyWidget() {
    return Column(
      children: [
        _makeSlider(),
        _sellerSimpleInfo(),
      ],
    );
  }

  Widget _bottomNavigationBarWidget() {
    return SizedBox(
      child: Container(
        color: Colors.red,
      ),
      height: 55,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: _bodyWidget(),
      bottomNavigationBar: _bottomNavigationBarWidget(),
      extendBodyBehindAppBar: true,
    );
  }
}
