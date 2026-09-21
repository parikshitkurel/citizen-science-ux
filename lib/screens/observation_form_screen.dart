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

  const ObservationFormScreen({super.key, this.initialObservation});

  @override
  State<ObservationFormScreen> createState() => _ObservationFormScreenState();
}

class _ObservationFormScreenState extends State<ObservationFormScreen> {
  int _currentStep = 1;
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

  @override
  void initState() {
    super.initState();
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
    // Generate UUID if creating new
    final String obsId =
        widget.initialObservation?.id ??
            DateTime.now().millisecondsSinceEpoch.toString();

    final observation = Observation(
      id: obsId,
      title: _titleController.text.trim(),
      waterBodyType: _waterBodyType,
      location: _locationController.text.trim(),
      observationDate: _observationDate,
      clarity: _clarity,
      visibleColour: _visibleColour,
      odour: _odour,
      surfaceMovement: _surfaceMovement,
      visibleLitter: _visibleLitter,
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
      'Basic Location Details',
      'Water Appearance',
      'Environmental Factors',
      'Additional Notes',
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Guided Observation Form'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _prevStep,
        ),
      ),
      body: SafeArea(
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

  // --- STEP 1: BASIC DETAILS ---
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
            'Give your observation a memorable title and location name.',
            style: TextStyle(color: AppColors.textMuted, fontSize: 14),
          ),
          const SizedBox(height: 20),

          // Title field
          const Text(
            'Observation Title *',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: 'e.g., Afternoon River Check, Bridge Survey',
              prefixIcon: Icon(Icons.title, color: AppColors.primaryTeal),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a title for your observation';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Water body type choices
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
          const SizedBox(height: 16),

          // Location field
          const Text(
            'Location Name / Landmark *',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _locationController,
            decoration: const InputDecoration(
              hintText: 'e.g., Riverside Park, East Canal Bank',
              prefixIcon:
                  Icon(Icons.location_on_outlined, color: AppColors.primaryTeal),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter the location name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Date & Time Picker field
          const Text(
            'Observation Date & Time',
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
                  Text(
                    DateFormat('EEEE, MMM dd, yyyy • hh:mm a')
                        .format(_observationDate),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.edit_calendar,
                      color: AppColors.textMuted, size: 18),
                ],
              ),
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
          'How clear does the water look?',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Observe the clarity and color from a safe position along the bank.',
          style: TextStyle(color: AppColors.textMuted, fontSize: 14),
        ),
        const SizedBox(height: 16),

        // Helper explanation tooltip
        InfoTooltipCard(
          title: 'Why we observe water clarity',
          description: AppConstants.optionTooltips['clarity']!,
          icon: Icons.water_drop_outlined,
        ),
        const SizedBox(height: 20),

        // Clarity Options
        const Text(
          'Water Clarity Choice',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        ...AppConstants.clarityOptions.map((opt) {
          final isSelected = _clarity == opt;
          return _buildRadioCard(
            title: opt,
            isSelected: isSelected,
            onTap: () {
              setState(() {
                _clarity = opt;
              });
            },
          );
        }),
        const SizedBox(height: 24),

        // Visible Colour Options
        const Text(
          'Visible Water Colour',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        InfoTooltipCard(
          title: 'Understanding water colour',
          description: AppConstants.optionTooltips['color']!,
          icon: Icons.palette_outlined,
        ),
        const SizedBox(height: 12),
        ...AppConstants.colorOptions.map((opt) {
          final isSelected = _visibleColour == opt;
          return _buildRadioCard(
            title: opt,
            isSelected: isSelected,
            onTap: () {
              setState(() {
                _visibleColour = opt;
              });
            },
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
          'Basic Environmental Factors',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Record odour, surface movement, and visible trash or litter.',
          style: TextStyle(color: AppColors.textMuted, fontSize: 14),
        ),
        const SizedBox(height: 20),

        // Odour Options
        const Text(
          'Water Odour',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        InfoTooltipCard(
          title: 'Odour context',
          description: AppConstants.optionTooltips['odour']!,
          icon: Icons.air,
        ),
        const SizedBox(height: 12),
        ...AppConstants.odourOptions.map((opt) {
          final isSelected = _odour == opt;
          return _buildRadioCard(
            title: opt,
            isSelected: isSelected,
            onTap: () {
              setState(() {
                _odour = opt;
              });
            },
          );
        }),
        const SizedBox(height: 24),

        // Surface Movement
        const Text(
          'Surface Water Movement',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        ...AppConstants.movementOptions.map((opt) {
          final isSelected = _surfaceMovement == opt;
          return _buildRadioCard(
            title: opt,
            isSelected: isSelected,
            onTap: () {
              setState(() {
                _surfaceMovement = opt;
              });
            },
          );
        }),
        const SizedBox(height: 24),

        // Visible Litter
        const Text(
          'Visible Litter / Trash',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        ...AppConstants.litterOptions.map((opt) {
          final isSelected = _visibleLitter == opt;
          return _buildRadioCard(
            title: opt,
            isSelected: isSelected,
            onTap: () {
              setState(() {
                _visibleLitter = opt;
              });
            },
          );
        }),
      ],
    );
  }

  // --- STEP 4: ADDITIONAL NOTES ---
  Widget _buildStep4AdditionalNotes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Additional Observation Notes',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Add any extra observations like surrounding wildlife, vegetation, or bank condition.',
          style: TextStyle(color: AppColors.textMuted, fontSize: 14),
        ),
        const SizedBox(height: 20),

        TextFormField(
          controller: _notesController,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText:
                'e.g., Ducks swimming near reeds. Water level looks slightly higher than usual after yesterday\'s rain.',
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: 24),

        // Future extension placeholder card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border, style: BorderStyle.solid),
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
                      'Photo capture and automatic GPS coordinate tagging will be enabled in Version 2.',
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
