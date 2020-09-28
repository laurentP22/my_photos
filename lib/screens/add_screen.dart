import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_photos/blocs/blocs.dart';
import 'package:my_photos/blocs/camera/camera_bloc.dart';
import 'package:my_photos/models/photo.dart';
import 'package:my_photos/screens/camera_screen.dart';
import 'package:my_photos/utils/camera_utils.dart';

class AddScreen extends StatefulWidget {
  static String route = "/addEdit";

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _textEditingController = TextEditingController();
  String path;

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  void savePhoto() {
    BlocProvider.of<PhotosBloc>(context).add(PhotosAdded(
        photo: Photo(name: _textEditingController.text, path: path)));
    Navigator.of(context).pop();
  }

  void openCamera() {
    FocusScope.of(context).requestFocus(FocusNode()); //remove focus
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => CameraBloc(cameraUtils: CameraUtils())
              ..add(CameraInitialized()),
            child: CameraScreen(),
          ),
        )).then((value) => setState(() => path = value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("Add photo"),
          actions: [
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () => savePhoto(),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Name",
                style: TextStyle(fontSize: 20),
              ),
              TextField(
                controller: _textEditingController,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Photo",
                    style: TextStyle(fontSize: 20),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => openCamera(),
                  )
                ],
              ),
              Expanded(
                child: path != null
                    ? Container(
                        width: double.infinity,
                        child: Image.file(File(path), fit: BoxFit.cover))
                    : Container(),
              ),
            ],
          ),
        ));
  }
}
