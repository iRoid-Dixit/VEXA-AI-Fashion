import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data.dart';
import '../theme.dart';
import '../widgets.dart';
import 'closet.dart';
import 'tryon.dart';

class OutfitScreen extends StatefulWidget {
  const OutfitScreen({super.key, required this.outfit});

  final Outfit outfit;

  @override
  State<OutfitScreen> createState() => _OutfitScreenState();
}

class _OutfitScreenState extends State<OutfitScreen> {
  late Outfit _outfit = widget.outfit;
  int _reaction = 0; // 0 none · 1 like · -1 dislike
  bool _shuffling = false;

  void _another() async {
    setState(() => _shuffling = true);
    await Future.delayed(const Duration(milliseconds: 420));
    if (!mounted) return;
    final others = Demo.outfits.where((o) => o != _outfit).toList();
    setState(() {
      _outfit = others[math.Random().nextInt(others.length)];
      _reaction = 0;
      _shuffling = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CircleIconButton(
                      icon: Icons.arrow_back_rounded,
                      onTap: () => Navigator.maybePop(context),
                    ),
                  ),
                  Text('Styled For You', style: VexaText.title(size: 17)),
                ],
              ),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  style: VexaText.display(size: 27),
                  children: [
                    TextSpan(text: '${_outfit.name} '),
                    TextSpan(
                      text: _outfit.accent,
                      style: VexaText.serifAccent(size: 27),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 7),
              Text(_outfit.mood, style: VexaText.body()),
              const SizedBox(height: 16),
              // outfit canvas
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: VexaShadows.card,
                  border: Border.all(color: const Color(0x08131217)),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      color: VexaColors.irisGhost,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.auto_awesome,
                            size: 15,
                            color: VexaColors.irisDeep,
                          ),
                          const SizedBox(width: 9),
                          Expanded(
                            child: Text(
                              'Styled from your closet · based on your ${_outfit.basedOn} preference',
                              style: VexaText.body(
                                size: 12,
                                color: VexaColors.irisDeep,
                              ).copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: _shuffling ? .3 : 1,
                      child: Column(
                        children: [
                          for (final (i, piece) in _outfit.pieces.indexed) ...[
                            if (i > 0) const Divider(),
                            InkWell(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ItemDetailScreen(
                                    item: Demo.itemById(piece.$2),
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 13,
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image(
                                        image: Demo.itemById(piece.$2).provider,
                                        width: 64,
                                        height: 64,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            piece.$1.toUpperCase(),
                                            style: VexaText.eyebrow().copyWith(
                                              fontSize: 9.5,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            Demo.itemById(piece.$2).name,
                                            style: VexaText.label(size: 14.5),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.chevron_right_rounded,
                                      color: VexaColors.faint,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  _reactButton(
                    'Love it',
                    Icons.thumb_up_outlined,
                    1,
                    VexaColors.good,
                    VexaColors.goodSoft,
                  ),
                  const SizedBox(width: 10),
                  _reactButton(
                    'Not for me',
                    Icons.thumb_down_outlined,
                    -1,
                    VexaColors.bad,
                    VexaColors.badSoft,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: VexaOutlineButton(
                      label: 'Another',
                      icon: Icons.shuffle_rounded,
                      onTap: _another,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: VexaOutlineButton(
                      label: 'Save',
                      icon: Icons.bookmark_outline_rounded,
                      onTap: () => vexaToast(context, 'Saved to your outfits'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              IrisButton(
                label: 'Try This Look On',
                icon: Icons.auto_fix_high_rounded,
                onTap: () => TryOnTab.startWith(
                  context,
                  _outfit.pieces.take(3).map((p) => p.$2).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _reactButton(
    String label,
    IconData icon,
    int value,
    Color color,
    Color soft,
  ) {
    final on = _reaction == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _reaction = on ? 0 : value);
          if (!on) {
            vexaToast(
              context,
              value == 1
                  ? 'Noted — more looks like this'
                  : 'Got it — fewer looks like this',
            );
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 50,
          decoration: BoxDecoration(
            color: on ? soft : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: on ? color : VexaColors.line2,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: on ? color : VexaColors.muted),
              const SizedBox(width: 8),
              Text(
                label,
                style: VexaText.label(
                  size: 13,
                  color: on ? color : VexaColors.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
