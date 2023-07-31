import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Image")),
      // body: const ImageExample(),
      // body: const FadeInImageExample(),
      body: const CacheNetworkImageExample(),
    );
  }
}

class ImageExample extends StatelessWidget {
  const ImageExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.network('https://picsum.photos/250?image=9'),
    );
  }
}

class FadeInImageExample extends StatelessWidget {
  const FadeInImageExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeInImage.memoryNetwork(
        placeholder: kTransparentImage,
        image: 'https://picsum.photos/250?image=9',
      ),
    );
  }
}

class CacheNetworkImageExample extends StatelessWidget {
  const CacheNetworkImageExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CachedNetworkImage(
        placeholder: (context, url) => const CircularProgressIndicator(),
        imageUrl: 'https://picsum.photos/250?image=9',
      ),
    );
  }
}
