import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme.dart';
import '../widgets.dart';
import 'setup.dart';
import 'shell.dart';

/* ==================== shared auth scaffolding ==================== */

class _AuthScaffold extends StatelessWidget {
  const _AuthScaffold({
    required this.eyebrow,
    required this.headline,
    required this.accent,
    this.sub,
    required this.children,
    this.showBack = true,
  });

  final String eyebrow;
  final String headline;
  final String accent;
  final String? sub;
  final List<Widget> children;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(26, 12, 26, 30),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 550),
            curve: Curves.easeOutCubic,
            builder: (context, v, child) => Opacity(
              opacity: v,
              child: Transform.translate(
                offset: Offset(0, 16 * (1 - v)),
                child: child,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (showBack)
                      CircleIconButton(
                        icon: Icons.arrow_back_rounded,
                        onTap: () => Navigator.maybePop(context),
                      ),
                    const Spacer(),
                    const Text(
                      'V E X A',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 5,
                        color: VexaColors.ink,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.auto_awesome,
                      size: 13,
                      color: VexaColors.iris,
                    ),
                    const Spacer(),
                    if (showBack) const SizedBox(width: 44),
                  ],
                ),
                SizedBox(height: showBack ? 30 : 46),
                Text(
                  eyebrow,
                  style: VexaText.eyebrow(color: VexaColors.irisDeep),
                ),
                const SizedBox(height: 12),
                RichText(
                  text: TextSpan(
                    style: VexaText.display(size: 32),
                    children: [
                      TextSpan(text: headline),
                      TextSpan(
                        text: accent,
                        style: VexaText.serifAccent(size: 32),
                      ),
                    ],
                  ),
                ),
                if (sub != null) ...[
                  const SizedBox(height: 10),
                  Text(sub!, style: VexaText.body()),
                ],
                const SizedBox(height: 26),
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Floating white panel that holds the form fields.
class _FormCard extends StatelessWidget {
  const _FormCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0x08131217)),
        boxShadow: VexaShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

/// Soft inset field used inside the white form card.
class _AuthField extends StatelessWidget {
  const _AuthField({
    required this.label,
    this.hint,
    this.icon,
    this.controller,
    this.obscure = false,
    this.onToggleObscure,
    this.onChanged,
    this.keyboardType,
  });

  final String label;
  final String? hint;
  final IconData? icon;
  final TextEditingController? controller;
  final bool obscure;
  final VoidCallback? onToggleObscure;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: VexaText.label()),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          onChanged: onChanged,
          keyboardType: keyboardType,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            fontVariations: const [FontVariation('wght', 520)],
            color: VexaColors.text,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: VexaColors.faint,
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: const Color(0xFFF4F3F8),
            prefixIcon: icon != null
                ? Icon(icon, size: 19, color: VexaColors.faint)
                : null,
            suffixIcon: onToggleObscure != null
                ? IconButton(
                    onPressed: onToggleObscure,
                    icon: Icon(
                      obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 19,
                      color: VexaColors.faint,
                    ),
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 17,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: VexaColors.iris, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _AuthFootLink extends StatelessWidget {
  const _AuthFootLink({
    required this.question,
    required this.action,
    required this.onTap,
  });

  final String question;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: RichText(
            text: TextSpan(
              style: VexaText.body(size: 13.5),
              children: [
                TextSpan(text: '$question  '),
                TextSpan(
                  text: action,
                  style: VexaText.label(size: 13.5, color: VexaColors.irisDeep),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ============================ LOGIN ============================ */

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscure = true;
  final _email = TextEditingController(text: 'amira.hassan@gmail.com');
  final _pass = TextEditingController(text: 'velvet-iris-9');

  void _signIn() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainShell()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _AuthScaffold(
      showBack: false,
      eyebrow: 'WELCOME BACK',
      headline: 'Step back into\nyour ',
      accent: 'wardrobe',
      sub: 'Sign in to access your closet, saved looks and AI try-ons.',
      children: [
        _FormCard(
          children: [
            _AuthField(
              label: 'Email',
              icon: Icons.mail_outline_rounded,
              controller: _email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _AuthField(
              label: 'Password',
              icon: Icons.lock_outline_rounded,
              controller: _pass,
              obscure: _obscure,
              onToggleObscure: () => setState(() => _obscure = !_obscure),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ForgotPasswordScreen(),
                  ),
                ),
                child: Text(
                  'Forgot password?',
                  style: VexaText.label(size: 13, color: VexaColors.irisDeep),
                ),
              ),
            ),
            const SizedBox(height: 18),
            VexaButton(
              label: 'Sign In',
              icon: Icons.arrow_forward_rounded,
              onTap: _signIn,
            ),
          ],
        ),
        const SizedBox(height: 22),
        _AuthFootLink(
          question: 'New to VEXA?',
          action: 'Create an account',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SignupScreen()),
          ),
        ),
        const SizedBox(height: 18),
        Center(
          child: Text(
            'CURATED BY YOU · STYLED BY AI',
            style: VexaText.eyebrow().copyWith(fontSize: 9.5),
          ),
        ),
      ],
    );
  }
}

