import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/gallery_controller.dart';
import 'controllers/discussion_controller.dart';
import 'screens/gallery_screen.dart';
import 'screens/discussion_screen.dart';

void main() {
  Get.put(GalleryController());
  Get.put(DiscussionController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Art Talks',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const GalleryScreen()),
        GetPage(name: '/discussion', page: () => const DiscussionScreen()),
      ],
    );
  }
}
