abstract class DetailsState {}

class DetailsInitialState extends DetailsState{}

class DetailsLoadingState extends DetailsState {}

class DetailsLoadedState extends DetailsState{
  final String? data;
  final bool isDetailsSelected;

  DetailsLoadedState({this.isDetailsSelected = true,this.data});
}

class ErrorState extends DetailsState {
  final String message;
  ErrorState(this.message);
}

class TabSwitchedState extends DetailsState {
  final bool isDetailsSelected;
  TabSwitchedState(this.isDetailsSelected);
}
