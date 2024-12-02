import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final List<Map<String, dynamic>> _slides = [
    {
      'title': 'UASD',
      'description': 'Bienvenidos a la Universidad Autónoma de Santo Domingo.',
      'image': 'assets/uasd_logo.png',
    },
    {
      'title': 'Misión',
      'description':
          'Formar profesionales con excelencia académica, pensamiento crítico, y compromiso social.',
      'image': 'assets/mission_image.png',
    },
    {
      'title': 'Visión',
      'description': 'Ser una universidad líder en educación superior en el Caribe.',
      'image': 'assets/vision_image.png',
    },
    {
      'title': 'Valores',
      'description': 'Excelencia, integridad, y compromiso.',
      'image': 'assets/values_image.png',
    },
    {
      'title': 'Video',
      'description': 'Conoce más sobre nosotros.',
      'videoUrl': 'https://www.youtube.com/watch?v=L8vm3FmNrUk',
    },
  ];

  int _currentSlideIndex = 0;
  late YoutubePlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
            _slides.last['videoUrl'] ?? '') ??
          '',
      flags: YoutubePlayerFlags(autoPlay: false, mute: false),
    );
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void _nextSlide() {
    setState(() {
      if (_currentSlideIndex < _slides.length - 1) {
        _currentSlideIndex++;
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentSlide = _slides[_currentSlideIndex];
    return Scaffold(
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 800),
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: Stack(
          key: ValueKey<int>(_currentSlideIndex),
          children: [
            Positioned.fill(
              child: currentSlide.containsKey('image')
                  ? Image.asset(
                      currentSlide['image'],
                      fit: BoxFit.cover,
                    )
                  : Container(color: Colors.black),
            ),
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.6),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (currentSlide.containsKey('title'))
                      AnimatedText(
                        text: currentSlide['title'] ?? '',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    if (currentSlide.containsKey('description'))
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: AnimatedText(
                          text: currentSlide['description'] ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    if (currentSlide.containsKey('videoUrl'))
                      YoutubePlayer(
                        controller: _videoController,
                        showVideoProgressIndicator: true,
                      ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: _nextSlide,
                child: Icon(
                  _currentSlideIndex < _slides.length - 1
                      ? Icons.arrow_forward
                      : Icons.check,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedText extends StatefulWidget {
  final String text;
  final TextStyle style;

  AnimatedText({required this.text, required this.style});

  @override
  _AnimatedTextState createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Text(
        widget.text,
        style: widget.style,
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
