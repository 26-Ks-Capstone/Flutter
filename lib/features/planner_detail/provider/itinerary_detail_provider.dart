import 'package:flutter/material.dart';
import '../repository/itinerary_detail_repository.dart';
import '../models/itinerary_detail_model.dart';

class ItineraryDetailProvider with ChangeNotifier {
  final ItineraryDetailRepository _repository = ItineraryDetailRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ItineraryDetailResponse? _detail;
  ItineraryDetailResponse? get detail => _detail;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchItineraryDetail(int itineraryId) async {
    _isLoading = true;
    _errorMessage = null;
    _detail = null;
    notifyListeners();

    try {
      final response = await _repository.getItineraryDetail(itineraryId);
      
      if (response.statusCode == 200) {
        // 백엔드 응답이 Wrapper 없이 DTO 단일 객체일 때
        final data = response.data;
        _detail = ItineraryDetailResponse.fromJson(data);
      } else {
        _errorMessage = "서버 응답 오류 (${response.statusCode})";
      }
    } catch (e) {
      debugPrint('❌ 상세 데이터 파싱 에러: $e');
      _errorMessage = "데이터를 불러오는 중 오류가 발생했습니다.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
