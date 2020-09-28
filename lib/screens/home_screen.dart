import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_photos/blocs/blocs.dart';
import 'package:my_photos/keys.dart';
import 'package:my_photos/screens/add_screen.dart';
import 'package:my_photos/widgets/error.dart';
import 'package:my_photos/widgets/photo_card.dart';

class HomeScreen extends StatefulWidget {
  static String route = "/";

  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My photos"),
      ),
      body: BlocBuilder<PhotosBloc, PhotosState>(builder: (context, state) {
        if (state is PhotosLoadInProgress) {
          return Center(
            child: CircularProgressIndicator(
              key: MyPhotosKeys.loadingScreen,
            ),
          );
        } else if (state is PhotosLoadSuccess) {
          return GridView.builder(
              key: MyPhotosKeys.photosGridScreen,
              itemCount: state.photos.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 10, mainAxisSpacing: 10, crossAxisCount: 2),
              itemBuilder: (_, index) => PhotoCard(
                    photo: state.photos[index],
                  ));
        } else if (state is PhotosLoadFailure) {
          return Error(
              key: MyPhotosKeys.errorScreen,
              message: state.error);
        } else {
          return Container(
            key: MyPhotosKeys.emptyContainerScreen,
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AddScreen.route),
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }
}
