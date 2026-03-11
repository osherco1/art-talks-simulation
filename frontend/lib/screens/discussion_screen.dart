import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/discussion_controller.dart';
import '../models/artwork.dart';
import '../models/message.dart';

class DiscussionScreen extends StatefulWidget {
  const DiscussionScreen({super.key});

  @override
  State<DiscussionScreen> createState() => _DiscussionScreenState();
}

class _DiscussionScreenState extends State<DiscussionScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final discussionController = Get.find<DiscussionController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discussion'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        final artwork = discussionController.selectedArtwork.value;
        if (artwork == null) {
          return const Center(child: Text('No artwork selected'));
        }
        return LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;
            if (isWide) {
              return Row(
                children: [
                  Expanded(
                    flex: 60,
                    child: _ArtworkDetails(artwork: artwork),
                  ),
                  Expanded(
                    flex: 40,
                    child: _ChatInterface(
                      controller: discussionController,
                      textController: _textController,
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  SizedBox(
                    height: 280,
                    child: _ArtworkDetails(artwork: artwork),
                  ),
                  Expanded(
                    child: _ChatInterface(
                      controller: discussionController,
                      textController: _textController,
                    ),
                  ),
                ],
              );
            }
          },
        );
      }),
    );
  }
}

class _ArtworkDetails extends StatelessWidget {
  final Artwork artwork;

  const _ArtworkDetails({required this.artwork});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: Image.network(
                artwork.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.broken_image, size: 48),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            artwork.pictureName,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            artwork.artist,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            artwork.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _ChatInterface extends StatelessWidget {
  final DiscussionController controller;
  final TextEditingController textController;

  const _ChatInterface({
    required this.controller,
    required this.textController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Obx(() {
            final messages = controller.messages;
            if (messages.isEmpty) {
              return const Center(child: Text('No messages yet'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return _MessageBubble(message: msg);
              },
            );
          }),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _sendMessage() {
    final text = textController.text;
    if (text.trim().isEmpty) return;
    controller.sendMessage(text);
    textController.clear();
  }
}

class _MessageBubble extends StatelessWidget {
  final Message message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message.text),
              Text(
                _formatTime(message.createdAt),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
