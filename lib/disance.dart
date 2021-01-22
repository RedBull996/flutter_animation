import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class DistanceWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DistanceWidget();
  }
}

class _DistanceWidget extends State<DistanceWidget> {
  Offset lastStartOffset = Offset(220, 330);
  Offset record = Offset(220, 330);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size contentSize = MediaQuery.of(context).size;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('data'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                "https://oss.voogolf-app.com/map/play/223/12211362a76afe073ac76f1522467947.jpg",
              ),
              fit: BoxFit.cover),
        ),
        child: Stack(
          children: <Widget>[
            CustomPaint(
              painter: LinePainter(Offset(180 + 22.0, 180 + 22.0),
                  Offset(record.dx + 15, record.dy + 15),
                  labelAlign: LabelAlign.right),
            ),
            Positioned(
              left: 180,
              top: 180,
              child: Image.asset('assets/target.png'),
            ),
            CustomPaint(
              painter: LinePainter(Offset(190 + 15.0, 500 + 15.0),
                  Offset(record.dx + 15, record.dy + 15)),
            ),
            Positioned(
              left: 190,
              top: 500,
              child: Image.asset(
                'assets/header.png',
                width: 30,
                height: 30,
              ),
            ),
            Positioned(
              left: record.dx,
              top: record.dy,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  print('点击');
                },
                onPanStart: (detail) {
                  setState(() {
                    print('开始-------${detail.globalPosition}');
                  });
                },
                onPanUpdate: (DragUpdateDetails details) {
                  double offsetX = record.dx + details.delta.dx;
                  double offsetY = record.dy + details.delta.dy;
                  if (offsetX + 30 >= contentSize.width) {
                    offsetX = contentSize.width - 30.0;
                  } else if (offsetX < 0.0) {
                    offsetX = 0.0;
                  }
                  if (offsetY >= contentSize.height - 76 - 30) {
                    offsetY = contentSize.height - 30.0 - 76;
                  } else if (offsetY < 0.0) {
                    offsetY = 0.0;
                  }
                  print(details);
                  setState(() {
                    record = Offset(offsetX, offsetY);
                  });
                },
                onPanEnd: (detail) {
                  setState(() {});
                  print('===>$record');
                },
                child: Image.asset(
                  'assets/touchP.png',
                  width: 30,
                  height: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum LabelAlign {
  left,
  center,
  right,
}

class LinePainter extends CustomPainter {
  Offset startPoint;
  Offset endPoint;
  LabelAlign labelAlign;

  Paint _paint = Paint()
    ..color = Color(0xFFFFFFFF)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  LinePainter(this.startPoint, this.endPoint,
      {this.labelAlign = LabelAlign.left});

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    canvas.drawLine(startPoint, endPoint, _paint);
    TextSpan textSpan = TextSpan(
        style: TextStyle(
          // backgroundColor: Colors.red,
          color: Colors.black,
          fontSize: 20,
        ),
        text: '${(endPoint.dy.toInt()-startPoint.dy.toInt()).abs()}yd');
    TextPainter textPainter =
        TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    textPainter.layout(maxWidth: 200);
    //绘制的文本size
    Size contentSize = Size(textPainter.width + textPainter.height, textPainter.height);
    //连线中心点位置(x,y)
    double x = endPoint.dx - (endPoint.dx - startPoint.dx) / 2.0;
    double y = endPoint.dy - (endPoint.dy - startPoint.dy) / 2.0;
    //label 背景中心位置
    Offset labelBg = Offset(
        x +
            (labelAlign.index == LabelAlign.left.index
                ? contentSize.width / 2.0
                : -(contentSize.width / 2.0)),
        y);
    canvas.drawRRect(
      RRect.fromRectXY(
        Rect.fromCenter(
          center: labelBg,
          width: contentSize.width,
          height: contentSize.height,
        ),
        contentSize.height / 2.0,
        contentSize.height / 2.0,
      ),
      Paint()
        ..color = Color(0xFFD4FE3E)
        ..style = PaintingStyle.fill,
    );
    Offset labelLocation = Offset(x,y);

    if(labelAlign.index == LabelAlign.right.index) {
      labelLocation = Offset(labelBg.dx-contentSize.width/2.0+contentSize.height/2.0, labelBg.dy-contentSize.height/2.0);
    } else {
      labelLocation = Offset(x+contentSize.height/2.0, labelBg.dy-contentSize.height/2.0);
    }
    //label 根据label背景位置计算文字位置
    Offset labelBgLeftLocation = Offset(labelBg.dx, y);
    textPainter.paint(
      canvas,
      labelLocation,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}
