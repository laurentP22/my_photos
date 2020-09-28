import 'package:bloc_test/bloc_test.dart';
import 'package:camera/camera.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';
import 'package:my_photos/blocs/camera/camera_bloc.dart';
import 'package:my_photos/utils/camera_utils.dart';

final String path = "path/to/directory";

class MockCameraController extends Mock implements CameraController {}

class MockCameraUtils extends Mock implements CameraUtils {
  @override
  Future<String> getPath() => Future.value(path);
}

void main() {
  MockCameraController cameraController;
  MockCameraUtils cameraUtils;

  setUp(() {
    cameraController = MockCameraController();
    cameraUtils = MockCameraUtils();

    // Default responses
    when(cameraController.initialize()).thenAnswer((_) => Future.value());
    when(cameraUtils.getCameraController(
            ResolutionPreset.high, CameraLensDirection.back))
        .thenAnswer((_) => Future.value(cameraController));
  });

  group('CameraInitialized', () {
    blocTest<CameraBloc, CameraState>(
      'Should initialize the camera controller',
      build: () => CameraBloc(cameraUtils: cameraUtils),
      act: (CameraBloc bloc) => bloc.add(CameraInitialized()),
      expect: <CameraState>[
        CameraReady(),
      ],
    );

    blocTest<CameraBloc, CameraState>(
      'Should throw an error (permission not granted)',
      build: () {
        when(cameraController.initialize()).thenAnswer((_) => Future.error(
            CameraException("cameraPermission",
                "MediaRecorderCamera permission not granted")));
        return CameraBloc(cameraUtils: cameraUtils);
      },
      act: (CameraBloc bloc) => bloc.add(CameraInitialized()),
      expect: <CameraState>[
        CameraFailure(error: "MediaRecorderCamera permission not granted")
      ],
    );

    blocTest<CameraBloc, CameraState>(
      'Should throw an error (no camera on device)',
      build: () {
        when(cameraUtils.getCameraController(
                ResolutionPreset.high, CameraLensDirection.back))
            .thenAnswer(
                (_) => Future.error(Exception("Bad state: no element")));
        return CameraBloc(cameraUtils: cameraUtils);
      },
      act: (CameraBloc bloc) => bloc.add(CameraInitialized()),
      expect: <CameraState>[
        CameraFailure(error: "Exception: Bad state: no element"),
      ],
    );
  });

  group('CameraCaptured', () {
    blocTest<CameraBloc, CameraState>(
      'Should capture a photo',
      build: () {
        when(cameraController.value).thenAnswer((_) => CameraValue());
        when(cameraController.takePicture(path))
            .thenAnswer((_) => Future.value());
        return CameraBloc(cameraUtils: cameraUtils);
      },
      act: (CameraBloc bloc) =>
          bloc..add(CameraInitialized())..add(CameraCaptured()),
      expect: <CameraState>[
        CameraReady(),
        CameraCaptureInProgress(),
        CameraCaptureSuccess(path)
      ],
    );

    blocTest<CameraBloc, CameraState>(
      'Should throw an error (problem with the camera)',
      build: () {
        when(cameraController.value)
            .thenAnswer((_) => CameraValue(isTakingPicture: false));
        when(cameraController.takePicture(path)).thenAnswer(
            (_) => Future.error(CameraException("error", "description")));
        return CameraBloc(cameraUtils: cameraUtils);
      },
      act: (CameraBloc bloc) =>
          bloc..add(CameraInitialized())..add(CameraCaptured()),
      expect: <CameraState>[
        CameraReady(),
        CameraCaptureInProgress(),
        CameraCaptureFailure(error: "description")
      ],
    );

    blocTest<CameraBloc, CameraState>(
      'Should pass nothing (camera is not ready)',
      build: () => CameraBloc(cameraUtils: cameraUtils),
      act: (CameraBloc bloc) => bloc.add(CameraCaptured()),
      expect: <CameraState>[],
    );
  });

  group('CameraStopped', () {
    blocTest<CameraBloc, CameraState>(
      'Should dispose the camera',
      build: () => CameraBloc(cameraUtils: cameraUtils),
      act: (CameraBloc bloc) =>
          bloc..add(CameraInitialized())..add(CameraStopped()),
      expect: <CameraState>[
        CameraReady(),
        CameraInitial(),
      ],
    );
  });
}
