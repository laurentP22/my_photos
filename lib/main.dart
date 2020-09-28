import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_photos/data/providers/photo_provider.dart';
import 'package:my_photos/screens/screens.dart';
import 'blocs/blocs.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(
    BlocProvider(
      create: (context) => PhotosBloc(photoProvider: PhotoProvider())..add(PhotosLoaded()),
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Photos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: HomeScreen.route,
      routes: {
        HomeScreen.route: (_) => HomeScreen(),
        DetailsScreen.route: (_) => DetailsScreen(),
        AddScreen.route: (_) => AddScreen(),
      },
    );
  }
}
