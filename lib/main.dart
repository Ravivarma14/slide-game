import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: GameBoard(),
    );
  }
}

///////////////////


class GameBoard extends StatefulWidget {

  @override
  State<GameBoard> createState() => _GameBoardState();

}

class _GameBoardState extends State<GameBoard> {

num currentIndex=5;
String direction='';
List<int> redBoxList=[42,46,48];
String gameover='';
int score=0;


Timer? timer;

@override
initState(){
  super.initState();
  start();
}

restart(){
  redBoxList.clear();
  direction='';
  currentIndex=5;
  score=0;
  gameover='';
  //start();
  print("restart()");
  if(timer!=null)
    timer?.cancel();
  timer= new Timer.periodic(Duration(milliseconds: 750), (timer) { randomGenerator(); });
}
start(){
  print("start()");
  if(timer!=null)
    timer?.cancel();
  timer=new Timer.periodic(Duration(milliseconds: 750), (timer) { randomGenerator(); });
}

randomGenerator(){
  var rng = Random();

  for(int i=0;i<redBoxList.length;i++){
    if(redBoxList[i]-10 >= 0)
      redBoxList[i]=redBoxList[i]-10;
    else
      redBoxList.remove(redBoxList[i]);
  }
  print(redBoxList);

  for (var i = 0; i < 3; i++) {
    int random=rng.nextInt(10) + 40;
    if(!redBoxList.contains(random))
      redBoxList.add(random);
  }

  if(redBoxList.contains(currentIndex)){
    timer?.cancel();
    timer=null;
    gameover='Game Over';
  }
  else{
   score++;
  }

  setState(() {
  });

}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 15, right: 15,top: 40,bottom: 15),
        child: Column(
          children: <Widget> [ Expanded(
            child: GridView.count(
                crossAxisCount: 10,
                scrollDirection: Axis.horizontal,
                children:
                List.generate(50, (index) {
                  return Padding(
                    padding: EdgeInsets.all(3),
                    child: GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(color: redBoxList.contains(currentIndex) && index.toInt() == currentIndex ? Colors.black: index.toInt() == currentIndex ? Colors.blue: redBoxList.contains(index.toInt())? Colors.red: Colors.black12,
                            borderRadius: BorderRadius.circular(5)),
                        //color: index.toInt() == currentIndex ? Colors.red: Colors.white70,
                        //color: index.toInt() == currentIndex ? Colors.blue: redBoxList.contains(index.toInt())? Colors.red: Colors.black12,
                        //child: Text('$index'),
                      ),
                      onTap: () {
                        setState(() {
                          currentIndex = index;
                        });
                      },


                      onPanEnd: (details) {
                        if (direction == 'right' && currentIndex + 10 <=50) {
                          currentIndex = (currentIndex + 10);
                          setState(() {});
                        }
                        if (direction == 'left' && currentIndex - 10 >= 0) {
                          currentIndex = (currentIndex - 10);
                          setState(() {});
                        }
                        if (direction == 'up' && currentIndex - 1 >=0) {
                          currentIndex = (currentIndex -1);
                          setState(() {});
                        }
                        if (direction == 'down' && currentIndex + 1 <=50) {
                          currentIndex = (currentIndex +1);
                          setState(() {});
                        }
                        else {}
                      },
                      onPanUpdate: (details) {
                        // Swiping in right direction.
                        if(details.delta.dy < 0){
                        direction='up';
                        }
                        else if(details.delta.dy > 0){
                        direction='down';
                        }
                        else if (details.delta.dx > 0) {
                        direction = 'right';
                        }

                        // Swiping in left direction.
                        else if (details.delta.dx < 0) {
                        direction = 'left';
                        }
                      },
                      ),
                  );
                }),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Text(
                "Score: $score",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0),
              ),
                Text(
                  "$gameover",
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 22.0),
                ),
              ]
            ),
          ),
        SizedBox(height: 10,),

         Align(
            alignment: Alignment.bottomCenter,
            child:Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue[200],
                borderRadius: BorderRadius.circular(15),
              ),
              child: GestureDetector(
                  onTap: () => restart(),
                  child: Text("Restart",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0),
                  )),
            ),
        ),
        ]
        ),
      ),
    );
  }

}

