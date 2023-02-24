import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as imgpart;
import 'package:permission_handler/permission_handler.dart';

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
  List myimg = [];
  bool temp = false;

  List<imgpart.Image> splitImage(imgpart.Image inputImage,
      int horizontalPieceCount, int verticalPieceCount) {
    imgpart.Image image = inputImage;

    final pieceWidth = (image.width / horizontalPieceCount).round();
    final pieceHeight = (image.height / verticalPieceCount).round();
    final pieceList = List<imgpart.Image>.empty(growable: true);
    int x = 0,
        y = 0;
    for (var i = 0; i < horizontalPieceCount; i++) {
      for (var j = 0; j < verticalPieceCount; j++) {
        pieceList.add(imgpart.copyCrop(image,
            x: x, y: y, width: pieceWidth, height: pieceHeight));
        x = x + pieceWidth;
      }
      y = y + pieceHeight;
      x = 0;
    }

    return pieceList;
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('images/$path');

    var path1 = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS) +
        "/myimg";
    Directory dir = Directory(path1);

    if (!await dir.exists()) {
      await dir.create();
    }

    final file = File('${dir.path}/$path');

    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_permission();

    getImageFileFromAssets("cdmi.jpg").then((value) {
      imgpart.Image? img = imgpart.decodeJpg(value.readAsBytesSync());
      myimg = splitImage(img!, 4, 4);
      temp = true;
      myimg.shuffle();
      setState(() {});
    });
  }

  get_permission() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
        Permission.storage,
      ].request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Puzzle"),
      ),
      body: (temp)
          ? GridView.builder(itemCount: 16,
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, crossAxisSpacing: 5, mainAxisSpacing: 5),
        itemBuilder: (context, index) {
          return Container(decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.fill,
              image: MemoryImage(imgpart.encodeJpg(myimg[index])))),);
        },)
          : CircularProgressIndicator(),
    );
  }
}
