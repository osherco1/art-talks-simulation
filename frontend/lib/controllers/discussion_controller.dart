import 'package:get/get.dart';
import '../models/artwork.dart';
import '../models/message.dart';
import '../services/api_service.dart';

class DiscussionController extends GetxController {
  final RxList<Message> messages = <Message>[].obs;
  final Rxn<Artwork> selectedArtwork = Rxn<Artwork>();

  Future<void> fetchMessages(String artworkId) async {
    try {
      final list = await ApiService().getList('/api/artworks/$artworkId/messages');
      if (list != null) {
        messages.value = list
            .map((e) => Message.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        messages.clear();
      }
    } catch (_) {
      messages.clear();
    }
  }

  Future<void> sendMessage(String text) async {
    final artwork = selectedArtwork.value;
    if (artwork == null || text.trim().isEmpty) return;

    final optimisticMessage = Message(
      id: 'temp-${DateTime.now().millisecondsSinceEpoch}',
      artworkId: artwork.id,
      text: text.trim(),
      createdAt: DateTime.now(),
    );

    messages.add(optimisticMessage);

    try {
      final result = await ApiService().post(
        '/api/artworks/${artwork.id}/messages',
        {'text': text.trim()},
      );
      if (result != null) {
        final serverMessage = Message.fromJson(result);
        final index = messages.indexWhere((m) => m.id == optimisticMessage.id);
        if (index >= 0) {
          messages[index] = serverMessage;
        } else {
          messages.add(serverMessage);
        }
      } else {
        messages.remove(optimisticMessage);
      }
    } catch (_) {
      messages.remove(optimisticMessage);
    }
  }
}
