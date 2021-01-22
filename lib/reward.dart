import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/gift.dart';

enum Style {
  unclaimed, //待领取
  success, //领取成功
}

class RewardResultPage extends StatefulWidget {
  final Style type;

  const RewardResultPage({Key key, this.type = Style.success})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RewardResultPage();
  }
}

class _RewardResultPage extends State<RewardResultPage>
    with TickerProviderStateMixin {
  AnimationController _anc;
  Animation<double> _imageAn;
  Animation<double> _bgAn;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.type == Style.unclaimed) {
      _anc = AnimationController(
          vsync: this, duration: Duration(milliseconds: 1100))
        ..repeat(reverse: true);
      Animation<double> ana =
          CurvedAnimation(parent: _anc, curve: Curves.easeIn);
      _imageAn = new Tween(begin: pi / 10, end: -pi / 10.0).animate(ana)
        ..addListener(() {
          setState(() {});
        });
      _bgAn = new Tween(begin: -pi / 10.0, end: pi / 10.0).animate(_anc)
        ..addListener(() {
          setState(() {});
        });
    } else {
      _anc = AnimationController(
          vsync: this, duration: Duration(milliseconds: 24000))
        ..repeat(reverse: false);
      _bgAn = new Tween(begin: 0.0, end: pi * 2.0).animate(_anc)
        ..addListener(() {
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (_anc != null) {
      _anc.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      type: MaterialType.transparency, // 配置透明度
      child: Container(
        // color: Color(0x99494949),
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.002)
                  ..rotateZ(_bgAn.value),
                alignment: Alignment.center,
                child: CustomPaint(
                  painter: new MyPainter(
                    lineColor: Color(0x804A4A4A),
                  ),
                ),
              ),
            ),
            widget.type == Style.unclaimed
                ? unclaimedWidget()
                : successWidget(),
          ],
        ),
      ),
    );
  }

  Widget unclaimedWidget() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset('assets/congratuate.png',fit: BoxFit.cover,),
          Padding(padding: EdgeInsets.only(top:10)),
          Transform(
            alignment: Alignment.center,
            // origin: Offset(100, 100),
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.002)
              ..rotateY(_imageAn.value),
            child: Image.asset('assets/rewardW.png'),
          ),
          bottomButton('领取我的奖励', () {}),
        ],
      ),
    );
  }

  Widget successWidget() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset('assets/congratulate.png'),
          Padding(padding: EdgeInsets.only(top:10)),
          Image.asset('assets/getSuccess.png'),
          bottomButton('好的', () {}),
        ],
      ),
    );
  }

  GestureDetector bottomButton(String title, Function onTap) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 32),
        width: 283,
        height: 48,
        decoration: BoxDecoration(
          color: Color(0xFF00CC67),
          borderRadius: BorderRadius.all(
            Radius.circular(24),
          ),
          border: Border.all(width: 2, color: Colors.white),
        ),
        child: Text(
          title,
          style: TextStyle(fontSize: 17, color: Colors.white),
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  Color lineColor;
  double startAngles = 0;

  MyPainter({this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    Paint line = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;
    Offset center = Offset(size.width / 2, size.height / 2); //  坐标中心
    //画扇形
    for (int i = 0; i < 60; i++) {
      if (i % 2 == 0) continue;

      canvas.drawArc(
          Rect.fromCircle(center: center, radius: size.height / 2.0 + 60),
          6 * pi * i / 180,
          6 * pi / 180,
          true,
          line);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
