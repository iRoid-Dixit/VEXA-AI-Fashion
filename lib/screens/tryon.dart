import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../data.dart';
import '../theme.dart';
import '../widgets.dart';
import 'setup.dart';
import 'shell.dart';

/* ============================ TRY-ON TAB ============================ */

class TryOnTab extends StatefulWidget {
  const TryOnTab({super.key});

  /// Bumped by [startWith] so the live tab can sync selection + step.
  static final request = ValueNotifier<int>(0);
  static int requestedStep = 0;

  /// Jump into the try-on studio with a preset selection — works from any
  /// pushed route (item detail, outfit) by unwinding back to the shell first.
  static void startWith(
    BuildContext context,
    List<String> ids, {
    int step = 2,
  }) {
    Demo.trySelection
      ..clear()
      ..addAll(ids.take(3));
    requestedStep = step;
    request.value++;
    Navigator.of(context).popUntil((r) => r.isFirst);
    MainShell.of(context)?.switchTab(2);
  }

  @override
  State<TryOnTab> createState() => _TryOnTabState();
}

class _TryOnTabState extends State<TryOnTab> {
  int _step = 0;
  String _category = 'All';

  @override
  void initState() {
    super.initState();
    TryOnTab.request.addListener(_onRequest);
  }

  void _onRequest() {
    if (!mounted) return;
    setState(() => _step = TryOnTab.requestedStep);
  }

  @override
  void dispose() {
    TryOnTab.request.removeListener(_onRequest);
    super.dispose();
  }

  List<WardrobeItem> get _pickList => Demo.items
      .where((i) => _category == 'All' || i.category == _category)
      .toList();

