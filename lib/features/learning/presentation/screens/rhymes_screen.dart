import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class RhymesScreen extends StatefulWidget {
  const RhymesScreen({super.key});

  @override
  State<RhymesScreen> createState() => _RhymesScreenState();
}

class _RhymesScreenState extends State<RhymesScreen> {
  final FlutterTts _tts = FlutterTts();
  int _rhymeIndex = 0;
  bool _isUrdu = false;
  bool _playing = false;

  static const _englishRhymes = [
    _Rhyme(
      title: 'Twinkle Twinkle',
      emoji: '⭐',
      text:
          'Twinkle, twinkle, little star,\n'
          'How I wonder what you are!\n'
          'Up above the world so high,\n'
          'Like a diamond in the sky.\n'
          'Twinkle, twinkle, little star,\n'
          'How I wonder what you are!',
    ),
    _Rhyme(
      title: 'Baa Baa Black Sheep',
      emoji: '🐑',
      text:
          'Baa, baa, black sheep,\n'
          'Have you any wool?\n'
          'Yes sir, yes sir,\n'
          'Three bags full!\n'
          'One for the master,\n'
          'One for the dame,\n'
          'And one for the little boy\n'
          'Who lives down the lane.',
    ),
    _Rhyme(
      title: 'Humpty Dumpty',
      emoji: '🥚',
      text:
          'Humpty Dumpty sat on a wall,\n'
          'Humpty Dumpty had a great fall.\n'
          'All the king\'s horses\n'
          'And all the king\'s men\n'
          'Couldn\'t put Humpty together again.',
    ),
    _Rhyme(
      title: 'Jack and Jill',
      emoji: '⛰️',
      text:
          'Jack and Jill went up the hill\n'
          'To fetch a pail of water.\n'
          'Jack fell down and broke his crown,\n'
          'And Jill came tumbling after.',
    ),
    _Rhyme(
      title: 'Old MacDonald',
      emoji: '🐄',
      text:
          'Old MacDonald had a farm, E-I-E-I-O!\n'
          'And on his farm he had a cow, E-I-E-I-O!\n'
          'With a moo moo here,\n'
          'And a moo moo there,\n'
          'Here a moo, there a moo,\n'
          'Everywhere a moo moo!\n'
          'Old MacDonald had a farm, E-I-E-I-O!',
    ),
  ];

  static const _urduRhymes = [
    _Rhyme(
      title: 'Machli Jal Ki Rani',
      emoji: '🐟',
      text:
          'Machli jal ki rani hai,\n'
          'Jeevan uska paani hai.\n'
          'Haath lagao, dar jayegi,\n'
          'Bahar nikalo, mar jayegi.',
      ttsText:
          'Machli jal ki rani hai. '
          'Jeevan uska paani hai. '
          'Haath lagao dar jayegi. '
          'Bahar nikalo mar jayegi.',
    ),
    _Rhyme(
      title: 'Aik Do Teen',
      emoji: '🔢',
      text:
          'Aik, do, teen, char,\n'
          'Panch, chay, saat, aath.\n'
          'Nau aur das,\n'
          'Ginti seekh lo aaj.',
      ttsText:
          'Aik do teen char. '
          'Panch chay saat aath. '
          'Nau aur das. '
          'Ginti seekh lo aaj.',
    ),
    _Rhyme(
      title: 'Chanda Mama',
      emoji: '🌙',
      text:
          'Chanda mama door ke,\n'
          'Puye pakaye boor ke.\n'
          'Aap khaye thali mein,\n'
          'Mujhe diye pyali mein.',
      ttsText:
          'Chanda mama door ke. '
          'Puye pakaye boor ke. '
          'Aap khaye thali mein. '
          'Mujhe diye pyali mein.',
    ),
    _Rhyme(
      title: 'Nani Teri Morni',
      emoji: '🦚',
      text:
          'Nani teri morni ko mor le gaaye,\n'
          'Bache khud aaye, bache khud aaye.\n'
          'Laal peeli harre rang ki,\n'
          'Nani ki morni naach gayi.',
      ttsText:
          'Nani teri morni ko mor le gaaye. '
          'Bache khud aaye. '
          'Laal peeli harre rang ki. '
          'Nani ki morni naach gayi.',
    ),
  ];

  List<_Rhyme> get _rhymes => _isUrdu ? _urduRhymes : _englishRhymes;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await _tts.awaitSpeakCompletion(true);
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.2);
  }

  Future<String> _resolveLanguage() async {
    if (!_isUrdu) return 'en-US';
    final indianEnglishOk = await _tts.isLanguageAvailable('en-IN');
    if (indianEnglishOk == true) return 'en-IN';
    return 'en-US';
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Future<void> _play() async {
    if (_playing) {
      await _tts.stop();
      if (mounted) setState(() => _playing = false);
      return;
    }
    final rhyme = _rhymes[_rhymeIndex];
    final textToSpeak = rhyme.ttsText ?? rhyme.text;
    final lang = await _resolveLanguage();
    await _tts.setLanguage(lang);
    await _tts.setSpeechRate(_isUrdu ? 0.40 : 0.45);
    setState(() => _playing = true);
    await _tts.speak(textToSpeak);
    if (mounted) setState(() => _playing = false);
  }

  Future<void> _toggleLanguage() async {
    await _tts.stop();
    setState(() {
      _isUrdu = !_isUrdu;
      _rhymeIndex = 0;
      _playing = false;
    });
    await _tts.setLanguage(await _resolveLanguage());
  }

  @override
  Widget build(BuildContext context) {
    final rhyme = _rhymes[_rhymeIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFFEF7F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFEF7F0),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Rhymes',
          style: TextStyle(fontFamily: 'arlrdbd', color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: _toggleLanguage,
            child: Text(
              _isUrdu ? '🇬🇧 English' : '🇵🇰 Urdu',
              style: const TextStyle(fontFamily: 'arlrdbd', fontSize: 14),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _rhymes.length,
              itemBuilder: (_, i) => GestureDetector(
                onTap: () {
                  _tts.stop();
                  setState(() {
                    _rhymeIndex = i;
                    _playing = false;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _rhymeIndex == i
                        ? const Color(0xFFF19335)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(_rhymes[i].emoji, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 6),
                      Text(
                        _rhymes[i].title,
                        style: TextStyle(
                          fontFamily: 'arlrdbd',
                          fontSize: 12,
                          color:
                              _rhymeIndex == i ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    rhyme.emoji,
                    style: const TextStyle(fontSize: 60),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    rhyme.title,
                    style: const TextStyle(
                      fontFamily: 'arlrdbd',
                      fontSize: 22,
                      color: Color(0xFFF19335),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        rhyme.text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'arlrdbd',
                          fontSize: _isUrdu ? 18 : 20,
                          height: 1.8,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: GestureDetector(
              onTap: _play,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _playing
                      ? Colors.red.shade400
                      : const Color(0xFFF19335),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFF19335).withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  _playing ? Icons.stop : Icons.play_arrow,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Rhyme {
  final String title;
  final String emoji;
  final String text;
  final String? ttsText;
  const _Rhyme({
    required this.title,
    required this.emoji,
    required this.text,
    this.ttsText,
  });
}
