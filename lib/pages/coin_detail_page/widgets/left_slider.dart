import 'package:flutter/material.dart';

class CustomSliderDemo extends StatelessWidget {
  final double value;
  final double max;
  final ValueChanged<double> onChanged;

  const CustomSliderDemo({
    Key? key,
    required this.value,
    this.max = 100,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 2,
        activeTrackColor: Colors.black,
        inactiveTrackColor: Colors.grey,
        thumbShape: _DiamondSliderThumb(),
        overlayColor: Colors.blue.withOpacity(0.2),
        tickMarkShape: _DiamondTickMarkShape(
          specialValues: [
            0.25 * max,
            0.50 * max,
            0.75 * max,
            0.25 * max * 0, // 0%
            max, // 100%
          ],
        ),
      ),
      child: Slider(
        min: 0,
        max: max,
        divisions: (max ~/ (max / 100)), // 每1%步长
        value: value.clamp(0, max),
        label: value.round().toString(),
        onChanged: (val) {
          double step = max / 100;
          double newValue = (val / step).round() * step;
          onChanged(newValue.clamp(0, max));
        },
      ),
    );
  }
}

class _DiamondSliderThumb extends SliderComponentShape {
  static const double _thumbSize = 20;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      const Size(_thumbSize, _thumbSize);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter? labelPainter,
    required RenderBox? parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final fillPaint = Paint()..color = Colors.white..style = PaintingStyle.fill;
    final borderPaint = Paint()..color = Colors.black..style = PaintingStyle.stroke..strokeWidth = 2;

    final path = Path()
      ..moveTo(center.dx, center.dy - _thumbSize / 2)
      ..lineTo(center.dx + _thumbSize / 2, center.dy)
      ..lineTo(center.dx, center.dy + _thumbSize / 2)
      ..lineTo(center.dx - _thumbSize / 2, center.dy)
      ..close();

    context.canvas.drawPath(path, fillPaint);
    context.canvas.drawPath(path, borderPaint);
  }
}

class _DiamondTickMarkShape extends SliderTickMarkShape {
  static const double _size = 8;
  final List<double> specialValues;

  _DiamondTickMarkShape({this.specialValues = const []});

  @override
  Size getPreferredSize({required bool isEnabled, required SliderThemeData sliderTheme}) =>
      const Size(_size, _size);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required bool isEnabled,
    required TextDirection textDirection,
    required Offset thumbCenter,
  }) {
    // 判断是否已滑过
    bool passed = center.dx <= thumbCenter.dx;
    double drawSize = _size.toDouble();
    Color color = passed ? Colors.black : Colors.grey;

    // 处理特殊节点
    if (specialValues.isNotEmpty) {
      double fraction = center.dx / parentBox.size.width;
      for (var val in specialValues) {
        double specialFraction = val / sliderTheme.trackHeight!;
        if ((fraction - specialFraction).abs() < 0.05) { // 接近特殊节点
          drawSize = _size + 4;
          color = Colors.blue;
        }
      }
    }

    final paint = Paint()..color = color..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(center.dx, center.dy - drawSize / 2)
      ..lineTo(center.dx + drawSize / 2, center.dy)
      ..lineTo(center.dx, center.dy + drawSize / 2)
      ..lineTo(center.dx - drawSize / 2, center.dy)
      ..close();

    context.canvas.drawPath(path, paint);
  }
}
