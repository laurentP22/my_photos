part of 'photos_bloc.dart';

abstract class PhotosState extends Equatable {
  const PhotosState();

  @override
  List<Object> get props => [];
}

class PhotosInitial extends PhotosState {}

class PhotosLoadInProgress extends PhotosState {}

class PhotosLoadSuccess extends PhotosState {
  final List<Photo> photos;
  PhotosLoadSuccess({@required this.photos});
}

class PhotosLoadFailure extends PhotosState {
  final String error;

  PhotosLoadFailure({this.error = "PhotosFailure"});

  @override
  List<Object> get props => [error];
}
