import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(const ArtTechDiaryApp());
}

const List<String> kBodyFontFallback = ['Inter', 'sans-serif'];
const List<String> kHeadingFontFallback = ['Russo One', 'Inter', 'sans-serif'];

class ArtTechDiaryApp extends StatelessWidget {
  const ArtTechDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'Manrope',
      fontFamilyFallback: kBodyFontFallback,
    );

    return MaterialApp(
      title: 'ArtTech · Дневник атмосферы',
      debugShowCheckedModeBanner: false,
      theme: baseTheme.copyWith(
        textTheme: baseTheme.textTheme.copyWith(
          headlineSmall: baseTheme.textTheme.headlineSmall?.copyWith(
            fontFamily: 'Rubik',
            fontFamilyFallback: kHeadingFontFallback,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
          titleLarge: baseTheme.textTheme.titleLarge?.copyWith(
            fontFamily: 'Rubik',
            fontFamilyFallback: kHeadingFontFallback,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
          titleMedium: baseTheme.textTheme.titleMedium?.copyWith(
            fontFamily: 'Rubik',
            fontFamilyFallback: kHeadingFontFallback,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.15,
          ),
          bodyLarge: baseTheme.textTheme.bodyLarge?.copyWith(
            fontFamily: 'Manrope',
            fontFamilyFallback: kBodyFontFallback,
          ),
          bodyMedium: baseTheme.textTheme.bodyMedium?.copyWith(
            fontFamily: 'Manrope',
            fontFamilyFallback: kBodyFontFallback,
          ),
          bodySmall: baseTheme.textTheme.bodySmall?.copyWith(
            fontFamily: 'Inter',
            fontFamilyFallback: const ['Manrope', 'sans-serif'],
          ),
        ),
      ),
      home: const DiaryHomeShell(),
    );
  }
}

class FlowerSunoStyle {
  final String id;
  final String flowerName;
  final String moodLabel;
  final String sunoStyleTag;
  final String sunoPrompt;
  final int bpm;
  final String modeLabel; // Мажор / Минор
  final String visualLogic; // Объяснимая логика связи музыки, цвета и ритма
  final String audioAssetPath;
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundTint;
  final double softBlur;
  final IconData icon;

  const FlowerSunoStyle({
    required this.id,
    required this.flowerName,
    required this.moodLabel,
    required this.sunoStyleTag,
    required this.sunoPrompt,
    required this.bpm,
    required this.modeLabel,
    required this.visualLogic,
    required this.audioAssetPath,
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundTint,
    required this.softBlur,
    required this.icon,
  });
}

const List<FlowerSunoStyle> kFlowerStyles = [
  FlowerSunoStyle(
    id: 'lily',
    flowerName: 'Лилия',
    moodLabel: 'Тихий свет и тепло',
    sunoStyleTag: 'Ambient / Felt Piano',
    sunoPrompt:
        'Warm ambient felt piano, soft airy pads, gentle room reverb, peaceful morning light, major key, 68 BPM, slow breathing pace, no percussion, instrumental',
    bpm: 68,
    modeLabel: 'Мажор',
    visualLogic:
        'Спокойный ритм и мягкий свет складываются в светлую палитру и плавное дыхание экрана.',
    audioAssetPath: 'assets/audio/lilyy.mp3',
    primaryColor: Color(0xFFD98A6C),
    secondaryColor: Color(0xFF9AB89E),
    backgroundTint: Color(0xFFFDF7EE),
    softBlur: 1.5,
    icon: Icons.spa_outlined,
  ),
  FlowerSunoStyle(
    id: 'lavender',
    flowerName: 'Лаванда',
    moodLabel: 'Вечер и задумчивость',
    sunoStyleTag: 'Lo-Fi / Dream Pop',
    sunoPrompt:
        'Dreamy lo-fi chill, warm Rhodes electric piano, subtle vinyl crackle, soft twilight pads, minor key, 78 BPM, reflective evening mood, laid-back groove, instrumental',
    bpm: 78,
    modeLabel: 'Минор',
    visualLogic:
        'Мягкий вечерний минор и неспешный пульс приглушают краски, чтобы было легче выдохнуть.',
    audioAssetPath: 'assets/audio/lavandd.mp3',
    primaryColor: Color(0xFF8B7EC8),
    secondaryColor: Color(0xFF7FA6C9),
    backgroundTint: Color(0xFFF4F2FB),
    softBlur: 2.2,
    icon: Icons.nightlight_round,
  ),
  FlowerSunoStyle(
    id: 'poppy',
    flowerName: 'Мак',
    moodLabel: 'Яркое событие и драйв',
    sunoStyleTag: 'Indie Pop / Synth',
    sunoPrompt:
        'Upbeat indie pop, bright plucky synths, crisp light drums, sunny energetic bassline, major key, 122 BPM, lively forward momentum, joyful daytime vibe, instrumental',
    bpm: 122,
    modeLabel: 'Мажор',
    visualLogic:
        'Бодрый темп и мажор добавляют больше цвета, тепла и живого движения.',
    audioAssetPath: 'assets/audio/makk.mp3',
    primaryColor: Color(0xFFE05A47),
    secondaryColor: Color(0xFFF2B84B),
    backgroundTint: Color(0xFFFFF4F0),
    softBlur: 0.5,
    icon: Icons.local_fire_department_outlined,
  ),
  FlowerSunoStyle(
    id: 'immortelle',
    flowerName: 'Сухоцвет',
    moodLabel: 'Дорога и плёночный день',
    sunoStyleTag: 'Acoustic Folk',
    sunoPrompt:
        'Warm acoustic folk, intimate fingerpicked guitar, subtle analog warmth, gentle brush rhythm, major key, 88 BPM, open road and golden hour nostalgia, instrumental',
    bpm: 88,
    modeLabel: 'Мажор',
    visualLogic:
        'Тёплая акустика и золотистые тона напоминают кадры из дороги, которые хочется беречь.',
    audioAssetPath: 'assets/audio/suhocvett.mp3',
    primaryColor: Color(0xFFC69349),
    secondaryColor: Color(0xFF8C6D53),
    backgroundTint: Color(0xFFFAF5EA),
    softBlur: 1.2,
    icon: Icons.wb_sunny_outlined,
  ),
  FlowerSunoStyle(
    id: 'heather',
    flowerName: 'Вереск',
    moodLabel: 'Тихий дождь и уединение',
    sunoStyleTag: 'Downtempo / Soft Pads',
    sunoPrompt:
        'Soft melancholic downtempo, warm analog pads, delicate muted piano, cozy quiet rain atmosphere, minor key, 64 BPM, introverted shelter mood, instrumental',
    bpm: 64,
    modeLabel: 'Минор',
    visualLogic:
        'Тихий дождь и приглушённые оттенки создают уютный уголок только для себя.',
    audioAssetPath: 'assets/audio/vereskk.mp3',
    primaryColor: Color(0xFF9A6B9E),
    secondaryColor: Color(0xFF7D8FA3),
    backgroundTint: Color(0xFFF7F3FA),
    softBlur: 2.5,
    icon: Icons.water_drop_outlined,
  ),
  FlowerSunoStyle(
    id: 'peony',
    flowerName: 'Пион',
    moodLabel: 'Тёплая встреча и радость',
    sunoStyleTag: 'Warm Indie / Keys',
    sunoPrompt:
        'Warm indie keys, soft bouncy bass, gentle hand percussion, sunlit afternoon warmth, major key, 108 BPM, friendly closeness and light happiness, instrumental',
    bpm: 108,
    modeLabel: 'Мажор',
    visualLogic:
        'Живой светлый ритм и нежно-коралловые оттенки передают радость от близких людей.',
    audioAssetPath: 'assets/audio/pionn.mp3',
    primaryColor: Color(0xFFD96B88),
    secondaryColor: Color(0xFFF2A68D),
    backgroundTint: Color(0xFFFFF4F6),
    softBlur: 1.0,
    icon: Icons.favorite_border,
  ),
  FlowerSunoStyle(
    id: 'wormwood',
    flowerName: 'Полынь',
    moodLabel: 'Усталость и тихая перезагрузка',
    sunoStyleTag: 'Deep Ambient / Drone',
    sunoPrompt:
        'Deep calming ambient drone, low warm textures, sparse slow piano notes, unhurried resting space, minor key, 60 BPM, gentle emotional reset, no harsh beats, instrumental',
    bpm: 60,
    modeLabel: 'Минор',
    visualLogic:
        'Самый спокойный темп и мягкие оливковые тона помогают замедлиться и передохнуть.',
    audioAssetPath: 'assets/audio/polynn.mp3',
    primaryColor: Color(0xFF6E8268),
    secondaryColor: Color(0xFF9FA89B),
    backgroundTint: Color(0xFFF5F7F3),
    softBlur: 2.8,
    icon: Icons.self_improvement_outlined,
  ),
];

