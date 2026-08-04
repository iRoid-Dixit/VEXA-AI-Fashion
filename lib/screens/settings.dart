import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data.dart';
import '../theme.dart';
import '../widgets.dart';
import 'auth.dart';

class _SubScaffold extends StatelessWidget {
  const _SubScaffold({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 12, 22, 6),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CircleIconButton(
                      icon: Icons.arrow_back_rounded,
                      onTap: () => Navigator.maybePop(context),
                    ),
                  ),
                  Text(title, style: VexaText.title(size: 17)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(22, 8, 22, 34),
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VexaToggle extends StatefulWidget {
  const VexaToggle({super.key, this.initial = true});

  final bool initial;

  @override
  State<VexaToggle> createState() => _VexaToggleState();
}

class _VexaToggleState extends State<VexaToggle> {
  late bool _on = widget.initial;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _on = !_on),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        width: 50,
        height: 30,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: _on ? VexaColors.good : const Color(0xFFDDDAE4),
          borderRadius: BorderRadius.circular(999),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          alignment: _on ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF000000).withValues(alpha: .2),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ============================ EDIT PROFILE ============================ */

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Future<void> _changePhoto() async {
    final path = await pickImageViaSheet(
      context,
      target: 'avatar',
      title: 'Profile Photo',
      subtitle: 'Shoot now or pick from your gallery',
    );
    if (path != null && mounted) {
      setState(() {});
      vexaToast(context, 'Profile photo updated');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _SubScaffold(
      title: 'Edit Profile',
      children: [
        Center(
          child: Stack(
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
                  child: CircleAvatar(radius: 46, backgroundImage: Demo.avatar),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 2,
                child: GestureDetector(
                  onTap: _changePhoto,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: VexaColors.ink,
                      shape: BoxShape.circle,
                      border: Border.all(color: VexaColors.paper, width: 2.5),
                    ),
                    child: const Icon(
                      Icons.photo_camera_outlined,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        VexaField(
          label: 'Full name',
          controller: TextEditingController(text: Demo.userFullName),
        ),
        const SizedBox(height: 16),
        VexaField(
          label: 'Email',
          controller: TextEditingController(text: Demo.userEmail),
        ),
        const SizedBox(height: 16),
        VexaField(
          label: 'City',
          controller: TextEditingController(text: Demo.userCity),
        ),
        const SizedBox(height: 24),
        VexaButton(
          label: 'Save Changes',
          onTap: () {
            Navigator.pop(context);
            vexaToast(context, 'Profile updated');
          },
        ),
      ],
    );
  }
}

/* ============================ CHANGE PASSWORD ============================ */

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _o1 = true, _o2 = true;

  @override
  Widget build(BuildContext context) {
    return _SubScaffold(
      title: 'Change Password',
      children: [
        const SizedBox(height: 8),
        VexaField(
          label: 'Current password',
          hint: 'Enter current password',
          icon: Icons.lock_outline_rounded,
          obscure: _o1,
          onToggleObscure: () => setState(() => _o1 = !_o1),
        ),
        const SizedBox(height: 16),
        VexaField(
          label: 'New password',
          hint: '8+ characters',
          icon: Icons.lock_outline_rounded,
          obscure: _o2,
          onToggleObscure: () => setState(() => _o2 = !_o2),
        ),
        const SizedBox(height: 16),
        const VexaField(
          label: 'Confirm new password',
          hint: 'Repeat new password',
          icon: Icons.lock_outline_rounded,
          obscure: true,
        ),
        const SizedBox(height: 24),
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
            if (ok != null && context.mounted) Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

/* ============================ PRIVACY ============================ */

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SubScaffold(
      title: 'Privacy',
      children: [
        VexaCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: const [
              SettingsRow(
                icon: Icons.lock_outline_rounded,
                title: 'Your photos stay private',
                subtitle: 'Stored encrypted, never public, visible only to you',
                green: true,
              ),
              Divider(indent: 18, endIndent: 18),
              SettingsRow(
                icon: Icons.auto_fix_high_outlined,
                title: 'Used only for try-on',
                subtitle:
                    'Photos are sent to the AI provider solely to render your look',
                green: true,
              ),
              Divider(indent: 18, endIndent: 18),
              SettingsRow(
                icon: Icons.delete_outline_rounded,
                title: 'Deleted with your account',
                subtitle:
                    'Closet, photos & results are fully removed on deletion',
                green: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        VexaCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: const [
              SettingsRow(
                icon: Icons.auto_awesome_outlined,
                title: 'Improve my recommendations',
                subtitle: 'Learn from looks I like',
                trailing: VexaToggle(),
              ),
              Divider(indent: 18, endIndent: 18),
              SettingsRow(
                icon: Icons.image_outlined,
                title: 'Keep generated images',
                subtitle: 'Store results for 90 days',
                trailing: VexaToggle(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        VexaOutlineButton(
          label: 'Download My Data',
          onTap: () => vexaToast(context, 'Data export will be emailed to you'),
        ),
        const SizedBox(height: 11),
        SizedBox(
          height: 56,
          child: Material(
            color: VexaColors.badSoft,
            borderRadius: BorderRadius.circular(999),
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
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
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (_) => false,
                  );
                }
              },
              child: Center(
                child: Text(
                  'Delete All My Data',
                  style: VexaText.label(size: 14.5, color: VexaColors.bad),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/* ============================ SETTINGS ============================ */

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SubScaffold(
      title: 'Settings',
      children: [
        Text('PRIVACY & LEGAL', style: VexaText.eyebrow()),
        const SizedBox(height: 9),
        VexaCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
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
                icon: Icons.description_outlined,
                title: 'Terms of Service',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TermsScreen()),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text('SUPPORT', style: VexaText.eyebrow()),
        const SizedBox(height: 9),
        VexaCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              SettingsRow(
                icon: Icons.help_outline_rounded,
                title: 'Help Center',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HelpScreen()),
                ),
              ),
              const Divider(indent: 18, endIndent: 18),
              SettingsRow(
                icon: Icons.mail_outline_rounded,
                title: 'Contact Us',
                subtitle: 'hello@vexa.app',
                onTap: () async {
                  await Clipboard.setData(
                    const ClipboardData(text: 'hello@vexa.app'),
                  );
                  if (context.mounted) {
                    vexaToast(context, 'hello@vexa.app copied to clipboard');
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 34),
        Center(
          child: Column(
            children: [
              const Text(
                'V E X A',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 7,
                  color: VexaColors.ink,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Your AI Fashion Assistant',
                style: VexaText.serifAccent(size: 13, color: VexaColors.muted),
              ),
              const SizedBox(height: 6),
              Text(
                'Version 1.0.0 (build 42)',
                style: VexaText.body(size: 11, color: VexaColors.faint),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/* ============================ TERMS ============================ */

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  static const _sections = [
    (
      '1 · Your account',
      'You are responsible for keeping your login details private. VEXA accounts are personal — one wardrobe, one owner.',
    ),
    (
      '2 · Your photos & closet',
      'Photographs you upload remain yours. We store them securely on protected cloud storage and use them only to organise your closet and render your virtual try-ons.',
    ),
    (
      '3 · AI generated images',
      'Try-on results are visual approximations produced by an AI provider. They do not guarantee exact garment size, fit, fabric behaviour or physical appearance.',
    ),
    (
      '4 · Acceptable use',
      'Upload only photographs you own or have permission to use. Content that is unlawful or infringes the rights of others may be removed.',
    ),
    (
      '5 · Deleting your data',
      'Deleting your account removes your profile, photographs, wardrobe images, generated results and recommendation history in line with our retention policy.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return _SubScaffold(
      title: 'Terms of Service',
      children: [
        Text('LAST UPDATED · 16 JULY 2026', style: VexaText.eyebrow()),
        const SizedBox(height: 16),
        for (final (title, body) in _sections) ...[
          VexaCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: VexaText.title(size: 14.5)),
                const SizedBox(height: 8),
                Text(body, style: VexaText.body(size: 13)),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 8),
        Center(
          child: Text(
            'Questions? hello@vexa.app',
            style: VexaText.body(size: 12, color: VexaColors.faint),
          ),
        ),
      ],
    );
  }
}

/* ============================ HELP ============================ */

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const _faqs = [
    (
      'How do I get the best try-on results?',
      'Use a full-body photo against a plain background in fitted clothing, and shoot wardrobe items flat with even lighting.',
    ),
    (
      'Why did my generation fail?',
      'Usually the garment photo is unclear or the combination is unsupported. Re-shoot the item or try fewer layers, then retry.',
    ),
    (
      'Can VEXA recommend clothes to buy?',
      'No — VEXA only styles pieces you already own. Outfits are combined from your uploaded closet.',
    ),
    (
      'How do I change my try-on photo?',
      'Profile → Try-On Photo → Replace, or tap Change on the photo card inside the Try-On studio.',
    ),
    (
      'Is my data private?',
      'Yes. Photos are stored encrypted, visible only to you, and fully deleted with your account.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return _SubScaffold(
      title: 'Help Center',
      children: [
        Text('FREQUENTLY ASKED', style: VexaText.eyebrow()),
        const SizedBox(height: 9),
        VexaCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (final (i, faq) in _faqs.indexed) ...[
                if (i > 0) const Divider(height: 1, indent: 18, endIndent: 18),
                Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 2,
                    ),
                    childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
                    iconColor: VexaColors.irisDeep,
                    collapsedIconColor: VexaColors.faint,
                    title: Text(faq.$1, style: VexaText.label(size: 14)),
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(faq.$2, style: VexaText.body(size: 13)),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 20),
        VexaOutlineButton(
          label: 'Email Support',
          icon: Icons.mail_outline_rounded,
          onTap: () async {
            await Clipboard.setData(
              const ClipboardData(text: 'hello@vexa.app'),
            );
            if (context.mounted) {
              vexaToast(context, 'hello@vexa.app copied to clipboard');
            }
          },
        ),
      ],
    );
  }
}
