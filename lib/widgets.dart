import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'data.dart';
import 'theme.dart';

/// Press-scale micro-interaction shared by all VEXA buttons.
class TapScale extends StatefulWidget {
  const TapScale({super.key, required this.child, this.enabled = true});

  final Widget child;
  final bool enabled;

  @override
  State<TapScale> createState() => _TapScaleState();
}

class _TapScaleState extends State<TapScale> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;
    return Listener(
      onPointerDown: (_) => setState(() => _down = true),
      onPointerUp: (_) => setState(() => _down = false),
      onPointerCancel: (_) => setState(() => _down = false),
      child: AnimatedScale(
        scale: _down ? .965 : 1,
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

/// Primary ink pill button.
class VexaButton extends StatelessWidget {
  const VexaButton({
    super.key,
    required this.label,
    this.onTap,
    this.icon,
    this.height = 56,
    this.expanded = true,
  });

  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final double height;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final btn = Material(
      color: onTap == null
          ? VexaColors.ink.withValues(alpha: .35)
          : VexaColors.ink,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Center(
            widthFactor: 1,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: Colors.white),
                  const SizedBox(width: 9),
                ],
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: VexaText.button(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    return TapScale(
      enabled: onTap != null,
      child: expanded ? SizedBox(width: double.infinity, child: btn) : btn,
    );
  }
}

/// Iris gradient button — reserved for AI moments only (70/30 rule).
class IrisButton extends StatelessWidget {
  const IrisButton({
    super.key,
    required this.label,
    this.onTap,
    this.icon,
    this.height = 56,
    this.expanded = true,
  });

  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final double height;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final btn = DecoratedBox(
      decoration: BoxDecoration(
        gradient: VexaColors.irisGradient,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7A48F5).withValues(alpha: .38),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Container(
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Center(
              widthFactor: 1,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18, color: Colors.white),
                    const SizedBox(width: 9),
                  ],
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: VexaText.button(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    return TapScale(
      enabled: onTap != null,
      child: expanded ? SizedBox(width: double.infinity, child: btn) : btn,
    );
  }
}

/// Bordered neutral pill button.
class VexaOutlineButton extends StatelessWidget {
  const VexaOutlineButton({
    super.key,
    required this.label,
    this.onTap,
    this.icon,
    this.height = 56,
    this.expanded = true,
  });

  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final double height;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final btn = Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
        side: const BorderSide(color: VexaColors.line2, width: 1.5),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            widthFactor: 1,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: VexaColors.text),
                  const SizedBox(width: 9),
                ],
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: VexaText.button(color: VexaColors.text),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    return TapScale(
      enabled: onTap != null,
      child: expanded ? SizedBox(width: double.infinity, child: btn) : btn,
    );
  }
}

/// Round white icon button used in headers.
class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.dark = false,
    this.color,
    this.size = 44,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool dark;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: dark ? const Color(0x6B111015) : Colors.white,
      shape: CircleBorder(
        side: dark
            ? BorderSide(color: Colors.white.withValues(alpha: .18))
            : const BorderSide(color: VexaColors.line),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            icon,
            size: 20,
            color: color ?? (dark ? Colors.white : VexaColors.text),
          ),
        ),
      ),
    );
  }
}

