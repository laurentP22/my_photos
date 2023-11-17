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

  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _textEditingController = TextEditingController();
  String? path;

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  void savePhoto() {
    if (path != null) {
      BlocProvider.of<PhotosBloc>(context).add(
        PhotosAdded(
          photo: Photo(
            name: _textEditingController.text,
            path: path!,
          ),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  void openCamera() {
    FocusScope.of(context).requestFocus(FocusNode()); //remove focus
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => CameraBloc(cameraUtils: CameraUtils())..add(CameraInitialized()),
            child: const CameraScreen(),
          ),
        )).then((value) => setState(() => path = value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Add photo"),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () => savePhoto(),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Name",
                style: TextStyle(fontSize: 20),
              ),
              TextField(
                controller: _textEditingController,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Photo",
                    style: TextStyle(fontSize: 20),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => openCamera(),
                  )
                ],
              ),
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: path != null
                      ? Image.file(
                          File(path!),
                          fit: BoxFit.cover,
                        )
                      : Container(),
                ),
              ),
            ],
          ),
        ));
  }
}
