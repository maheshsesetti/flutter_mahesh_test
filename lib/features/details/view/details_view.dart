import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mahesh_test/features/details/bloc/details_bloc.dart';
import 'package:flutter_mahesh_test/features/details/bloc/details_state.dart';
import 'package:flutter_mahesh_test/features/details/repository/details_repo_impl.dart';
import 'package:flutter_mahesh_test/features/details/useCase/details_use_case.dart';

import '../bloc/details_event.dart';

class DetailsView extends StatelessWidget {
  const DetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DetailsBloc(FetchDetailsUseCase(DetailsRepoImpl()))..add(LoadDetailsEvent()),
        child: Scaffold(
          body: SafeArea(
            child: BlocConsumer< DetailsBloc,DetailsState>(
              buildWhen: (previous, current) =>
                  current is! ErrorState, 
              listenWhen: (previous, current) =>
                  current is ErrorState, 
        
              builder: (context, state) {
                if(state is DetailsLoadingState) return CircularProgressIndicator();
                if(state is DetailsLoadedState) return Text(state.data);
                if(state is ErrorState) return Text(state.message);
        
                return SizedBox();
                
              },
              listener: (context, state) {
                if (state is ErrorState) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
            ),
          ),
        )
      
    );
  }
}
