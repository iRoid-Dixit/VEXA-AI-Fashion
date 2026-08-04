import 'dart:async';

import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets.dart';
import 'auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  Timer? _timer;

  /// Slow cinematic push-in on the boutique backdrop.
  late final AnimationController _zoom = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3400),
  )..forward();

  /// Gentle light sweep across the wordmark — no loading bar needed.
  late final AnimationController _shimmer = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  )..repeat();

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 3000), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, _, _) => const OnboardingScreen(),
          transitionsBuilder: (_, anim, _, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _zoom.dispose();
    _shimmer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VexaColors.ink,
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: _zoom,
            builder: (context, child) => Transform.scale(
              scale: 1 + .09 * Curves.easeOutCubic.transform(_zoom.value),
              child: child,
            ),
            child: Opacity(
              opacity: .62,
              child: Image.asset(
                'assets/images/portrait.jpg',
                fit: BoxFit.cover,
                alignment: const Alignment(0, -.4),
              ),
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x8C0B0B0F),
                  Color(0x3D0B0B0F),
                  Color(0xF20B0B0F),
                ],
                stops: [0, .42, .88],
              ),
            ),
          ),
          // soft iris aura behind the wordmark
          Center(
            child: IgnorePointer(
              child: Container(
                width: 340,
                height: 340,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF8A5CFF).withValues(alpha: .28),
                      const Color(0xFF8A5CFF).withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              // wordmark settles in: letters glide together while fading up
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 1300),
                curve: Curves.easeOutCubic,
                builder: (context, v, _) => Opacity(
                  opacity: v.clamp(0, 1),
                  child: Transform.translate(
                    offset: Offset(0, 22 * (1 - v)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnimatedBuilder(
                              animation: _shimmer,
                              builder: (context, child) {
                                final t = _shimmer.value * 2.4 - .7;
                                return ShaderMask(
                                  blendMode: BlendMode.srcIn,
                                  shaderCallback: (rect) => LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: const [
                                      Colors.white,
                                      Color(0xFFD8C9FF),
                                      Colors.white,
                                    ],
                                    stops: [
                                      (t - .25).clamp(0.0, 1.0),
                                      t.clamp(0.0, 1.0),
                                      (t + .25).clamp(0.0, 1.0),
                                    ],
                                  ).createShader(rect),
                                  child: child,
                                );
                              },
                              child: Text(
                                'V E X A',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 44,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 10 + 16 * (1 - v),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Opacity(
                                opacity: ((v - .55) / .45).clamp(0, 1),
                                child: Transform.rotate(
                                  angle: (1 - v) * 1.2,
                                  child: const Icon(
                                    Icons.auto_awesome,
                                    color: VexaColors.iris,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Opacity(
                          opacity: ((v - .35) / .65).clamp(0, 1),
                          child: Text(
                            'Your AI Fashion Assistant',
                            style: VexaText.serifAccent(
                              size: 17,
                              color: Colors.white.withValues(alpha: .82),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 3),
              const SizedBox(height: 18),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeOut,
                builder: (context, v, child) =>
                    Opacity(opacity: v, child: child),
                child: Text(
                  'CURATED BY YOU · STYLED BY AI',
                  style: VexaText.eyebrow(
                    color: Colors.white.withValues(alpha: .5),
                  ),
                ),
              ),
              const SizedBox(height: 64),
            ],
          ),
        ],
      ),
    );
  }
}

class _OnbPage {
  const _OnbPage(
    this.eyebrow,
    this.headline,
    this.accent,
    this.tail,
    this.body,
  );

  final String eyebrow;
  final String headline;
  final String accent;
  final String tail;
  final String body;
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  static const _pages = [
    _OnbPage(
      'WELCOME TO VEXA',
      'Your personal ',
      'AI fashion',
      ' assistant',
      'Organize your wardrobe, discover stylish outfits, and experience fashion powered by AI.',
    ),
    _OnbPage(
      'YOUR DIGITAL CLOSET',
      'Your entire wardrobe, ',
      'organized',
      '',
      'Upload your clothes once and access your complete wardrobe anytime, anywhere.',
    ),
    _OnbPage(
      'AI OUTFIT RECOMMENDATIONS',
      'Smart outfit ',
      'suggestions',
      '',
      'Our AI creates stylish combinations using only the clothes you already own.',
    ),
    _OnbPage(
      'AI VIRTUAL TRY-ON',
      'See it before you ',
      'wear it',
      '',
      'Generate realistic AI try-on images and preview your outfit with confidence.',
    ),
  ];

  bool get _isLast => _index == _pages.length - 1;

  void _next() {
    if (_isLast) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_index];
    final h = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: h * .62,
            child: PageView(
              controller: _controller,
              onPageChanged: (i) => setState(() => _index = i),
              children: const [
                _SlideWelcome(),
                _SlideCloset(),
                _SlideOutfits(),
                _SlideTryOn(),
              ],
            ),
          ),
          // Fade the imagery into the porcelain panel.
          Positioned(
            top: h * .46,
            left: 0,
            right: 0,
            height: h * .17,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      VexaColors.paper.withValues(alpha: 0),
                      VexaColors.paper,
                    ],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, right: 20),
                child: Material(
                  color: const Color(0x5C111015),
                  borderRadius: BorderRadius.circular(999),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 9,
                      ),
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: VexaColors.paper,
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 46),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 188,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 380),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeIn,
                      transitionBuilder: (child, anim) => FadeTransition(
                        opacity: anim,
                        child: SlideTransition(
                          position: Tween(
                            begin: const Offset(0, .06),
                            end: Offset.zero,
                          ).animate(anim),
                          child: child,
                        ),
                      ),
                      child: Column(
                        key: ValueKey(_index),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            page.eyebrow,
                            style: VexaText.eyebrow(color: VexaColors.irisDeep),
                          ),
                          const SizedBox(height: 12),
                          RichText(
                            text: TextSpan(
                              style: VexaText.display(size: 32),
                              children: [
                                TextSpan(text: page.headline),
                                TextSpan(
                                  text: page.accent,
                                  style: VexaText.serifAccent(size: 32),
                                ),
                                TextSpan(text: page.tail),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(page.body, style: VexaText.body(size: 14.5)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      if (!_isLast) ...[
                        ...List.generate(
                          _pages.length,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: i == _index ? 24 : 7,
                            height: 7,
                            margin: const EdgeInsets.only(right: 7),
                            decoration: BoxDecoration(
                              color: i == _index
                                  ? VexaColors.ink
                                  : VexaColors.line2,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 72,
                          height: 72,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // page progress ring around the arrow
                              TweenAnimationBuilder<double>(
                                tween: Tween(
                                  begin: 0,
                                  end: (_index + 1) / _pages.length,
                                ),
                                duration: const Duration(milliseconds: 450),
                                curve: Curves.easeOutCubic,
                                builder: (context, v, _) => CustomPaint(
                                  size: const Size(72, 72),
                                  painter: _OnbRingPainter(v),
                                ),
                              ),
                              Material(
                                color: VexaColors.ink,
                                shape: const CircleBorder(),
                                child: InkWell(
                                  customBorder: const CircleBorder(),
                                  onTap: _next,
                                  child: const SizedBox(
                                    width: 58,
                                    height: 58,
                                    child: Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else
                        Expanded(
                          child: VexaButton(
                            label: 'Start Your Fashion Journey',
                            icon: Icons.arrow_forward_rounded,
                            height: 58,
                            onTap: _next,
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

class _SlideWelcome extends StatelessWidget {
  const _SlideWelcome();

  @override
  Widget build(BuildContext context) {
    return _KenBurns(
      child: Image.asset('assets/images/onb_editorial.jpg', fit: BoxFit.cover),
    );
  }
}

class _SlideCloset extends StatelessWidget {
  const _SlideCloset();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _KenBurns(
          child: Image.asset('assets/images/onb_closet.jpg', fit: BoxFit.cover),
        ),
      ],
    );
  }
}

class _SlideOutfits extends StatelessWidget {
  const _SlideOutfits();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _KenBurns(
          child: Image.asset(
            'assets/images/onb_flatlay.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          left: 20,
          bottom: 130,
          child: Container(
            padding: const EdgeInsets.fromLTRB(9, 9, 14, 9),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .85),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: .6)),
              boxShadow: VexaShadows.card,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final img in const [
                  'assets/images/item_sweat.jpg',
                  'assets/images/item_rawdenim.jpg',
                  'assets/images/item_sneakers.jpg',
                ])
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(11),
                      child: Image.asset(
                        img,
                        width: 34,
                        height: 34,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                const SizedBox(width: 5),
                Text('Top + Bottom + Shoes', style: VexaText.label(size: 11)),
                const SizedBox(width: 7),
                const Icon(
                  Icons.auto_awesome,
                  size: 15,
                  color: VexaColors.irisDeep,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SlideTryOn extends StatelessWidget {
  const _SlideTryOn();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Row(
          children: [
            Expanded(
              child: Image.asset(
                'assets/images/user_photo.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Container(width: 1.5, color: Colors.white.withValues(alpha: .6)),
            Expanded(
              child: Image.asset(
                'assets/images/result_floral.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
        const Positioned(
          top: 130,
          left: 14,
          child: PillTag(label: 'Your photo'),
        ),
        const Positioned(
          top: 130,
          right: 14,
          child: PillTag(label: '✦ AI result', iris: true),
        ),
        Center(
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: VexaColors.irisGradient,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: .35),
                width: 5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6E41E2).withValues(alpha: .5),
                  blurRadius: 32,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }
}

/// Ambient slow zoom that gives onboarding imagery a living, editorial feel.
class _KenBurns extends StatefulWidget {
  const _KenBurns({required this.child});

  final Widget child;

  @override
  State<_KenBurns> createState() => _KenBurnsState();
}

class _KenBurnsState extends State<_KenBurns>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 9),
    lowerBound: 1.0,
    upperBound: 1.07,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, child) =>
            Transform.scale(scale: _c.value, child: child),
        child: widget.child,
      ),
    );
  }
}

/// Thin page-progress arc drawn around the onboarding arrow button.
class _OnbRingPainter extends CustomPainter {
  _OnbRingPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    const width = 3.0;
    final rect = Rect.fromLTWH(
      width / 2,
      width / 2,
      size.width - width,
      size.height - width,
    );
    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..color = VexaColors.line2;
    canvas.drawArc(rect, 0, 6.2832, false, track);

    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..shader = const SweepGradient(
        startAngle: -1.5708,
        endAngle: 4.7124,
        colors: [Color(0xFF7747F2), Color(0xFFC9B4FF)],
      ).createShader(rect);
    canvas.drawArc(rect, -1.5708, 6.2832 * progress, false, arc);
  }

  @override
  bool shouldRepaint(covariant _OnbRingPainter old) => old.progress != progress;
}