/// Selectable pill chip.
class VexaChip extends StatelessWidget {
  const VexaChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? VexaColors.ink : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
        side: BorderSide(
          color: selected ? VexaColors.ink : VexaColors.line2,
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: SizedBox(
          height: 40,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17),
            // widthFactor keeps the chip shrink-wrapped inside Wrap —
            // a plain Center/alignment would stretch it to full width.
            child: Center(
              widthFactor: 1,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : VexaColors.muted,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// White rounded card container.
class VexaCard extends StatelessWidget {
  const VexaCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.radius = 22,
    this.onTap,
  });

  final Widget child;
  final EdgeInsets padding;
  final double radius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: VexaShadows.card,
        border: Border.all(color: const Color(0x08131217)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// Small frosted pill tag rendered over imagery.
class PillTag extends StatelessWidget {
  const PillTag({super.key, required this.label, this.icon, this.iris = false});

  final String label;
  final IconData? icon;
  final bool iris;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
        color: iris
            ? VexaColors.iris.withValues(alpha: .55)
            : const Color(0xFF111015).withValues(alpha: .4),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: .18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: Colors.white),
            const SizedBox(width: 6),
          ],
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

/// Dark floating toast, VEXA style.
void vexaToast(BuildContext context, String message, {bool info = false}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 2200),
        margin: const EdgeInsets.only(bottom: 24, left: 60, right: 60),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              info ? Icons.info_outline_rounded : Icons.check_circle_rounded,
              size: 17,
              color: info ? const Color(0xFFC9B4FF) : const Color(0xFF7EE79D),
            ),
            const SizedBox(width: 9),
            Flexible(
              child: Text(
                message,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
}

/// VEXA bottom sheet scaffold — grabber + icon tile header + content.
Future<T?> showVexaSheet<T>(
  BuildContext context, {
  required String title,
  required String subtitle,
  required IconData icon,
  required List<Widget> children,
}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0xFF0B0B0F).withValues(alpha: .5),
    isScrollControlled: true,
    builder: (context) => Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0B0B0F).withValues(alpha: .3),
              blurRadius: 60,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(22, 0, 22, 22),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  margin: const EdgeInsets.only(top: 11, bottom: 14),
                  decoration: BoxDecoration(
                    color: VexaColors.line2,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              Row(
                children: [
                  // soft double-ring icon tile, matching the dialogs
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: VexaColors.irisGhost,
                      borderRadius: BorderRadius.circular(19),
                    ),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: VexaColors.irisSoft,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(icon, color: VexaColors.irisDeep, size: 21),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: VexaText.title(size: 17)),
                        const SizedBox(height: 3),
                        Text(subtitle, style: VexaText.body(size: 12)),
                      ],
                    ),
                  ),
                  CircleIconButton(
                    icon: Icons.close_rounded,
                    size: 38,
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...children,
            ],
          ),
        ),
      ),
    ),
  );
}

/// Large tappable option row inside a bottom sheet.
class SheetOption extends StatelessWidget {
  const SheetOption({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.danger = false,
    this.iris = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool danger;
  final bool iris;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: danger
                    ? VexaColors.badSoft
                    : iris
                    ? VexaColors.irisSoft
                    : VexaColors.paper,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                size: 21,
                color: danger
                    ? VexaColors.bad
                    : iris
                    ? VexaColors.irisDeep
                    : VexaColors.text,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: VexaText.label(
                      size: 14.5,
                      color: danger ? VexaColors.bad : VexaColors.text,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: VexaText.body(size: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: VexaColors.faint),
          ],
        ),
      ),
    );
  }
}

/// Premium centered dialog with a colored icon badge.
Future<bool?> showVexaDialog(
  BuildContext context, {
  required IconData icon,
  required Color iconColor,
  required Color iconBg,
  required String title,
  required String body,
  required String confirmLabel,
  String cancelLabel = 'Cancel',
  bool destructive = false,
  bool irisConfirm = false,
}) {
  return showDialog<bool>(
    context: context,
    barrierColor: const Color(0xFF0B0B0F).withValues(alpha: .55),
    builder: (context) => TweenAnimationBuilder<double>(
      tween: Tween(begin: .92, end: 1),
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      builder: (context, v, child) => Transform.scale(scale: v, child: child),
      child: Dialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 36),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // soft double-ring icon badge
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: iconBg.withValues(alpha: .45),
                  shape: BoxShape.circle,
                ),
                child: Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: iconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 27),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                style: VexaText.title(size: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  body,
                  style: VexaText.body(size: 13.5),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 22),
              if (destructive)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: VexaColors.bad,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(
                      confirmLabel,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
              else if (irisConfirm)
                IrisButton(
                  label: confirmLabel,
                  height: 50,
                  onTap: () => Navigator.pop(context, true),
                )
              else
                VexaButton(
                  label: confirmLabel,
                  height: 50,
                  onTap: () => Navigator.pop(context, true),
                ),
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  cancelLabel,
                  style: VexaText.label(size: 13.5, color: VexaColors.muted),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Section header with an optional trailing action.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.action,
    this.onAction,
  });

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 28, 22, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: VexaText.title()),
          if (action != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                action!,
                style: VexaText.label(size: 12.5, color: VexaColors.irisDeep),
              ),
            ),
        ],
      ),
    );
  }
}

