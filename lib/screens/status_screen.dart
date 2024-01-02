import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key, required this.imageUrl});
  final String imageUrl;

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CachedNetworkImage(
        imageUrl: widget.imageUrl,
        progressIndicatorBuilder: (context, url, progress) {
          return Container(
            decoration: const BoxDecoration(color: Colors.black),
            height: double.infinity,
            width: double.infinity,
            child: Center(
              child: CircularProgressIndicator(
                value: progress.progress,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          );
        },
        imageBuilder: (context, imageProvider) {
          return Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: imageProvider,
              ),
            ),
          );
        },
      ),
    );
  }
}
