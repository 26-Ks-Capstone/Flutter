import 'package:flutter/material.dart';
import '../model/guide_item.dart';

class GuideProvider extends ChangeNotifier {
  final List<GuideItem> _guides = [
    GuideItem(
      id: 1,
      guideName: '이현지',
      title: '제주 숨은 맛집 & 자연 투어',
      description:
      '관광객이 모르는 현지인 맛집과 숨겨진 자연 명소를 함께 둘러보는 투어입니다. 제주에서 오래 거주한 로컬 가이드가 진짜 제주를 안내합니다.',
      region: '제주도',
      rating: 4.9,
      reviewCount: 47,
      price: 45000,
      durationText: '6시간',
      peopleText: '3/6명',
      tags: ['맛집 투어', '자연 탐방', '사진 촬영'],
      imageUrl:
      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e',
      isVerified: true,
      hasOwnCar: true,
      languages: ['English', '日本語'],
      meetingPlace: '제주공항 1번 출구 앞',
      meetingGuide: '파란 모자를 쓴 가이드가 기다리고 있습니다.',
      includedItems: ['차량 이동', '입장료 일부', '사진 촬영'],
      schedules: [
        GuideScheduleItem(
          startTime: '10:00',
          endTime: '11:30',
          title: '로컬 브런치 맛집 방문',
          description: '현지인들이 자주 가는 브런치 식당에서 식사합니다.',
        ),
        GuideScheduleItem(
          startTime: '12:00',
          endTime: '14:00',
          title: '숨은 자연 명소 탐방',
          description: '잘 알려지지 않은 해안 산책길과 포토스팟을 둘러봅니다.',
        ),
        GuideScheduleItem(
          startTime: '14:30',
          endTime: '16:00',
          title: '감성 카페 및 자유 촬영',
          description: '오션뷰 카페에서 휴식 후 사진 촬영 시간을 가집니다.',
        ),
      ],
    ),
    GuideItem(
      id: 2,
      guideName: '박도현',
      title: '부산 야경 & 해산물 프리미엄 투어',
      description:
      '광안대교 야경을 배경으로 부산의 해산물과 감성 포인트를 함께 즐길 수 있는 프리미엄 저녁 투어입니다.',
      region: '부산',
      rating: 4.8,
      reviewCount: 32,
      price: 65000,
      durationText: '4시간',
      peopleText: '1/4명',
      tags: ['야경 투어', '사진 촬영', '맛집 투어'],
      imageUrl:
      'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d',
      isVerified: true,
      hasOwnCar: false,
      languages: ['English', '中文(简)'],
      meetingPlace: '광안리 해수욕장 입구',
      meetingGuide: '입구 앞 안내판 근처에서 만납니다.',
      includedItems: ['야경 명소 안내', '사진 촬영', '맛집 코스 추천'],
      schedules: [
        GuideScheduleItem(
          startTime: '17:00',
          endTime: '18:00',
          title: '광안리 해변 산책',
          description: '광안리 일대를 걸으며 포인트 설명을 듣습니다.',
        ),
        GuideScheduleItem(
          startTime: '18:10',
          endTime: '19:20',
          title: '해산물 맛집 방문',
          description: '부산 대표 해산물 맛집에서 저녁 식사를 즐깁니다.',
        ),
        GuideScheduleItem(
          startTime: '19:30',
          endTime: '21:00',
          title: '광안대교 야경 촬영',
          description: '야경 포인트로 이동해 인생샷을 촬영합니다.',
        ),
      ],
    ),
    GuideItem(
      id: 3,
      guideName: '김서연',
      title: '경주 역사 깊이 탐방 투어',
      description:
      '경주 출신 역사 전공 가이드가 교과서에 나오지 않는 신라 이야기와 유적의 숨겨진 의미를 쉽고 재미있게 설명합니다.',
      region: '경주',
      rating: 4.7,
      reviewCount: 21,
      price: 35000,
      durationText: '5시간',
      peopleText: '5/8명',
      tags: ['역사 해설', '문화 체험', '트레킹'],
      imageUrl:
      'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
      isVerified: true,
      hasOwnCar: false,
      languages: ['English'],
      meetingPlace: '경주역 앞 광장',
      meetingGuide: '역 앞 시계탑 옆에서 만납니다.',
      includedItems: ['역사 해설', '도보 코스 안내'],
      schedules: [
        GuideScheduleItem(
          startTime: '09:30',
          endTime: '11:00',
          title: '대릉원 탐방',
          description: '왕릉의 역사와 배경을 설명합니다.',
        ),
        GuideScheduleItem(
          startTime: '11:20',
          endTime: '13:00',
          title: '황리단길 문화 산책',
          description: '전통과 현대가 섞인 공간을 둘러봅니다.',
        ),
        GuideScheduleItem(
          startTime: '13:20',
          endTime: '14:30',
          title: '첨성대 및 주변 유적 설명',
          description: '대표 유적을 중심으로 역사 흐름을 설명합니다.',
        ),
      ],
    ),
  ];

  String _selectedRegion = '전체';
  String _searchKeyword = '';
  String _sortType = '추천순';

  List<GuideItem> get guides => List.unmodifiable(_guides);
  String get selectedRegion => _selectedRegion;
  String get searchKeyword => _searchKeyword;
  String get sortType => _sortType;

  List<String> get regionOptions => ['전체', '제주도', '부산', '서울', '경주', '강릉', '여수'];
  List<String> get sortOptions => ['추천순', '평점순', '가격낮은순'];

  List<GuideItem> get filteredGuides {
    List<GuideItem> result = _guides.where((item) {
      final regionMatched =
          _selectedRegion == '전체' || item.region == _selectedRegion;

      final keyword = _searchKeyword.trim().toLowerCase();
      final keywordMatched = keyword.isEmpty ||
          item.guideName.toLowerCase().contains(keyword) ||
          item.title.toLowerCase().contains(keyword) ||
          item.region.toLowerCase().contains(keyword) ||
          item.description.toLowerCase().contains(keyword);

      return regionMatched && keywordMatched;
    }).toList();

    if (_sortType == '평점순') {
      result.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (_sortType == '가격낮은순') {
      result.sort((a, b) => a.price.compareTo(b.price));
    } else {
      result.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
    }

    return result;
  }

  void updateRegion(String region) {
    _selectedRegion = region;
    notifyListeners();
  }

  void updateSearchKeyword(String keyword) {
    _searchKeyword = keyword;
    notifyListeners();
  }

  void updateSortType(String sortType) {
    _sortType = sortType;
    notifyListeners();
  }

  void addGuide(GuideItem item) {
    _guides.insert(0, item);
    notifyListeners();
  }

  int getNextId() {
    if (_guides.isEmpty) return 1;
    return _guides.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
  }
}