class DayMemoryFolder {
  final String id;
  final DateTime createdAt;
  final String folderTitle;
  final String storyText;
  final List<Uint8List> photoBytes;
  final FlowerSunoStyle flowerStyle;
  final String musicPrompt;

  const DayMemoryFolder({
    required this.id,
    required this.createdAt,
    required this.folderTitle,
    required this.storyText,
    required this.photoBytes,
    required this.flowerStyle,
    this.musicPrompt = '',
  });
}

String generateFolderTitle(String rawText, FlowerSunoStyle style) {
  final cleaned = rawText
      .replaceAll(RegExp(r'[^\p{L}\p{N}\s]', unicode: true), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  if (cleaned.isEmpty) {
    return '${style.flowerName} и тихий след дня';
  }

  final words = cleaned.split(' ').where((w) => w.isNotEmpty).toList();
  if (words.length >= 3 && words.length <= 7) {
    return _capitalizeFirst(words.join(' '));
  }
  if (words.length > 7) {
    return _capitalizeFirst(words.take(5).join(' '));
  }
  return _capitalizeFirst('${words.join(' ')} · ${style.flowerName}');
}

String _capitalizeFirst(String s) {
  if (s.isEmpty) return s;
  return s[0].toUpperCase() + s.substring(1);
}

class MusicService {
  String buildMusicPrompt({
    required FlowerSunoStyle style,
    required String storyText,
  }) {
    final cleanStory = storyText.trim();
    final storyPart = cleanStory.isEmpty
        ? style.moodLabel
        : cleanStory.length > 140
            ? '${cleanStory.substring(0, 140)}...'
            : cleanStory;

    final modeEn = style.modeLabel.toLowerCase().contains('минор')
        ? 'minor key'
        : 'major key';

    return '${style.sunoStyleTag}, ${style.bpm} BPM, $modeEn, '
        'mood: ${style.moodLabel}, atmosphere: $storyPart, instrumental';
  }

  String generateMascotReflection({
    required DayMemoryFolder memory,
  }) {
    final style = memory.flowerStyle;
    final hasStory = memory.storyText.trim().isNotEmpty;
    final pacePhrase = style.bpm >= 105
        ? 'живым, тёплым движением'
        : style.bpm >= 80
            ? 'ровным, уютным шагом'
            : 'очень спокойным дыханием';
    final modePhrase = style.modeLabel.toLowerCase().contains('минор')
        ? 'с тихой глубиной и поводом поразмышлять'
        : 'с тёплым светом и лёгкостью';
    final photoPhrase = memory.photoBytes.isEmpty
        ? 'Даже без фото настроение этого дня уже хорошо слышно.'
        : 'А снимки (${memory.photoBytes.length}) бережно сохранили живые мелочи этого момента.';

    if (!hasStory) {
      return 'Похоже, этот день откликается цветком «${style.flowerName}» — здесь есть ${style.moodLabel.toLowerCase()}, $pacePhrase и $modePhrase. $photoPhrase';
    }

    return 'В «${memory.folderTitle}» чувствуется душа цветка «${style.flowerName}»: ${style.moodLabel.toLowerCase()}, $pacePhrase и $modePhrase. $photoPhrase';
  }
}

/// 3. ГЛАВНАЯ ОБОЛОЧКА: СОЗДАНИЕ ДНЯ + ПРОСМОТР + АРХИВ ПАПОК
class DiaryHomeShell extends StatefulWidget {
  final String mascotBreathAssetPath;
  final String mascotEyesAssetPath;

  const DiaryHomeShell({
    super.key,
    this.mascotBreathAssetPath = 'assets/images/mascot_breath.png',
    this.mascotEyesAssetPath = 'assets/images/mascot_eyes.png',
  });

  @override
  State<DiaryHomeShell> createState() => _DiaryHomeShellState();
}

class _DiaryHomeShellState extends State<DiaryHomeShell>
    with SingleTickerProviderStateMixin {
  int _tabIndex = 0; // 0 = Новый день, 1 = Воспоминание, 2 = Архив папок

  FlowerSunoStyle _selectedFlower = kFlowerStyles.first;
  final MusicService _musicService = MusicService();
  final TextEditingController _storyController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final List<Uint8List> _pickedPhotos = [];

  late final AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  String? _currentLoadedAsset;
  String? _audioNotice;

  late AnimationController _pulseController;
  late List<DayMemoryFolder> _archive;
  DayMemoryFolder? _activeMemory;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.playerStateStream.listen((state) {
      if (!mounted) return;
      final playing = state.playing &&
          state.processingState != ProcessingState.completed;
      setState(() {
        _isPlaying = playing;
      });
    });

    _pulseController = AnimationController(
      vsync: this,
      duration: _durationFromBpm(_selectedFlower.bpm),
    )..repeat(reverse: true);

    const initialTitle = 'Тёплый вечер в парке и какао';
    const initialStory =
        'Шли неспешно по аллее, вокруг падал мягкий свет и хотелось запомнить это спокойствие.';
    final initialStyle = kFlowerStyles[0];

    final initialMemory = DayMemoryFolder(
      id: 'demo-1',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      folderTitle: initialTitle,
      storyText: initialStory,
      photoBytes: const [],
      flowerStyle: initialStyle,
      musicPrompt: _musicService.buildMusicPrompt(
        style: initialStyle,
        storyText: initialStory,
      ),
    );

    _archive = [initialMemory];
    _activeMemory = initialMemory;
    _titleController.text = initialTitle;
  }

  Duration _durationFromBpm(int bpm) {
    final ms = (60000 / bpm).clamp(380, 1150).round();
    return Duration(milliseconds: ms);
  }

  Future<void> _playFlowerMusicForMemory(
    DayMemoryFolder memory, {
    bool isAutoPlay = false,
  }) async {
    final assetPath = memory.flowerStyle.audioAssetPath;
    try {
      setState(() {
        _audioNotice = null;
      });

      if (_currentLoadedAsset != assetPath) {
        await _audioPlayer.setAsset(assetPath);
        _currentLoadedAsset = assetPath;
      }
      await _audioPlayer.play();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isPlaying = false;
        _audioNotice = isAutoPlay
            ? 'Браузер мог придержать звук — просто нажми «Включить музыку».'
            : 'Пока не получилось включить "$assetPath". Загляни в assets/audio/ и pubspec.yaml.';
      });
    }
  }

  Future<void> _togglePlayOrPause(DayMemoryFolder memory) async {
    if (_isPlaying && _currentLoadedAsset == memory.flowerStyle.audioAssetPath) {
      await _audioPlayer.pause();
      return;
    }
    await _playFlowerMusicForMemory(memory, isAutoPlay: false);
  }

  Future<void> _openMemory(DayMemoryFolder memory) async {
    setState(() {
      _activeMemory = memory;
      _tabIndex = 1;
    });
    await _playFlowerMusicForMemory(memory, isAutoPlay: true);
  }

  Future<void> _onTabSelected(int idx) async {
    setState(() {
      _tabIndex = idx;
    });

    if (idx == 1 && _activeMemory != null) {
      await _playFlowerMusicForMemory(_activeMemory!, isAutoPlay: true);
    } else if (idx != 1 && _isPlaying) {
      await _audioPlayer.pause();
    }
  }

  void _onFlowerTap(FlowerSunoStyle style) {
    setState(() {
      _selectedFlower = style;
      _pulseController.duration = _durationFromBpm(style.bpm);
      _pulseController
        ..reset()
        ..repeat(reverse: true);

      if (_storyController.text.trim().isNotEmpty) {
        _titleController.text =
            generateFolderTitle(_storyController.text, _selectedFlower);
      }
    });
  }

  void _onStoryChanged(String value) {
    setState(() {
      _titleController.text = generateFolderTitle(value, _selectedFlower);
    });
  }

  Future<void> _pickPhotosWeb() async {
    if (!kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Выбор фото здесь настроен для браузерной версии'),
        ),
      );
      return;
    }

    final input = html.FileUploadInputElement()
      ..accept = 'image/*'
      ..multiple = true;
    input.click();

    await input.onChange.first;
    final files = input.files;
    if (files == null || files.isEmpty) return;

    for (final file in files) {
      final reader = html.FileReader();
      reader.readAsDataUrl(file);
      await reader.onLoad.first;
      final result = reader.result;
      if (result is String) {
        final base64Part = result.split(',').last;
        final Uint8List bytes = base64Decode(base64Part);
        setState(() {
          _pickedPhotos.add(bytes);
        });
      }
    }
  }

  Future<void> _createAndSaveMemory() async {
    final story = _storyController.text.trim();
    final title = _titleController.text.trim().isEmpty
        ? generateFolderTitle(story, _selectedFlower)
        : _titleController.text.trim();

    final prompt = _musicService.buildMusicPrompt(
      style: _selectedFlower,
      storyText: story,
    );

    final newMemory = DayMemoryFolder(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      folderTitle: title,
      storyText: story.isEmpty
          ? 'День, который захотелось бережно сохранить в цвете «${_selectedFlower.flowerName}».'
          : story,
      photoBytes: List<Uint8List>.from(_pickedPhotos),
      flowerStyle: _selectedFlower,
      musicPrompt: prompt,
    );

    setState(() {
      _archive.insert(0, newMemory);
      _activeMemory = newMemory;
      _tabIndex = 1;
    });

    await _playFlowerMusicForMemory(newMemory, isAutoPlay: true);
  }

  void _openPhotoPreview(Uint8List bytes, FlowerSunoStyle style, int index) {
    showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 680),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: style.backgroundTint,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: style.primaryColor, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Кадр #${index + 1} · ${style.flowerName}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: style.primaryColor.withValues(alpha: 0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 460),
                    child: Image.memory(bytes, fit: BoxFit.contain),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _currentMascotMessage(FlowerSunoStyle currentStyle) {
    if (_tabIndex == 0) {
      if (_storyController.text.trim().isEmpty) {
        return 'Привет! Выбери цветок, который ближе всего к твоему дню, и расскажи пару слов — куда ходил, что порадовало или запомнилось.';
      }
      return 'Как уютно получается! Теперь можно нажать «Сохранить день в папку» и переслушать настроение.';
    }

    if (_tabIndex == 1 && _activeMemory != null) {
      return _musicService.generateMascotReflection(memory: _activeMemory!);
    }

    return 'Здесь живут твои сохранённые дни. Нажми на любую папку — откроем воспоминание и включим музыку под цвет «${currentStyle.flowerName}».';
  }

  @override
  void dispose() {
    _storyController.dispose();
    _titleController.dispose();
    _pulseController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentStyle = _tabIndex == 1 && _activeMemory != null
        ? _activeMemory!.flowerStyle
        : _selectedFlower;
    final headingStyle = Theme.of(context).textTheme.titleLarge;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      color: currentStyle.backgroundTint,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Make the Invisible Visible · Тёплый дневник дня',
            style: headingStyle?.copyWith(fontSize: 19),
          ),
        ),
        body: Stack(
          children: [
            const _ConstantAmbientBackground(),
            _MoodAtmosphereBackground(style: currentStyle),
            _buildAnimatedSideFlowers(currentStyle),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 820),
                child: IndexedStack(
                  index: _tabIndex,
                  children: [
                    _buildCreateDayTab(),
                    _buildMemoryViewTab(),
                    _buildArchiveTab(),
                  ],
                ),
              ),
            ),
            _FloatingMascotGuide(
              style: currentStyle,
              message: _currentMascotMessage(currentStyle),
              breathAssetPath: widget.mascotBreathAssetPath,
              eyesAssetPath: widget.mascotEyesAssetPath,
            ),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _tabIndex,
          onDestinationSelected: _onTabSelected,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.edit_note_outlined),
              selectedIcon: Icon(Icons.edit_note),
              label: 'Мой день',
            ),
            NavigationDestination(
              icon: Icon(Icons.auto_awesome_outlined),
              selectedIcon: Icon(Icons.auto_awesome),
              label: 'Воспоминание',
            ),
            NavigationDestination(
              icon: Icon(Icons.folder_copy_outlined),
              selectedIcon: Icon(Icons.folder_copy),
              label: 'Мои папки',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedSideFlowers(FlowerSunoStyle style) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final showSides = constraints.maxWidth >= 560;
          final flowerSize = showSides ? 118.0 : 76.0;
          final sideOffset = showSides ? -24.0 : -34.0;

          return AnimatedBuilder(
            animation: _pulseController,
            builder: (context, _) {
              final sway = (_pulseController.value - 0.5) * 0.12;
              final breathe = 0.96 + _pulseController.value * 0.06;

              return Stack(
                children: [
                  Positioned(
                    left: sideOffset,
                    top: constraints.maxHeight * 0.14,
                    child: _SideFlowerDecoration(
                      key: ValueKey('left_${style.id}'),
                      style: style,
                      size: flowerSize,
                      angle: sway - 0.2,
                      scale: breathe,
                      flipHorizontal: false,
                    ),
                  ),
                  Positioned(
                    right: sideOffset,
                    top: constraints.maxHeight * 0.36,
                    child: _SideFlowerDecoration(
                      key: ValueKey('right_${style.id}'),
                      style: style,
                      size: flowerSize * 1.08,
                      angle: -sway + 0.25,
                      scale: breathe,
                      flipHorizontal: true,
                    ),
                  ),
                  Positioned(
                    left: sideOffset * 0.8,
                    bottom: constraints.maxHeight * 0.12,
                    child: _SideFlowerDecoration(
                      key: ValueKey('left_low_${style.id}'),
                      style: style,
                      size: flowerSize * 0.85,
                      angle: -sway - 0.15,
                      scale: breathe,
                      flipHorizontal: false,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCreateDayTab() {
    final sectionTitleStyle = Theme.of(context).textTheme.titleMedium;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 140),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildMascotPreviewCard(_selectedFlower),
          const SizedBox(height: 18),
          Text(
            '1. Выбери цветок, который лучше всего передаёт настроение дня',
            style: sectionTitleStyle?.copyWith(fontSize: 15.5),
          ),
          const SizedBox(height: 10),
          _buildFlowersGrid(),
          const SizedBox(height: 22),
          Text(
            '2. Расскажи о дне своими словами и посмотри на название папки',
            style: sectionTitleStyle?.copyWith(fontSize: 15.5),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _storyController,
            onChanged: _onStoryChanged,
            maxLines: 3,
            decoration: InputDecoration(
              hintText:
                  'Например: сходил на прогулку, пил горячий кофе и поймал спокойный свет...',
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Название папки дня (3–7 слов)',
              prefixIcon: const Icon(Icons.folder_open_outlined),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: _pickPhotosWeb,
                icon: const Icon(Icons.add_photo_alternate_outlined),
                label: Text('Прикрепить фото (${_pickedPhotos.length})'),
              ),
              const SizedBox(width: 12),
              if (_pickedPhotos.isNotEmpty)
                TextButton(
                  onPressed: () => setState(() => _pickedPhotos.clear()),
                  child: const Text('Убрать фото'),
                ),
            ],
          ),
          if (_pickedPhotos.isNotEmpty) ...[
            const SizedBox(height: 10),
            SizedBox(
              height: 92,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _pickedPhotos.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, i) => ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    _pickedPhotos[i],
                    width: 92,
                    height: 92,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 22),
          FilledButton.icon(
            onPressed: _createAndSaveMemory,
            style: FilledButton.styleFrom(
              backgroundColor: _selectedFlower.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.auto_awesome),
            label: const Text(
              'Сохранить день в папку',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMascotPreviewCard(FlowerSunoStyle style) {
    final cardHeadingStyle = Theme.of(context).textTheme.titleLarge;

    return Card(
      elevation: 0,
      color: Colors.white.withValues(alpha: 0.88),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: style.primaryColor.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScaleTransition(
              scale: Tween<double>(begin: 0.98, end: 1.03).animate(
                CurvedAnimation(
                  parent: _pulseController,
                  curve: Curves.easeInOut,
                ),
              ),
              child: Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: style.primaryColor.withValues(alpha: 0.14),
                  border: Border.all(color: style.primaryColor, width: 2),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  widget.mascotBreathAssetPath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(
                    style.icon,
                    size: 38,
                    color: style.primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _chip('SUNO AI: ${style.sunoStyleTag}', style.primaryColor),
                      _chip('${style.bpm} BPM', style.secondaryColor),
                      _chip(style.modeLabel, Colors.black87),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${style.flowerName} · ${style.moodLabel}',
                    style: cardHeadingStyle?.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  SelectableText(
                    'Идея для SUNO AI: ${style.sunoPrompt}',
                    style: TextStyle(fontSize: 12.5, color: Colors.grey[800]),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    style.visualLogic,
                    style: TextStyle(fontSize: 12.5, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color == Colors.black87 ? Colors.black87 : color,
        ),
      ),
    );
  }

  Widget _buildFlowersGrid() {
    final tileHeadingStyle = Theme.of(context).textTheme.titleMedium;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: kFlowerStyles.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 230,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.05,
      ),
      itemBuilder: (_, index) {
        final style = kFlowerStyles[index];
        final selected = style.id == _selectedFlower.id;
        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _onFlowerTap(style),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected ? style.primaryColor : Colors.grey.shade300,
                width: selected ? 2.4 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 17,
                      backgroundColor: style.primaryColor.withValues(alpha: 0.15),
                      child: Icon(
                        style.icon,
                        color: style.primaryColor,
                        size: 19,
                      ),
                    ),
                    Text(
                      '${style.bpm} BPM',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      style.flowerName,
                      style: tileHeadingStyle?.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      style.sunoStyleTag,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: style.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      style.moodLabel,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.25,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMemoryViewTab() {
    final memory = _activeMemory;
    if (memory == null) {
      return const Center(
        child: Text('Пока здесь пусто — выбери день в папках или запиши новый.'),
      );
    }

    final style = memory.flowerStyle;
    final memoryHeadingStyle = Theme.of(context).textTheme.headlineSmall;
    final subHeadingStyle = Theme.of(context).textTheme.titleMedium;
    final dateStr =
        '${memory.createdAt.day.toString().padLeft(2, '0')}.${memory.createdAt.month.toString().padLeft(2, '0')}.${memory.createdAt.year}';
    final isThisPlaying =
        _isPlaying && _currentLoadedAsset == style.audioAssetPath;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 140),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.94),
              style.primaryColor.withValues(alpha: 0.14),
              style.secondaryColor.withValues(alpha: 0.14),
            ],
          ),
          border: Border.all(
            color: style.primaryColor.withValues(alpha: 0.45),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: style.primaryColor.withValues(alpha: 0.15),
                  backgroundImage: AssetImage(widget.mascotBreathAssetPath),
                  onBackgroundImageError: (_, __) {},
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ПАПКА · $dateStr',
                        style: TextStyle(
                          fontSize: 11.5,
                          letterSpacing: 1.1,
                          fontWeight: FontWeight.w700,
                          color: style.primaryColor,
                        ),
                      ),
                      Text(
                        memory.folderTitle,
                        style: memoryHeadingStyle?.copyWith(fontSize: 21),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                _chip('Цветок: ${style.flowerName}', style.primaryColor),
                _chip('SUNO AI: ${style.sunoStyleTag}', style.secondaryColor),
                _chip('${style.bpm} BPM · ${style.modeLabel}', Colors.black87),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: style.primaryColor.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      FilledButton.icon(
                        onPressed: () => _togglePlayOrPause(memory),
                        style: FilledButton.styleFrom(
                          backgroundColor: style.primaryColor,
                        ),
                        icon: Icon(
                          isThisPlaying ? Icons.pause : Icons.play_arrow,
                        ),
                        label: Text(
                          isThisPlaying ? 'Приостановить' : 'Включить музыку',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isThisPlaying
                                  ? 'Звучит настроение дня: ${style.flowerName}'
                                  : 'Мелодия под «${style.flowerName}» (${style.moodLabel})',
                              style: subHeadingStyle?.copyWith(fontSize: 14),
                            ),
                            Text(
                              style.audioAssetPath,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (_audioNotice != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _audioNotice!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 18),
            if (memory.photoBytes.isNotEmpty) ...[
              _AnimatedPhotoCollage(
                key: ValueKey('collage_${memory.id}_${memory.photoBytes.length}'),
                photos: memory.photoBytes,
                style: style,
                pulseListenable: _pulseController,
                onPhotoTap: (idx, bytes) =>
                    _openPhotoPreview(bytes, style, idx),
              ),
              const SizedBox(height: 18),
            ],
            Text(
              memory.storyText,
              style: const TextStyle(fontSize: 15.5, height: 1.55),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Как звук и цвет подстроились под этот день:',
                    style: subHeadingStyle?.copyWith(fontSize: 13.5),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    style.visualLogic,
                    style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                  ),
                  const SizedBox(height: 6),
                  SelectableText(
                    'Промпт для SUNO AI: ${memory.musicPrompt.isEmpty ? style.sunoPrompt : memory.musicPrompt}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArchiveTab() {
    final itemTitleStyle = Theme.of(context).textTheme.titleMedium;

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 140),
      itemCount: _archive.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, index) {
        final item = _archive[index];
        final style = item.flowerStyle;
        final dateStr =
            '${item.createdAt.day.toString().padLeft(2, '0')}.${item.createdAt.month.toString().padLeft(2, '0')}.${item.createdAt.year}';

        return Card(
          elevation: 0,
          color: Colors.white.withValues(alpha: 0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: style.primaryColor.withValues(alpha: 0.35)),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            leading: CircleAvatar(
              backgroundColor: style.primaryColor.withValues(alpha: 0.15),
              child: Icon(style.icon, color: style.primaryColor),
            ),
            title: Text(
              item.folderTitle,
              style: itemTitleStyle?.copyWith(fontSize: 16),
            ),
            subtitle: Text(
              '$dateStr · ${style.flowerName} · ${style.sunoStyleTag} · фото: ${item.photoBytes.length}',
              style: TextStyle(fontSize: 12.5, color: Colors.grey[700]),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _openMemory(item),
          ),
        );
      },
    );
  }
}

/// Маскот в правом нижнем углу экрана: моргает каждые 4.5 сек на 1 сек и говорит в рамке под цвет цветка.
class _FloatingMascotGuide extends StatefulWidget {
  final FlowerSunoStyle style;
  final String message;
  final String breathAssetPath;
  final String eyesAssetPath;

  const _FloatingMascotGuide({
    required this.style,
    required this.message,
    required this.breathAssetPath,
    required this.eyesAssetPath,
  });

  @override
  State<_FloatingMascotGuide> createState() => _FloatingMascotGuideState();
}

class _FloatingMascotGuideState extends State<_FloatingMascotGuide> {
  bool _isBlinking = false;
  Timer? _blinkCycleTimer;
  Timer? _blinkDurationTimer;

  @override
  void initState() {
    super.initState();
    _scheduleNextBlink();
  }

  void _scheduleNextBlink() {
    _blinkCycleTimer?.cancel();
    _blinkCycleTimer = Timer(const Duration(milliseconds: 4500), () {
      if (!mounted) return;
      setState(() {
        _isBlinking = true;
      });
      _blinkDurationTimer?.cancel();
      _blinkDurationTimer = Timer(const Duration(milliseconds: 1000), () {
        if (!mounted) return;
        setState(() {
          _isBlinking = false;
        });
        _scheduleNextBlink();
      });
    });
  }

  @override
  void dispose() {
    _blinkCycleTimer?.cancel();
    _blinkDurationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeAsset =
        _isBlinking ? widget.eyesAssetPath : widget.breathAssetPath;
    final bubbleFill = Color.alphaBlend(
      widget.style.primaryColor.withValues(alpha: 0.14),
      Colors.white.withValues(alpha: 0.96),
    );

    return Positioned(
      right: 16,
      bottom: 14,
      child: SafeArea(
        top: false,
        left: false,
        child: LayoutBuilder(
          builder: (context, _) {
            final screenW = MediaQuery.sizeOf(context).width;
            final bubbleMaxW = math.min(280.0, screenW * 0.56);
            final mascotSize = screenW < 540 ? 74.0 : 92.0;

            return Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: bubbleMaxW),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: bubbleFill,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: widget.style.primaryColor,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.style.primaryColor.withValues(
                            alpha: 0.22,
                          ),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: Text(
                        widget.message,
                        key: ValueKey(widget.message),
                        style: TextStyle(
                          fontSize: 12.2,
                          height: 1.38,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[900],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: mascotSize,
                  height: mascotSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.white,
                    border: Border.all(
                      color: widget.style.primaryColor,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.style.primaryColor.withValues(alpha: 0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 120),
                    child: Image.asset(
                      activeAsset,
                      key: ValueKey(activeAsset),
                      fit: BoxFit.cover,
                      width: mascotSize,
                      height: mascotSize,
                      errorBuilder: (_, __, ___) => Center(
                        child: Icon(
                          widget.style.icon,
                          color: widget.style.primaryColor,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Фотоколлаж в декоративных рамках с поэтапным появлением и лёгким ритмичным покачиванием.
class _AnimatedPhotoCollage extends StatefulWidget {
  final List<Uint8List> photos;
  final FlowerSunoStyle style;
  final Animation<double> pulseListenable;
  final void Function(int index, Uint8List bytes) onPhotoTap;

  const _AnimatedPhotoCollage({
    super.key,
    required this.photos,
    required this.style,
    required this.pulseListenable,
    required this.onPhotoTap,
  });

  @override
  State<_AnimatedPhotoCollage> createState() => _AnimatedPhotoCollageState();
}

class _AnimatedPhotoCollageState extends State<_AnimatedPhotoCollage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _staggerController;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 420 + (widget.photos.length.clamp(1, 6) * 110),
      ),
    )..forward();
  }

  @override
  void didUpdateWidget(covariant _AnimatedPhotoCollage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.photos.length != widget.photos.length) {
      _staggerController
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  double _baseTiltForIndex(int index) {
    const tilts = [-0.028, 0.024, -0.02, 0.03, -0.015, 0.022];
    return tilts[index % tilts.length];
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.photos.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: widget.style.primaryColor.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.photo_library_outlined,
                size: 17,
                color: widget.style.primaryColor,
              ),
              const SizedBox(width: 6),
              Text(
                'Коллаж дня · $count ${count == 1 ? 'кадр' : count < 5 ? 'кадра' : 'кадров'}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 13.5,
                      color: widget.style.primaryColor,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final isSingle = count == 1;
              final twoColumns = !isSingle && constraints.maxWidth >= 500;
              final cardWidth = isSingle
                  ? math.min(constraints.maxWidth, 420.0)
                  : twoColumns
                      ? (constraints.maxWidth - 16) / 2
                      : constraints.maxWidth;
              final imageHeight = isSingle ? 240.0 : 175.0;

              return Wrap(
                spacing: 14,
                runSpacing: 14,
                alignment:
                    isSingle ? WrapAlignment.center : WrapAlignment.start,
                children: List.generate(count, (index) {
                  final start = (index * 0.14).clamp(0.0, 0.65);
                  final end = (start + 0.45).clamp(0.25, 1.0);
                  final itemCurve = CurvedAnimation(
                    parent: _staggerController,
                    curve: Interval(start, end, curve: Curves.easeOutBack),
                  );

                  return AnimatedBuilder(
                    animation: Listenable.merge([
                      itemCurve,
                      widget.pulseListenable,
                    ]),
                    builder: (context, child) {
                      final appear = itemCurve.value.clamp(0.0, 1.0);
                      final rhythmWave =
                          (widget.pulseListenable.value - 0.5) * 0.012;
                      final dir = index.isEven ? 1.0 : -1.0;
                      final angle = _baseTiltForIndex(index) + (rhythmWave * dir);
                      final offsetY = (1.0 - appear) * 18.0;

                      return Opacity(
                        opacity: appear.clamp(0.0, 1.0),
                        child: Transform.translate(
                          offset: Offset(0, offsetY),
                          child: Transform.scale(
                            scale: 0.92 + (0.08 * appear),
                            child: Transform.rotate(
                              angle: angle,
                              child: child,
                            ),
                          ),
                        ),
                      );
                    },
                    child: _FramedPhotoCard(
                      bytes: widget.photos[index],
                      index: index,
                      width: cardWidth,
                      height: imageHeight,
                      style: widget.style,
                      onTap: () =>
                          widget.onPhotoTap(index, widget.photos[index]),
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FramedPhotoCard extends StatelessWidget {
  final Uint8List bytes;
  final int index;
  final double width;
  final double height;
  final FlowerSunoStyle style;
  final VoidCallback onTap;

  const _FramedPhotoCard({
    required this.bytes,
    required this.index,
    required this.width,
    required this.height,
    required this.style,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderAccent = index.isEven ? style.primaryColor : style.secondaryColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: width,
          padding: const EdgeInsets.fromLTRB(9, 9, 9, 14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFDF9),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: borderAccent.withValues(alpha: 0.55),
              width: 1.6,
            ),
            boxShadow: [
              BoxShadow(
                color: borderAccent.withValues(alpha: 0.16),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: Image.memory(
                  bytes,
                  height: height,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 7),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'КАДР 0${index + 1}',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: borderAccent,
                    ),
                  ),
                  Text(
                    style.flowerName.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Константный фоновый слой: не меняется при переключении цветка/настроения,
/// включает небесную дымку, мягкие плывущие облака и мерцающие звёзды.
class _ConstantAmbientBackground extends StatefulWidget {
  const _ConstantAmbientBackground();

  @override
  State<_ConstantAmbientBackground> createState() =>
      _ConstantAmbientBackgroundState();
}

class _ConstantAmbientBackgroundState extends State<_ConstantAmbientBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 34),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _ConstantCelestialPainter(progress: _controller.value),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _ConstantCelestialPainter extends CustomPainter {
  final double progress;

  const _ConstantCelestialPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Тонкая дневниковая сетка
    final subtleLinePaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.022)
      ..strokeWidth = 1;

    const step = 48.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), subtleLinePaint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), subtleLinePaint);
    }

    // 2. Небесные световые облака-ореолы
    final angle = progress * 2 * math.pi;
    final orb1 = Offset(
      size.width * 0.24 + math.cos(angle) * 28,
      size.height * 0.22 + math.sin(angle) * 18,
    );
    final orb2 = Offset(
      size.width * 0.78 + math.sin(angle * 0.8) * 32,
      size.height * 0.68 + math.cos(angle * 0.8) * 22,
    );

    canvas.drawCircle(
      orb1,
      math.min(size.width, size.height) * 0.28,
      Paint()..color = Colors.white.withValues(alpha: 0.34),
    );
    canvas.drawCircle(
      orb2,
      math.min(size.width, size.height) * 0.24,
      Paint()..color = Colors.white.withValues(alpha: 0.26),
    );

    // 3. Медленно плывущие облака в небе
    _drawDriftingCloud(
      canvas,
      size,
      baseYRatio: 0.13,
      speedMultiplier: 1.0,
      phaseOffset: 0.1,
      scale: 1.05,
    );
    _drawDriftingCloud(
      canvas,
      size,
      baseYRatio: 0.27,
      speedMultiplier: 0.7,
      phaseOffset: 0.55,
      scale: 0.82,
    );
    _drawDriftingCloud(
      canvas,
      size,
      baseYRatio: 0.44,
      speedMultiplier: 0.5,
      phaseOffset: 0.82,
      scale: 0.68,
    );

    // 4. Мерцающие звёзды и тонкие линии созвездия в верхней части неба
    const starCoords = <Offset>[
      Offset(0.11, 0.09),
      Offset(0.19, 0.15),
      Offset(0.28, 0.08),
      Offset(0.37, 0.17),
      Offset(0.64, 0.10),
      Offset(0.73, 0.16),
      Offset(0.84, 0.09),
      Offset(0.90, 0.20),
      Offset(0.15, 0.33),
      Offset(0.86, 0.35),
    ];

    final constellationPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..strokeWidth = 1.0;

    for (int i = 0; i < 3; i++) {
      final p1 = Offset(
        starCoords[i].dx * size.width,
        starCoords[i].dy * size.height,
      );
      final p2 = Offset(
        starCoords[i + 1].dx * size.width,
        starCoords[i + 1].dy * size.height,
      );
      canvas.drawLine(p1, p2, constellationPaint);
    }
    for (int i = 4; i < 7; i++) {
      final p1 = Offset(
        starCoords[i].dx * size.width,
        starCoords[i].dy * size.height,
      );
      final p2 = Offset(
        starCoords[i + 1].dx * size.width,
        starCoords[i + 1].dy * size.height,
      );
      canvas.drawLine(p1, p2, constellationPaint);
    }

    for (int i = 0; i < starCoords.length; i++) {
      final pos = Offset(
        starCoords[i].dx * size.width,
        starCoords[i].dy * size.height,
      );
      final twinkle =
          0.45 + 0.55 * math.sin((progress * 6 * math.pi) + (i * 1.15));
      final starRadius = (3.2 + (i % 3) * 1.3) * (0.8 + 0.35 * twinkle);
      _drawFourPointStar(
        canvas,
        pos,
        starRadius,
        Colors.white.withValues(alpha: (0.45 + 0.4 * twinkle).clamp(0.0, 0.9)),
      );
    }
  }

  void _drawDriftingCloud(
    Canvas canvas,
    Size size, {
    required double baseYRatio,
    required double speedMultiplier,
    required double phaseOffset,
    required double scale,
  }) {
    final t = (progress * speedMultiplier + phaseOffset) % 1.0;
    final span = size.width + 260.0;
    final cx = -130.0 + t * span;
    final cy = size.height * baseYRatio + math.sin(t * 2 * math.pi) * 6.0;

    final cloudPaint = Paint()..color = Colors.white.withValues(alpha: 0.42);
    final edgePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..color = Colors.white.withValues(alpha: 0.55);

    final puffs = <Offset>[
      Offset(cx - 38 * scale, cy + 6 * scale),
      Offset(cx - 14 * scale, cy - 8 * scale),
      Offset(cx + 16 * scale, cy - 6 * scale),
      Offset(cx + 42 * scale, cy + 7 * scale),
      Offset(cx, cy + 8 * scale),
    ];
    final radii = <double>[
      22 * scale,
      28 * scale,
      25 * scale,
      20 * scale,
      26 * scale,
    ];

    for (int i = 0; i < puffs.length; i++) {
      canvas.drawCircle(puffs[i], radii[i], cloudPaint);
    }
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(cx - 14 * scale, cy - 8 * scale),
        width: 56 * scale,
        height: 56 * scale,
      ),
      math.pi * 1.08,
      math.pi * 0.84,
      false,
      edgePaint,
    );
  }

  void _drawFourPointStar(
    Canvas canvas,
    Offset center,
    double radius,
    Color color,
  ) {
    final inner = radius * 0.28;
    final path = Path()
      ..moveTo(center.dx, center.dy - radius)
      ..lineTo(center.dx + inner, center.dy - inner)
      ..lineTo(center.dx + radius, center.dy)
      ..lineTo(center.dx + inner, center.dy + inner)
      ..lineTo(center.dx, center.dy + radius)
      ..lineTo(center.dx - inner, center.dy + inner)
      ..lineTo(center.dx - radius, center.dy)
      ..lineTo(center.dx - inner, center.dy - inner)
      ..close();

    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _ConstantCelestialPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Динамический небесный слой настроения: солнце/луна, падающие звёзды и небесные частицы под BPM.
class _MoodAtmosphereBackground extends StatefulWidget {
  final FlowerSunoStyle style;

  const _MoodAtmosphereBackground({required this.style});

  @override
  State<_MoodAtmosphereBackground> createState() =>
      _MoodAtmosphereBackgroundState();
}

class _MoodAtmosphereBackgroundState extends State<_MoodAtmosphereBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  Duration _loopDurationForBpm(int bpm) {
    final seconds = (520 / bpm.clamp(55, 140)).clamp(3.5, 11.0);
    return Duration(milliseconds: (seconds * 1000).round());
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _loopDurationForBpm(widget.style.bpm),
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant _MoodAtmosphereBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.style.id != widget.style.id ||
        oldWidget.style.bpm != widget.style.bpm) {
      _controller.duration = _loopDurationForBpm(widget.style.bpm);
      _controller
        ..reset()
        ..repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _MoodAtmospherePainter(
              style: widget.style,
              progress: _controller.value,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _MoodAtmospherePainter extends CustomPainter {
  final FlowerSunoStyle style;
  final double progress;

  const _MoodAtmospherePainter({
    required this.style,
    required this.progress,
  });

  bool get _isEveningOrMinor =>
      style.modeLabel.toLowerCase().contains('минор');

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Небесное светило в правом верхнем секторе (мягкое солнце для мажора, полумесяц для минора)
    final celestialCenter = Offset(size.width * 0.84, size.height * 0.14);
    final pulse = 0.5 + 0.5 * math.sin(progress * 2 * math.pi);

    if (_isEveningOrMinor) {
      // Полумесяц и мягкое лунное гало
      canvas.drawCircle(
        celestialCenter,
        42 + pulse * 6,
        Paint()..color = style.primaryColor.withValues(alpha: 0.10),
      );
      final moonPath = Path.combine(
        PathOperation.difference,
        Path()
          ..addOval(Rect.fromCircle(center: celestialCenter, radius: 22)),
        Path()
          ..addOval(
            Rect.fromCircle(
              center: celestialCenter.translate(9, -6),
              radius: 19,
            ),
          ),
      );
      canvas.drawPath(
        moonPath,
        Paint()..color = style.primaryColor.withValues(alpha: 0.28),
      );
    } else {
      // Тёплое солнце и вращающиеся лучи
      canvas.drawCircle(
        celestialCenter,
        46 + pulse * 8,
        Paint()..color = style.secondaryColor.withValues(alpha: 0.12),
      );
      canvas.drawCircle(
        celestialCenter,
        22 + pulse * 2,
        Paint()..color = style.primaryColor.withValues(alpha: 0.22),
      );

      final rayPaint = Paint()
        ..color = style.primaryColor.withValues(alpha: 0.22)
        ..strokeWidth = 1.6
        ..strokeCap = StrokeCap.round;

      const rayCount = 10;
      for (int r = 0; r < rayCount; r++) {
        final theta = (2 * math.pi * r / rayCount) + (progress * 0.5 * math.pi);
        final innerR = 28.0;
        final outerR = 37.0 + pulse * 5.0;
        canvas.drawLine(
          Offset(
            celestialCenter.dx + math.cos(theta) * innerR,
            celestialCenter.dy + math.sin(theta) * innerR,
          ),
          Offset(
            celestialCenter.dx + math.cos(theta) * outerR,
            celestialCenter.dy + math.sin(theta) * outerR,
          ),
          rayPaint,
        );
      }
    }

    // 2. Падающая звезда (для вечерних/минорных настроений)
    if (_isEveningOrMinor) {
      final shootT = (progress * 1.4) % 1.0;
      if (shootT < 0.45) {
        final localT = shootT / 0.45;
        final start = Offset(size.width * 0.72, size.height * 0.08);
        final head = Offset(
          start.dx - localT * 170,
          start.dy + localT * 95,
        );
        final tail = Offset(
          head.dx + 48 * (1.0 - localT * 0.4),
          head.dy - 27 * (1.0 - localT * 0.4),
        );
        canvas.drawLine(
          tail,
          head,
          Paint()
            ..color = style.primaryColor.withValues(alpha: 0.35 * (1.0 - localT))
            ..strokeWidth = 1.8
            ..strokeCap = StrokeCap.round,
        );
        canvas.drawCircle(
          head,
          2.6,
          Paint()
            ..color = Colors.white.withValues(alpha: 0.85 * (1.0 - localT)),
        );
      }
    }

    // 3. Тематические небесные частицы / капли / блики под BPM
    const count = 14;
    for (int i = 0; i < count; i++) {
      final seed = (i + 1) * 97.0;
      final baseX = ((seed * 13) % 100) / 100.0 * size.width;
      final baseY = ((seed * 29) % 100) / 100.0 * size.height;
      final phase = (progress + i / count) % 1.0;
      final waveAngle = phase * 2 * math.pi;

      double dx = 0;
      double dy = 0;
      double radius = 5 + (i % 4) * 2.5;

      switch (style.id) {
        case 'poppy':
          dx = math.cos(waveAngle + i) * 26;
          dy = -phase * 48;
          radius = 4 + (i % 3) * 2.0;
          break;
        case 'heather':
          dx = math.sin(waveAngle * 0.5 + i) * 8;
          dy = phase * 70;
          radius = 3.5 + (i % 3) * 1.5;
          break;
        case 'lavender':
          dx = math.sin(waveAngle + i) * 22;
          dy = math.cos(waveAngle * 0.7 + i) * 14;
          radius = 6 + (i % 3) * 2.5;
          break;
        case 'wormwood':
          dx = math.cos(waveAngle * 0.5 + i) * 14;
          dy = math.sin(waveAngle * 0.5 + i) * 10;
          radius = 10 + (i % 3) * 4.0;
          break;
        default:
          dx = math.sin(waveAngle + i) * 18;
          dy = math.cos(waveAngle + i) * 18;
          radius = 5 + (i % 4) * 2.0;
      }

      final pos = Offset(
        (baseX + dx).clamp(0.0, size.width),
        (baseY + dy).clamp(0.0, size.height),
      );

      final paint = Paint()
        ..color = (i.isEven ? style.primaryColor : style.secondaryColor)
            .withValues(alpha: 0.15);

      if (style.id == 'heather') {
        canvas.drawLine(
          pos,
          Offset(pos.dx, (pos.dy + radius * 2.2).clamp(0.0, size.height)),
          Paint()
            ..color = style.secondaryColor.withValues(alpha: 0.22)
            ..strokeWidth = 1.5,
        );
      } else {
        canvas.drawCircle(pos, radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MoodAtmospherePainter oldDelegate) {
    return oldDelegate.style.id != style.id ||
        oldDelegate.style.bpm != style.bpm ||
        oldDelegate.progress != progress;
  }
}

class _SideFlowerDecoration extends StatefulWidget {
  final FlowerSunoStyle style;
  final double size;
  final double angle;
  final double scale;
  final bool flipHorizontal;

  const _SideFlowerDecoration({
    super.key,
    required this.style,
    required this.size,
    required this.angle,
    required this.scale,
    required this.flipHorizontal,
  });

  @override
  State<_SideFlowerDecoration> createState() => _SideFlowerDecorationState();
}

class _SideFlowerDecorationState extends State<_SideFlowerDecoration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _enterController;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _enterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    )..forward();
    _progress = CurvedAnimation(
      parent: _enterController,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _enterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _progress,
      builder: (context, child) {
        final t = _progress.value.clamp(0.0, 1.0);
        final slideX = (1.0 - t) * (widget.flipHorizontal ? 60.0 : -60.0);

        return Opacity(
          opacity: (t * 0.85).clamp(0.0, 0.85),
          child: Transform.translate(
            offset: Offset(slideX, 0),
            child: Transform.scale(
              scale: widget.scale * (0.7 + 0.3 * t),
              child: Transform.rotate(
                angle: widget.angle,
                child: child,
              ),
            ),
          ),
        );
      },
      child: Transform(
        alignment: Alignment.center,
        transform: widget.flipHorizontal
            ? (Matrix4.identity()..scale(-1.0, 1.0, 1.0))
            : Matrix4.identity(),
        child: SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: _FlowerPetalPainter(
              flowerId: widget.style.id,
              primaryColor: widget.style.primaryColor,
              secondaryColor: widget.style.secondaryColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _FlowerPetalPainter extends CustomPainter {
  final String flowerId;
  final Color primaryColor;
  final Color secondaryColor;

  const _FlowerPetalPainter({
    required this.flowerId,
    required this.primaryColor,
    required this.secondaryColor,
  });

  int _petalCount() {
    switch (flowerId) {
      case 'lily':
        return 6;
      case 'lavender':
        return 8;
      case 'poppy':
        return 5;
      case 'immortelle':
        return 10;
      case 'heather':
        return 7;
      case 'peony':
        return 12;
      case 'wormwood':
        return 6;
      default:
        return 6;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.44;
    final petals = _petalCount();

    final petalPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = primaryColor.withValues(alpha: 0.24);

    final innerPetalPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = secondaryColor.withValues(alpha: 0.26);

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..color = primaryColor.withValues(alpha: 0.42);

    for (int i = 0; i < petals; i++) {
      final theta = (2 * math.pi * i) / petals;
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(theta);

      final petalRect = Rect.fromCenter(
        center: Offset(0, -radius * 0.52),
        width: radius *
            (flowerId == 'lavender' || flowerId == 'wormwood' ? 0.34 : 0.52),
        height: radius * 0.78,
      );

      final rrect = RRect.fromRectAndRadius(
        petalRect,
        Radius.circular(radius * 0.4),
      );
      canvas.drawRRect(rrect, i.isEven ? petalPaint : innerPetalPaint);
      canvas.drawRRect(rrect, strokePaint);
      canvas.restore();
    }

    canvas.drawCircle(
      center,
      radius * 0.22,
      Paint()..color = secondaryColor.withValues(alpha: 0.45),
    );
  }

  @override
  bool shouldRepaint(covariant _FlowerPetalPainter oldDelegate) {
    return oldDelegate.flowerId != flowerId ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.secondaryColor != secondaryColor;
  }
}