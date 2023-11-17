import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_photos/blocs/blocs.dart';
import 'package:my_photos/models/photo.dart';

class DetailsScreen extends StatelessWidget {
  static String route = "/details";

  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Photo photo = ModalRoute.of(context)!.settings.arguments as Photo;

    deletePhoto() {
      BlocProvider.of<PhotosBloc>(context).add(PhotosDeleted(photo: photo));
      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(photo.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => deletePhoto(),
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            child: Image.file(
              File(photo.path),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
