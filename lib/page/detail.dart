import 'package:carousel_slider/carousel_slider.dart';
import 'package:dedent/dedent.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danggn_ui/component/manner_temperature.dart';
import 'package:flutter_danggn_ui/util.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../repository/contents_repository.dart';

class DetailContentView extends StatefulWidget {
  final Map<String, String> data;

  const DetailContentView(this.data, {Key? key}) : super(key: key);

  @override
  State<DetailContentView> createState() => _DetailContentViewState();
}

class _DetailContentViewState extends State<DetailContentView>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final ContentsRepository contentsRepository = ContentsRepository();

  int _current = 0;
  double _scrollPosToAlpha = 0;

  /// Late inits
  late List<String> imgList;
  bool _isFavorite = false;

  /// animation ?
  late final AnimationController _animationController;
  late final Animation _colorTween;

  /// data
  late final String imagePath;
  late final String title;
  late final String location;
  late final String price;
  late final String likes;
  late final String cid;

  @override
  void initState() {
    super.initState();

    imagePath = widget.data["image"]!;
    title = widget.data["title"]!;
    location = widget.data["location"]!;
    price = widget.data["price"]!;
    likes = widget.data["likes"]!;
    cid = widget.data["cid"]!;

    asyncInitState();

    _animationController = AnimationController(vsync: this);
    _colorTween = ColorTween(begin: Colors.white, end: Colors.black)
        .animate(_animationController);
    _scrollController.addListener(() {
      setState(() {
        _scrollPosToAlpha = _scrollController.offset.clamp(0.0, 255.0);
        _animationController.value = _scrollPosToAlpha / 255;
      });
    });
  }

  void asyncInitState() async {
    bool fav = await contentsRepository.isFavorite(cid);
    setState(() {
      _isFavorite = fav;
    });

    // await contentsRepository.debugClean();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    imgList = List.generate(5, (index) => imagePath);
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  Widget _makeIcon(IconData icon) {
    return AnimatedBuilder(
      animation: _colorTween,
      builder: (context, child) => Icon(icon, color: _colorTween.value),
    );
  }

  AppBar _appbarWidget() {
    return AppBar(
      backgroundColor: Colors.white.withAlpha(_scrollPosToAlpha.toInt()),
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: _makeIcon(Icons.arrow_back),
      ),
      actions: [
        IconButton(onPressed: () {}, icon: _makeIcon(Icons.share)),
        IconButton(onPressed: () {}, icon: _makeIcon(Icons.more_vert)),
      ],
    );
  }

  Stack _makeSlider() {
    return Stack(
      children: [
        Hero(
          tag: cid,
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

          /// Center??? ??????. l r == 0?????? ??????
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
                "?????????1",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text("????????? ?????????"),
            ],
          ),
          Expanded(child: MannerTemperature(40.5)),
        ],
      ),
    );
  }

  Widget _line() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      height: 1,
      color: Colors.grey.withOpacity(0.3),
    );
  }

  Widget _contentDetail() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Text(
            "?????????/?????? ?? 22?????? ???",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 20),
          Text(
            dedent('''
                ???????????? ?????? ?????? ????????? ?????? ????????? ?????? ???????????? ????????? ?????? ????????? ?????????. ??????, ?????????????????? ????????? ???????????? ?????? ??? ?????? ????????? ????????? ????????? ?????? ????????? ????????? ???????????? ?????????.

                ????????? ????????? ????????? ????????? ?????????, ?????????????? ??? ??????????????? ????????? ????????? ????????? ?????? ????????????.

                ???????????? ??????????????? ????????? ????????? ???????????? ?????????????????????????? ??? ?????????????????? ?????????.
                '''),
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
            ),
          ),
          SizedBox(height: 15),
          Text(
            "?????? 3 ?? ?????? 17 ?? ?????? 275",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _reportButton() {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        // color: Colors.blue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Report this post",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              // textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }

  Widget _otherCellContents() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "??????????????? ?????? ??????",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Text(
            "?????? ??????",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _bodyWidget() {
    /// nested -> SingleChildScrollView ?????? Custom
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            _makeSlider(),
            _sellerSimpleInfo(),
            _line(),
            _contentDetail(),
            _line(),
            _reportButton(),
            _line(),
            _otherCellContents(),
          ]),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            delegate: SliverChildListDelegate(
              List.generate(20, (index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        color: Colors.grey,
                        height: 120,
                      ),
                    ),
                    Text("?????? ??????", style: TextStyle(fontSize: 14)),
                    Text(
                      "??????",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _bottomNavigationBarWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: 55,
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              if (_isFavorite) {
                await contentsRepository.removeFavorite(widget.data);
              } else {
                await contentsRepository.addFavorite(widget.data);
              }

              if (kDebugMode) {
                print(await contentsRepository.get("FAVORITES"));
                print(await contentsRepository.get(cid));
              }

              setState(() {
                _isFavorite = !_isFavorite;
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(_isFavorite ? "??????????????? ?????????????????????" : "?????????????????? ?????????????????????"),
                duration: const Duration(seconds: 1),
              ));
            },
            child: SvgPicture.asset(
              "assets/svg/heart_${_isFavorite ? 'on' : 'off'}.svg",
              width: 25,
              height: 25,
              color: _isFavorite ? const Color(0xfff08f4f) : Colors.grey,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 15, right: 10),
            width: 1,
            height: 40,
            color: Colors.grey.withOpacity(0.3),
          ),
          Column(
            children: [
              Text(
                calcStringToWon(price),
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "??????????????????",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color(0xfff08f4f),
                  ),
                  child: Text(
                    "???????????? ????????????",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _appbarWidget(),
      body: _bodyWidget(),
      bottomNavigationBar: _bottomNavigationBarWidget(),
      extendBodyBehindAppBar: true,
    );
  }
}
