

import 'package:flutter_mahesh_test/features/details/repository/details_repo_impl.dart';

class FetchDetailsUseCase {
  final DetailsRepoImpl repository;

  FetchDetailsUseCase(this.repository);

  Future<String> call() async {
    return await repository.fetchData();
  }
}