/* ============================ SIGN UP ============================ */

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _obscure = true;
  bool _agreed = true;
  double _strength = 0;

  void _updateStrength(String v) {
    var s = 0.0;
    if (v.length >= 8) s += .34;
    if (v.contains(RegExp(r'\d'))) s += .33;
    if (v.contains(RegExp(r'[A-Z]')) && v.contains(RegExp(r'[a-z]'))) s += .33;
    setState(() => _strength = s);
  }

  Color get _strengthColor => _strength < .4
      ? VexaColors.bad
      : _strength < .8
      ? VexaColors.warn
      : VexaColors.good;

  @override
  Widget build(BuildContext context) {
    return _AuthScaffold(
      eyebrow: 'CREATE ACCOUNT',
      headline: 'Your closet,\n',
      accent: 'reimagined',
      sub: 'One account for your wardrobe, outfits and AI try-ons.',
      children: [
        _FormCard(
          children: [
            const _AuthField(
              label: 'Full name',
              hint: 'e.g. Amira Hassan',
              icon: Icons.person_outline_rounded,
            ),
            const SizedBox(height: 16),
            const _AuthField(
              label: 'Email',
              hint: 'you@example.com',
              icon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _AuthField(
              label: 'Password',
              hint: '8+ characters',
              icon: Icons.lock_outline_rounded,
              obscure: _obscure,
              onToggleObscure: () => setState(() => _obscure = !_obscure),
              onChanged: _updateStrength,
            ),
            if (_strength > 0) ...[
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: _strength,
                  minHeight: 4,
                  backgroundColor: VexaColors.line,
                  color: _strengthColor,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _agreed,
                    activeColor: VexaColors.iris,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    onChanged: (v) => setState(() => _agreed = v ?? false),
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Text(
                    "I agree to VEXA's Terms of Service and Privacy Policy, including how my photos are processed for try-on.",
                    style: VexaText.body(size: 12.5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            VexaButton(
              label: 'Create Account',
              icon: Icons.arrow_forward_rounded,
              onTap: _agreed
                  ? () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const OtpScreen(fromSignup: true),
                      ),
                    )
                  : null,
            ),
          ],
        ),
        const SizedBox(height: 22),
        _AuthFootLink(
          question: 'Already have an account?',
          action: 'Sign in',
          onTap: () => Navigator.maybePop(context),
        ),
      ],
    );
  }
}

/* ============================ FORGOT ============================ */

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final email = TextEditingController(text: 'amira.hassan@gmail.com');
    return _AuthScaffold(
      eyebrow: 'RESET PASSWORD',
      headline: 'Forgot your\n',
      accent: 'password?',
      sub:
          "Enter the email linked to your account and we'll send a 4-digit verification code.",
      children: [
        _FormCard(
          children: [
            _AuthField(
              label: 'Email',
              icon: Icons.mail_outline_rounded,
              controller: email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            VexaButton(
              label: 'Send Code',
              icon: Icons.arrow_forward_rounded,
              onTap: () {
                vexaToast(context, 'Code sent to your email');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const OtpScreen(fromSignup: false),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

/* ============================ OTP ============================ */

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.fromSignup});

  final bool fromSignup;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _nodes = List.generate(4, (_) => FocusNode());
  static const _demoCode = ['4', '7', '2', '9'];
  final _ctrls = List.generate(
    4,
    (i) => TextEditingController(text: _demoCode[i]),
  );
  Timer? _timer;
  int _seconds = 24;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _seconds = 24);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_seconds <= 0) {
        t.cancel();
      } else {
        setState(() => _seconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final n in _nodes) {
      n.dispose();
    }
    for (final c in _ctrls) {
      c.dispose();
    }
    super.dispose();
  }

  void _verify() {
    if (widget.fromSignup) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PhotoUploadScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ResetPasswordScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _AuthScaffold(
      eyebrow: 'VERIFICATION',
      headline: 'Check your\n',
      accent: 'inbox',
      sub: 'We sent a code to amira.hassan@gmail.com',
      children: [
        _FormCard(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (i) {
                return Container(
                  width: 54,
                  height: 66,
                  margin: EdgeInsets.only(right: i < 3 ? 10 : 0),
                  child: TextField(
                    controller: _ctrls[i],
                    focusNode: _nodes[i],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                    onChanged: (v) {
                      if (v.isNotEmpty && i < 3) _nodes[i + 1].requestFocus();
                      if (v.isEmpty && i > 0) _nodes[i - 1].requestFocus();
                    },
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: const Color(0xFFF4F3F8),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: const BorderSide(
                          color: VexaColors.iris,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 18),
            Center(
              child: _seconds > 0
                  ? Text(
                      "Didn't receive it? Resend in 0:${_seconds.toString().padLeft(2, '0')}",
                      style: VexaText.body(size: 13),
                    )
                  : GestureDetector(
                      onTap: () {
                        _startTimer();
                        vexaToast(context, 'New code sent');
                      },
                      child: Text(
                        'Resend code',
                        style: VexaText.label(
                          size: 13,
                          color: VexaColors.irisDeep,
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            VexaButton(label: 'Verify', onTap: _verify),
          ],
        ),
      ],
    );
  }
}

/* ============================ RESET ============================ */

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool _obscure = true;
  String _value = '';

  bool get _len => _value.length >= 8;
  bool get _num => _value.contains(RegExp(r'\d'));
  bool get _case =>
      _value.contains(RegExp(r'[A-Z]')) && _value.contains(RegExp(r'[a-z]'));

  Widget _rule(String label, bool ok) => Padding(
    padding: const EdgeInsets.only(bottom: 9),
    child: Row(
      children: [
        Icon(
          ok ? Icons.check_circle_rounded : Icons.check_circle_outline_rounded,
          size: 17,
          color: ok ? VexaColors.good : VexaColors.line2,
        ),
        const SizedBox(width: 9),
        Text(
          label,
          style: VexaText.body(
            size: 13,
            color: ok ? VexaColors.text : VexaColors.muted,
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return _AuthScaffold(
      eyebrow: 'NEW PASSWORD',
      headline: 'Create a new\n',
      accent: 'password',
      children: [
        _FormCard(
          children: [
            _AuthField(
              label: 'New password',
              hint: '8+ characters',
              icon: Icons.lock_outline_rounded,
              obscure: _obscure,
              onToggleObscure: () => setState(() => _obscure = !_obscure),
              onChanged: (v) => setState(() => _value = v),
            ),
            const SizedBox(height: 16),
            const _AuthField(
              label: 'Confirm password',
              hint: 'Repeat password',
              icon: Icons.lock_outline_rounded,
              obscure: true,
            ),
            const SizedBox(height: 16),
            _rule('At least 8 characters', _len),
            _rule('Contains a number', _num),
            _rule('Upper & lowercase letters', _case),
            const SizedBox(height: 12),
            VexaButton(
              label: 'Update Password',
              onTap: () async {
                final ok = await showVexaDialog(
                  context,
                  icon: Icons.check_rounded,
                  iconColor: VexaColors.good,
                  iconBg: VexaColors.goodSoft,
                  title: 'Password updated',
                  body:
                      'Your password was changed successfully. Use it the next time you sign in.',
                  confirmLabel: 'Done',
                  cancelLabel: 'Close',
                );
                if (ok != null && context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (_) => false,
                  );
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
