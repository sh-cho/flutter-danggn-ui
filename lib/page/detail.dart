import 'package:flutter/material.dart';

class DetailContentView extends StatefulWidget {
  final Map<String, String> data;

  const DetailContentView(this.data, {Key? key}) : super(key: key);

  @override
  State<DetailContentView> createState() => _DetailContentViewState();
}

class _DetailContentViewState extends State<DetailContentView> {
  AppBar _appbarWidget() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.share)),
        IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
      ],
    );
  }

  Widget _bodyWidget() {
    return Hero(
      tag: widget.data["cid"]!,
      child: Image.asset(
        widget.data["image"]!,
        width: double.infinity,
        fit: BoxFit.fill,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: _bodyWidget(),
      extendBodyBehindAppBar: true,
    );
  }
}
