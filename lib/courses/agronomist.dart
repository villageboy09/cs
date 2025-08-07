// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class CourseVideoPage extends StatefulWidget {
  const CourseVideoPage({super.key});

  @override
  _CourseVideoPageState createState() => _CourseVideoPageState();
}

class _CourseVideoPageState extends State<CourseVideoPage> {
  VideoPlayerController? _controller;
  int _currentVideoIndex = 0;
  List<DocumentSnapshot> _videos = [];
  final int _quizzesAttempted = 0;
  bool _controlsVisible = true;
  bool _isMuted = false;
  late Duration _videoDuration;
  bool _isFullScreen = false;
  Timer? _hideControlsTimer;

  List<QuizQuestion> _quizQuestions = [];
  // ignore: unused_field
  int _quizIndex = 0; // Track the current quiz index

  @override
  void initState() {
    super.initState();
    _fetchVideos();
    _fetchQuizQuestions();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void _fetchVideos() async {
    final snapshot = await FirebaseFirestore.instance.collection('videos').get();
    setState(() {
      _videos = snapshot.docs;
      if (_videos.isNotEmpty) {
        _loadVideo(_videos[_currentVideoIndex]['Uri']);
      }
    });
  }

  void _fetchQuizQuestions() async {
    // Fetch quiz questions from Firestore or another source
    // Example: final snapshot = await FirebaseFirestore.instance.collection('quizzes').get();
    // _quizQuestions = snapshot.docs.map((doc) => QuizQuestion.fromDocument(doc)).toList();
    setState(() {
      _quizQuestions = [
        QuizQuestion(
          question: "What is the capital of France?",
          options: ["Berlin", "Madrid", "Paris", "Rome"],
          correctAnswerIndex: 2,
        ),
        QuizQuestion(
          question: "What is 2 + 2?",
          options: ["3", "4", "5", "6"],
          correctAnswerIndex: 1,
        ),
        // Add more questions as needed
      ];
    });
  }

  void _loadVideo(String url) {
    _controller?.dispose();
    _controller = VideoPlayerController.networkUrl(Uri.parse(url));

    _controller!.initialize().then((_) {
      setState(() {
        _videoDuration = _controller!.value.duration;
      });
      _controller!.play();
    }).catchError((error) {
      print("Error initializing video: $error");
    });

    _controller!.addListener(_videoListener);
  }

  void _videoListener() {
    if (_controller!.value.hasError) {
      print("Video player error: ${_controller!.value.errorDescription}");
    }
    
    if (_controller!.value.position >= _controller!.value.duration) {
      _onVideoComplete();
    }
  }

  void _onVideoComplete() {
    if (_currentVideoIndex < _videos.length - 1) {
      // Switch to the Final Exam tab
      DefaultTabController.of(context).animateTo(2);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Course Completed'),
          content: const Text('Congratulations! You\'ve completed all videos.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  void updateProgress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
      await userDoc.set({
        'quizzesAttempted': _quizzesAttempted,
        'lastWatchedVideo': _currentVideoIndex,
      }, SetOptions(merge: true));
    }
  }

  void _onNextVideo() {
    if (_currentVideoIndex < _videos.length - 1) {
      setState(() {
        _currentVideoIndex++;
        _loadVideo(_videos[_currentVideoIndex]['Uri']);
      });
    }
  }

  void _checkAnswer(int questionIndex, int selectedOptionIndex) {
    if (selectedOptionIndex == _quizQuestions[questionIndex].correctAnswerIndex) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Correct answer!')),
      );
      // Move to the next quiz or final exam section
      if (questionIndex < _quizQuestions.length - 1) {
        setState(() {
          _quizIndex++;
        });
      } else {
        _completeFinalExam(); // End of quiz
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect answer, try again!')),
      );
    }
  }

