import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/observation.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/form_step_indicator.dart';
import '../widgets/info_tooltip_card.dart';
import 'review_save_screen.dart';

class ObservationFormScreen extends StatefulWidget {
  final Observation? initialObservation;
  final int initialStep;

  const ObservationFormScreen({
    super.key,
    this.initialObservation,
    this.initialStep = 1,
  });

  @override
  State<ObservationFormScreen> createState() => _ObservationFormScreenState();
}

class _ObservationFormScreenState extends State<ObservationFormScreen> {
  late int _currentStep;
  final int _totalSteps = 4;
  final _formKeyStep1 = GlobalKey<FormState>();

  // Form Fields State
  late TextEditingController _titleController;
  late TextEditingController _locationController;
  late TextEditingController _notesController;
  late String _waterBodyType;
  late DateTime _observationDate;
  late String _clarity;
  late String _visibleColour;
  late String _odour;
  late String _surfaceMovement;
  late String _visibleLitter;
  late String _surroundingVegetation;
  late String _surroundingEnvironment;

  @override
  void initState() {
    super.initState();
    _currentStep = widget.initialStep;
    final initial = widget.initialObservation;

    _titleController = TextEditingController(
      text: initial?.title ?? '',
    );
    _locationController = TextEditingController(
      text: initial?.location ?? '',
    );
    _notesController = TextEditingController(
      text: initial?.notes ?? '',
    );
    _waterBodyType = initial?.waterBodyType ?? AppConstants.waterBodyTypes.first;
    _observationDate = initial?.observationDate ?? DateTime.now();
    _clarity = initial?.clarity ?? AppConstants.clarityOptions.first;
    _visibleColour = initial?.visibleColour ?? AppConstants.colorOptions.first;
    _odour = initial?.odour ?? AppConstants.odourOptions.first;
    _surfaceMovement =
        initial?.surfaceMovement ?? AppConstants.movementOptions.first;
    _visibleLitter = initial?.visibleLitter ?? AppConstants.litterOptions.first;
    _surroundingVegetation = initial?.surroundingVegetation ??
        AppConstants.vegetationOptions.first;
    _surroundingEnvironment = initial?.surroundingEnvironment ??
        AppConstants.surroundingEnvironmentOptions.first;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 1) {
      if (!_formKeyStep1.currentState!.validate()) {
        return;
      }
    }

