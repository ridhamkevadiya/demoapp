import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: first(),
  ));
}

class first extends StatefulWidget {
  const first({Key? key}) : super(key: key);

  @override
  State<first> createState() => _firstState();
}

class _firstState extends State<first> {
  List num = [10, 20, 30, 40, 50, 60, 70, 80, 90];
  List<bool> temp = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    temp = List.filled(9, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Drag Container"),
        ),
        body: GridView.builder(
          itemCount: 9,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10),
          itemBuilder: (context, index) {
            return (temp[index])
                ? Draggable(data: index,
                    onDragStarted: () {
                      temp = List.filled(9, false);
                      temp[index] = true;
                      setState(() {});
                    },
                    onDragEnd: (details) {
                      temp = List.filled(9, true);
                      setState(() {});
                    },
                    child: Container(
                      color: Colors.red,
                      alignment: Alignment.center,
                      child: Text(
                        "${num[index]}",
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ),
                    ),
                    feedback: Container(
                      width: 100,
                      height: 100,
                      color: Colors.yellow,
                      alignment: Alignment.center,
                      child: Text(
                        "${num[index]}",
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ),
                    ),
                  )
                : DragTarget(onAccept: (data) {
                    int c;
                    c = num[data as int];
                    num[data as int] = num[index];
                    num[index] =c;
                    setState(() {

                    });
                },
                    builder: (context, candidateData, rejectedData) {
                      return Container(
                        height: 100,
                        width: 100,
                        alignment: Alignment.center,
                        color: Colors.pink,
                        child: Text("${num[index]}",
                            style:
                                TextStyle(fontSize: 30, color: Colors.white)),
                      );
                    },
                  );
          },
        ));
  }
}
