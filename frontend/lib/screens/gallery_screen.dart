import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/gallery_controller.dart';
import '../controllers/discussion_controller.dart';
import '../models/artwork.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final galleryController = Get.find<GalleryController>();
    final discussionController = Get.find<DiscussionController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Art Talks'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search artworks or artists...',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _searchController.clear();
                    galleryController.fetchArtworks('');
                  },
                ),
              ),
              onChanged: galleryController.fetchArtworks,
            ),
          ),
          Expanded(
            child: Obx(() {
              if (galleryController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              final artworks = galleryController.artworks;
              if (artworks.isEmpty) {
                return const Center(child: Text('No artworks found'));
              }
              return _buildArtworkGrid(context, artworks, discussionController);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildArtworkGrid(
    BuildContext context,
    List<Artwork> artworks,
    DiscussionController discussionController,
  ) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 600 ? 3 : 2;

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: artworks.length,
      itemBuilder: (context, index) {
        final artwork = artworks[index];
        return _ArtworkCard(
          artwork: artwork,
          onTap: () {
            discussionController.selectedArtwork.value = artwork;
            discussionController.fetchMessages(artwork.id);
            Get.toNamed('/discussion');
          },
        );
      },
    );
  }
}

class _ArtworkCard extends StatelessWidget {
  final Artwork artwork;
  final VoidCallback onTap;

  const _ArtworkCard({required this.artwork, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Image.network(
                artwork.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.broken_image, size: 48),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      artwork.pictureName,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      artwork.artist,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Expanded(
                      child: Text(
                        artwork.description,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