    if (_currentStep < _totalSteps) {
      setState(() {
        _currentStep++;
      });
    } else {
      _goToReview();
    }
  }

  void _prevStep() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
      });
    } else {
      Navigator.pop(context);
    }
  }

  void _goToReview() {
    final String obsId =
        widget.initialObservation?.id ??
            DateTime.now().millisecondsSinceEpoch.toString();

    // Auto generate title if user left it blank
    String title = _titleController.text.trim();
    if (title.isEmpty) {
      final loc = _locationController.text.trim();
      if (loc.isNotEmpty) {
        title = '$loc Assessment';
      } else {
        title = '$_waterBodyType Observation';
      }
    }

    final observation = Observation(
      id: obsId,
      title: title,
      waterBodyType: _waterBodyType,
      location: _locationController.text.trim(),
      observationDate: _observationDate,
      clarity: _clarity,
      visibleColour: _visibleColour,
      odour: _odour,
      surfaceMovement: _surfaceMovement,
      visibleLitter: _visibleLitter,
      surroundingVegetation: _surroundingVegetation,
      surroundingEnvironment: _surroundingEnvironment,
      notes: _notesController.text.trim(),
      isDemo: false,
      createdAt: widget.initialObservation?.createdAt ?? DateTime.now(),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewSaveScreen(observation: observation),
      ),
    );
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _observationDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryTeal,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      if (!mounted) return;
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_observationDate),
      );
      if (pickedTime != null) {
        setState(() {
          _observationDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final stepTitles = [
      'Location & Water Body',
      'Water Appearance',
      'Environmental Factors',
      'Field Notes & Summary',
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('New Assessment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _prevStep,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              children: [
                FormStepIndicator(
                  currentStep: _currentStep,
                  totalSteps: _totalSteps,
                  stepTitles: stepTitles,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: _buildCurrentStepContent(),
                  ),
                ),
                _buildBottomNavigation(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 1:
        return _buildStep1BasicDetails();
      case 2:
        return _buildStep2WaterAppearance();
      case 3:
        return _buildStep3EnvironmentalFactors();
      case 4:
        return _buildStep4AdditionalNotes();
      default:
        return const SizedBox.shrink();
    }
  }

  // --- STEP 1: BASIC LOCATION & WATER BODY ---
  Widget _buildStep1BasicDetails() {
    return Form(
      key: _formKeyStep1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dominant question (Selective Attention)
          const Text(
            'Where are you observing?',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Select the type of water body and enter the location.',
            style: TextStyle(color: AppColors.textMuted, fontSize: 14),
          ),
          const SizedBox(height: 20),

          // Water body type selection
          const Text(
            'Water Body Type',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AppConstants.waterBodyTypes.map((type) {
              final isSelected = _waterBodyType == type;
              return ChoiceChip(
                label: Text(type),
                selected: isSelected,
                selectedColor: AppColors.lightTealSurface,
                checkmarkColor: AppColors.primaryTeal,
                labelStyle: TextStyle(
                  color: isSelected
                      ? AppColors.darkTeal
                      : AppColors.textPrimary,
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _waterBodyType = type;
                    });
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Location Name field — REQUIRED, prominent
          const Text(
            'Location Name / Landmark',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _locationController,
            decoration: const InputDecoration(
              hintText: 'e.g., Willow Creek Bridge',
              prefixIcon:
                  Icon(Icons.location_on_outlined, color: AppColors.primaryTeal),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter or select a location name';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),

          // Quick demo locations — compact, secondary
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: AppConstants.predefinedLocations.map((loc) {
                return Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: ActionChip(
                    avatar: const Icon(Icons.place, size: 14, color: AppColors.primaryTeal),
                    label: Text(loc, style: const TextStyle(fontSize: 12)),
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: AppColors.border),
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      setState(() {
                        _locationController.text = loc;
                        if (_titleController.text.isEmpty) {
                          _titleController.text = '$loc Assessment';
                        }
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // Title field — clearly marked optional, visually receding
          const Text(
            'Observation Title',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 2),
          const Text(
            'Optional — auto-generated if left blank',
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: 'e.g., Afternoon River Check',
              prefixIcon: Icon(Icons.title, color: AppColors.primaryTeal),
            ),
          ),
          const SizedBox(height: 20),

          // Date & Time Picker field
          const Text(
            'Date & Time',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 6),
          InkWell(
            onTap: _pickDate,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.inputBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today,
                      color: AppColors.primaryTeal, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      DateFormat('EEE, MMM dd, yyyy • hh:mm a')
                          .format(_observationDate),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const Icon(Icons.edit_calendar,
                      color: AppColors.textMuted, size: 18),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Future GPS capability — subtle, does not compete
          Row(
            children: [
              Icon(Icons.gps_fixed, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'GPS location tagging — coming in a future release.',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- STEP 2: WATER APPEARANCE ---
  // Hierarchy per question: Question → Options → "Why we ask this" (collapsed)
  // (Hick's Law: ONE dominant task per question group)
  Widget _buildStep2WaterAppearance() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What does the water look like?',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Observe from a safe position on the bank.',
          style: TextStyle(color: AppColors.textMuted, fontSize: 14),
        ),
        const SizedBox(height: 24),

        // 1. Water Clarity
        _buildQuestionGroup(
          question: 'How clear does the water look?',
          options: AppConstants.clarityOptions,
          selectedValue: _clarity,
          onChanged: (val) => setState(() => _clarity = val),
          infoTitle: 'Why we ask this (Clarity)',
          infoDescription: AppConstants.educationalExplanations['clarity']!,
          infoIcon: Icons.water_drop_outlined,
        ),
        const SizedBox(height: 28),

        // 2. Visible Water Colour
        _buildQuestionGroup(
          question: 'What colour does the water appear?',
          options: AppConstants.colorOptions,
          selectedValue: _visibleColour,
          onChanged: (val) => setState(() => _visibleColour = val),
          infoTitle: 'Why we ask this (Colour)',
          infoDescription: AppConstants.educationalExplanations['color']!,
          infoIcon: Icons.palette_outlined,
        ),
        const SizedBox(height: 28),

        // 3. Water Odour
        _buildQuestionGroup(
          question: 'Do you notice any unusual smell?',
          options: AppConstants.odourOptions,
          selectedValue: _odour,
          onChanged: (val) => setState(() => _odour = val),
          infoTitle: 'Why we ask this (Odour & Safety)',
          infoDescription: AppConstants.educationalExplanations['odour']!,
          infoIcon: Icons.air,
        ),
      ],
    );
  }

  // --- STEP 3: ENVIRONMENTAL FACTORS ---
  Widget _buildStep3EnvironmentalFactors() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What is happening around the water?',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Record flow, litter, vegetation, and surrounding land use.',
          style: TextStyle(color: AppColors.textMuted, fontSize: 14),
        ),
        const SizedBox(height: 24),

        // 1. Surface Water Movement
        _buildQuestionGroup(
          question: 'How is the water moving?',
          options: AppConstants.movementOptions,
          selectedValue: _surfaceMovement,
          onChanged: (val) => setState(() => _surfaceMovement = val),
          infoTitle: 'Why we ask this (Water Movement)',
          infoDescription: AppConstants.educationalExplanations['movement']!,
          infoIcon: Icons.waves,
        ),
        const SizedBox(height: 28),

        // 2. Visible Litter
        _buildQuestionGroup(
          question: 'How much visible litter or trash do you notice?',
          options: AppConstants.litterOptions,
          selectedValue: _visibleLitter,
          onChanged: (val) => setState(() => _visibleLitter = val),
          infoTitle: 'Why we ask this (Litter)',
          infoDescription: AppConstants.educationalExplanations['litter']!,
          infoIcon: Icons.delete_outline,
        ),
        const SizedBox(height: 28),

        // 3. Surrounding Vegetation
        _buildQuestionGroup(
          question: 'How much vegetation is near the water?',
          options: AppConstants.vegetationOptions,
          selectedValue: _surroundingVegetation,
          onChanged: (val) => setState(() => _surroundingVegetation = val),
          infoTitle: 'Why we ask this (Vegetation)',
          infoDescription: AppConstants.educationalExplanations['vegetation']!,
          infoIcon: Icons.grass,
        ),
        const SizedBox(height: 28),

        // 4. Surrounding Environment
        _buildQuestionGroup(
          question: 'What best describes the surrounding area?',
          options: AppConstants.surroundingEnvironmentOptions,
          selectedValue: _surroundingEnvironment,
          onChanged: (val) => setState(() => _surroundingEnvironment = val),
          infoTitle: 'Why we ask this (Surrounding Area)',
          infoDescription: AppConstants.educationalExplanations['environment']!,
          infoIcon: Icons.location_city,
        ),
      ],
    );
  }

  // --- STEP 4: FIELD NOTES & SUMMARY ---
  Widget _buildStep4AdditionalNotes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Anything else to record?',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Add any extra field observations, wildlife sightings, or unusual conditions.',
          style: TextStyle(color: AppColors.textMuted, fontSize: 14),
        ),
        const SizedBox(height: 20),

        // Notes Text Field
        const Text(
          'Additional Field Notes',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 2),
        const Text(
          'Optional — your observation is valid without notes',
          style: TextStyle(color: AppColors.textMuted, fontSize: 12),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _notesController,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText:
                'e.g., Ducks spotted along the reeds. Riverbank was muddy after recent rain.',
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: 24),

        // Future capability — clearly informational, not interactive
        Row(
          children: [
            Icon(Icons.photo_camera_outlined, size: 18, color: AppColors.textMuted),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Photo capture and GPS tagging — coming in a future release.',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Observation disclaimer
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.warningSurface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.warning.withOpacity(0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.shield_outlined,
                  color: AppColors.warning, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Observation Disclaimer',
                      style: TextStyle(
                        color: AppColors.warning,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      AppConstants.observationDisclaimer,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Reusable question group: Question → Options → Info (collapsed).
  /// Consistent hierarchy across all questions (Law of Similarity).
  /// Info card appears AFTER options (progressive disclosure).
  Widget _buildQuestionGroup({
    required String question,
    required List<String> options,
    required String selectedValue,
    required ValueChanged<String> onChanged,
    required String infoTitle,
    required String infoDescription,
    required IconData infoIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question — visually dominant
        Text(
          question,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        // Options — immediate, large touch targets (Fitts's Law)
        ...options.map((opt) {
          return _buildRadioCard(
            title: opt,
            isSelected: selectedValue == opt,
            onTap: () => onChanged(opt),
          );
        }),
        const SizedBox(height: 6),
        // Educational info — collapsed by default (Hick's Law, progressive disclosure)
        InfoTooltipCard(
          title: infoTitle,
          description: infoDescription,
          icon: infoIcon,
        ),
      ],
    );
  }

  Widget _buildRadioCard({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.lightTealSurface : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected ? AppColors.primaryTeal : AppColors.border,
          width: isSelected ? 1.5 : 1.0,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Row(
            children: [
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: isSelected ? AppColors.primaryTeal : AppColors.textMuted,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.darkTeal
                        : AppColors.textPrimary,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          if (_currentStep > 1) ...[
            Expanded(
              child: CustomButton(
                text: 'Previous',
                type: CustomButtonType.outlined,
                onPressed: _prevStep,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            flex: _currentStep > 1 ? 2 : 1,
            child: CustomButton(
              text: _currentStep == _totalSteps ? 'Review Summary' : 'Next Step',
              icon: _currentStep == _totalSteps
                  ? Icons.check_circle_outline
                  : Icons.arrow_forward,
              type: CustomButtonType.primary,
              onPressed: _nextStep,
            ),
          ),
        ],
      ),
    );
  }
}