  void _generate({bool forceFail = false}) {
    if (Demo.trySelection.isEmpty) {
      Demo.trySelection.addAll(['floraldress', 'heels']);
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => GeneratingScreen(forceFail: forceFail)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('VIRTUAL TRY-ON', style: VexaText.eyebrow()),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    style: VexaText.display(size: 26),
                    children: [
                      const TextSpan(text: 'The '),
                      TextSpan(
                        text: 'Studio',
                        style: VexaText.serifAccent(size: 26),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(34, 18, 34, 6),
            child: Row(
              children: [
                _stepDot(0, 'PHOTO'),
                _stepLine(_step > 0),
                _stepDot(1, 'CLOTHES'),
                _stepLine(_step > 1),
                _stepDot(2, 'GENERATE'),
              ],
            ),
          ),
          Expanded(
            child: switch (_step) {
              0 => _photoStep(),
              1 => _clothesStep(),
              _ => _reviewStep(),
            },
          ),
        ],
      ),
    );
  }

  Widget _stepDot(int i, String label) {
    final on = _step == i;
    final done = _step > i;
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: on
                ? VexaColors.ink
                : done
                ? VexaColors.irisSoft
                : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: on
                  ? VexaColors.ink
                  : done
                  ? VexaColors.iris
                  : VexaColors.line2,
              width: 1.5,
            ),
          ),
          child: Center(
            child: done
                ? const Icon(
                    Icons.check_rounded,
                    size: 16,
                    color: VexaColors.irisDeep,
                  )
                : Text(
                    '${i + 1}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: on ? Colors.white : VexaColors.faint,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 7),
        Text(
          label,
          style: VexaText.eyebrow(
            color: on ? VexaColors.text : VexaColors.faint,
          ).copyWith(fontSize: 9.5),
        ),
      ],
    );
  }

  Widget _stepLine(bool filled) {
    return Expanded(
      child: Container(
        height: 1.5,
        margin: const EdgeInsets.only(left: 8, right: 8, bottom: 22),
        color: filled ? VexaColors.iris : VexaColors.line2,
      ),
    );
  }

  /* -------- step 1: photo -------- */

  Widget _photoStep() {
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(22, 10, 22, 200),
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Stack(
                children: [
                  Image(
                    image: Demo.tryOnPhoto,
                    height: 380,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    height: 380,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: VexaColors.iris, width: 2.5),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          const Color(0xFF0B0B0F).withValues(alpha: .6),
                        ],
                        stops: const [.6, 1],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 14,
                    right: 14,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: VexaColors.iris,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        size: 17,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 14,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'My try-on photo',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Approved · Updated 3 weeks ago',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: .8),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // quick photo change without leaving the studio
                  Positioned(
                    right: 12,
                    bottom: 12,
                    child: Material(
                      color: Colors.white.withValues(alpha: .22),
                      borderRadius: BorderRadius.circular(999),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(999),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const PhotoUploadScreen(replacing: true),
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: .35),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.photo_camera_outlined,
                                size: 14,
                                color: Colors.white,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Change',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            VexaOutlineButton(
              label: 'Use a Different Photo',
              icon: Icons.photo_camera_outlined,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PhotoUploadScreen(replacing: true),
                ),
              ),
            ),
          ],
        ),
        _tray(
          left: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: VexaColors.irisSoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 18,
                  color: VexaColors.irisDeep,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Photo ready', style: VexaText.label(size: 13)),
                    const SizedBox(height: 1),
                    Text(
                      'Approved · 1 selected',
                      style: VexaText.body(size: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
          buttonLabel: 'Choose Clothes',
          onNext: () => setState(() => _step = 1),
        ),
      ],
    );
  }

  /* -------- step 2: clothes -------- */

  Widget _clothesStep() {
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(
              height: 62,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(22, 10, 22, 10),
                itemCount: Demo.categories.length + 1,
                separatorBuilder: (_, _) => const SizedBox(width: 9),
                itemBuilder: (context, i) {
                  final cat = i == 0 ? 'All' : Demo.categories[i - 1];
                  return VexaChip(
                    label: cat,
                    selected: _category == cat,
                    onTap: () => setState(() => _category = cat),
                  );
                },
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(22, 2, 22, 210),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: .68,
                ),
                itemCount: _pickList.length,
                itemBuilder: (context, i) {
                  final item = _pickList[i];
                  final on = Demo.trySelection.contains(item.id);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (on) {
                          Demo.trySelection.remove(item.id);
                        } else if (Demo.trySelection.length >= 3) {
                          vexaToast(
                            context,
                            'Up to 3 pieces per try-on',
                            info: true,
                          );
                        } else {
                          Demo.trySelection.add(item.id);
                        }
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: on ? VexaColors.iris : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: VexaShadows.card,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image(image: item.provider, fit: BoxFit.cover),
                                Positioned(
                                  top: 7,
                                  right: 7,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      color: on
                                          ? VexaColors.iris
                                          : Colors.white.withValues(alpha: .9),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFF000000,
                                          ).withValues(alpha: .15),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: on
                                        ? const Icon(
                                            Icons.check_rounded,
                                            size: 14,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              item.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: VexaText.label(size: 10.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        _tray(
          left: Demo.trySelection.isEmpty
              ? Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: VexaColors.paper,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.checkroom_rounded,
                        size: 17,
                        color: VexaColors.faint,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Select up to 3 pieces',
                        style: VexaText.label(
                          size: 12.5,
                          color: VexaColors.faint,
                        ),
                      ),
                    ),
                  ],
                )
              : SizedBox(
                  height: 48,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: Demo.trySelection.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final item = Demo.itemById(Demo.trySelection[i]);
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image(
                              image: item.provider,
                              width: 46,
                              height: 46,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: -5,
                            right: -5,
                            child: GestureDetector(
                              onTap: () => setState(
                                () => Demo.trySelection.remove(item.id),
                              ),
                              child: Container(
                                width: 18,
                                height: 18,
                                decoration: const BoxDecoration(
                                  color: VexaColors.ink,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close_rounded,
                                  size: 11,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
          buttonLabel: 'Review',
          onNext: Demo.trySelection.isEmpty
              ? null
              : () => setState(() => _step = 2),
        ),
      ],
    );
  }

  /* -------- step 3: review -------- */

  Widget _reviewStep() {
    final selection = Demo.trySelection.map(Demo.itemById).toList();
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(22, 10, 22, 210),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 115,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Stack(
                      children: [
                        Image(
                          image: Demo.tryOnPhoto,
                          height: 300,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        const Positioned(
                          top: 10,
                          left: 10,
                          child: PillTag(
                            label: 'Photo',
                            icon: Icons.check_rounded,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  flex: 100,
                  child: Column(
                    children: selection.isEmpty
                        ? [
                            VexaCard(
                              child: Text(
                                'No items selected',
                                style: VexaText.label(size: 12),
                              ),
                            ),
                          ]
                        : selection
                              .map(
                                (item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: VexaCard(
                                    padding: const EdgeInsets.all(8),
                                    radius: 16,
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Image(
                                            image: item.provider,
                                            width: 44,
                                            height: 44,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.category.toUpperCase(),
                                                style: VexaText.eyebrow()
                                                    .copyWith(fontSize: 8.5),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                item.name,
                                                style: VexaText.label(
                                                  size: 11.5,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: VexaColors.warnSoft,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    size: 18,
                    color: VexaColors.warn,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Generated images are visual approximations. Exact fit, fabric drape and sizing may differ in real life.',
                      style: VexaText.body(
                        size: 11.5,
                        color: const Color(0xFF8A5A00),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 96,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .97),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: const Color(0x0F131217)),
              boxShadow: VexaShadows.pop,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width:
                          30.0 +
                          16 * (Demo.trySelection.length - 1).clamp(0, 2),
                      height: 30,
                      child: Stack(
                        children: [
                          for (final (i, id)
                              in Demo.trySelection.take(3).indexed)
                            Positioned(
                              left: i * 16.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image(
                                    image: Demo.itemById(id).provider,
                                    width: 26,
                                    height: 26,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Ready to style · ${Demo.trySelection.length} '
                        '${Demo.trySelection.length == 1 ? 'piece' : 'pieces'}',
                        style: VexaText.label(size: 12.5),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _step = 1),
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 4,
                        ),
                        child: Text(
                          'Edit',
                          style: VexaText.label(
                            size: 13,
                            color: VexaColors.irisDeep,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onLongPress: () => _generate(forceFail: true),
                  child: IrisButton(
                    label: 'Generate My Look',
                    icon: Icons.auto_awesome,
                    height: 52,
                    onTap: _generate,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _tray({
    required Widget left,
    required String buttonLabel,
    VoidCallback? onNext,
  }) {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 96,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 11, 11, 11),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .97),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: const Color(0x0F131217)),
          boxShadow: VexaShadows.pop,
        ),
        child: Row(
          children: [
            Expanded(child: left),
            const SizedBox(width: 12),
            VexaButton(
              label: buttonLabel,
              icon: Icons.arrow_forward_rounded,
              height: 48,
              expanded: false,
              onTap: onNext,
            ),
          ],
        ),
      ),
    );
  }
}

/* ============================ GENERATING ============================ */

class GeneratingScreen extends StatefulWidget {
  const GeneratingScreen({super.key, this.forceFail = false});

  final bool forceFail;

  @override
  State<GeneratingScreen> createState() => _GeneratingScreenState();
}

class _GeneratingScreenState extends State<GeneratingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _spin = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat();
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1300),
    lowerBound: .94,
    upperBound: 1.05,
  )..repeat(reverse: true);
  Timer? _timer;
  double _progress = 0;

  static const _stages = [
    'Request queued',
    'Analyzing your photo',
    'Draping selected garments',
    'Rendering final image',
  ];
  static const _thresholds = [.06, .32, .68, .92];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 110), (t) {
      setState(() {
        _progress += _progress < .7 ? .022 : .012;
      });
      if (_progress >= 1) {
        t.cancel();
        _finish();
      }
    });
  }

  void _finish() {
    if (widget.forceFail) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const GenerationFailedScreen()),
      );
      return;
    }
    final selection = Demo.trySelection.map(Demo.itemById).toList();
    // Closest available on-model render PER ITEM, so the result shows the
    // piece the user actually picked (demo stand-in for the AI provider).
    const renders = {
      'tee': 'assets/images/item_tee.jpg',
      'shirt': 'assets/images/result_denim.jpg',
      'sweat': 'assets/images/result_chevron.jpg',
      'blazer': 'assets/images/item_blazer.jpg',
      'bomber': 'assets/images/result_chevron.jpg',
      'poncho': 'assets/images/result_chevron.jpg',
      'rawdenim': 'assets/images/result_denim.jpg',
      'indigo': 'assets/images/result_denim.jpg',
      'joggers': 'assets/images/item_joggers.jpg',
    };
    WardrobeItem? byCat(String c) =>
        selection.where((i) => i.category == c).firstOrNull;
    final lead = byCat('Dresses') ?? byCat('Tops') ?? byCat('Bottoms');
    final after = lead != null
        ? (renders[lead.id] ?? lead.image)
        : selection.isNotEmpty
        ? (renders[selection.first.id] ?? selection.first.image)
        : 'assets/images/result_floral.jpg';
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          afterImage: after,
          itemIds: List.of(Demo.trySelection),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _spin.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pct = (_progress.clamp(0, 1) * 100).round();
    return Scaffold(
      backgroundColor: VexaColors.ink,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            SizedBox(
              width: 182,
              height: 182,
              child: AnimatedBuilder(
                animation: Listenable.merge([_spin, _pulse]),
                builder: (context, _) => Stack(
                  alignment: Alignment.center,
                  children: [
                    // progress ring bound to the real percentage
                    CustomPaint(
                      size: const Size(182, 182),
                      painter: _ProgressRingPainter(
                        _progress.clamp(0, 1).toDouble(),
                      ),
                    ),
                    // slow ambient sweep for life
                    Transform.rotate(
                      angle: -_spin.value * 2 * math.pi * .7,
                      child: CustomPaint(
                        size: const Size(146, 146),
                        painter: _ArcPainter(const Color(0x8CC9B4FF), 2.5),
                      ),
                    ),
                    Transform.scale(
                      scale: _pulse.value,
                      child: Container(
                        width: 104,
                        height: 104,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const RadialGradient(
                            center: Alignment(-.3, -.4),
                            colors: [Color(0xFFB18CFF), Color(0xFF6E41E2)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF8A5CFF,
                              ).withValues(alpha: .55),
                              blurRadius: 70,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              '$pct%',
              style: VexaText.display(size: 44, color: Colors.white),
            ),
            const SizedBox(height: 6),
            RichText(
              text: TextSpan(
                style: VexaText.title(size: 19, color: Colors.white),
                children: [
                  const TextSpan(text: 'Tailoring your '),
                  TextSpan(
                    text: 'look',
                    style: VexaText.serifAccent(size: 19, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Usually takes about 20 seconds — hang tight.',
              style: VexaText.body(
                size: 12.5,
                color: Colors.white.withValues(alpha: .55),
              ),
            ),
            const SizedBox(height: 20),
            // the pieces being draped
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final id in Demo.trySelection.take(3))
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: .25),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image(
                          image: Demo.itemById(id).provider,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 22),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 44),
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .05),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.white.withValues(alpha: .08)),
              ),
              child: Column(
                children: List.generate(_stages.length, (i) {
                  final now =
                      _progress >= _thresholds[i] &&
                      (i == _stages.length - 1 ||
                          _progress < _thresholds[i + 1]);
                  final done =
                      i < _stages.length - 1 && _progress >= _thresholds[i + 1];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 13),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: done ? VexaColors.iris : Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: done || now
                                  ? VexaColors.iris
                                  : Colors.white.withValues(alpha: .2),
                              width: 1.5,
                            ),
                            boxShadow: now
                                ? [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF8A5CFF,
                                      ).withValues(alpha: .6),
                                      blurRadius: 14,
                                    ),
                                  ]
                                : null,
                          ),
                          child: done
                              ? const Icon(
                                  Icons.check_rounded,
                                  size: 15,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _stages[i],
                          style: VexaText.body(
                            size: 13.5,
                            color: now
                                ? Colors.white
                                : done
                                ? Colors.white.withValues(alpha: .75)
                                : Colors.white.withValues(alpha: .4),
                          ).copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            const Spacer(flex: 2),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel generation',
                style: VexaText.body(
                  size: 13.5,
                  color: Colors.white.withValues(alpha: .55),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

/// Circular track + gradient progress arc tied to the generation %.
class _ProgressRingPainter extends CustomPainter {
  _ProgressRingPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    const width = 4.0;
    final rect = Rect.fromLTWH(
      width / 2,
      width / 2,
      size.width - width,
      size.height - width,
    );
    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..color = Colors.white.withValues(alpha: .09);
    canvas.drawArc(rect, 0, 2 * math.pi, false, track);

    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..shader = const SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: 3 * math.pi / 2,
        colors: [Color(0xFF7747F2), Color(0xFFC9B4FF)],
      ).createShader(rect);
    canvas.drawArc(rect, -math.pi / 2, 2 * math.pi * progress, false, arc);
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter old) =>
      old.progress != progress;
}

class _ArcPainter extends CustomPainter {
  _ArcPainter(this.color, this.width);

  final Color color;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        colors: [color.withValues(alpha: 0), color],
        stops: const [0, .35],
      ).createShader(Offset.zero & size);
    canvas.drawArc(
      Rect.fromLTWH(
        width / 2,
        width / 2,
        size.width - width,
        size.height - width,
      ),
      0,
      2 * math.pi * .75,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _ArcPainter old) => old.color != color;
}

/* ============================ FAILED ============================ */

class GenerationFailedScreen extends StatelessWidget {
  const GenerationFailedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 60, 22, 34),
          child: Column(
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: VexaColors.badSoft,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: VexaColors.bad,
                  size: 38,
                ),
              ),
              const SizedBox(height: 24),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: VexaText.display(size: 27),
                  children: [
                    const TextSpan(text: "We couldn't\nstyle this "),
                    TextSpan(
                      text: 'look',
                      style: VexaText.serifAccent(size: 27),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "The AI couldn't produce a reliable result from this combination. It happens — here's what usually helps:",
                style: VexaText.body(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 22),
              VexaCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: const [
                    SettingsRow(
                      icon: Icons.image_outlined,
                      title: 'Re-shoot the garment',
                      subtitle: 'Lay the item flat with even lighting',
                    ),
                    Divider(indent: 18, endIndent: 18),
                    SettingsRow(
                      icon: Icons.accessibility_new_rounded,
                      title: 'Check your photo',
                      subtitle: 'Full body visible, plain background',
                    ),
                    Divider(indent: 18, endIndent: 18),
                    SettingsRow(
                      icon: Icons.layers_outlined,
                      title: 'Try fewer layers',
                      subtitle: 'Start with one or two pieces',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              IrisButton(
                label: 'Retry Generation',
                icon: Icons.refresh_rounded,
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const GeneratingScreen()),
                ),
              ),
              const SizedBox(height: 11),
              VexaOutlineButton(
                label: 'Change Selected Items',
                onTap: () => Navigator.pop(context),
              ),
              TextButton(
                onPressed: () => vexaToast(
                  context,
                  'Support chat opens in v1.1',
                  info: true,
                ),
                child: Text(
                  'Contact support',
                  style: VexaText.label(size: 13, color: VexaColors.irisDeep),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ============================ RESULT ============================ */

class ResultScreen extends StatefulWidget {
  const ResultScreen({
    super.key,
    required this.afterImage,
    required this.itemIds,
  });

  final String afterImage;
  final List<String> itemIds;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  double _cut = .03;
  bool _revealed = false;

  @override
  void initState() {
    super.initState();
    // Cinematic wipe: the AI look sweeps in from the right on entry.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1100),
      );
      final anim = Tween(begin: .97, end: .5).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOutCubic),
      );
      anim.addListener(() {
        if (mounted && !_revealed) setState(() => _cut = anim.value);
      });
      await controller.forward();
      _revealed = true;
      controller.dispose();
    });
  }

  void _shareSheet() {
    showVexaSheet(
      context,
      title: 'Share This Look',
      subtitle: 'Your image stays private until you share it',
      icon: Icons.ios_share_rounded,
      children: [
        SheetOption(
          icon: Icons.download_rounded,
          title: 'Save Image',
          subtitle: 'Download to your device',
          onTap: () {
            Navigator.pop(context);
            vexaToast(context, 'Saved to Photos');
          },
        ),
        const Divider(),
        SheetOption(
          icon: Icons.send_rounded,
          title: 'Share via…',
          subtitle: 'Messages, Instagram, WhatsApp',
          onTap: () {
            Navigator.pop(context);
            vexaToast(context, 'Share sheet opened');
          },
        ),
        const Divider(),
        SheetOption(
          icon: Icons.link_rounded,
          title: 'Copy Private Link',
          subtitle: 'Expires after 7 days',
          onTap: () {
            Navigator.pop(context);
            vexaToast(context, 'Private link copied');
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.itemIds.map(Demo.itemById).toList();
    return Scaffold(
      backgroundColor: VexaColors.ink,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // before / after slider
          LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              return GestureDetector(
                onHorizontalDragUpdate: (d) => setState(
                  () => _cut = ((_cut * w + d.delta.dx) / w).clamp(.03, .97),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image(image: Demo.tryOnPhoto, fit: BoxFit.cover),
                    ClipRect(
                      clipper: _RightClipper(_cut),
                      child: Image.asset(widget.afterImage, fit: BoxFit.cover),
                    ),
                    Positioned(
                      left: w * _cut - 1,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 2,
                        color: Colors.white.withValues(alpha: .9),
                      ),
                    ),
                    Positioned(
                      left: w * _cut - 23,
                      top: constraints.maxHeight / 2 - 23,
                      child: Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .92),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF000000,
                              ).withValues(alpha: .35),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.swap_horiz_rounded,
                          size: 20,
                          color: VexaColors.ink,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          // top bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleIconButton(
                        icon: Icons.close_rounded,
                        dark: true,
                        onTap: () => Navigator.maybePop(context),
                      ),
                      const PillTag(
                        label: 'AI approximation',
                        icon: Icons.info_outline_rounded,
                      ),
                      CircleIconButton(
                        icon: Icons.ios_share_rounded,
                        dark: true,
                        onTap: _shareSheet,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PillTag(label: 'Before'),
                      PillTag(label: '✦ AI Look', iris: true),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // bottom actions
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 70, 20, 30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    const Color(0xFF0B0B0F).withValues(alpha: .88),
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, i) => Container(
                        padding: const EdgeInsets.fromLTRB(4, 4, 13, 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .13),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: .15),
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 15,
                              backgroundImage: items[i].provider,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              items[i].name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      CircleIconButton(
                        icon: Icons.bookmark_outline_rounded,
                        dark: true,
                        size: 52,
                        onTap: () =>
                            vexaToast(context, 'Saved to your results'),
                      ),
                      const SizedBox(width: 9),
                      CircleIconButton(
                        icon: Icons.download_rounded,
                        dark: true,
                        size: 52,
                        onTap: () => vexaToast(context, 'Saved to Photos'),
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: IrisButton(
                          label: 'Generate Again',
                          icon: Icons.refresh_rounded,
                          height: 52,
                          onTap: () async {
                            final ok = await showVexaDialog(
                              context,
                              icon: Icons.refresh_rounded,
                              iconColor: VexaColors.irisDeep,
                              iconBg: VexaColors.irisSoft,
                              title: 'Generate again?',
                              body:
                                  "We'll re-render this look with the same photo and clothes. Small details may vary.",
                              confirmLabel: 'Generate Again',
                              irisConfirm: true,
                            );
                            if (ok == true && context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const GeneratingScreen(),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RightClipper extends CustomClipper<Rect> {
  _RightClipper(this.cut);

  final double cut;

  @override
  Rect getClip(Size size) =>
      Rect.fromLTRB(size.width * cut, 0, size.width, size.height);

  @override
  bool shouldReclip(covariant _RightClipper old) => old.cut != cut;
}

/* ============================ RESULTS GALLERY ============================ */

class ResultsGalleryScreen extends StatelessWidget {
  const ResultsGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 12, 22, 0),
              child: Row(
                children: [
                  CircleIconButton(
                    icon: Icons.arrow_back_rounded,
                    onTap: () => Navigator.maybePop(context),
                  ),
                  const Spacer(),
                  Text(
                    '${Demo.results.length} LOOKS',
                    style: VexaText.eyebrow(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 20, 22, 6),
              child: RichText(
                text: TextSpan(
                  style: VexaText.display(size: 28),
                  children: [
                    const TextSpan(text: 'Your AI '),
                    TextSpan(
                      text: 'results',
                      style: VexaText.serifAccent(size: 28),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 4),
              child: Text(
                'Every look you have generated, in one place.',
                style: VexaText.body(size: 13),
              ),
            ),
            Expanded(
              child: MasonryGridView.count(
                padding: const EdgeInsets.fromLTRB(22, 14, 22, 34),
                crossAxisCount: 2,
                mainAxisSpacing: 13,
                crossAxisSpacing: 13,
                itemCount: Demo.results.length,
                itemBuilder: (context, i) {
                  final r = Demo.results[i];
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ResultScreen(
                          afterImage: r.image,
                          itemIds: r.itemIds,
                        ),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Stack(
                        children: [
                          AspectRatio(
                            aspectRatio: i.isEven ? .72 : .84,
                            child: Image.asset(r.image, fit: BoxFit.cover),
                          ),
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    const Color(
                                      0xFF0B0B0F,
                                    ).withValues(alpha: .62),
                                  ],
                                  stops: const [.55, 1],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              height: 22,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                color: VexaColors.iris.withValues(alpha: .55),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.auto_awesome,
                                    size: 10,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'AI',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: .8,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 12,
                            right: 12,
                            bottom: 10,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  r.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  r.when,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: .8),
                                    fontSize: 10.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
