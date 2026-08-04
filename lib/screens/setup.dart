import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../data.dart';
import '../theme.dart';
import '../widgets.dart';
import 'shell.dart';

/* ==================== STEP 1 · PHOTO UPLOAD ==================== */

class PhotoUploadScreen extends StatefulWidget {
  const PhotoUploadScreen({super.key, this.replacing = false});

  /// True when opened from Profile → Replace photo.
  final bool replacing;

  @override
  State<PhotoUploadScreen> createState() => _PhotoUploadScreenState();
}

class _PhotoUploadScreenState extends State<PhotoUploadScreen> {
  double _progress = 0;
  bool _uploading = false;
  bool _done = false;
  Timer? _timer;

  Future<void> _pickAndUpload(ImageSource source) async {
    await Demo.beginPick('tryon');
    try {
      final file = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1440,
        imageQuality: 88,
      );
      await Demo.endPick();
      if (file == null) return;
      Demo.applyPick('tryon', file.path);
    } catch (_) {
      await Demo.endPick();
      if (mounted) vexaToast(context, 'Could not open the camera', info: true);
      return;
    }
    _simulateUpload();
  }

  void _simulateUpload() {
    _timer?.cancel();
    setState(() {
      _uploading = true;
      _done = false;
      _progress = 0;
    });
    _timer = Timer.periodic(const Duration(milliseconds: 90), (t) {
      setState(() => _progress = (_progress + .07).clamp(0, 1));
      if (_progress >= 1) {
        t.cancel();
        setState(() => _done = true);
        vexaToast(context, 'Photo looks great');
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _showGuidelines() {
    showVexaSheet(
      context,
      title: 'Photo Guidelines',
      subtitle: 'What makes a great try-on photo',
      icon: Icons.accessibility_new_rounded,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _Example(
                image: 'assets/images/user_photo.jpg',
                good: true,
                points: const [
                  'Full body visible',
                  'Even, soft lighting',
                  'Simple background',
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _Example(
                image: 'assets/images/portrait.jpg',
                good: false,
                points: const [
                  'Body partly cropped',
                  'Dark, moody lighting',
                  'Loose, flowing layers',
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        VexaButton(label: 'Got It', onTap: () => Navigator.pop(context)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 34),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleIconButton(
                    icon: Icons.arrow_back_rounded,
                    onTap: () => Navigator.maybePop(context),
                  ),
                  const Spacer(),
                  Text(
                    widget.replacing ? 'REPLACE PHOTO' : 'STEP 1 OF 3',
                    style: VexaText.eyebrow(),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              RichText(
                text: TextSpan(
                  style: VexaText.display(size: 32),
                  children: [
                    const TextSpan(text: 'Add your\n'),
                    TextSpan(
                      text: 'try-on photo',
                      style: VexaText.serifAccent(size: 32),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'One clear, full-body photo is all the AI needs to dress you.',
                style: VexaText.body(),
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: _uploading
                    ? Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Image(
                            image: Demo.tryOnPhoto,
                            height: 420,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(14),
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF111015,
                                ).withValues(alpha: .6),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          if (_done)
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                right: 7,
                                              ),
                                              child: Icon(
                                                Icons.check_circle_rounded,
                                                size: 16,
                                                color: Color(0xFF7EE79D),
                                              ),
                                            ),
                                          Text(
                                            _done
                                                ? 'Quality check passed'
                                                : 'IMG_2841.jpg',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        _done
                                            ? 'Ready'
                                            : '${(_progress * 100).round()}%',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 9),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(2),
                                    child: LinearProgressIndicator(
                                      value: _progress,
                                      minHeight: 4,
                                      backgroundColor: Colors.white.withValues(
                                        alpha: .2,
                                      ),
                                      color: _done
                                          ? VexaColors.good
                                          : const Color(0xFF9B72FF),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(
                        height: 380,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFEDF3),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: VexaColors.line2,
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 74,
                              height: 74,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(26),
                                boxShadow: VexaShadows.card,
                              ),
                              child: const Icon(
                                Icons.accessibility_new_rounded,
                                color: VexaColors.iris,
                                size: 34,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No photo yet',
                              style: VexaText.title(size: 17),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 60,
                              ),
                              child: Text(
                                'Stand facing the camera against a plain background, in fitted clothing.',
                                style: VexaText.body(size: 13),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: VexaOutlineButton(
                      label: 'Take Photo',
                      icon: Icons.photo_camera_outlined,
                      height: 52,
                      onTap: () => _pickAndUpload(ImageSource.camera),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: VexaOutlineButton(
                      label: 'From Gallery',
                      icon: Icons.image_outlined,
                      height: 52,
                      onTap: () => _pickAndUpload(ImageSource.gallery),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Center(
                child: TextButton.icon(
                  onPressed: _showGuidelines,
                  icon: const Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: VexaColors.irisDeep,
                  ),
                  label: Text(
                    'See photo guidelines',
                    style: VexaText.label(size: 13, color: VexaColors.irisDeep),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              VexaButton(
                label: widget.replacing ? 'Save New Photo' : 'Continue',
                onTap: _done
                    ? () {
                        if (widget.replacing) {
                          Navigator.pop(context);
                          vexaToast(context, 'Try-on photo updated');
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MeasurementsScreen(),
                            ),
                          );
                        }
                      }
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Example extends StatelessWidget {
  const _Example({
    required this.image,
    required this.good,
    required this.points,
  });

  final String image;
  final bool good;
  final List<String> points;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: VexaColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(
                image,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  height: 26,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: good ? VexaColors.good : VexaColors.bad,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        good ? Icons.check_rounded : Icons.close_rounded,
                        size: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        good ? 'Good' : 'Avoid',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final p in points)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          good ? Icons.check_rounded : Icons.close_rounded,
                          size: 14,
                          color: good ? VexaColors.good : VexaColors.bad,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(p, style: VexaText.body(size: 11.5)),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ==================== STEP 2 · MEASUREMENTS ==================== */

class MeasurementsScreen extends StatefulWidget {
  const MeasurementsScreen({super.key, this.editing = false});

  final bool editing;

  @override
  State<MeasurementsScreen> createState() => _MeasurementsScreenState();
}

class _MeasurementsScreenState extends State<MeasurementsScreen> {
  int _gender = 0;
  double _height = 168;
  double _weight = 58;
  int _chest = 86;
  int _waist = 66;
  int _hip = 92;
  int _age = 27;

  Widget _sliderCard(
    String label,
    IconData icon,
    double value,
    String unit,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return VexaCard(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: VexaColors.paper,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, size: 19, color: VexaColors.text),
              ),
              const SizedBox(width: 12),
              Text(label, style: VexaText.label(size: 13.5)),
              const Spacer(),
              RichText(
                text: TextSpan(
                  style: VexaText.display(
                    size: 24,
                  ).copyWith(letterSpacing: -.6),
                  children: [
                    TextSpan(text: value.round().toString()),
                    TextSpan(
                      text: '\u2006 $unit',
                      style: VexaText.body(
                        size: 12,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: VexaColors.iris,
              inactiveTrackColor: VexaColors.line,
              thumbColor: Colors.white,
              trackHeight: 6,
              overlayShape: SliderComponentShape.noOverlay,
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 13,
                elevation: 4,
              ),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${min.round()} $unit',
                  style: VexaText.body(size: 10.5, color: VexaColors.faint),
                ),
                Text(
                  '${max.round()} $unit',
                  style: VexaText.body(size: 10.5, color: VexaColors.faint),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepper(
    String label,
    int value,
    String unit,
    ValueChanged<int> onChanged,
  ) {
    return Expanded(
      child: VexaCard(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        radius: 16,
        child: Column(
          children: [
            Text(
              label.toUpperCase(),
              style: VexaText.eyebrow(
                color: VexaColors.muted,
              ).copyWith(fontSize: 10),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: VexaText.display(size: 21).copyWith(letterSpacing: -.4),
                children: [
                  TextSpan(text: '$value'),
                  TextSpan(
                    text: '\u2006 $unit',
                    style: VexaText.body(
                      size: 11,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 9),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _roundStep(Icons.remove_rounded, () => onChanged(value - 1)),
                const SizedBox(width: 8),
                _roundStep(Icons.add_rounded, () => onChanged(value + 1)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _roundStep(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(
        side: BorderSide(color: VexaColors.line2, width: 1.2),
      ),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 34,
          height: 34,
          child: Icon(icon, size: 17, color: VexaColors.text),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 34),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleIconButton(
                    icon: Icons.arrow_back_rounded,
                    onTap: () => Navigator.maybePop(context),
                  ),
                  const Spacer(),
                  Text(
                    widget.editing ? 'PROFILE' : 'STEP 2 OF 3',
                    style: VexaText.eyebrow(),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              RichText(
                text: TextSpan(
                  style: VexaText.display(size: 32),
                  children: [
                    const TextSpan(text: 'Your\n'),
                    TextSpan(
                      text: 'measurements',
                      style: VexaText.serifAccent(size: 32),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Used only to keep outfit proportions realistic. You can update these anytime.',
                style: VexaText.body(),
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFEDF3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: List.generate(3, (i) {
                    final labels = ['Female', 'Male', 'Non-binary'];
                    final on = _gender == i;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _gender = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          height: 44,
                          decoration: BoxDecoration(
                            color: on ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: on
                                ? [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF131217,
                                      ).withValues(alpha: .1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            labels[i],
                            style: VexaText.label(
                              size: 13.5,
                              color: on ? VexaColors.text : VexaColors.muted,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),
              _sliderCard(
                'Height',
                Icons.height_rounded,
                _height,
                'cm',
                140,
                200,
                (v) => setState(() => _height = v),
              ),
              const SizedBox(height: 16),
              _sliderCard(
                'Weight',
                Icons.monitor_weight_outlined,
                _weight,
                'kg',
                38,
                130,
                (v) => setState(() => _weight = v),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _stepper(
                    'Chest',
                    _chest,
                    'cm',
                    (v) => setState(() => _chest = v),
                  ),
                  const SizedBox(width: 12),
                  _stepper(
                    'Waist',
                    _waist,
                    'cm',
                    (v) => setState(() => _waist = v),
                  ),
                  const SizedBox(width: 12),
                  _stepper('Hip', _hip, 'cm', (v) => setState(() => _hip = v)),
                ],
              ),
              const SizedBox(height: 16),
              VexaCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                radius: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Age', style: VexaText.label(size: 13)),
                    Row(
                      children: [
                        _roundStep(
                          Icons.remove_rounded,
                          () => setState(() => _age--),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Text(
                            '$_age',
                            style: VexaText.display(size: 21),
                          ),
                        ),
                        _roundStep(
                          Icons.add_rounded,
                          () => setState(() => _age++),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              VexaButton(
                label: widget.editing ? 'Save Changes' : 'Continue',
                onTap: () {
                  if (widget.editing) {
                    Navigator.pop(context);
                    vexaToast(context, 'Measurements updated');
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const StylePrefsScreen(),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ==================== STEP 3 · STYLE PREFERENCES ==================== */

class StylePrefsScreen extends StatefulWidget {
  const StylePrefsScreen({super.key, this.editing = false});

  final bool editing;

  @override
  State<StylePrefsScreen> createState() => _StylePrefsScreenState();
}

class _StylePrefsScreenState extends State<StylePrefsScreen> {
  static const _icons = {
    'Casual': Icons.checkroom_rounded,
    'Minimal': Icons.circle_outlined,
    'Formal': Icons.diamond_outlined,
    'Business': Icons.work_outline_rounded,
    'Sporty': Icons.bolt_rounded,
    'Elegant': Icons.auto_awesome_outlined,
  };

  static const _descs = {
    'Casual': 'Easy, everyday comfort',
    'Minimal': 'Clean lines, quiet colors',
    'Formal': 'Sharp, occasion-ready',
    'Business': 'Polished workwear',
    'Sporty': 'Active, athleisure energy',
    'Elegant': 'Refined evening looks',
  };

  int get _count => Demo.stylePrefs.values.where((v) => v).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 12, 22, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleIconButton(
                          icon: Icons.arrow_back_rounded,
                          onTap: () => Navigator.maybePop(context),
                        ),
                        const Spacer(),
                        Text(
                          widget.editing ? 'PROFILE' : 'STEP 3 OF 3',
                          style: VexaText.eyebrow(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    RichText(
                      text: TextSpan(
                        style: VexaText.display(size: 32),
                        children: [
                          const TextSpan(text: "What's your\n"),
                          TextSpan(
                            text: 'style?',
                            style: VexaText.serifAccent(size: 32),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Pick as many as you like — recommendations will lean this way.',
                      style: VexaText.body(),
                    ),
                    const SizedBox(height: 20),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 13,
                      crossAxisSpacing: 13,
                      childAspectRatio: 1.12,
                      children: Demo.stylePrefs.keys.map((name) {
                        final on = Demo.stylePrefs[name]!;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => Demo.stylePrefs[name] = !on),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            padding: const EdgeInsets.all(17),
                            decoration: BoxDecoration(
                              color: on ? VexaColors.irisGhost : Colors.white,
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: on ? VexaColors.iris : VexaColors.line,
                                width: 1.5,
                              ),
                              boxShadow: VexaShadows.card,
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: on
                                            ? VexaColors.irisSoft
                                            : VexaColors.paper,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Icon(
                                        _icons[name],
                                        size: 21,
                                        color: on
                                            ? VexaColors.irisDeep
                                            : VexaColors.text,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      name,
                                      style: VexaText.title(size: 15.5),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _descs[name]!,
                                      style: VexaText.body(size: 11.5),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 220),
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: on
                                          ? VexaColors.iris
                                          : Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: on
                                            ? VexaColors.iris
                                            : VexaColors.line2,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: on
                                        ? const Icon(
                                            Icons.check_rounded,
                                            size: 15,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 8, 22, 24),
              child: VexaButton(
                label: widget.editing
                    ? 'Save Changes'
                    : 'Continue · $_count selected',
                onTap: _count == 0
                    ? null
                    : () {
                        if (widget.editing) {
                          Navigator.pop(context);
                          vexaToast(context, 'Style preferences saved');
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SetupCompleteScreen(),
                            ),
                          );
                        }
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ==================== SETUP COMPLETE ==================== */

class SetupCompleteScreen extends StatelessWidget {
  const SetupCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 40, 22, 36),
          child: Column(
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: const BoxDecoration(
                  color: VexaColors.goodSoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: VexaColors.good,
                  size: 36,
                ),
              ),
              const SizedBox(height: 22),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: VexaText.display(size: 32),
                  children: [
                    const TextSpan(text: 'Your studio\nis '),
                    TextSpan(
                      text: 'ready',
                      style: VexaText.serifAccent(size: 32),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Photo approved, measurements saved, style set. Time to build your digital closet.',
                style: VexaText.body(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Stack(
                  children: [
                    Image(
                      image: Demo.tryOnPhoto,
                      height: 360,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      height: 360,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            const Color(0xFF0B0B0F).withValues(alpha: .68),
                          ],
                          stops: const [.4, 1],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 14,
                      left: 14,
                      child: Container(
                        height: 32,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: VexaColors.good.withValues(alpha: .75),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.check_rounded,
                              size: 15,
                              color: Colors.white,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'APPROVED',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      bottom: 18,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Try-on photo approved',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Quality check passed · Just now',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: .75),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              IrisButton(
                label: 'Enter VEXA',
                icon: Icons.auto_awesome,
                onTap: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const MainShell()),
                  (_) => false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
