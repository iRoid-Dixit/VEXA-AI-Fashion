import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../data.dart';
import '../theme.dart';
import '../widgets.dart';
import 'tryon.dart';

/* ============================ CLOSET TAB ============================ */

class ClosetTab extends StatefulWidget {
  const ClosetTab({super.key});

  /// Opens the "Add to Closet" source sheet from anywhere.
  static void showAddSheet(BuildContext context) {
    showVexaSheet(
      context,
      title: 'Add to Closet',
      subtitle: 'Digitize a piece you own',
      icon: Icons.add_rounded,
      children: [
        SheetOption(
          icon: Icons.photo_camera_outlined,
          title: 'Take a Photo',
          subtitle: 'Lay the item flat or hang it up',
          onTap: () => _pickForNewItem(context, ImageSource.camera),
        ),
        const Divider(),
        SheetOption(
          icon: Icons.image_outlined,
          title: 'Choose from Gallery',
          subtitle: 'Pick an existing photo',
          onTap: () => _pickForNewItem(context, ImageSource.gallery),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: VexaColors.irisGhost,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                size: 17,
                color: VexaColors.irisDeep,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'VEXA auto-detects the category and dominant color — you just confirm.',
                  style: VexaText.body(size: 11.5, color: VexaColors.irisDeep),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Future<void> _pickForNewItem(
    BuildContext context,
    ImageSource source,
  ) async {
    Navigator.pop(context);
    String? path;
    await Demo.beginPick('item:poncho');
    try {
      final file = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1440,
        imageQuality: 88,
      );
      await Demo.endPick();
      path = file?.path;
    } catch (_) {
      await Demo.endPick();
      if (context.mounted) {
        vexaToast(context, 'Could not open the camera', info: true);
      }
    }
    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddItemScreen(pickedPath: path)),
    );
  }

  @override
  State<ClosetTab> createState() => _ClosetTabState();
}

class _ClosetTabState extends State<ClosetTab> {
  String _category = 'All';
  String _query = '';
  bool _searching = false;
  final _searchCtrl = TextEditingController();

  List<WardrobeItem> get _filtered => Demo.items
      .where(
        (i) =>
            (_category == 'All' || i.category == _category) &&
            (_query.isEmpty ||
                i.name.toLowerCase().contains(_query.toLowerCase()) ||
                i.colorName.toLowerCase().contains(_query.toLowerCase())),
      )
      .toList();

