import 'dart:async';
import 'package:get/get.dart';
import '../models/artwork.dart';
import '../services/api_service.dart';

class GalleryController extends GetxController {
  final RxList<Artwork> artworks = <Artwork>[].obs;
  final RxBool isLoading = false.obs;

  Timer? _debounceTimer;

  Future<void> fetchArtworks(String query) async {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      await _doFetchArtworks(query);
    });
  }

  Future<void> _doFetchArtworks(String query) async {
    isLoading.value = true;
    try {
      final path = query.trim().isEmpty
          ? '/api/artworks'
          : '/api/artworks?q=${Uri.encodeQueryComponent(query.trim())}';
      final list = await ApiService().getList(path);
      if (list != null) {
        artworks.value = list
            .map((e) => Artwork.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        artworks.clear();
      }
    } catch (_) {
      artworks.clear();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onReady() {
    super.onReady();
    _doFetchArtworks('');
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    super.onClose();
  }
}
