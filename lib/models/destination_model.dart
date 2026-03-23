class Destination {
  final String id;
  final String name;
  final String location;
  final String imageUrl;
  final double rating;
  final List<String> tags;

  Destination({
    required this.id,
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.rating,
    required this.tags,
  });
}

// 샘플 데이터
final List<Destination> sampleDestinations = [
  Destination(
    id: '1',
    name: '제주도',
    location: '제주특별자치도',
    imageUrl: 'https://images.unsplash.com/photo-1571746242701-a187b508f7f8?q=80&w=1000&auto=format&fit=crop',
    rating: 4.8,
    tags: ['자연', '해변', '맛집'],
  ),
  Destination(
    id: '2',
    name: '부산 해운대',
    location: '부산광역시',
    imageUrl: 'https://images.unsplash.com/photo-1590483734724-383b853b237d?q=80&w=1000&auto=format&fit=crop',
    rating: 4.7,
    tags: ['바다', '야경'],
  ),
  Destination(
    id: '3',
    name: '서울 경복궁',
    location: '서울특별시',
    imageUrl: 'https://images.unsplash.com/photo-1538669715515-5c398980710b?q=80&w=1000&auto=format&fit=crop',
    rating: 4.6,
    tags: ['문화', '역사'],
  ),
  Destination(
    id: '4',
    name: '강릉 안목해변',
    location: '강원도',
    imageUrl: 'https://images.unsplash.com/photo-1621609764095-b32bbe35cf3a?q=80&w=1000&auto=format&fit=crop',
    rating: 4.5,
    tags: ['카페', '바다'],
  ),
  Destination(
    id: '5',
    name: '전주 한옥마을',
    location: '전라북도',
    imageUrl: 'https://images.unsplash.com/photo-1547039916-d34e94285871?q=80&w=1000&auto=format&fit=crop',
    rating: 4.4,
    tags: ['한옥', '전통'],
  ),
];
