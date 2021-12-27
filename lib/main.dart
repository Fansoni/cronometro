import 'dart:math';

import 'package:flutter/material.dart';

import 'pallete.dart';

void main() => runApp(MaterialApp(
  title: 'Cronômetro',
  home: HomePage(),
));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin {
  AnimationController _controller;
  AnimationController horaController;
  AnimationController minutoController;
  AnimationController segundoController;
  Animation relogioAnimation;
  double percentage = 0.0;
  int hora = 0;
  int minuto = 0;
  int segundo = 0;
  bool complete = false;
  bool isAnimating = false;
  bool isReseted = true;
  @override
  void initState() {
    super.initState();
    //int calcularSegundos = (horas * 3600) + (minutos * 60) + segundos;
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 121));
    relogioAnimation = CurvedAnimation(parent: _controller, curve: Curves.linear);
    relogioAnimation = Tween(begin: 0.0, end: 100.0).animate(relogioAnimation);
    _controller.addListener((){
      if(_controller.isCompleted){
        complete = true;
        isAnimating = false;
        isReseted = false;
      }
      setState(() {
        percentage = relogioAnimation.value;
      });
    });

    /*  SEGUNDOS */
    segundoController = AnimationController(vsync: this, duration: Duration(seconds: 1));
    segundoController.addListener((){
      if (segundoController.isCompleted) {
        if(segundo < 59){
          segundo++;
        }else{
          if (minuto < 59) {
            minuto++;
          } else {
            if(hora < 23){hora++;}else{hora = 0;}
            minuto = 0;
          }
          segundo = 0;
        }
        segundoController.reset();
        segundoController.forward();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    horaController.dispose();
    minutoController.dispose();
    segundoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cronômetro'),
        centerTitle: true,
        backgroundColor: background,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: background,
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                child: Container(
                  width: 310,
                  height: 310,
                  decoration: BoxDecoration(
                    //color: letters.withOpacity(0.7),
                    borderRadius: BorderRadius.all(Radius.circular(155))
                  ),
                  child: RelogioDrawer(
                    complete: complete,
                    percentage: percentage,
                    hora: hora,
                    minuto: minuto,
                    segundo: segundo,
                    isReseted: isReseted,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        if (!complete) {
                          if(_controller.isAnimating){
                            setState(() {
                              isAnimating = false;
                            });
                            _controller.stop(canceled: true);
                            segundoController.stop(canceled: true);
                          }else{
                            setState(() {
                              isAnimating = true;
                              isReseted = false;
                            });
                            _controller.forward();
                            segundoController.forward();
                          }
                        }                        
                      },
                      child: Container(
                        width: 100,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: letters,),
                          borderRadius: BorderRadius.all(Radius.circular(25))
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Icon((isAnimating)?Icons.pause:Icons.play_arrow, color: letters,),
                              Text((isAnimating)?'Pause':'Play', style: TextStyle(
                                fontSize: 20,
                                color: letters
                              ),)
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          segundo = 0;
                          minuto = 0;
                          hora = 0;
                          isAnimating = false;
                          isReseted = true;
                          percentage = 0.0;
                          _controller.reset();
                        });
                      },
                      child: Container(
                        width: 100,
                        height: 50,
                        decoration: BoxDecoration(
                          //border: Border.all(color: letters,),
                          borderRadius: BorderRadius.all(Radius.circular(25))
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Icon(Icons.refresh, color: letters,),
                              Text('Reset', style: TextStyle(
                                fontSize: 20,
                                color: letters
                              ),)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width/3,
                    decoration: BoxDecoration(
                      //color: menu,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        'Alarm', 
                        textAlign: TextAlign.center,
                        style: TextStyle(color: disable, fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    )
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width/3,
                    decoration: BoxDecoration(
                      //color: menu,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        'StopWatch', 
                        textAlign: TextAlign.center,
                        style: TextStyle(color: disable, fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    )
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width/3,
                    decoration: BoxDecoration(
                      color: menu,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        'Countdown', 
                        textAlign: TextAlign.center,
                        style: TextStyle(color: letters, fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    )
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RelogioDrawer extends StatelessWidget {
  const RelogioDrawer({
    Key key,
    @required this.complete,
    @required this.percentage,
    @required this.hora,
    @required this.minuto,
    @required this.segundo,
    @required this.isReseted,
  }) : super(key: key);

  final bool isReseted;
  final bool complete;
  final double percentage;
  final int hora;
  final int minuto;
  final int segundo;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: RelogioPainter(
        completeColor: (complete)?Colors.blue:background,
        lineColor: letters,
        completePercent: percentage,
        width: 8.0
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text((isReseted)?'00':'', style: TextStyle(
                color: disable,
                fontSize: 30
              ),),
              GestureDetector(
                child: Text((hora < 10)?'0'+hora.toString():hora.toString(), style: TextStyle(
                  color: letters,
                  fontSize: 50
                ),),
              ),
              Text((isReseted)?'00':'', style: TextStyle(
                color: disable,
                fontSize: 30
              ),),
            ],
          ),
          SizedBox(width: 10,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(':', style: TextStyle(
                color: letters,
                fontSize: 50
              ),),
            ],
          ),
          SizedBox(width: 10,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text((isReseted)?'00':'', style: TextStyle(
                color: disable,
                fontSize: 30
              ),),
              Text((minuto < 10)?'0'+minuto.toString():minuto.toString(), style: TextStyle(
                color: letters,
                fontSize: 50
              ),),
              Text((isReseted)?'00':'', style: TextStyle(
                color: disable,
                fontSize: 30
              ),),
            ],
          ),
          SizedBox(width: 10,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(':', style: TextStyle(
                color: letters,
                fontSize: 50
              ),),
            ],
          ),
          SizedBox(width: 10,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text((isReseted)?'00':'', style: TextStyle(
                color: disable,
                fontSize: 30
              ),),
              Text((segundo < 10)?'0'+segundo.toString():segundo.toString(), style: TextStyle(
                color: letters,
                fontSize: 50
              ),),
              Text((isReseted)?'00':'', style: TextStyle(
                color: disable,
                fontSize: 30
              ),),
            ],
          ),
        ],
      ),
    );
  }
}

class RelogioPainter extends CustomPainter{
  Color lineColor;
  Color completeColor;
  double completePercent;
  double width;

  RelogioPainter({this.lineColor,this.completeColor,this.completePercent,this.width});

  @override
  void paint(Canvas canvas, Size size) {
    Paint line = new Paint()
    ..color = lineColor
    ..strokeCap = StrokeCap.square
    ..style = PaintingStyle.stroke
    ..strokeWidth = width;
    Paint complete = new Paint()
    ..color = completeColor
    ..strokeCap = StrokeCap.square
    ..style = PaintingStyle.stroke
    ..strokeWidth = width;
    Offset center  = new Offset(size.width/2, 155);
    double radius  = 150;

    canvas.drawCircle(center, radius, line);

    double arcAngle = 2*pi*(completePercent/100);
    canvas.drawArc(
      new Rect.fromCircle(center: center,radius: radius),
      -pi/2,
      arcAngle,
      false,
      complete
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
  
}