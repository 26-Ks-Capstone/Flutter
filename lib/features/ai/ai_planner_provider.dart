import 'package:flutter/material.dart';

enum MessageRole { ai, user }

class ChatMessage {
  final String content;
  final MessageRole role;
  final PlanSummary? planSummary;

  ChatMessage({
    required this.content,
    required this.role,
    this.planSummary,
  });
}

class PlanSummary {
  final String duration;
  final String estimatedCost;
  final int courseCount;
  final List<String> highlights;

  PlanSummary({
    required this.duration,
    required this.estimatedCost,
    required this.courseCount,
    required this.highlights,
  });
}

class AIPlannerProvider with ChangeNotifier {
  final List<ChatMessage> _messages = [
    ChatMessage(
      content: '안녕하세요! AI 여행 플래너입니다. 가고 싶은 여행지, 일정, 취향을 자유롭게 말씀해주세요. 최적의 이동경로와 체류 시간을 자동으로 계산해 드릴게요!',
      role: MessageRole.ai,
    ),
  ];

  List<ChatMessage> get messages => _messages;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // 사용자 메시지 추가
    _messages.add(ChatMessage(content: text, role: MessageRole.user));
    notifyListeners();

    _isLoading = true;
    notifyListeners();

    // TODO: 제미나이 API 연동 예정 (현재는 Mock 응답)
    await Future.delayed(const Duration(seconds: 2));

    // AI 응답 및 일정 요약 데이터 생성 (Mock)
    final aiResponse = ChatMessage(
      content: '요청하신 내용을 바탕으로 최적의 일정을 만들어보았습니다! 마음에 드시는지 확인해보세요.',
      role: MessageRole.ai,
      planSummary: PlanSummary(
        duration: '2박 3일',
        estimatedCost: '약 450,000원',
        courseCount: 8,
        highlights: ['해운대 야경', '광안리 맛집', '감천문화마을'],
      ),
    );

    _messages.add(aiResponse);
    _isLoading = false;
    notifyListeners();
  }

  // 플래너 저장 Mock 함수
  Future<bool> savePlanner(PlanSummary summary) async {
    // DB 저장 로직 시뮬레이션
    await Future.delayed(const Duration(seconds: 1));
    print('플래너 저장 완료: ${summary.duration} 일정');
    return true;
  }
}