/// Rounded text field with the VEXA border treatment.
class VexaField extends StatelessWidget {
  const VexaField({
    super.key,
    required this.label,
    this.hint,
    this.icon,
    this.controller,
    this.obscure = false,
    this.onToggleObscure,
    this.keyboardType,
  });

  final String label;
  final String? hint;
  final IconData? icon;
  final TextEditingController? controller;
  final bool obscure;
  final VoidCallback? onToggleObscure;
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
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: VexaColors.faint,
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: Colors.white,
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
              borderSide: const BorderSide(color: VexaColors.line2, width: 1.5),
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

/// List row used in profile / settings groups.
class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.value,
    this.onTap,
    this.trailing,
    this.danger = false,
    this.green = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? value;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool danger;
  final bool green;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: danger
                    ? VexaColors.badSoft
                    : green
                    ? VexaColors.goodSoft
                    : VexaColors.paper,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                icon,
                size: 19,
                color: danger
                    ? VexaColors.bad
                    : green
                    ? VexaColors.good
                    : VexaColors.text,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: VexaText.label(
                      size: 14.5,
                      color: danger ? VexaColors.bad : VexaColors.text,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle!, style: VexaText.body(size: 12)),
                  ],
                ],
              ),
            ),
            if (value != null)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Text(
                  value!,
                  style: VexaText.body(
                    size: 13,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            trailing ??
                (onTap != null
                    ? const Icon(
                        Icons.chevron_right_rounded,
                        color: VexaColors.faint,
                        size: 20,
                      )
                    : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}

/// Empty / error state used across the app.
class VexaEmptyState extends StatelessWidget {
  const VexaEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.ctaLabel,
    this.onCta,
    this.bubbleColor = VexaColors.iris,
    this.bubbleIcon = Icons.add_rounded,
  });

  final IconData icon;
  final String title;
  final String body;
  final String? ctaLabel;
  final VoidCallback? onCta;
  final Color bubbleColor;
  final IconData bubbleIcon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 46, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: VexaShadows.card,
                  ),
                  child: Icon(icon, size: 48, color: VexaColors.faint),
                ),
                Positioned(
                  top: -7,
                  right: -7,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: bubbleColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(bubbleIcon, size: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Text(
              title,
              style: VexaText.title(size: 19),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: VexaText.body(size: 13.5),
              textAlign: TextAlign.center,
            ),
            if (ctaLabel != null) ...[
              const SizedBox(height: 22),
              VexaButton(
                label: ctaLabel!,
                onTap: onCta,
                expanded: false,
                height: 50,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Premium camera / gallery chooser — returns the picked file path.
Future<String?> pickImageViaSheet(
  BuildContext context, {
  required String target,
  String title = 'Add a Photo',
  String subtitle = 'Shoot now or pick from your gallery',
}) async {
  final source = await showVexaSheet<ImageSource>(
    context,
    title: title,
    subtitle: subtitle,
    icon: Icons.photo_camera_outlined,
    children: [
      Builder(
        builder: (sheetContext) => Column(
          children: [
            SheetOption(
              icon: Icons.photo_camera_outlined,
              title: 'Take a Photo',
              subtitle: 'Open the camera',
              onTap: () => Navigator.pop(sheetContext, ImageSource.camera),
            ),
            const Divider(),
            SheetOption(
              icon: Icons.image_outlined,
              title: 'Choose from Gallery',
              subtitle: 'Pick an existing photo',
              onTap: () => Navigator.pop(sheetContext, ImageSource.gallery),
            ),
          ],
        ),
      ),
    ],
  );
  if (source == null) return null;
  await Demo.beginPick(target);
  try {
    final file = await ImagePicker().pickImage(
      source: source,
      maxWidth: 1440,
      imageQuality: 88,
    );
    if (file != null) Demo.applyPick(target, file.path);
    await Demo.endPick();
    return file?.path;
  } catch (_) {
    await Demo.endPick();
    if (context.mounted) {
      vexaToast(context, 'Could not open the camera', info: true);
    }
    return null;
  }
}
