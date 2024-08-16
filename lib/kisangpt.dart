// ignore_for_file: avoid_print

import 'dart:io';
import 'package:cropsync/users/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';


const String _apiKey = String.fromEnvironment(
  'API_KEY',
  defaultValue: 'AIzaSyCroPtzjFYNxHBuf_f-S_10cxu-B9TBhQI',
);

class GenerativeAISample extends StatelessWidget {
  const GenerativeAISample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter + Generative AI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color.fromARGB(255, 171, 222, 244),
        ),
        useMaterial3: true,
      ),
      home: const ChatScreen(title: 'Flutter + Generative AI'),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.title});

  final String title;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: const Sidebar(profileImageUrl: '', userName: '',),

      body: const ChatWidget(apiKey: _apiKey),
    );
  }
}

class ChatWidget extends StatefulWidget {
  const ChatWidget({
    required this.apiKey,
    super.key,
  });

  final String apiKey;

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  GenerativeModel? _model;
  ChatSession? _chat;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFieldFocus = FocusNode();
  final List<({Image? image, String? text, bool fromUser})> _generatedContent =
      <({Image? image, String? text, bool fromUser})>[];
  bool _loading = false;
  File? _uploadedImageFile;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeChat();
    });
  }

  void _initializeChat() {
    if (widget.apiKey.isNotEmpty) {
      _model = GenerativeModel(
        model: 'gemini-1.5-flash-latest',
        apiKey: widget.apiKey,
      );
      _chat = _model?.startChat();
    } else {
      _model = null;
      _chat = null;
      _showError('API key is empty. Please provide a valid API key.');
    }
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(
          milliseconds: 750,
        ),
        curve: Curves.easeOutCirc,
      ),
    );
  }

  Future<void> _uploadImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _uploadedImageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _sendChatMessage() async {
    if (_chat == null) {
      _showError('No chat session available. Please ensure the API key is valid.');
      return;
    }

    String message = _textController.text;
    if (message.isEmpty && _uploadedImageFile == null) {
      _showError('Please provide a message or upload an image.');
      return; // Do nothing if both text and image are empty
    }

    setState(() {
      _loading = true;
    });

    // Display the image and text in the chat
    setState(() {
      _generatedContent.add((
        image: _uploadedImageFile != null ? Image.file(_uploadedImageFile!) : null,
        text: message.isNotEmpty ? message : null,
        fromUser: true,
      ));
      _scrollDown();
    });

    try {
      if (_uploadedImageFile != null) {
        // Convert image to bytes and send it to the API
        final imageBytes = await _uploadedImageFile!.readAsBytes();
        final mimeType = lookupMimeType(_uploadedImageFile!.path);

        if (mimeType == null || !mimeType.startsWith('image/')) {
          _showError('Selected file is not a valid image.');
          return;
        }

        // Example of how to use the imageBytes if needed
        // For now, just log the size of the imageBytes
        print('Image size: ${imageBytes.length} bytes');

        // Handle the image upload or analysis here
        // For example: send the imageBytes to the API
      }

      if (message.isNotEmpty) {
        final response = await _chat!.sendMessage(Content.text(message));
        final text = response.text;

        if (text != null) {
          _generatedContent.add((image: null, text: text, fromUser: false));
        } else {
          _showError('No response from API.');
        }
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() {
        _loading = false;
        _uploadedImageFile = null; // Reset the image after sending
        _textController.clear(); // Clear the text field
        _scrollDown();
      });
      _textFieldFocus.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textFieldDecoration = InputDecoration(
      contentPadding: const EdgeInsets.all(15),
      hintText: 'Enter a prompt...',
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(14),
        ),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(14),
        ),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _model != null
                  ? ListView.builder(
                      controller: _scrollController,
                      itemBuilder: (context, idx) {
                        final content = _generatedContent[idx];
                        return MessageWidget(
                          text: content.text,
                          image: content.image,
                          isFromUser: content.fromUser,
                        );
                      },
                      itemCount: _generatedContent.length,
                    )
                  : ListView(
                      children: const [
                        Text(
                          'No API key found. Please provide an API Key using '
                          "'--dart-define' to set the 'API_KEY' declaration.",
                        ),
                      ],
                    ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 25,
                horizontal: 15,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      focusNode: _textFieldFocus,
                      decoration: textFieldDecoration,
                      controller: _textController,
                    ),
                  ),
                  const SizedBox.square(dimension: 15),
                  IconButton(
                    onPressed: !_loading ? _uploadImage : null,
                    icon: Icon(
                      Icons.image,
                      color: _loading
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  if (!_loading)
                    IconButton(
                      onPressed: _sendChatMessage,
                      icon: Icon(
                        Icons.send,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  else
                    const CircularProgressIndicator(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showError(String message) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Something went wrong'),
          content: SingleChildScrollView(
            child: SelectableText(message),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            )
          ],
        );
      },
    );
  }
}

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    required this.text,
    required this.image,
    required this.isFromUser,
    super.key,
  });

  final String? text;
  final Image? image;
  final bool isFromUser;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isFromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: isFromUser
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 250),
            child: Column(
              crossAxisAlignment:
                  isFromUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (text != null) MarkdownBody(data: text!),
                if (image != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: image!,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}