import 'package:flutter_mahesh_test/features/details/repository/details_repo.dart';

class DetailsRepoImpl extends DetailsRepo {
  DetailsRepoImpl();

  @override
  Future<dynamic> fetchData() async {
    print("Hello teams");
    return "detailsPage";
    // API Implimentation
  }
}
