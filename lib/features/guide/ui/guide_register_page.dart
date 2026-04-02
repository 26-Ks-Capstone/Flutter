import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/guide_item.dart';
import '../provider/guide_provider.dart';
import 'guide_register_step_page.dart';

class GuideRegisterPage extends StatefulWidget {
  const GuideRegisterPage({super.key});

  @override
  State<GuideRegisterPage> createState() => _GuideRegisterPageState();
}

class _GuideRegisterPageState extends State<GuideRegisterPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  final _basicFormKey = GlobalKey<FormState>();

  final TextEditingController _guideNameController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _peopleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _meetingPlaceController = TextEditingController();
  final TextEditingController _meetingGuideController = TextEditingController();
  final TextEditingController _includedItemsController = TextEditingController();

  bool _hasOwnCar = false;
  final List<String> _selectedLanguages = [];

  final List<String> _languageOptions = [
    'English',
    '日本語',
    '中文(简)',
    '中文(繁)',
    'Español',
    'Français',
    'Deutsch',
    'Tiếng Việt',
    'ไทย',
  ];

  final List<ScheduleFormData> _scheduleForms = [
    ScheduleFormData(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _guideNameController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _regionController.dispose();
    _durationController.dispose();
    _peopleController.dispose();
    _priceController.dispose();
    _meetingPlaceController.dispose();
    _meetingGuideController.dispose();
    _includedItemsController.dispose();

    for (final form in _scheduleForms) {
      form.dispose();
    }
    super.dispose();
  }

  void _goToStep(int step) {
    setState(() {
      _currentStep = step;
    });
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOut,
    );
  }

  void _nextStep() {
    if (_currentStep == 0) {
      if (!_basicFormKey.currentState!.validate()) return;
      if (_selectedLanguages.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('안내 가능 언어를 1개 이상 선택해주세요.')),
        );
        return;
      }
    }

    if (_currentStep < 2) {
      _goToStep(_currentStep + 1);
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      _goToStep(_currentStep - 1);
    }
  }

  void _submit() {
    final provider = context.read<GuideProvider>();

    final schedules = _scheduleForms
        .where((e) =>
    e.titleController.text.trim().isNotEmpty &&
        e.startController.text.trim().isNotEmpty &&
        e.endController.text.trim().isNotEmpty)
        .map(
          (e) => GuideScheduleItem(
        startTime: e.startController.text.trim(),
        endTime: e.endController.text.trim(),
        title: e.titleController.text.trim(),
        description: e.descriptionController.text.trim(),
      ),
    )
        .toList();

    final item = GuideItem(
      id: provider.getNextId(),
      guideName: _guideNameController.text.trim(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      region: _regionController.text.trim(),
      rating: 5.0,
      reviewCount: 0,
      price: int.tryParse(_priceController.text.trim()) ?? 0,
      durationText: _durationController.text.trim(),
      peopleText: '0/${_peopleController.text.trim()}명',
      tags: _buildTags(),
      imageUrl: 'https://images.unsplash.com/photo-1521119989659-a83eee488004',
      isVerified: true,
      hasOwnCar: _hasOwnCar,
      languages: List<String>.from(_selectedLanguages),
      meetingPlace: _meetingPlaceController.text.trim(),
      meetingGuide: _meetingGuideController.text.trim(),
      includedItems: _includedItemsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      schedules: schedules,
    );

    provider.addGuide(item);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('등록 완료'),
          content: const Text(
            '가이드 등록이 완료되었습니다.\n탐색 화면에서 바로 확인할 수 있습니다.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  List<String> _buildTags() {
    final List<String> tags = [];
    if (_hasOwnCar) tags.add('자차 포함');
    if (_selectedLanguages.isNotEmpty) tags.add(_selectedLanguages.first);
    tags.add('신규 등록');
    return tags;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        title: const Text(
          '가이드 등록',
          style: TextStyle(
            color: Color(0xFF111827),
            fontWeight: FontWeight.w800,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF111827)),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: GuideRegisterStepPage(
              currentStep: _currentStep,
              stepTitles: const ['기본 정보', '상세 일정', '확인 및 등록'],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildBasicStep(),
                _buildScheduleStep(),
                _buildSummaryStep(),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              if (_currentStep > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: _prevStep,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      '이전',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              if (_currentStep > 0) const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: _currentStep == 2 ? _submit : _nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _currentStep == 2
                        ? const Color(0xFF16A34A)
                        : const Color(0xFF2F6BFF),
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(54),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Text(
                    _currentStep == 2 ? '등록 완료' : '다음으로',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Form(
        key: _basicFormKey,
        child: Column(
          children: [
            _input(
              controller: _guideNameController,
              label: '가이드 이름',
              hint: '예: 박도현',
            ),
            _input(
              controller: _titleController,
              label: '투어 제목',
              hint: '예: 부산 야경 & 해산물 프리미엄 투어',
            ),
            _input(
              controller: _descriptionController,
              label: '투어 설명',
              hint: '투어의 특별한 점과 매력을 소개해주세요.',
              maxLines: 4,
            ),
            _input(
              controller: _regionController,
              label: '활동 지역',
              hint: '예: 부산',
            ),
            Row(
              children: [
                Expanded(
                  child: _input(
                    controller: _durationController,
                    label: '소요 시간',
                    hint: '예: 4시간',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _input(
                    controller: _peopleController,
                    label: '최대 인원',
                    hint: '예: 4',
                  ),
                ),
              ],
            ),
            _input(
              controller: _priceController,
              label: '1인당 가격(원)',
              hint: '예: 45000',
              keyboardType: TextInputType.number,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '자차 안내 여부',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _choiceButton(
                          label: '자차 포함',
                          selected: _hasOwnCar,
                          onTap: () {
                            setState(() {
                              _hasOwnCar = true;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _choiceButton(
                          label: '도보 / 대중교통',
                          selected: !_hasOwnCar,
                          onTap: () {
                            setState(() {
                              _hasOwnCar = false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '안내 가능 언어',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '복수 선택 가능',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _languageOptions.map((lang) {
                      final selected = _selectedLanguages.contains(lang);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (selected) {
                              _selectedLanguages.remove(lang);
                            } else {
                              _selectedLanguages.add(lang);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFF2F6BFF)
                                : const Color(0xFFF2F4F8),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Text(
                            lang,
                            style: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : const Color(0xFF374151),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            _input(
              controller: _meetingPlaceController,
              label: '접선 장소',
              hint: '예: 부산역 1번 출구 앞',
            ),
            _input(
              controller: _meetingGuideController,
              label: '상세 안내',
              hint: '예: 파란색 가방을 들고 있는 가이드가 기다립니다.',
              maxLines: 3,
              requiredField: false,
            ),
            _input(
              controller: _includedItemsController,
              label: '포함 사항',
              hint: '예: 차량 이동, 사진 촬영, 입장료 일부 (쉼표로 구분)',
              requiredField: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleStep() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        ...List.generate(_scheduleForms.length, (index) {
          final form = _scheduleForms[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '일정 ${index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _smallInput(
                        controller: form.startController,
                        label: '시작 시간',
                        hint: '10:00',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _smallInput(
                        controller: form.endController,
                        label: '종료 시간',
                        hint: '11:30',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _smallInput(
                  controller: form.titleController,
                  label: '일정 제목',
                  hint: '예: 광안리 해변 산책',
                ),
                const SizedBox(height: 12),
                _smallInput(
                  controller: form.descriptionController,
                  label: '일정 설명',
                  hint: '무엇을 하는지 작성해주세요.',
                  maxLines: 3,
                ),
                if (_scheduleForms.length > 1)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          form.dispose();
                          _scheduleForms.removeAt(index);
                        });
                      },
                      child: const Text('삭제'),
                    ),
                  ),
              ],
            ),
          );
        }),
        OutlinedButton.icon(
          onPressed: () {
            setState(() {
              _scheduleForms.add(ScheduleFormData());
            });
          },
          icon: const Icon(Icons.add),
          label: const Text('일정 추가'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryStep() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        _summaryCard(
          title: '기본 정보',
          onEdit: () => _goToStep(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _summaryRow('가이드 이름', _guideNameController.text),
              _summaryRow('투어 제목', _titleController.text),
              _summaryRow('지역', _regionController.text),
              _summaryRow('소요 시간', _durationController.text),
              _summaryRow('최대 인원', _peopleController.text.isEmpty ? '' : '${_peopleController.text}명'),
              _summaryRow('가격', _priceController.text.isEmpty ? '' : '${_priceController.text}원'),
              _summaryRow('자차 여부', _hasOwnCar ? '자차 포함' : '도보 / 대중교통'),
              _summaryRow('언어', _selectedLanguages.join(', ')),
              _summaryRow('접선 장소', _meetingPlaceController.text),
            ],
          ),
        ),
        _summaryCard(
          title: '상세 일정',
          onEdit: () => _goToStep(1),
          child: Column(
            children: _scheduleForms.map((e) {
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${e.startController.text} ~ ${e.endController.text}',
                      style: const TextStyle(
                        color: Color(0xFF2F6BFF),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      e.titleController.text,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111827),
                      ),
                    ),
                    if (e.descriptionController.text.trim().isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        e.descriptionController.text,
                        style: const TextStyle(
                          color: Color(0xFF6B7280),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _summaryCard({
    required String title,
    required Widget child,
    required VoidCallback onEdit,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                  color: Color(0xFF111827),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: onEdit,
                child: const Text('수정'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF9CA3AF),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: const TextStyle(
                color: Color(0xFF111827),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    bool requiredField = true,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: (value) {
          if (!requiredField) return null;
          if (value == null || value.trim().isEmpty) {
            return '$label 값을 입력해주세요.';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _smallInput({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _choiceButton({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEAF2FF) : const Color(0xFFF2F4F8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? const Color(0xFF2F6BFF) : Colors.transparent,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: selected ? const Color(0xFF2F6BFF) : const Color(0xFF374151),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class ScheduleFormData {
  final TextEditingController startController = TextEditingController();
  final TextEditingController endController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  void dispose() {
    startController.dispose();
    endController.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }
}