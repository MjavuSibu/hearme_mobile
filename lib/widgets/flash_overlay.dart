import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FlashOverlay extends StatefulWidget {
  const FlashOverlay({
    required this.active,
    required this.soundName,
    required this.child,
    super.key,
  });

  final bool active;
  final String? soundName;
  final Widget child;

  @override
  State<FlashOverlay> createState() => _FlashOverlayState();
}

class _FlashOverlayState extends State<FlashOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  @override
  void didUpdateWidget(FlashOverlay old) {
    super.didUpdateWidget(old);
    if (widget.active && !old.active) {
      _controller.forward(from: 0);
    } else if (!widget.active && old.active) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _flashColor(String? sound) {
    final theme = sound != null ? SoundTheme.of(sound) : null;
    return (theme?.fg ?? AppColors.accent).withOpacity(0.15);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        FadeTransition(
          opacity: _opacity,
          child: IgnorePointer(
            child: Container(
              color: _flashColor(widget.soundName),
            ),
          ),
        ),
      ],
    );
  }
}