import 'package:flutter/material.dart';
import '../model/movie.dart';

class HoverMovieCard extends StatefulWidget {
  final Movie movie;
  final VoidCallback onTap;
  final Widget child;

  const HoverMovieCard({
    Key? key,
    required this.movie,
    required this.onTap,
    required this.child,
  }) : super(key: key);

  @override
  State<HoverMovieCard> createState() => _HoverMovieCardState();
}

class _HoverMovieCardState extends State<HoverMovieCard>
    with SingleTickerProviderStateMixin {
  bool isHovered = false;
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  void _onHoverChanged(bool hovered) {
    setState(() {
      isHovered = hovered;
    });
    if (hovered) {
      _shimmerController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHoverChanged(true),
      onExit: (_) => _onHoverChanged(false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => _onHoverChanged(true),
        onTapUp: (_) => _onHoverChanged(false),
        onTapCancel: () => _onHoverChanged(false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          transform: isHovered
              ? (Matrix4.identity()..scale(1.05)..translate(0.0, -8.0, 0.0))
              : Matrix4.identity(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isHovered
                  ? const Color(0xFFFFD700)
                  : Colors.transparent,
              width: 2,
            ),
            boxShadow: isHovered
                ? [
                    BoxShadow(
                      color: const Color(0xFFE52521).withOpacity(0.9),
                      blurRadius: 25,
                      spreadRadius: 4,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: const Color(0xFFFF8C00).withOpacity(0.6),
                      blurRadius: 35,
                      spreadRadius: 8,
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      blurRadius: 15,
                      spreadRadius: 1,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: const Offset(0, 5),
                    ),
                  ],
          ),
          child: Stack(
            children: [
              widget.child,
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _shimmerController,
                  builder: (context, child) {
                    if (_shimmerController.value == 0 ||
                        _shimmerController.value == 1) {
                      return const SizedBox.shrink();
                    }
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: FractionalTranslation(
                        translation: Offset(
                          (_shimmerController.value * 3) - 1.5,
                          0,
                        ),
                        child: Transform.rotate(
                          angle: 0.5,
                          child: Container(
                            width: 80,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.0),
                                  Colors.white.withOpacity(0.4),
                                  Colors.white.withOpacity(0.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}