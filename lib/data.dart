import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WardrobeItem {
  WardrobeItem({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.color,
    required this.colorName,
    required this.season,
    required this.occasion,
    required this.worn,
    this.aspect = 1.0,
  });

  final String id;
  final String name;
  final String category;
  final String image;
  final Color color;
  final String colorName;
  final String season;
  final String occasion;
  final int worn;

  /// Width / height ratio used by the masonry closet grid.
  final double aspect;

  bool favorite = false;

  /// User re-shot photo (camera/gallery); falls back to the demo asset.
  String? photoPath;

  ImageProvider get provider => photoPath != null
      ? FileImage(File(photoPath!))
      : AssetImage(image) as ImageProvider;
}

class Outfit {
  const Outfit({
    required this.name,
    required this.accent,
    required this.mood,
    required this.basedOn,
    required this.pieces,
  });

  final String name;

  /// The word rendered in the editorial serif italic.
  final String accent;
  final String mood;
  final String basedOn;

  /// slot label -> item id
  final List<(String, String)> pieces;
}

class AiResult {
  const AiResult({
    required this.title,
    required this.when,
    required this.image,
    required this.itemIds,
  });

  final String title;
  final String when;
  final String image;
  final List<String> itemIds;
}

/// In-memory demo state for the prototype build.
class Demo {
  Demo._();

  static const userName = 'Amira';
  static const userFullName = 'Amira Hassan';
  static const userEmail = 'amira.hassan@gmail.com';
  static const userCity = 'Dubai, UAE';

  static const categories = [
    'Tops',
    'Bottoms',
    'Shoes',
    'Dresses',
    'Accessories',
  ];

