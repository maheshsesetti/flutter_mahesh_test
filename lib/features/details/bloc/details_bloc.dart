import 'package:bloc/bloc.dart';
import 'package:flutter_mahesh_test/features/details/bloc/details_event.dart';
import 'package:flutter_mahesh_test/features/details/bloc/details_state.dart';

import '../useCase/details_use_case.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  final FetchDetailsUseCase fetchDetailsUseCase;

  dynamic finalData;
  DetailsBloc(this.fetchDetailsUseCase) : super(DetailsInitialState()) {
    on<LoadDetailsEvent>((event, emit) =>onload(emit));
    on<SwitchTabEvent>((event, emit) =>onSwitchTab(event,emit));
  }

  Future<void> onload(Emitter<DetailsState> emit) async {
     emit(DetailsLoadingState());
    try {
      final data = await fetchDetailsUseCase();
      finalData = data;
      emit(DetailsLoadedState(data));
    } catch (e) {
      emit(ErrorState("Failed to Load Screen"));
    }
  }

    Future<void> onSwitchTab(SwitchTabEvent event, Emitter<DetailsState> emit) async {
      if(finalData != null) {
    emit(DetailsLoadedState(finalData,isDetailsSelected: event.isDetailsSelected));
      }
  }
}
