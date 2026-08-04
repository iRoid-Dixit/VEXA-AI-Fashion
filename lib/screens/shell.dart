import 'package:flutter/material.dart';

import '../data.dart';
import '../theme.dart';
import '../widgets.dart';
import 'auth.dart';
import 'closet.dart';
import 'outfit.dart';
import 'settings.dart';
import 'setup.dart';
import 'tryon.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key, this.initialTab = 0});

  final int initialTab;

  /// Pushed routes (item detail, outfit, …) live outside the shell's
  /// subtree, so fall back to the live instance when ancestor lookup fails.
  static MainShellState? _current;

  static MainShellState? of(BuildContext context) =>
      context.findAncestorStateOfType<MainShellState>() ?? _current;

  @override
  State<MainShell> createState() => MainShellState();
}

class MainShellState extends State<MainShell>
    with SingleTickerProviderStateMixin {
  late int _tab = widget.initialTab;
  late final AnimationController _fade = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 280),
    value: 1,
  );

  @override
  void initState() {
    super.initState();
    MainShell._current = this;
  }

  void switchTab(int i) {
    if (i == _tab) return;
    // Dismiss the keyboard (e.g. closet search) so the floating nav
    // never rides up on the keyboard inset.
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _tab = i);
    _fade.forward(from: .35);
  }

  @override
  void dispose() {
    if (MainShell._current == this) MainShell._current = null;
    _fade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      // Keep the pill nav glued to the bottom even while a keyboard is open.
      resizeToAvoidBottomInset: false,
      body: FadeTransition(
        opacity: CurvedAnimation(parent: _fade, curve: Curves.easeOut),
        child: IndexedStack(
          index: _tab,
          children: const [HomeTab(), ClosetTab(), TryOnTab(), ProfileTab()],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.only(bottom: 14),
        // Row shrink-wraps its height — Center would greedily expand to the
        // whole screen and float the pill mid-screen.
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: const Color(0xFF0D0C11).withValues(alpha: .92),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.white.withValues(alpha: .08)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0B0B0F).withValues(alpha: .4),
                    blurRadius: 42,
                    offset: const Offset(0, 18),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _tabButton(0, Icons.home_outlined, 'Home'),
                  _tabButton(1, Icons.checkroom_outlined, 'Closet'),
                  _tabButton(2, Icons.auto_fix_high_outlined, 'Try On'),
                  _tabButton(3, Icons.person_outline_rounded, 'Profile'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabButton(int i, IconData icon, String label) {
    final on = _tab == i;
    return GestureDetector(
      onTap: () => switchTab(i),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        width: 76,
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          gradient: on ? VexaColors.irisGradient : null,
          borderRadius: BorderRadius.circular(999),
          boxShadow: on
              ? [
                  BoxShadow(
                    color: const Color(0xFF7A48F5).withValues(alpha: .45),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 21,
              color: on ? Colors.white : const Color(0xFF8B8696),
            ),
            const SizedBox(height: 3),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: .6,
                color: on ? Colors.white : const Color(0xFF8B8696),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ============================ HOME ============================ */

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  String get _dateLine {
    final now = DateTime.now();
    const days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    const months = [
      'JANUARY',
      'FEBRUARY',
      'MARCH',
      'APRIL',
      'MAY',
      'JUNE',
      'JULY',
      'AUGUST',
      'SEPTEMBER',
      'OCTOBER',
      'NOVEMBER',
      'DECEMBER',
    ];
    return '${days[now.weekday - 1]} · ${now.day} ${months[now.month - 1]}';
  }

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final today = Demo.outfits.first;
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 120),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 14, 22, 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_dateLine, style: VexaText.eyebrow()),
                      const SizedBox(height: 5),
                      RichText(
                        text: TextSpan(
                          style: VexaText.display(size: 24),
                          children: [
                            TextSpan(text: '$_greeting, '),
                            TextSpan(
                              text: Demo.userName,
                              style: VexaText.serifAccent(size: 24),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => MainShell.of(context)?.switchTab(3),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: VexaShadows.card,
                    ),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundImage: Demo.avatar,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ---- Today's look hero ----
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => OutfitScreen(outfit: today)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: AspectRatio(
                  aspectRatio: 4 / 4.6,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/images/onb_flatlay.jpg',
                        fit: BoxFit.cover,
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFF0B0B0F).withValues(alpha: .22),
                              Colors.transparent,
                              Colors.transparent,
                              const Color(0xFF0B0B0F).withValues(alpha: .78),
                            ],
                            stops: const [0, .32, .48, 1],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                PillTag(
                                  label: "Today's Look",
                                  icon: Icons.auto_awesome,
                                  iris: true,
                                ),
                                PillTag(label: 'Minimal Edit'),
                              ],
                            ),
                            const Spacer(),
                            RichText(
                              text: TextSpan(
                                style: VexaText.display(
                                  size: 24,
                                  color: Colors.white,
                                ),
                                children: [
                                  TextSpan(text: '${today.name} '),
                                  TextSpan(
                                    text: today.accent,
                                    style: VexaText.serifAccent(
                                      size: 24,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 9),
                            Row(
                              children: [
                                SizedBox(
                                  width: 74,
                                  height: 30,
                                  child: Stack(
                                    children: [
                                      for (var i = 0; i < 3; i++)
                                        Positioned(
                                          left: i * 22.0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: Colors.white.withValues(
                                                  alpha: .85,
                                                ),
                                                width: 2,
                                              ),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image(
                                                image: Demo.itemById(
                                                  today.pieces[i].$2,
                                                ).provider,
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
                                Text(
                                  '${today.pieces.length} pieces from your closet',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: .85),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: IrisButton(
                                    label: 'Try It On',
                                    icon: Icons.auto_fix_high_rounded,
                                    height: 48,
                                    onTap: () => TryOnTab.startWith(
                                      context,
                                      today.pieces
                                          .take(3)
                                          .map((p) => p.$2)
                                          .toList(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: SizedBox(
                                    height: 48,
                                    child: Material(
                                      color: Colors.white.withValues(alpha: .2),
                                      borderRadius: BorderRadius.circular(999),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                OutfitScreen(outfit: today),
                                          ),
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              999,
                                            ),
                                            border: Border.all(
                                              color: Colors.white.withValues(
                                                alpha: .34,
                                              ),
                                            ),
                                          ),
                                          child: const Text(
                                            'Details',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // ---- Quick actions ----
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
            child: Row(
              children: [
                _quickAction(
                  context,
                  Icons.add_rounded,
                  'Add Item',
                  iris: true,
                  onTap: () => ClosetTab.showAddSheet(context),
                ),
                const SizedBox(width: 10),
                _quickAction(
                  context,
                  Icons.auto_fix_high_outlined,
                  'Try-On',
                  onTap: () => MainShell.of(context)?.switchTab(2),
                ),
                const SizedBox(width: 10),
                _quickAction(
                  context,
                  Icons.checkroom_outlined,
                  'Closet',
                  onTap: () => MainShell.of(context)?.switchTab(1),
                ),
                const SizedBox(width: 10),
                _quickAction(
                  context,
                  Icons.shuffle_rounded,
                  'New Look',
                  onTap: () {
                    final next =
                        Demo.outfits[DateTime.now().millisecond %
                            Demo.outfits.length];
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OutfitScreen(outfit: next),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // ---- Stats ----
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
            child: VexaCard(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Row(
                children: [
                  _stat('${Demo.items.length}', 'ITEMS'),
                  Container(width: 1, height: 40, color: VexaColors.line),
                  _stat('12', 'OUTFITS'),
                  Container(width: 1, height: 40, color: VexaColors.line),
                  _stat('8', 'TRY-ONS'),
                ],
              ),
            ),
          ),
          // ---- Recent results ----
          SectionHeader(
            title: 'Recent AI Results',
            action: 'See all',
            onAction: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ResultsGalleryScreen()),
            ),
          ),
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 22),
              itemCount: Demo.results.length,
              separatorBuilder: (_, _) => const SizedBox(width: 13),
              itemBuilder: (context, i) {
                final r = Demo.results[i];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ResultScreen(afterImage: r.image, itemIds: r.itemIds),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: SizedBox(
                      width: 150,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(r.image, fit: BoxFit.cover),
                          DecoratedBox(
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
                          Positioned(
                            top: 9,
                            left: 9,
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
                            left: 11,
                            right: 11,
                            bottom: 9,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  r.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  r.when,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: .8),
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: VexaText.display(size: 21)),
          const SizedBox(height: 3),
          Text(label, style: VexaText.eyebrow().copyWith(fontSize: 10)),
        ],
      ),
    );
  }

  Widget _quickAction(
    BuildContext context,
    IconData icon,
    String label, {
    bool iris = false,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: TapScale(
        child: VexaCard(
          padding: const EdgeInsets.symmetric(vertical: 16),
          radius: 18,
          onTap: onTap,
          child: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iris ? VexaColors.irisSoft : VexaColors.paper,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: iris
                        ? VexaColors.iris.withValues(alpha: .25)
                        : VexaColors.line,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 21,
                  color: iris ? VexaColors.irisDeep : VexaColors.text,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: VexaText.label(size: 11, color: VexaColors.text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ============================ PROFILE ============================ */

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  Future<void> _open(Widget screen) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 120),
        children: [
          const SizedBox(height: 18),
          Center(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: VexaColors.irisGradient,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: VexaShadows.pop,
                        ),
                        child: const CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage(
                            'assets/images/avatar.jpg',
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 2,
                      child: GestureDetector(
                        onTap: () => _open(const EditProfileScreen()),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: VexaColors.ink,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: VexaColors.paper,
                              width: 2.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.edit_outlined,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(Demo.userFullName, style: VexaText.display(size: 22)),
                const SizedBox(height: 4),
                Text(
                  '${Demo.userEmail} · Dubai',
                  style: VexaText.body(size: 13),
                ),
                const SizedBox(height: 9),
                Text(
                  '${Demo.items.length} PIECES · 12 OUTFITS · 8 TRY-ONS',
                  style: VexaText.eyebrow().copyWith(fontSize: 9.5),
                ),
                const SizedBox(height: 14),
                VexaOutlineButton(
                  label: 'Edit Profile',
                  height: 44,
                  expanded: false,
                  onTap: () => _open(const EditProfileScreen()),
                ),
              ],
            ),
          ),
          // Try-on photo card
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 0),
            child: VexaCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Try-On Photo', style: VexaText.title(size: 14.5)),
                      GestureDetector(
                        onTap: () => _confirmReplace(context),
                        child: Text(
                          'Replace',
                          style: VexaText.label(
                            size: 12,
                            color: VexaColors.irisDeep,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image(
                          image: Demo.tryOnPhoto,
                          width: 64,
                          height: 82,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Approved · Good quality',
                              style: VexaText.label(size: 13.5),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Used as the base for all AI try-on images. Replace it whenever your look changes.',
                              style: VexaText.body(size: 11.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Measurements
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 16, 22, 0),
            child: VexaCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Body Measurements',
                        style: VexaText.title(size: 14.5),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const MeasurementsScreen(editing: true),
                          ),
                        ),
                        child: Text(
                          'Edit',
                          style: VexaText.label(
                            size: 12,
                            color: VexaColors.irisDeep,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      crossAxisCount: 3,
                      mainAxisSpacing: 1,
                      crossAxisSpacing: 1,
                      childAspectRatio: 1.55,
                      children: const [
                        _MeasureCell('168', 'cm', 'HEIGHT'),
                        _MeasureCell('58', 'kg', 'WEIGHT'),
                        _MeasureCell('27', '', 'AGE'),
                        _MeasureCell('86', 'cm', 'CHEST'),
                        _MeasureCell('66', 'cm', 'WAIST'),
                        _MeasureCell('92', 'cm', 'HIP'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Style prefs
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 16, 22, 0),
            child: VexaCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Style Preferences',
                        style: VexaText.title(size: 14.5),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const StylePrefsScreen(editing: true),
                          ),
                        ),
                        child: Text(
                          'Edit',
                          style: VexaText.label(
                            size: 12,
                            color: VexaColors.irisDeep,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: Demo.stylePrefs.entries
                        .map(
                          (e) => Container(
                            height: 34,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: e.value
                                  ? VexaColors.irisSoft
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: e.value
                                    ? VexaColors.iris
                                    : VexaColors.line2,
                                width: 1.4,
                              ),
                            ),
                            child: Center(
                              widthFactor: 1,
                              child: Text(
                                e.key,
                                style: VexaText.label(
                                  size: 12.5,
                                  color: e.value
                                      ? VexaColors.irisDeep
                                      : VexaColors.muted,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          // Account rows
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 16, 22, 0),
            child: VexaCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SettingsRow(
                    icon: Icons.lock_outline_rounded,
                    title: 'Change Password',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChangePasswordScreen(),
                      ),
                    ),
                  ),
                  const Divider(indent: 18, endIndent: 18),
                  SettingsRow(
                    icon: Icons.shield_outlined,
                    title: 'Privacy',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PrivacyScreen()),
                    ),
                  ),
                  const Divider(indent: 18, endIndent: 18),
                  SettingsRow(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 16, 22, 0),
            child: VexaCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SettingsRow(
                    icon: Icons.logout_rounded,
                    title: 'Log Out',
                    onTap: () async {
                      final ok = await showVexaDialog(
                        context,
                        icon: Icons.logout_rounded,
                        iconColor: VexaColors.irisDeep,
                        iconBg: VexaColors.irisSoft,
                        title: 'Log out of VEXA?',
                        body:
                            'Your closet and results stay safe. You can sign back in anytime.',
                        confirmLabel: 'Log Out',
                        cancelLabel: 'Stay Signed In',
                      );
                      if (ok == true && context.mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                          (_) => false,
                        );
                      }
                    },
                  ),
                  const Divider(indent: 18, endIndent: 18),
                  SettingsRow(
                    icon: Icons.delete_outline_rounded,
                    title: 'Delete Account',
                    subtitle: 'Removes photos, closet & results',
                    danger: true,
                    onTap: () async {
                      final ok = await showVexaDialog(
                        context,
                        icon: Icons.warning_amber_rounded,
                        iconColor: VexaColors.bad,
                        iconBg: VexaColors.badSoft,
                        title: 'Delete account forever?',
                        body:
                            "Your photos, closet, outfits and AI results will be permanently erased. This can't be undone.",
                        confirmLabel: 'Delete Everything',
                        destructive: true,
                      );
                      if (ok == true && context.mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                          (_) => false,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 26),
        ],
      ),
    );
  }

  void _confirmReplace(BuildContext context) async {
    final ok = await showVexaDialog(
      context,
      icon: Icons.photo_camera_outlined,
      iconColor: VexaColors.irisDeep,
      iconBg: VexaColors.irisSoft,
      title: 'Replace try-on photo?',
      body:
          'Your current photo will be archived. New photos go through a quick quality check.',
      confirmLabel: 'Upload New Photo',
      irisConfirm: true,
    );
    if (ok == true && context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const PhotoUploadScreen(replacing: true),
        ),
      );
    }
  }
}

class _MeasureCell extends StatelessWidget {
  const _MeasureCell(this.value, this.unit, this.label);

  final String value;
  final String unit;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: VexaColors.paper,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: VexaText.display(size: 16),
              children: [
                TextSpan(text: value),
                if (unit.isNotEmpty)
                  TextSpan(
                    text: '\u2006 $unit',
                    style: VexaText.body(
                      size: 10,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 3),
          Text(label, style: VexaText.eyebrow().copyWith(fontSize: 9)),
        ],
      ),
    );
  }
}
