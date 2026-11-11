import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Article thumbnail shared by every article card.
///
/// * Falls back to the bundled "image not found" asset when the URL is
///   missing or fails to load (the API does not guarantee an image).
/// * Shows a neutral placeholder while loading so layouts never collapse.
/// * Always uses [BoxFit.cover] so images are cropped, never stretched.
///
/// Size it with its parent (e.g. [AspectRatio] / [SizedBox]) or pass
/// [width]/[height].
class ArticleImage extends StatelessWidget {
  static const String fallbackAsset = 'assets/images/Image-not-found.png';

  final String? imageUrl;
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;

  const ArticleImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final url = imageUrl?.trim();
    final Widget image;

    if (url == null || url.isEmpty) {
      image = _fallback();
    } else {
      image = CachedNetworkImage(
        imageUrl: url,
        width: width ?? double.infinity,
        height: height ?? double.infinity,
        fit: BoxFit.cover,
        placeholder:
            (context, _) => ColoredBox(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
        errorWidget: (_, _, _) => _fallback(),
      );
    }

    final sized = SizedBox(width: width, height: height, child: image);
    if (borderRadius == null) return sized;
    return ClipRRect(borderRadius: borderRadius!, child: sized);
  }

  Widget _fallback() {
    return Image.asset(
      fallbackAsset,
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      fit: BoxFit.cover,
    );
  }
}