  void _openFilterSheet() {
    var sort = 0;
    showVexaSheet(
      context,
      title: 'Sort & Filter',
      subtitle: 'Organize your closet view',
      icon: Icons.tune_rounded,
      children: [
        StatefulBuilder(
          builder: (context, setSheet) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('SORT BY', style: VexaText.eyebrow()),
              const SizedBox(height: 4),
              for (final (i, label) in [
                'Recently added',
                'Most worn',
                'Name A–Z',
              ].indexed)
                InkWell(
                  onTap: () => setSheet(() => sort = i),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          label,
                          style: VexaText.body(
                            size: 14.5,
                            color: VexaColors.text,
                          ).copyWith(fontWeight: FontWeight.w600),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: sort == i
                                  ? VexaColors.iris
                                  : VexaColors.line2,
                              width: sort == i ? 6.5 : 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 10),
              Text('SEASON', style: VexaText.eyebrow()),
              const SizedBox(height: 10),
              Wrap(
                spacing: 9,
                runSpacing: 9,
                children: ['All Season', 'Summer', 'Winter', 'Monsoon']
                    .map(
                      (s) => VexaChip(
                        label: s,
                        selected: s == 'All Season',
                        onTap: () {},
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 18),
              VexaButton(
                label: 'Apply',
                onTap: () {
                  Navigator.pop(context);
                  vexaToast(context, 'Filters applied');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    return Scaffold(
      backgroundColor: VexaColors.paper,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 84),
        child: FloatingActionButton(
          backgroundColor: VexaColors.ink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          onPressed: () => ClosetTab.showAddSheet(context),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 26),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 12, 22, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Closet', style: VexaText.display()),
                        const SizedBox(height: 4),
                        Text(
                          '${Demo.items.length} pieces · 5 categories',
                          style: VexaText.body(size: 12.5),
                        ),
                      ],
                    ),
                  ),
                  CircleIconButton(
                    icon: Icons.search_rounded,
                    onTap: () => setState(() {
                      _searching = !_searching;
                      if (!_searching) {
                        _query = '';
                        _searchCtrl.clear();
                      }
                    }),
                  ),
                  const SizedBox(width: 9),
                  CircleIconButton(
                    icon: Icons.tune_rounded,
                    onTap: _openFilterSheet,
                  ),
                ],
              ),
            ),
            if (_searching)
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
                child: TextField(
                  controller: _searchCtrl,
                  autofocus: true,
                  onChanged: (v) => setState(() => _query = v),
                  style: const TextStyle(fontSize: 14.5),
                  decoration: InputDecoration(
                    hintText: 'Search your closet…',
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      size: 19,
                      color: VexaColors.faint,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        size: 17,
                        color: VexaColors.faint,
                      ),
                      onPressed: () => setState(() {
                        _query = '';
                        _searchCtrl.clear();
                      }),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 13,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: VexaColors.line2,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: VexaColors.iris,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            SizedBox(
              height: 66,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(22, 14, 22, 12),
                itemCount: Demo.categories.length + 1,
                separatorBuilder: (_, _) => const SizedBox(width: 9),
                itemBuilder: (context, i) {
                  final cat = i == 0 ? 'All' : Demo.categories[i - 1];
                  final count = i == 0
                      ? null
                      : Demo.items.where((it) => it.category == cat).length;
                  return VexaChip(
                    label: count == null ? cat : '$cat · $count',
                    selected: _category == cat,
                    onTap: () => setState(() => _category = cat),
                  );
                },
              ),
            ),
            Expanded(
              child: list.isEmpty
                  ? VexaEmptyState(
                      icon: _query.isNotEmpty
                          ? Icons.search_rounded
                          : Icons.checkroom_rounded,
                      bubbleIcon: _query.isNotEmpty
                          ? Icons.close_rounded
                          : Icons.add_rounded,
                      bubbleColor: _query.isNotEmpty
                          ? VexaColors.faint
                          : VexaColors.iris,
                      title: _query.isNotEmpty
                          ? 'No matches for “$_query”'
                          : 'Nothing here yet',
                      body: _query.isNotEmpty
                          ? 'Try a different word — search looks across names and colors.'
                          : 'Add your first piece to this category.',
                      ctaLabel: _query.isNotEmpty ? 'Clear Search' : 'Add Item',
                      onCta: _query.isNotEmpty
                          ? () => setState(() {
                              _query = '';
                              _searchCtrl.clear();
                            })
                          : () => ClosetTab.showAddSheet(context),
                    )
                  : MasonryGridView.count(
                      padding: const EdgeInsets.fromLTRB(22, 4, 22, 130),
                      crossAxisCount: 2,
                      mainAxisSpacing: 13,
                      crossAxisSpacing: 13,
                      itemCount: list.length,
                      itemBuilder: (context, i) => _ItemCard(
                        item: list[i],
                        onChanged: () => setState(() {}),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({required this.item, required this.onChanged});

  final WardrobeItem item;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ItemDetailScreen(item: item)),
        );
        onChanged();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: VexaShadows.card,
          border: Border.all(color: const Color(0x08131217)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: item.aspect,
                  child: Image(image: item.provider, fit: BoxFit.cover),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      item.favorite = !item.favorite;
                      onChanged();
                      if (item.favorite) {
                        vexaToast(context, 'Added to favorites');
                      }
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .88),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF131217,
                            ).withValues(alpha: .14),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        item.favorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_outline_rounded,
                        size: 16,
                        color: item.favorite ? VexaColors.bad : VexaColors.ink,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(13, 11, 13, 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: VexaText.label(size: 13)),
                  const SizedBox(height: 5),
                  Text(
                    '${item.category} · ${item.colorName}'.toUpperCase(),
                    style: VexaText.eyebrow().copyWith(
                      fontSize: 9.5,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ============================ ADD / EDIT ITEM ============================ */

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key, this.editing, this.pickedPath});

  final WardrobeItem? editing;
  final String? pickedPath;

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  late final TextEditingController _name = TextEditingController(
    text: widget.editing?.name ?? Demo.poncho.name,
  );
  late String _category = widget.editing?.category ?? 'Tops';
  late String _season = widget.editing?.season ?? 'Winter';
  late String _occasion = widget.editing?.occasion ?? 'Casual';
  late Color _color = widget.editing?.color ?? const Color(0xFFEFE3CF);

  static const _swatches = [
    Color(0xFFEFE3CF),
    Color(0xFF131217),
    Color(0xFFF5F4F0),
    Color(0xFF3E4A5A),
    Color(0xFFB4623E),
    Color(0xFF3F7E75),
    Color(0xFFD9A296),
  ];

  late String? _pickedPath = widget.pickedPath;

  String get _image => widget.editing?.image ?? Demo.poncho.image;

  Widget get _preview => _pickedPath != null
      ? Image.file(
          File(_pickedPath!),
          height: 300,
          width: double.infinity,
          fit: BoxFit.cover,
        )
      : Image.asset(
          _image,
          height: 300,
          width: double.infinity,
          fit: BoxFit.cover,
        );

  void _save() {
    if (widget.editing != null) {
      if (_pickedPath != null) {
        Demo.applyPick('item:${widget.editing!.id}', _pickedPath!);
      }
      Navigator.pop(context);
      vexaToast(context, 'Item updated');
      return;
    }
    if (_pickedPath != null) Demo.applyPick('item:poncho', _pickedPath!);
    if (!Demo.items.any((i) => i.id == Demo.poncho.id)) {
      Demo.items.insert(0, Demo.poncho);
    }
    Navigator.pop(context);
    vexaToast(context, 'Added to your closet');
  }

  Widget _chipGroup(
    String title,
    List<String> options,
    String value,
    ValueChanged<String> onPick,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: VexaText.label()),
        const SizedBox(height: 10),
        Wrap(
          spacing: 9,
          runSpacing: 9,
          children: options
              .map(
                (o) => VexaChip(
                  label: o,
                  selected: o == value,
                  onTap: () => onPick(o),
                ),
              )
              .toList(),
        ),
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
                  Text(
                    widget.editing != null ? 'Edit Item' : 'Add Clothing',
                    style: VexaText.title(size: 17),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Stack(
                  children: [
                    _preview,
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        height: 32,
                        padding: const EdgeInsets.symmetric(horizontal: 13),
                        decoration: BoxDecoration(
                          color: VexaColors.iris.withValues(alpha: .55),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              size: 14,
                              color: Colors.white,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'AI DETECTED · TOP',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 12,
                      bottom: 12,
                      child: Material(
                        color: Colors.white.withValues(alpha: .25),
                        borderRadius: BorderRadius.circular(999),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(999),
                          onTap: () async {
                            final p = await pickImageViaSheet(
                              context,
                              target: 'item:${widget.editing?.id ?? 'poncho'}',
                              title: 'Item Photo',
                              subtitle: 'Re-shoot or pick a clearer photo',
                            );
                            if (p != null) setState(() => _pickedPath = p);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 11,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: .35),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.photo_camera_outlined,
                                  size: 15,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 7),
                                Text(
                                  'Retake',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
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
              const SizedBox(height: 22),
              VexaField(label: 'Item name', controller: _name),
              const SizedBox(height: 20),
              _chipGroup(
                'Category',
                Demo.categories,
                _category,
                (v) => setState(() => _category = v),
              ),
              const SizedBox(height: 20),
              Text('Color', style: VexaText.label()),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _swatches.map((c) {
                  final on = _color == c;
                  return GestureDetector(
                    onTap: () => setState(() => _color = c),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 44,
                      height: 44,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: on ? VexaColors.ink : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: c,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0x14000000)),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              _chipGroup(
                'Season',
                const ['All Season', 'Summer', 'Winter', 'Monsoon'],
                _season,
                (v) => setState(() => _season = v),
              ),
              const SizedBox(height: 20),
              _chipGroup(
                'Occasion',
                const ['Casual', 'Business', 'Party', 'Evening', 'Vacation'],
                _occasion,
                (v) => setState(() => _occasion = v),
              ),
              const SizedBox(height: 28),
              VexaButton(
                label: widget.editing != null
                    ? 'Save Changes'
                    : 'Save to Closet',
                onTap: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ============================ ITEM DETAIL ============================ */

class ItemDetailScreen extends StatelessWidget {
  const ItemDetailScreen({super.key, required this.item});

  final WardrobeItem item;

  void _showMoreSheet(BuildContext context) {
    showVexaSheet(
      context,
      title: item.name,
      subtitle: 'Item options',
      icon: Icons.checkroom_rounded,
      children: [
        SheetOption(
          icon: Icons.auto_fix_high_rounded,
          title: 'Use in Try-On',
          subtitle: 'Send to the studio',
          iris: true,
          onTap: () {
            Navigator.pop(context);
            TryOnTab.startWith(context, [item.id], step: 1);
          },
        ),
        const Divider(),
        SheetOption(
          icon: Icons.edit_outlined,
          title: 'Edit Details',
          subtitle: 'Name, category, color, season',
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddItemScreen(editing: item)),
            );
          },
        ),
        const Divider(),
        SheetOption(
          icon: Icons.photo_camera_outlined,
          title: 'Replace Photo',
          subtitle: 'Re-shoot this item',
          onTap: () async {
            Navigator.pop(context);
            final ok = await showVexaDialog(
              context,
              icon: Icons.photo_camera_outlined,
              iconColor: VexaColors.irisDeep,
              iconBg: VexaColors.irisSoft,
              title: 'Replace item photo?',
              body:
                  "Re-shoot this piece for cleaner try-on results. The item's details stay unchanged.",
              confirmLabel: 'Take New Photo',
              irisConfirm: true,
            );
            if (ok == true && context.mounted) {
              final p = await pickImageViaSheet(
                context,
                target: 'item:${item.id}',
                title: 'Item Photo',
                subtitle: 'Re-shoot or pick a clearer photo',
              );
              if (p != null) {
                item.photoPath = p;
                if (context.mounted) vexaToast(context, 'Item photo updated');
              }
            }
          },
        ),
        const Divider(),
        SheetOption(
          icon: Icons.delete_outline_rounded,
          title: 'Delete Item',
          subtitle: 'Remove from your closet',
          danger: true,
          onTap: () {
            Navigator.pop(context);
            _confirmDelete(context);
          },
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context) async {
    final ok = await showVexaDialog(
      context,
      icon: Icons.delete_outline_rounded,
      iconColor: VexaColors.bad,
      iconBg: VexaColors.badSoft,
      title: 'Delete this item?',
      body:
          '“${item.name}” will be removed from your closet and saved outfits.',
      confirmLabel: 'Delete Item',
      cancelLabel: 'Keep It',
      destructive: true,
    );
    if (ok == true && context.mounted) {
      Demo.items.removeWhere((i) => i.id == item.id);
      Demo.trySelection.remove(item.id);
      Navigator.pop(context);
      vexaToast(context, 'Item deleted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(34),
                  ),
                  child: Image(
                    image: item.provider,
                    height: 440,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleIconButton(
                            icon: Icons.arrow_back_rounded,
                            dark: true,
                            onTap: () => Navigator.maybePop(context),
                          ),
                          CircleIconButton(
                            icon: Icons.more_horiz_rounded,
                            dark: true,
                            onTap: () => _showMoreSheet(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.category.toUpperCase(),
                    style: VexaText.eyebrow(color: VexaColors.irisDeep),
                  ),
                  const SizedBox(height: 7),
                  Text(item.name, style: VexaText.display(size: 26)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _metaTile('COLOR', item.colorName, dot: item.color),
                      const SizedBox(width: 11),
                      _metaTile('SEASON', item.season),
                    ],
                  ),
                  const SizedBox(height: 11),
                  Row(
                    children: [
                      _metaTile('OCCASION', item.occasion),
                      const SizedBox(width: 11),
                      _metaTile(
                        'STYLED',
                        item.worn > 0
                            ? 'In ${item.worn} outfits'
                            : 'Not styled yet',
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: IrisButton(
                          label: 'Use in Try-On',
                          icon: Icons.auto_fix_high_rounded,
                          onTap: () =>
                              TryOnTab.startWith(context, [item.id], step: 1),
                        ),
                      ),
                      const SizedBox(width: 10),
                      CircleIconButton(
                        icon: Icons.edit_outlined,
                        size: 56,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddItemScreen(editing: item),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      CircleIconButton(
                        icon: Icons.delete_outline_rounded,
                        size: 56,
                        color: VexaColors.bad,
                        onTap: () => _confirmDelete(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metaTile(String label, String value, {Color? dot}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: VexaColors.line),
          boxShadow: VexaShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: VexaText.eyebrow().copyWith(fontSize: 9.5)),
            const SizedBox(height: 6),
            Row(
              children: [
                if (dot != null) ...[
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: dot,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0x1A000000)),
                    ),
                  ),
                  const SizedBox(width: 7),
                ],
                Expanded(
                  child: Text(
                    value,
                    style: VexaText.label(size: 13.5),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
