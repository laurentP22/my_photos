/*
import 'package:bloc_test/bloc_test.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_photos/blocs/camera/camera_bloc.dart';
import 'package:my_photos/keys.dart';
import 'package:my_photos/screens/camera_screen.dart';

class MockCameraBloc extends MockBloc implements CameraBloc {}

void main() {
  CameraBloc cameraBloc;
  Widget app;

  setUp(() {
    cameraBloc = MockCameraBloc();
    app = MaterialApp(
      home: Scaffold(
        body: BlocProvider.value(
          value: cameraBloc,
          child: BlocBuilder<CameraBloc, CameraState>(
            builder: (context, state) => CameraScreen(),
          ),
        ),
      ),
    );
  });

  tearDown(() {
    cameraBloc?.close();
  });

group('CameraScreen', () {
  testWidgets('Should show an empty container when state is CameraInitial',
      (WidgetTester tester) async {
    when(cameraBloc.state).thenAnswer((_) => CameraInitial());

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    expect(find.byKey(MyPhotosKeys.emptyContainerScreen), findsOneWidget);
  });

  testWidgets('Should show the camera preview when state is CameraReady',
      (WidgetTester tester) async {
    when(cameraBloc.state).thenAnswer((_) => CameraReady());
    when(cameraBloc.getController()).thenAnswer(
      (_) => CameraController(CameraDescription(), ResolutionPreset.high),
    );

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    expect(find.byKey(MyPhotosKeys.cameraPreviewScreen), findsOneWidget);
  });

  testWidgets('Should show the error message when state is CameraFailure',
      (WidgetTester tester) async {
    when(cameraBloc.state).thenAnswer((_) =>
        CameraFailure(error: "MediaRecorderCamera permission not granted"));

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    expect(find.byKey(MyPhotosKeys.errorScreen), findsOneWidget);
    expect(find.text("MediaRecorderCamera permission not granted"),
        findsOneWidget);
  });

  testWidgets('Should show an empty container when state is CameraCaptureInProgress',
          (WidgetTester tester) async {
        when(cameraBloc.state).thenAnswer((_) => CameraCaptureInProgress());

        await tester.pumpWidget(app);
        await tester.pumpAndSettle();

        expect(find.byKey(MyPhotosKeys.emptyContainerScreen), findsOneWidget);
      });

  /*
  // TODO Fix the test
  testWidgets(
      'Should show the error snackBar when state is CameraCaptureFailure',
      (WidgetTester tester) async {
    whenListen(
        cameraBloc,
        Stream.fromIterable(
            [CameraCaptureInProgress(), CameraCaptureFailure()]));

    when(cameraBloc.getController()).thenAnswer(
      (_) => CameraController(CameraDescription(), ResolutionPreset.high),
    );

    //Act
    await tester.pumpWidget(app);
    await tester.pump();

    //Assert
    expect(find.byKey(MyPhotosKeys.errorSnackBar), findsOneWidget);
  });
   */
});
}
*/