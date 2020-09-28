part of 'photos_bloc.dart';

abstract class PhotosEvent extends Equatable {
  const PhotosEvent();


  @override
  List<Object> get props => [];
}

class PhotosLoaded extends PhotosEvent {}

class PhotosAdded extends PhotosEvent {
  final Photo photo;
  PhotosAdded({@required this.photo});
}

class PhotosDeleted extends PhotosEvent {
  final Photo photo;
  PhotosDeleted({@required this.photo});
}