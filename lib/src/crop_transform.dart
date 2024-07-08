import 'package:flutter/material.dart';

class CropTransform extends StatelessWidget {
  const CropTransform({
    super.key,
    required this.ratio,
    required this.scale,
    required this.view,
    required this.childSize,
    required this.getRect,
    required this.child,
  });

  final Rect view;
  final double ratio, scale;
  final Size childSize;

  final Rect Function(Size size) getRect;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (childSize == Size.zero) return const SizedBox.shrink();

    return LayoutBuilder(builder: (_, constraints) {
      final size = constraints.biggest;
      final rect = getRect(size);

      final src = Offset.zero & childSize;
      final dst = Rect.fromLTWH(
        view.left * childSize.width * scale * ratio,
        view.top * childSize.height * scale * ratio,
        childSize.width * scale * ratio,
        childSize.height * scale * ratio,
      );

      print(
          '---------------------------------------------------------------------');

      final double translateX = dst.left;
      final double translateY = dst.top;

      print('LAYOUT BUILDER 1 = translateX=$translateX translateY=$translateY');
      print(
          'LAYOUT BUILDER 2 = rect=$rect src=$src dst=$dst scale=$scale ratio=$ratio');

      return Transform.translate(
        offset: Offset(rect.left, rect.top),
        child: ClipRect(
          // clip grid
          clipper: CropClipper(rect),
          child: Transform.translate(
            offset: Offset(translateX, translateY),
            child: Transform.scale(
              scale: scale,
              alignment: Alignment.topLeft,
              child: FittedBox(
                fit: BoxFit.cover,
                alignment: Alignment.topLeft,
                child: child,
              ),
            ),
          ),
          // ),
        ),
      );
    });
  }
}

class CropClipper extends CustomClipper<Rect> {
  const CropClipper(this.rect);

  final Rect rect;

  @override
  Rect getClip(Size size) => Rect.fromLTWH(0.0, 0.0, rect.width, rect.height);

  @override
  bool shouldReclip(covariant CropClipper oldClipper) => false;
}
