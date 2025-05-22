abstract class DetailsState {}

class DetailsInitialState extends DetailsState{}

class DetailsLoadingState extends DetailsState {}

class DetailsLoadedState extends DetailsState{
  final String data;

  DetailsLoadedState(this.data);
}

class ErrorState extends DetailsState {
  final String message;
  ErrorState(this.message);
}