  static final items = <WardrobeItem>[
    WardrobeItem(
      id: 'tee',
      name: 'Classic White Tee',
      category: 'Tops',
      image: 'assets/images/item_tee.jpg',
      color: const Color(0xFFF5F4F0),
      colorName: 'White',
      season: 'All Season',
      occasion: 'Casual',
      worn: 6,
      aspect: 1.0,
    ),
    WardrobeItem(
      id: 'shirt',
      name: 'Chambray Dot Shirt',
      category: 'Tops',
      image: 'assets/images/item_shirt.jpg',
      color: const Color(0xFF7A8FA6),
      colorName: 'Chambray',
      season: 'All Season',
      occasion: 'Smart Casual',
      worn: 3,
      aspect: .67,
    ),
    WardrobeItem(
      id: 'sweat',
      name: 'White Crew Sweatshirt',
      category: 'Tops',
      image: 'assets/images/item_sweat.jpg',
      color: const Color(0xFFF3F1EC),
      colorName: 'Ivory',
      season: 'Winter',
      occasion: 'Casual',
      worn: 4,
      aspect: 1.33,
    ),
    WardrobeItem(
      id: 'blazer',
      name: 'Check Wool Blazer',
      category: 'Tops',
      image: 'assets/images/item_blazer.jpg',
      color: const Color(0xFF9A9494),
      colorName: 'Grey Check',
      season: 'Winter',
      occasion: 'Business',
      worn: 5,
      aspect: .78,
    ),
    WardrobeItem(
      id: 'bomber',
      name: 'Rust Bomber Jacket',
      category: 'Tops',
      image: 'assets/images/item_bomber.jpg',
      color: const Color(0xFFB4623E),
      colorName: 'Rust',
      season: 'Monsoon',
      occasion: 'Casual',
      worn: 2,
      aspect: .75,
    ),
    WardrobeItem(
      id: 'rawdenim',
      name: 'Raw Denim Jeans',
      category: 'Bottoms',
      image: 'assets/images/item_rawdenim.jpg',
      color: const Color(0xFF3E4A5A),
      colorName: 'Indigo',
      season: 'All Season',
      occasion: 'Casual',
      worn: 8,
      aspect: .7,
    ),
    WardrobeItem(
      id: 'indigo',
      name: 'Slim Indigo Jeans',
      category: 'Bottoms',
      image: 'assets/images/item_indigo.jpg',
      color: const Color(0xFF2E3A4E),
      colorName: 'Dark Indigo',
      season: 'All Season',
      occasion: 'Casual',
      worn: 5,
      aspect: 1.25,
    ),
    WardrobeItem(
      id: 'joggers',
      name: 'Blush Satin Joggers',
      category: 'Bottoms',
      image: 'assets/images/item_joggers.jpg',
      color: const Color(0xFFD9A296),
      colorName: 'Blush',
      season: 'Summer',
      occasion: 'Evening',
      worn: 2,
      aspect: .67,
    ),
    WardrobeItem(
      id: 'brogues',
      name: 'Teal Suede Brogues',
      category: 'Shoes',
      image: 'assets/images/item_brogues.jpg',
      color: const Color(0xFF3F7E75),
      colorName: 'Teal',
      season: 'All Season',
      occasion: 'Smart Casual',
      worn: 3,
      aspect: .8,
    ),
    WardrobeItem(
      id: 'sneakers',
      name: 'Sand Leather Sneakers',
      category: 'Shoes',
      image: 'assets/images/item_sneakers.jpg',
      color: const Color(0xFFC9B49A),
      colorName: 'Sand',
      season: 'All Season',
      occasion: 'Casual',
      worn: 7,
      aspect: .72,
    ),
    WardrobeItem(
      id: 'heels',
      name: 'Floral Satin Heels',
      category: 'Shoes',
      image: 'assets/images/item_heels.jpg',
      color: const Color(0xFF4C7FBE),
      colorName: 'Blue Floral',
      season: 'Summer',
      occasion: 'Party',
      worn: 2,
      aspect: 1.0,
    ),
    WardrobeItem(
      id: 'floraldress',
      name: 'Floral Wrap Midi Dress',
      category: 'Dresses',
      image: 'assets/images/result_floral.jpg',
      color: const Color(0xFFEFE6DC),
      colorName: 'Ivory Floral',
      season: 'Summer',
      occasion: 'Vacation',
      worn: 4,
      aspect: 1.5,
    ),
    WardrobeItem(
      id: 'gown',
      name: 'Scarlet Evening Gown',
      category: 'Dresses',
      image: 'assets/images/item_gown.jpg',
      color: const Color(0xFFC1272D),
      colorName: 'Scarlet',
      season: 'All Season',
      occasion: 'Party',
      worn: 1,
      aspect: .83,
    ),
    WardrobeItem(
      id: 'plum',
      name: 'Plum Off-Shoulder Gown',
      category: 'Dresses',
      image: 'assets/images/item_plum.jpg',
      color: const Color(0xFF6C1F5E),
      colorName: 'Plum',
      season: 'Winter',
      occasion: 'Evening',
      worn: 2,
      aspect: .71,
    ),
    WardrobeItem(
      id: 'ruby',
      name: 'Ruby Floral Dress',
      category: 'Dresses',
      image: 'assets/images/item_ruby.jpg',
      color: const Color(0xFFC1272D),
      colorName: 'Ruby',
      season: 'Summer',
      occasion: 'Party',
      worn: 1,
      aspect: .8,
    ),
    WardrobeItem(
      id: 'jumpsuit',
      name: 'Teal Halter Jumpsuit',
      category: 'Dresses',
      image: 'assets/images/item_jumpsuit.jpg',
      color: const Color(0xFF1F6E78),
      colorName: 'Teal',
      season: 'Summer',
      occasion: 'Evening',
      worn: 3,
      aspect: .64,
    ),
    WardrobeItem(
      id: 'watch',
      name: 'Taupe Leather Watch',
      category: 'Accessories',
      image: 'assets/images/item_watch.jpg',
      color: const Color(0xFFB3A08C),
      colorName: 'Taupe',
      season: 'All Season',
      occasion: 'Everyday',
      worn: 11,
      aspect: 1.33,
    ),
    WardrobeItem(
      id: 'crossbody',
      name: 'Grey Studded Crossbody',
      category: 'Accessories',
      image: 'assets/images/item_crossbody.jpg',
      color: const Color(0xFFB9BCC4),
      colorName: 'Dove Grey',
      season: 'All Season',
      occasion: 'Everyday',
      worn: 6,
      aspect: 1.5,
    ),
  ];

  /// The item the "Add Clothing" flow adds — not in the closet initially.
  static final poncho = WardrobeItem(
    id: 'poncho',
    name: 'Cream Knit Poncho',
    category: 'Tops',
    image: 'assets/images/item_poncho.jpg',
    color: const Color(0xFFEFE3CF),
    colorName: 'Cream',
    season: 'Winter',
    occasion: 'Casual',
    worn: 0,
    aspect: .7,
  );

