
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WatchPage(),
    );
  }
}

class WatchPage extends StatefulWidget {

  @override
  _WatchPageState createState() => _WatchPageState();
}

class _WatchPageState extends State<WatchPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //1초마다 새로그리게 해주기 !!
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Container(
            margin: EdgeInsets.all(90),
            child: AspectRatio( //1:1비율로 만들어주
              aspectRatio: 1,
              child: CustomPaint(
                painter: WatchPainter(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WatchPainter extends CustomPainter{ //Widget size = 1:1
  @override
  void paint(Canvas canvas, Size size) {
    // 1 . 초침, 분침 시침
    // 2 . 시간 1, 2, 3, 4 ... 12


    var center = getCenter(size);

    //뒤쪽 데코레이션
    canvas.drawCircle(center, size.width * .48, Paint()..color = Colors.grey[200]);
    canvas.drawCircle(center, size.width * .45, Paint()..color = Colors.white);

    //시간 꾸미기 (1, 2, ... 12)
    drawHours(canvas, size);


    //분침, 시침, 초침
    var now = DateTime.now();
    drawHourTick(now, size, canvas);
    drawMinuteTick(now, size, canvas);
    drawSecondTick(now, size, canvas);

    //가움데 이쁘게 !!
    canvas.drawCircle(center, size.width * .02, Paint()..color = Colors.grey[300]);
    canvas.drawCircle(center, size.width * .01, Paint()..color = Colors.grey[700]);
  }



  //시침
  void drawHourTick(DateTime now, Size size, Canvas canvas){
    var h = now.hour;
    if(h >= 12)
      h -= 12;
    var hourDegree = h * (2 * pi / 12);
    var minutesDegree = (now.minute / 60) * (2 * pi / 12); // 0 ~ 1 * 30도;
    var sumDegree = hourDegree + minutesDegree;
    drawTick(canvas, size, sumDegree, size.width * .01, Colors.grey[600], size.width/2 * .3);
  }


  //분침
  void drawMinuteTick(DateTime now, Size size, Canvas canvas){
    var minutesDegree = (now.minute / 60) * (2 * pi); // 0 ~ 1 * 360도;
    var secondsDegree = (now.second / 60) * (2 * pi / 60); // 0 ~ 1 * 6도
    var sumDegree = minutesDegree + secondsDegree;
    drawTick(canvas, size, sumDegree, size.width * .008, Colors.grey[800], size.width/2 * .55);
  }

  //초침
  void drawSecondTick(DateTime now, Size size, Canvas canvas){
    var secondsDegree = (now.second / 60) * (2 * pi); // 0 ~ 1 * 360도
    drawTick(canvas, size, secondsDegree, size.width * .003, Colors.red[400], size.width/2 * .65);
  }





  //침의 기원 ㅋㅋ
  void drawTick(Canvas canvas, Size size, double degree, double thickness, Color color, double length){
    var center = getCenter(size);
    var o = getOffset(size, degreeConvert(degree), length);

    var p = Paint();
    p.strokeWidth = thickness;
    p.color = color;
    p.style = PaintingStyle.stroke;
    p.strokeCap = StrokeCap.round;

    canvas.drawLine(center, o, p);
  }

  //12시간 다 그려주기
  void drawHours(Canvas canvas, Size size){
    for(var hour = 1; hour <= 12; hour++){
      drawHour(canvas, size, hour);
    }
  }

  void drawHour(Canvas canvas, Size size, int hour){
    double hourLength = size.width/2 * .8; //
    var degree = degreeConvert((2 * pi) * (hour/12));

    var o = getOffset(size, degree, hourLength);

    //minWidth 가 있는 이유는 text 가움데 해주기 위해서. 이거 해서 offset 조절 안해주면 offset 기점으로 오른쪽 하단에 보여지게 된다.
    var minWidth = size.width * .05;
    var t = TextPainter(text: TextSpan(text: hour.toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: minWidth)), textDirection: TextDirection.ltr, textAlign: TextAlign.center);
    t.layout(minWidth: minWidth);
    var resultOffset = Offset(o.dx - minWidth/2, o.dy - minWidth/2);
    t.paint(canvas, resultOffset);
  }


  //우리가 머리로 생각하는 각도로 변경해주는 거. (12시가 0도부터 시작해서 오른쪽으로 각도가 늘어나는 것)
  double degreeConvert(double degree){
    return - degree + (pi/2);
  }

  //각도에 따라서 해당 위치 offset 가져다주기
  Offset getOffset(Size size, double degree, double length){
    Offset center = getCenter(size);
    double x = (cos(degree) * length) + center.dx;
    double y = center.dy - (sin(degree) * length);
    return Offset(x, y);
  }

  //가움데 보여주기
  Offset getCenter(Size size){
    return Offset(size.width/2, size.height/2);
  }

  //화면 새로그릴때마다 paint 새로 그려주기
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}