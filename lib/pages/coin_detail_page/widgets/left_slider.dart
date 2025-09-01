import 'package:flutter/material.dart';

class CustomSliderDemo extends StatelessWidget {
  final double value;
  final double max;
  final ValueChanged<double> onChanged;
  final double stepPercent; // 步进百分比，1.0表示1%，10.0表示10%

  const CustomSliderDemo({
    Key? key,
    required this.value,
    this.max = 100,
    required this.onChanged,
    this.stepPercent = 1.0, // 默认1%
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 2, // 加粗轨道
        activeTrackColor: Colors.black, // 已滑过部分为黑色
        inactiveTrackColor: const Color.fromARGB(255, 239, 236, 236), // 未滑过部分为灰色
        thumbShape: _DiamondSliderThumb(),
        overlayColor: Colors.blue.withOpacity(0.2),
        tickMarkShape: _DiamondTickMarkShape(
          max: max,
          currentValue: value,
        ),
        showValueIndicator: ShowValueIndicator.never, // 隐藏默认标签
      ),
      child: Slider(
        min: 0,
        max: max,
        divisions: 4, // 固定4个节点：0%, 25%, 50%, 75%, 100%
        value: value.clamp(0, max),
        onChanged: (val) {
          // 根据步进比例计算新值
          double step = max * stepPercent / 100;
          double newValue = (val / step).round() * step;
          onChanged(newValue.clamp(0, max));
        },
      ),
    );
  }
}

class _DiamondSliderThumb extends SliderComponentShape {
  static const double _thumbSize = 22;

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
    // 填充色
    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    // 边框色
    final borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    // 绘制菱形路径
    final path = Path()
      ..moveTo(center.dx, center.dy - _thumbSize / 2)
      ..lineTo(center.dx + _thumbSize / 2, center.dy)
      ..lineTo(center.dx, center.dy + _thumbSize / 2)
      ..lineTo(center.dx - _thumbSize / 2, center.dy)
      ..close();

    // 先绘制填充，再绘制边框
    context.canvas.drawPath(path, fillPaint);
    context.canvas.drawPath(path, borderPaint);
  }
}

class _DiamondTickMarkShape extends SliderTickMarkShape {
  static const double _size = 10;
  final double max;
  final double currentValue;

  _DiamondTickMarkShape({
    required this.max,
    required this.currentValue,
  });

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
    // 计算当前刻度对应的值
    double trackWidth = parentBox.size.width;
    double currentPosition = center.dx;
    double valueAtPosition = (currentPosition / trackWidth) * max;
    
    // 判断是否已滑过该节点
    bool passed = valueAtPosition <= currentValue;
    
    // 设置颜色：已滑过为黑色，未滑过为灰色
    Color color = passed ? Colors.black : Colors.grey[400]!;
    
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    // 绘制小菱形
    final path = Path()
      ..moveTo(center.dx, center.dy - _size / 2)
      ..lineTo(center.dx + _size / 2, center.dy)
      ..lineTo(center.dx, center.dy + _size / 2)
      ..lineTo(center.dx - _size / 2, center.dy)
      ..close();

    context.canvas.drawPath(path, paint);
    
    // 添加菱形边框
    final borderPaint = Paint()
      ..color = passed ? Colors.black : Colors.grey[500]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    context.canvas.drawPath(path, borderPaint);
  }
}