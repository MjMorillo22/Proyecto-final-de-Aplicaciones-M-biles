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
      'title': 'Himno UASD',
      'description': 'Conoce más sobre nosotros.',
      'videoUrl': 'https://www.youtube.com/watch?v=L8vm3FmNrUk',
    },
  ];

  late PageController _pageController;
  late YoutubePlayerController _videoController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _videoController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
            _slides.last['videoUrl'] ?? '') ??
          '',
      flags: YoutubePlayerFlags(autoPlay: false, mute: false),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _videoController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });

    if (index == _slides.length - 1) {
      _videoController.play();
    } else {
      _videoController.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: _slides.length,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          final currentSlide = _slides[index];
          return Stack(
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
                        Text(
                          currentSlide['title'] ?? '',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      if (currentSlide.containsKey('description'))
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            currentSlide['description'] ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
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
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(108, 62, 115, 206),
        onPressed: () {
          final nextPage = _currentPage + 1;
          if (nextPage < _slides.length) {
            _pageController.animateToPage(
              nextPage,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          } else {
            Navigator.pushReplacementNamed(context, '/login');
          }
        },
        child: Icon(
          color: Colors.white,
          _currentPage == _slides.length - 1 ? Icons.check : Icons.keyboard_arrow_right_sharp,
        ),
      ),
    );
  }
}
