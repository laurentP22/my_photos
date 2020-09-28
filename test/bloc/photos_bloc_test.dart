import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';
import 'package:my_photos/blocs/blocs.dart';
import 'package:my_photos/data/providers/photo_provider.dart';
import 'package:my_photos/models/photo.dart';

class MockPhotoProvider extends Mock implements PhotoProvider {}

void main() {
  PhotoProvider photoProvider;

  final photo1 = Photo(id: 1, name: "cat", path: "path/to/dir/cat");
  final photo2 = Photo(id: 2, name: "tv", path: "path/to/dir/tv");
  final photos = [photo1, photo2];

  setUp(() {
    photoProvider = MockPhotoProvider();
    when(photoProvider.loadPhotos()).thenAnswer((_) => Future.value(photos));
  });

  group('PhotosLoaded', () {
    blocTest<PhotosBloc, PhotosState>(
      'should load photos successfully',
      build: () => PhotosBloc(photoProvider: photoProvider),
      act: (PhotosBloc bloc) => bloc.add(PhotosLoaded()),
      expect: <PhotosState>[
        PhotosLoadInProgress(),
        PhotosLoadSuccess(photos: photos)
      ],
    );

    blocTest<PhotosBloc, PhotosState>(
      'Should throw an error (error loading photos)',
      build: () {
        when(photoProvider.loadPhotos())
            .thenAnswer((_) => Future.error(Exception()));
        return PhotosBloc(photoProvider: photoProvider);
      },
      act: (PhotosBloc bloc) => bloc.add(PhotosLoaded()),
      expect: <PhotosState>[
        PhotosLoadInProgress(),
        PhotosLoadFailure(error: "Exception")
      ],
    );
  });

  group('PhotosAdded', () {
    blocTest<PhotosBloc, PhotosState>(
      'Should add a photo to the list',
      build: () {
        when(photoProvider.addPhoto(photo1)).thenAnswer((_) => Future.value());
        return PhotosBloc(photoProvider: photoProvider);
      },
      act: (PhotosBloc bloc) =>
          bloc..add(PhotosLoaded())..add(PhotosAdded(photo: photo1)),
      expect: <PhotosState>[
        PhotosLoadInProgress(),
        PhotosLoadSuccess(photos: photos),
        PhotosLoadInProgress(),
        PhotosLoadSuccess(photos: [photo1, photo2, photo1])
      ],
    );

    blocTest<PhotosBloc, PhotosState>(
      'Should throw an error (error saving photo)',
      build: () {
        when(photoProvider.addPhoto(photo1))
            .thenAnswer((_) => Future.error(Exception()));
        return PhotosBloc(photoProvider: photoProvider);
      },
      act: (PhotosBloc bloc) =>
          bloc..add(PhotosLoaded())..add(PhotosAdded(photo: photo1)),
      expect: <PhotosState>[
        PhotosLoadInProgress(),
        PhotosLoadSuccess(photos: photos),
        PhotosLoadInProgress(),
        PhotosLoadFailure(error: "Exception")
      ],
    );

    blocTest<PhotosBloc, PhotosState>(
      'Should pass nothing in response (bloc not in good state)',
      build: () {
        when(photoProvider.addPhoto(photo1)).thenAnswer((_) => Future.value());
        return PhotosBloc(photoProvider: photoProvider);
      },
      act: (PhotosBloc bloc) => bloc.add(PhotosAdded(photo: photo1)),
      expect: <PhotosState>[],
    );
  });

  group('PhotosDeleted', () {
    blocTest<PhotosBloc, PhotosState>(
      'Should remove a photo from the list',
      build: () {
        when(photoProvider.deletePhoto(photo1))
            .thenAnswer((_) => Future.value());
        return PhotosBloc(photoProvider: photoProvider);
      },
      act: (PhotosBloc bloc) =>
          bloc..add(PhotosLoaded())..add(PhotosDeleted(photo: photo1)),
      expect: <PhotosState>[
        PhotosLoadInProgress(),
        PhotosLoadSuccess(photos: photos),
        PhotosLoadInProgress(),
        PhotosLoadSuccess(photos: [photo2])
      ],
    );

    blocTest<PhotosBloc, PhotosState>(
      'Should throw an error (error deleting photo)',
      build: () {
        when(photoProvider.deletePhoto(photo1))
            .thenAnswer((_) => Future.error(Exception()));
        return PhotosBloc(photoProvider: photoProvider);
      },
      act: (PhotosBloc bloc) =>
          bloc..add(PhotosLoaded())..add(PhotosDeleted(photo: photo1)),
      expect: <PhotosState>[
        PhotosLoadInProgress(),
        PhotosLoadSuccess(photos: photos),
        PhotosLoadInProgress(),
        PhotosLoadFailure(error: "Exception")
      ],
    );

    blocTest<PhotosBloc, PhotosState>(
      'Should pass nothing (bloc not in good state)',
      build: () {
        when(photoProvider.deletePhoto(photo1))
            .thenAnswer((_) => Future.value());
        return PhotosBloc(photoProvider: photoProvider);
      },
      act: (PhotosBloc bloc) => bloc.add(PhotosDeleted(photo: photo1)),
      expect: <PhotosState>[],
    );
  });
}
