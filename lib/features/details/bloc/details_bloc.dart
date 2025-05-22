import 'package:bloc/bloc.dart';
import 'package:flutter_mahesh_test/features/details/bloc/details_event.dart';
import 'package:flutter_mahesh_test/features/details/bloc/details_state.dart';

import '../useCase/details_use_case.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  final FetchDetailsUseCase fetchDetailsUseCase;
  DetailsBloc(this.fetchDetailsUseCase) : super(DetailsInitialState()) {
    on<LoadDetailsEvent>((event, emit) async {
      emit(DetailsLoadingState());
      try {
        final data = await fetchDetailsUseCase();
        emit(DetailsLoadedState(data));
      } catch (e) {
        emit(ErrorState("Failed to Load Screen"));
      }
    });
  }
}
