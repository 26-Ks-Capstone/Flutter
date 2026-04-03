class GuideScheduleItem {
  final String startTime;
  final String endTime;
  final String title;
  final String description;

  GuideScheduleItem({
    required this.startTime,
    required this.endTime,
    required this.title,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'startTime': startTime,
      'endTime': endTime,
      'title': title,
      'description': description,
    };
  }

  factory GuideScheduleItem.fromMap(Map<String, dynamic> map) {
    return GuideScheduleItem(
      startTime: map['startTime'] ?? '',
      endTime: map['endTime'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
    );
  }
}

class GuideItem {
  final int id;
  final String guideName;
  final String title;
  final String description;
  final String region;
  final double rating;
  final int reviewCount;
  final int price;
  final String durationText;
  final String peopleText;
  final List<String> tags;
  final String imageUrl;
  final bool isVerified;

  final bool hasOwnCar;
  final List<String> languages;
  final String meetingPlace;
  final String meetingGuide;
  final List<String> includedItems;
  final List<GuideScheduleItem> schedules;

  GuideItem({
    required this.id,
    required this.guideName,
    required this.title,
    required this.description,
    required this.region,
    required this.rating,
    required this.reviewCount,
    required this.price,
    required this.durationText,
    required this.peopleText,
    required this.tags,
    required this.imageUrl,
    required this.isVerified,
    required this.hasOwnCar,
    required this.languages,
    required this.meetingPlace,
    required this.meetingGuide,
    required this.includedItems,
    required this.schedules,
  });

  GuideItem copyWith({
    int? id,
    String? guideName,
    String? title,
    String? description,
    String? region,
    double? rating,
    int? reviewCount,
    int? price,
    String? durationText,
    String? peopleText,
    List<String>? tags,
    String? imageUrl,
    bool? isVerified,
    bool? hasOwnCar,
    List<String>? languages,
    String? meetingPlace,
    String? meetingGuide,
    List<String>? includedItems,
    List<GuideScheduleItem>? schedules,
  }) {
    return GuideItem(
      id: id ?? this.id,
      guideName: guideName ?? this.guideName,
      title: title ?? this.title,
      description: description ?? this.description,
      region: region ?? this.region,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      price: price ?? this.price,
      durationText: durationText ?? this.durationText,
      peopleText: peopleText ?? this.peopleText,
      tags: tags ?? this.tags,
      imageUrl: imageUrl ?? this.imageUrl,
      isVerified: isVerified ?? this.isVerified,
      hasOwnCar: hasOwnCar ?? this.hasOwnCar,
      languages: languages ?? this.languages,
      meetingPlace: meetingPlace ?? this.meetingPlace,
      meetingGuide: meetingGuide ?? this.meetingGuide,
      includedItems: includedItems ?? this.includedItems,
      schedules: schedules ?? this.schedules,
    );
  }
}