  static const outfits = <Outfit>[
    Outfit(
      name: 'Soft',
      accent: 'Neutrals',
      mood: 'Effortless daytime look · 4 pieces',
      basedOn: 'Minimal',
      pieces: [
        ('Top', 'sweat'),
        ('Bottom', 'rawdenim'),
        ('Shoes', 'sneakers'),
        ('Accessory', 'watch'),
      ],
    ),
    Outfit(
      name: 'Denim on',
      accent: 'Denim',
      mood: 'Relaxed weekend layers · 4 pieces',
      basedOn: 'Casual',
      pieces: [
        ('Top', 'shirt'),
        ('Bottom', 'indigo'),
        ('Shoes', 'brogues'),
        ('Accessory', 'crossbody'),
      ],
    ),
    Outfit(
      name: 'Evening',
      accent: 'Edit',
      mood: 'After-dark statement · 3 pieces',
      basedOn: 'Elegant',
      pieces: [('Dress', 'gown'), ('Shoes', 'heels'), ('Accessory', 'watch')],
    ),
    Outfit(
      name: 'City',
      accent: 'Layers',
      mood: 'Transitional street look · 4 pieces',
      basedOn: 'Casual',
      pieces: [
        ('Top', 'bomber'),
        ('Bottom', 'rawdenim'),
        ('Shoes', 'sneakers'),
        ('Accessory', 'crossbody'),
      ],
    ),
    Outfit(
      name: 'Boardroom',
      accent: 'Soft',
      mood: 'Polished business look · 4 pieces',
      basedOn: 'Business',
      pieces: [
        ('Top', 'blazer'),
        ('Bottom', 'indigo'),
        ('Shoes', 'heels'),
        ('Accessory', 'watch'),
      ],
    ),
  ];

  static const results = <AiResult>[
    AiResult(
      title: 'Plum Evening Look',
      when: '2 days ago',
      image: 'assets/images/item_plum.jpg',
      itemIds: ['plum', 'heels'],
    ),
    AiResult(
      title: 'Blue Coat Editorial',
      when: 'Last week',
      image: 'assets/images/onb_editorial.jpg',
      itemIds: ['crossbody'],
    ),
    AiResult(
      title: 'Autumn Knit Look',
      when: '2 weeks ago',
      image: 'assets/images/result_chevron.jpg',
      itemIds: ['sneakers'],
    ),
    AiResult(
      title: 'Seaside Floral',
      when: '3 weeks ago',
      image: 'assets/images/result_floral.jpg',
      itemIds: ['floraldress', 'heels'],
    ),
  ];

  static final stylePrefs = <String, bool>{
    'Casual': false,
    'Minimal': true,
    'Formal': false,
    'Business': false,
    'Sporty': false,
    'Elegant': true,
  };

  /// Items currently selected for virtual try-on.
  static final trySelection = <String>[];

  /// User-picked photos (camera/gallery). Fall back to the demo assets.
  static String? tryOnPhotoPath;
  static String? avatarPath;

  static SharedPreferences? _prefs;

  static String? _valid(String? p) =>
      (p != null && File(p).existsSync()) ? p : null;

  /// Restore persisted photos and recover a pick that Android lost when it
  /// killed the activity while the camera was open.
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    avatarPath = _valid(_prefs!.getString('avatarPath'));
    tryOnPhotoPath = _valid(_prefs!.getString('tryOnPhotoPath'));
    for (final item in [...items, poncho]) {
      item.photoPath = _valid(_prefs!.getString('item:${item.id}'));
    }
    final target = _prefs!.getString('pickTarget');
    if (target != null) {
      try {
        final lost = await ImagePicker().retrieveLostData();
        final path = lost.file?.path;
        if (path != null) applyPick(target, path);
      } catch (_) {}
      await _prefs!.remove('pickTarget');
    }
  }

  /// Remember what a pick is for, so a killed activity can recover it.
  static Future<void> beginPick(String target) async =>
      _prefs?.setString('pickTarget', target);

  static Future<void> endPick() async => _prefs?.remove('pickTarget');

  static void applyPick(String target, String path) {
    if (target == 'avatar') {
      avatarPath = path;
      _prefs?.setString('avatarPath', path);
    } else if (target == 'tryon') {
      tryOnPhotoPath = path;
      _prefs?.setString('tryOnPhotoPath', path);
    } else if (target.startsWith('item:')) {
      itemById(target.substring(5)).photoPath = path;
      _prefs?.setString(target, path);
    }
  }

  static ImageProvider get tryOnPhoto => tryOnPhotoPath != null
      ? FileImage(File(tryOnPhotoPath!))
      : const AssetImage('assets/images/user_photo.jpg') as ImageProvider;

  static ImageProvider get avatar => avatarPath != null
      ? FileImage(File(avatarPath!))
      : const AssetImage('assets/images/avatar.jpg') as ImageProvider;

  static WardrobeItem itemById(String id) =>
      items.firstWhere((i) => i.id == id, orElse: () => poncho);
}
