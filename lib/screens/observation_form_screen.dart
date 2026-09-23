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
      title = '$_waterBodyType Observation';
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
        title: const Text('Guided Assessment Wizard'),
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
          const Text(
            'Where are you observing?',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Select or enter the location name and type of freshwater body.',
            style: TextStyle(color: AppColors.textMuted, fontSize: 14),
          ),
          const SizedBox(height: 20),

          // Water body type selection
          const Text(
            'Water Body Type *',
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
          const SizedBox(height: 20),

          // Predefined Demonstration Locations
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                child: Text(
                  'Quick Demo Locations',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Tap to fill',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.primaryTeal,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: AppConstants.predefinedLocations.map((loc) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ActionChip(
                    avatar: const Icon(Icons.place, size: 14, color: AppColors.primaryTeal),
                    label: Text(loc, style: const TextStyle(fontSize: 12)),
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: AppColors.border),
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
          const SizedBox(height: 16),

          // Location Name field
          const Text(
            'Location Name / Landmark *',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _locationController,
            decoration: const InputDecoration(
              hintText: 'e.g., Willow Creek Bridge, Riverside Canal',
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
          const SizedBox(height: 16),

          // Title field (Optional / Auto-generated)
          const Text(
            'Observation Title (Optional)',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: 'e.g., Afternoon River Check (defaults if blank)',
              prefixIcon: Icon(Icons.title, color: AppColors.primaryTeal),
            ),
          ),
          const SizedBox(height: 16),

          // Date & Time Picker field
          const Text(
            'Observation Date & Time (Auto-generated)',
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
                      DateFormat('EEEE, MMM dd, yyyy • hh:mm a')
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

          // Location note
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.lightTealSurface.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: const [
                Icon(Icons.gps_fixed, size: 16, color: AppColors.darkTeal),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Location model is structured for direct GPS integration in future releases.',
                    style: TextStyle(
                      color: AppColors.darkTeal,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- STEP 2: WATER APPEARANCE ---
  Widget _buildStep2WaterAppearance() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Water Appearance',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Observe visual clarity, colour, and odour from a safe position on the bank.',
          style: TextStyle(color: AppColors.textMuted, fontSize: 14),
        ),
        const SizedBox(height: 16),

        // 1. Water Clarity
        const Text(
          'How clear does the water look?',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        const SizedBox(height: 6),
        InfoTooltipCard(
          title: 'Why we ask this (Clarity)',
          description: AppConstants.educationalExplanations['clarity']!,
          icon: Icons.water_drop_outlined,
        ),
        const SizedBox(height: 8),
        ...AppConstants.clarityOptions.map((opt) {
          return _buildRadioCard(
            title: opt,
            isSelected: _clarity == opt,
            onTap: () => setState(() => _clarity = opt),
          );
        }),
        const SizedBox(height: 24),

        // 2. Visible Water Colour
        const Text(
          'What colour does the water appear to be?',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        const SizedBox(height: 6),
        InfoTooltipCard(
          title: 'Why we ask this (Colour)',
          description: AppConstants.educationalExplanations['color']!,
          icon: Icons.palette_outlined,
        ),
        const SizedBox(height: 8),
        ...AppConstants.colorOptions.map((opt) {
          return _buildRadioCard(
            title: opt,
            isSelected: _visibleColour == opt,
            onTap: () => setState(() => _visibleColour = opt),
          );
        }),
        const SizedBox(height: 24),

        // 3. Water Odour
        const Text(
          'Do you notice any unusual smell?',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        const SizedBox(height: 6),
        InfoTooltipCard(
          title: 'Why we ask this (Odour & Safety)',
          description: AppConstants.educationalExplanations['odour']!,
          icon: Icons.air,
        ),
        const SizedBox(height: 8),
        ...AppConstants.odourOptions.map((opt) {
          return _buildRadioCard(
            title: opt,
            isSelected: _odour == opt,
            onTap: () => setState(() => _odour = opt),
          );
        }),
      ],
    );
  }

  // --- STEP 3: ENVIRONMENTAL FACTORS ---
  Widget _buildStep3EnvironmentalFactors() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Environmental Factors',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Record surface flow, litter presence, vegetation, and surrounding land use.',
          style: TextStyle(color: AppColors.textMuted, fontSize: 14),
        ),
        const SizedBox(height: 16),

        // 1. Surface Water Movement
        const Text(
          'How is the water moving?',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        const SizedBox(height: 6),
        InfoTooltipCard(
          title: 'Why we ask this (Water Movement)',
          description: AppConstants.educationalExplanations['movement']!,
          icon: Icons.waves,
        ),
        const SizedBox(height: 8),
        ...AppConstants.movementOptions.map((opt) {
          return _buildRadioCard(
            title: opt,
            isSelected: _surfaceMovement == opt,
            onTap: () => setState(() => _surfaceMovement = opt),
          );
        }),
        const SizedBox(height: 24),

        // 2. Visible Litter
        const Text(
          'How much visible litter or trash do you notice?',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        const SizedBox(height: 6),
        InfoTooltipCard(
          title: 'Why we ask this (Litter)',
          description: AppConstants.educationalExplanations['litter']!,
          icon: Icons.delete_outline,
        ),
        const SizedBox(height: 8),
        ...AppConstants.litterOptions.map((opt) {
          return _buildRadioCard(
            title: opt,
            isSelected: _visibleLitter == opt,
            onTap: () => setState(() => _visibleLitter = opt),
          );
        }),
        const SizedBox(height: 24),

        // 3. Surrounding Vegetation
        const Text(
          'What do you notice around the water (Vegetation)?',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        const SizedBox(height: 6),
        InfoTooltipCard(
          title: 'Why we ask this (Vegetation)',
          description: AppConstants.educationalExplanations['vegetation']!,
          icon: Icons.grass,
        ),
        const SizedBox(height: 8),
        ...AppConstants.vegetationOptions.map((opt) {
          return _buildRadioCard(
            title: opt,
            isSelected: _surroundingVegetation == opt,
            onTap: () => setState(() => _surroundingVegetation = opt),
          );
        }),
        const SizedBox(height: 24),

        // 4. Surrounding Environment
        const Text(
          'What best describes the surrounding area?',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        const SizedBox(height: 6),
        InfoTooltipCard(
          title: 'Why we ask this (Surrounding Area)',
          description: AppConstants.educationalExplanations['environment']!,
          icon: Icons.location_city,
        ),
        const SizedBox(height: 8),
        ...AppConstants.surroundingEnvironmentOptions.map((opt) {
          return _buildRadioCard(
            title: opt,
            isSelected: _surroundingEnvironment == opt,
            onTap: () => setState(() => _surroundingEnvironment = opt),
          );
        }),
      ],
    );
  }

  // --- STEP 4: FIELD NOTES & SUMMARY ---
  Widget _buildStep4AdditionalNotes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Field Notes & Summary',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Add any extra field observations, wildlife sightings, or unusual conditions.',
          style: TextStyle(color: AppColors.textMuted, fontSize: 14),
        ),
        const SizedBox(height: 20),

        // Notes Text Field
        const Text(
          'Additional Field Notes (Optional)',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
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
        const SizedBox(height: 20),

        // Photo / Attachment Placeholder
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.lightTealSurface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.photo_camera_outlined,
                  color: AppColors.primaryTeal,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Photo & GPS Attachment',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Photo capture and GPS metadata tagging are designed for future releases.',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Official Observation Disclaimer Banner
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.warningSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.warning.withOpacity(0.4)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.shield_outlined,
                  color: AppColors.warning, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Observation Disclaimer',
                      style: TextStyle(
                        color: AppColors.warning,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(height: 4),
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

  Widget _buildRadioCard({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.lightTealSurface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.primaryTeal : AppColors.border,
          width: isSelected ? 1.5 : 1.0,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
