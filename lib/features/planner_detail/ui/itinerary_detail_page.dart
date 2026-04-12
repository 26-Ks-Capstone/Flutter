import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capstone/config/palette.dart';
import '../provider/itinerary_detail_provider.dart';
import '../models/itinerary_detail_model.dart';

class ItineraryDetailPage extends StatefulWidget {
  final int itineraryId;

  const ItineraryDetailPage({super.key, required this.itineraryId});

  @override
  State<ItineraryDetailPage> createState() => _ItineraryDetailPageState();
}

class _ItineraryDetailPageState extends State<ItineraryDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ItineraryDetailProvider>().fetchItineraryDetail(widget.itineraryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final detailProvider = context.watch<ItineraryDetailProvider>();
    
    return Scaffold(
      backgroundColor: Palette.background,
      body: detailProvider.isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF2962FF)))
          : detailProvider.errorMessage != null
              ? _buildErrorState(detailProvider.errorMessage!)
              : detailProvider.detail == null
                  ? const Center(child: Text('일정 정보를 불러올 수 없습니다.'))
                  : _buildContent(detailProvider.detail!),
      bottomNavigationBar: detailProvider.detail != null ? _buildBottomBar() : null,
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(color: Palette.mutedForeground)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.read<ItineraryDetailProvider>().fetchItineraryDetail(widget.itineraryId),
            child: const Text('다시 시도'),
          )
        ],
      ),
    );
  }

  Widget _buildContent(ItineraryDetailResponse detail) {
    return CustomScrollView(
      slivers: [
        // 상단 헤더 이미지 및 정보
        SliverToBoxAdapter(
          child: Stack(
            children: [
              Container(
                height: 280,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1596403140595-65715f53f938?q=80&w=1000&auto=format&fit=crop'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: 280,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(0.3), Colors.black.withOpacity(0.7)],
                  ),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('AI 생성 일정', style: TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 8),
                    Text(
                      detail.title,
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.white70, size: 14),
                        const SizedBox(width: 6),
                        Text('${detail.startDate} ~ ${detail.endDate}', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                        const SizedBox(width: 16),
                        const Icon(Icons.location_on, color: Colors.white70, size: 14),
                        const SizedBox(width: 6),
                        Text(detail.region, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 50,
                left: 20,
                child: CircleAvatar(
                  backgroundColor: Colors.black26,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ],
          ),
        ),

        // 지역 요약 정보 카드
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Color(0xFF2962FF), size: 20),
                    const SizedBox(width: 8),
                    Text(detail.region, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(width: 8),
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const Text(' 4.7', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const Spacer(),
                    const Text('상세보기', style: TextStyle(color: Color(0xFF2962FF), fontSize: 13)),
                    const Icon(Icons.open_in_new, color: Color(0xFF2962FF), size: 14),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  '역동적인 도시와 아름다운 해변이 공존하는 대한민국 제2의 도시. 해운대, 광안리의 바다 풍경과 신선한 해산물이 일품입니다.',
                  style: TextStyle(color: Colors.grey, height: 1.5, fontSize: 14),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: ['해변', '도시', '해산물', '야경'].map((tag) => Chip(
                    label: Text(tag, style: const TextStyle(fontSize: 12)),
                    backgroundColor: Palette.inputBackground,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  )).toList(),
                ),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Text('상세 일정', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),

        // 날짜별 타임라인 리스트
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final item = detail.details[index];
              final isFirstInDay = index == 0 || detail.details[index - 1].dayNumber != item.dayNumber;
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isFirstInDay) _buildDayHeader(item.dayNumber),
                  _buildTimelineTile(item, index == detail.details.length - 1),
                ],
              );
            },
            childCount: detail.details.length,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildDayHeader(int day) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: const Color(0xFF2962FF),
            child: Text('$day', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Text('Day $day', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const Spacer(),
          const Icon(Icons.keyboard_arrow_up, color: Colors.grey, size: 20),
        ],
      ),
    );
  }

  Widget _buildTimelineTile(ItineraryDetailItem item, bool isLast) {
    Color bgColor = const Color(0xFFE3F2FD);
    Color iconColor = const Color(0xFF2962FF);
    IconData icon = Icons.location_on;
    String tag = '관광';

    if (item.categoryType.any((t) => t.contains('식당') || t.contains('맛'))) {
      bgColor = const Color(0xFFFFF8F1);
      iconColor = Colors.orange;
      icon = Icons.restaurant;
      tag = '식사';
    } else if (item.categoryType.any((t) => t.contains('이동') || t.contains('역'))) {
      bgColor = const Color(0xFFE8F5E9);
      iconColor = Colors.green;
      icon = Icons.near_me;
      tag = '이동';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                if (!isLast)
                  Expanded(child: VerticalDivider(color: Colors.grey[300], thickness: 1.5)),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Palette.border),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(item.placeName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(4)),
                                child: Text(tag, style: TextStyle(color: iconColor, fontSize: 10, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 12, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text('${item.durationMinutes}분', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(item.description, style: const TextStyle(color: Colors.black87, fontSize: 13, height: 1.4)),
                        ],
                      ),
                    ),
                    Text(item.startTime, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.auto_awesome, size: 18),
              label: const Text('일정 수정하기', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2962FF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 1,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                backgroundColor: Palette.inputBackground,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text('목록', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