  void _completeFinalExam() {
    // Handle completion of final exam
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Quiz completed!')),
    );
    _onNextVideo(); // Move to the next video
  }

  Widget _buildCustomControls() {
    return AnimatedOpacity(
      opacity: _controlsVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black54, Colors.transparent],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VideoProgressIndicator(
              _controller!,
              allowScrubbing: true,
              colors: const VideoProgressColors(
                playedColor: Colors.red,
                bufferedColor: Colors.grey,
                backgroundColor: Colors.white54,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(_controller!.value.isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: _togglePlayPause,
                  color: Colors.white,
                ),
                IconButton(
                  icon: const Icon(Icons.replay_10),
                  onPressed: () => _seekRelative(-10),
                  color: Colors.white,
                ),
                IconButton(
                  icon: const Icon(Icons.forward_10),
                  onPressed: () => _seekRelative(10),
                  color: Colors.white,
                ),
                ValueListenableBuilder<VideoPlayerValue>(
                  valueListenable: _controller!,
                  builder: (context, value, child) {
                    return Text(
                      '${_formatDuration(value.position)} / ${_formatDuration(_videoDuration)}',
                      style: const TextStyle(color: Colors.white),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(_isMuted ? Icons.volume_off : Icons.volume_up),
                  onPressed: _toggleMute,
                  color: Colors.white,
                ),
                IconButton(
                  icon: Icon(_isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen),
                  onPressed: _toggleFullScreen,
                  color: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return _controller != null && _controller!.value.isInitialized
        ? GestureDetector(
            onTap: _toggleControls,
            child: AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  VideoPlayer(_controller!),
                  _buildCustomControls(),
                ],
              ),
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }

  Widget _buildModulesList() {
    return ListView.builder(
      itemCount: _videos.length,
      itemBuilder: (context, index) {
        return Card(
          color: _currentVideoIndex == index ? Colors.blue.shade100 : Colors.white, // Highlight the current module
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ListTile(
            leading: CircleAvatar(
              child: Text('${index + 1}'),
            ),
            title: Text(
              _videos[index]['title'], // Display the video title
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            trailing: Icon(Icons.play_arrow, color: Theme.of(context).primaryColor),
            onTap: () {
              setState(() {
                _currentVideoIndex = index;
                _loadVideo(_videos[index]['Uri']); // Load the video on tap
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildMaterialsList() {
    return ListView(
      children: [
        ListTile(
          title: const Text('Course Material'),
          leading: const Icon(Icons.book),
          onTap: () {
            // Handle download or view of additional resources
          },
        ),
      ],
    );
  }

  Widget _buildFinalExam() {
    return _quizQuestions.isNotEmpty
        ? ListView.builder(
            itemCount: _quizQuestions.length,
            itemBuilder: (context, index) {
              final quiz = _quizQuestions[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  title: Text(quiz.question),
                  subtitle: Column(
                    children: quiz.options.asMap().entries.map((entry) {
                      int optionIndex = entry.key;
                      String option = entry.value;
                      return ListTile(
                        title: Text(option),
                        onTap: () {
                          _checkAnswer(index, optionIndex);
                        },
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          )
        : const Center(child: CircularProgressIndicator());
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
    });
  }

  void _seekRelative(double seconds) {
    final position = _controller!.value.position + Duration(seconds: seconds.toInt());
    setState(() {
      _controller!.seekTo(
        position < Duration.zero
            ? Duration.zero
            : position > _videoDuration
                ? _videoDuration
                : position,
      );
    });
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controller!.setVolume(_isMuted ? 0.0 : 1.0);
    });
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
    if (_isFullScreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  void _toggleControls() {
    setState(() {
      _controlsVisible = !_controlsVisible;
    });
    _hideControlsTimer?.cancel();
    if (_controlsVisible) {
      _hideControlsTimer = Timer(const Duration(seconds: 3), () {
        setState(() {
          _controlsVisible = false;
        });
      });
    }
  }

  String _formatDuration(Duration duration) {
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _controller?.dispose();
    _hideControlsTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isFullScreen
          ? null
          : AppBar(
              title: Text('Agronomist', style: GoogleFonts.poppins(fontSize: 24, color: Colors.white)),
              backgroundColor: Colors.green,
              elevation: 0,
              centerTitle: true,
            ),
      body: SafeArea(
        child: _isFullScreen
            ? _buildVideoPlayer()
            : Column(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: _buildVideoPlayer(),
                  ),
                  Expanded(
                    child: DefaultTabController(
                      length: 3,
                      child: Column(
                        children: [
                          const TabBar(
                            tabs: [
                              Tab(text: 'Modules'),
                              Tab(text: 'Materials'),
                              Tab(text: 'Final Exam'),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                _buildModulesList(),
                                _buildMaterialsList(),
                                _buildFinalExam(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });

  // Factory method to create a QuizQuestion from a Firestore document
  factory QuizQuestion.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return QuizQuestion(
      question: data['question'] ?? '',
      options: List<String>.from(data['options'] ?? []),
      correctAnswerIndex: data['correctAnswerIndex'] ?? 0,
    );
  }
}
