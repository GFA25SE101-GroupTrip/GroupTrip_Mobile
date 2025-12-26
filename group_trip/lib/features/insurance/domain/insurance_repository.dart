import 'package:group_trip/features/insurance/data/insurance_api.dart';
import 'package:group_trip/features/insurance/data/insurance_data.dart';

class InsuranceRepository {
  final InsuranceRemoteDataSource remoteDataSource;
  InsuranceRepository({required this.remoteDataSource});

  Future<List<InsuranceUser>> fetchUserInsurance() async {
    return await remoteDataSource.fetchUserInsurance();
  }
  

}