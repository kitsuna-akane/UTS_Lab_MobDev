import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF1C1C2E),
      highlightColor: const Color(0xFF2E2E4A),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFF1C1C2E),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster placeholder
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF2A2A3E),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
              ),
            ),
            // Text placeholders
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 12, color: const Color(0xFF2A2A3E)),
                  const SizedBox(height: 6),
                  Container(
                    height: 10,
                    width: 80,
                    color: const Color(0xFF2A2A3E),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Convenience grid of shimmer cards — call anywhere loading is needed
class ShimmerGrid extends StatelessWidget {
  final int count;

  const ShimmerGrid({super.key, this.count = 8});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: count,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (_, __) => const ShimmerCard(),
    );
  }
}