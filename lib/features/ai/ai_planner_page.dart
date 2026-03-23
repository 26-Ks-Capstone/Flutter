import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capstone/config/palette.dart';
import 'package:capstone/features/ai/ai_planner_provider.dart';

class AIPlannerPage extends StatefulWidget {
  const AIPlannerPage({super.key});

  @override
  State<AIPlannerPage> createState() => _AIPlannerPageState();
}

class _AIPlannerPageState extends State<AIPlannerPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Set<String> _selectedInterests = {};

  final List<Map<String, dynamic>> _interests = [
    {'icon': Icons.sailing, 'label': '레저'},
    {'icon': Icons.restaurant, 'label': '맛집'},
    {'icon': Icons.directions_walk, 'label': '산책'},
    {'icon': Icons.waves, 'label': '바다/해변'},
    {'icon': Icons.music_note, 'label': '문화/공연'},
  ];

  final List<String> _exampleQueries = [
    '제주도 2박3일 자연 힐링 여행 만들어줘'
  ];

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // context.watch를 사용하여 상태 변경 시 리빌드 보장
    final plannerProvider = context.watch<AIPlannerProvider>();

    return Scaffold(
      backgroundColor: Palette.background,
      appBar: AppBar(
        backgroundColor: Palette.background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFF6600FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI 여행 플래너',
                  style: TextStyle(
                    color: Palette.foreground,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '온라인',
                  style: TextStyle(color: Colors.green, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              children: [
                // 기존 메시지들
                ...plannerProvider.messages.map((msg) => _buildChatBubble(msg)),
                
                // 로딩 애니메이션
                if (plannerProvider.isLoading) _buildLoadingBubble(),
              ],
            ),
          ),
          
          // 초기 상태일 때 도우미 UI를 입력창 바로 위(Column 하단)에 배치
          if (plannerProvider.messages.length == 1 && !plannerProvider.isLoading)
            _buildHelperUI(),

          _buildInputSection(plannerProvider),
        ],
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage message) {
    bool isAi = message.role == MessageRole.ai;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: isAi ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isAi) ...[
            _buildAiIcon(),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isAi ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isAi ? Palette.inputBackground : const Color(0xFF0055FF),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(15),
                      topRight: const Radius.circular(15),
                      bottomLeft: isAi ? Radius.zero : const Radius.circular(15),
                      bottomRight: isAi ? const Radius.circular(15) : Radius.zero,
                    ),
                  ),
                  child: Text(
                    message.content,
                    style: TextStyle(
                      color: isAi ? Palette.foreground : Colors.white,
                      height: 1.4,
                    ),
                  ),
                ),
                if (message.planSummary != null) _buildResultCard(message.planSummary!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiIcon() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: const BoxDecoration(
        color: Color(0xFF6600FF),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.auto_awesome, color: Colors.white, size: 14),
    );
  }

  Widget _buildResultCard(PlanSummary summary) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Palette.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('📅 추천 일정 요약', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.calendar_today, '기간', summary.duration),
          _buildInfoRow(Icons.payments_outlined, '예상 비용', summary.estimatedCost),
          _buildInfoRow(Icons.map_outlined, '코스 개수', '${summary.courseCount}개'),
          const Divider(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<AIPlannerProvider>().savePlanner(summary).then((success) {
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('플래너가 저장되었습니다.')),
                        );
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0055FF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('플래너 저장'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('다른 일정'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Palette.mutedForeground),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Palette.mutedForeground, fontSize: 12)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildLoadingBubble() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          _buildAiIcon(),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Palette.inputBackground,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF6600FF)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelperUI() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '관심 분야를 선택하세요',
            style: TextStyle(color: Palette.mutedForeground, fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: _interests.map((item) => _buildInterestChip(item['icon'], item['label'])).toList(),
          ),
          const SizedBox(height: 24),
          const Text(
            '이렇게 물어보세요',
            style: TextStyle(color: Palette.mutedForeground, fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          ..._exampleQueries.map((query) => _buildExampleQueryCard(query)),
        ],
      ),
    );
  }

  Widget _buildInterestChip(IconData icon, String label) {
    final isSelected = _selectedInterests.contains(label);
    return FilterChip(
      label: Text(label),
      avatar: Icon(
        icon, 
        size: 16, 
        color: isSelected ? Colors.white : Palette.mutedForeground,
      ),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          if (selected) {
            _selectedInterests.add(label);
          } else {
            _selectedInterests.remove(label);
          }
        });
      },
      backgroundColor: Palette.inputBackground,
      selectedColor: const Color(0xFF6600FF),
      labelStyle: TextStyle(
        fontSize: 12, 
        color: isSelected ? Colors.white : Palette.foreground,
      ),
      showCheckmark: false,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide.none),
    );
  }

  Widget _buildExampleQueryCard(String query) {
    return InkWell(
      onTap: () {
        _messageController.text = query;
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Palette.inputBackground.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                query,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Palette.mutedForeground),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection(AIPlannerProvider provider) {
    return Container(
      padding: EdgeInsets.only(
        left: 20, 
        right: 20, 
        top: 10, 
        bottom: MediaQuery.of(context).padding.bottom + 10
      ),
      decoration: const BoxDecoration(
        color: Palette.background,
        border: Border(top: BorderSide(color: Palette.border, width: 0.5)),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Palette.inputBackground,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: '여행지, 일정, 취향을 말해주세요...',
                  hintStyle: TextStyle(color: Palette.mutedForeground, fontSize: 14),
                  border: InputBorder.none,
                ),
                onSubmitted: (value) => _handleSend(provider),
              ),
            ),
            IconButton(
              onPressed: () => _handleSend(provider),
              icon: const Icon(Icons.send_rounded, color: Color(0xFF0055FF)),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSend(AIPlannerProvider provider) {
    if (_messageController.text.isNotEmpty) {
      provider.sendMessage(_messageController.text);
      _messageController.clear();
      _scrollToBottom();
    }
  }
}
