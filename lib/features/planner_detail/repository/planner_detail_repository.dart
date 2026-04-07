import 'package:capstone/features/core/network/dio_client.dart';
import 'package:dio/dio.dart';

class PlannerRepository {
  Future<Response> getItineraries() async {
    try {
      return await DioClient.instance.get('/api/v1/planner/itineraries');
    } catch (e) {
      rethrow;
    }
  }
}
