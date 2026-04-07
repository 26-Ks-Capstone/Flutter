import 'package:flutter/material.dart';
import '../repository/itinerary_detail_repository.dart';
import 'planner_detail_provider.dart'; // Itinerary 모델 재사용 혹은 신규 정의

class ItineraryDetailProvider with ChangeNotifier {
  final ItineraryDetailRepository _repository = ItineraryDetailRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map<String, dynamic>? _itineraryDetail;
  Map<String, dynamic>? get itineraryDetail => _itineraryDetail;

  Future<void> fetchItineraryDetail(int itineraryId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _repository.getItineraryDetail(itineraryId);
      if (response.statusCode == 200) {
        _itineraryDetail = response.data;
      }
    } catch (e) {
      debugPrint('❌ Error fetching itinerary detail: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
