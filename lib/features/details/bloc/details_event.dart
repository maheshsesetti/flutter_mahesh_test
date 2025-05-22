abstract class DetailsEvent {}

class LoadDetailsEvent extends DetailsEvent {}

class SwitchTabEvent extends DetailsEvent {
  final bool isDetailsSelected;
  SwitchTabEvent(this.isDetailsSelected);
}
