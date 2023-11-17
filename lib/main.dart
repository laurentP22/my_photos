import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_photos/blocs/photos/photos_bloc.dart';
import 'package:my_photos/blocs/simple_bloc_observer.dart';
import 'package:my_photos/data/providers/photo_provider.dart';
import 'package:my_photos/screens/screens.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(
    BlocProvider(
      create: (context) => PhotosBloc(photoProvider: PhotoProvider())..add(PhotosLoaded()),
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

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
        HomeScreen.route: (_) => const HomeScreen(),
        DetailsScreen.route: (_) => const DetailsScreen(),
        AddScreen.route: (_) => const AddScreen(),
      },
    );
  }
}
