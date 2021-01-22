import 'package:flutter/material.dart';

class GiftItem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _GiftItem();
  }
}

class _GiftItem extends State<GiftItem> with SingleTickerProviderStateMixin {
  AnimationController _giftAnc;
  Animation<double> _giftAn;
  Animation<double> _giftTextAn;

  int anSt = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _giftAnc =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400))
          ..addListener(() {
            if (_giftAnc.status == AnimationStatus.dismissed) {
              anSt = 3;
            } else if (_giftAnc.status == AnimationStatus.completed) {
              anSt = 2;
            } else if (_giftAnc.status == AnimationStatus.forward) {
              anSt = 1;
            } else if (_giftAnc.status == AnimationStatus.reverse) {
              anSt = 1;
            }
          });
    _giftAn = new Tween(begin: 160.0, end: 46.0).animate(_giftAnc)
      ..addListener(() {
        setState(() {});
      });
    _giftTextAn = new Tween(begin: 1.0, end: 0.0).animate(_giftAnc)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _giftAnc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: () {
        print('开始动画');
        if (anSt == 2) {
          _giftAnc.reverse();
        } else if (anSt == 3 || anSt == 0) {
          _giftAnc.forward();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(23)),
          color: Colors.red,
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            stops: [0, 0.7],
            colors: [
              const Color(0xFF4EE097),
              const Color(0xFF00CC67)
            ], // whitish to gray
          ),
        ),
        width: _giftAn.value,
        height: 46,
        child: Stack(
          alignment: Alignment.centerLeft,
          overflow: Overflow.clip,
          children: <Widget>[
            Positioned(
              left: 46 * _giftTextAn.value,
              right: 5,
              child: FadeTransition(
                opacity: _giftTextAn,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '五层球',
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                          Text(
                            '您有一份礼物待领取',
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset('assets/closeJ.png'),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              left: 4.5,
              child: Image.asset('assets/gift.png'),
            ),
          ],
        ),
      ),
    );
  }
}
