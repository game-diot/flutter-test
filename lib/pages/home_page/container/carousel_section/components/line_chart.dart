// ==========================================
// lib/home_page/symbol_carousel/components/line_chart_enhanced.dart
// ==========================================

import 'package:flutter/material.dart';

class LineChartEnhancedPainter extends CustomPainter {
  final List<double> data;
  final bool isLight;
  final Color trendColor;

  LineChartEnhancedPainter(this.data, this.isLight, this.trendColor);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    double minY = data.reduce((a, b) => a < b ? a : b);
    double maxY = data.reduce((a, b) => a > b ? a : b);
    double rangeY = maxY - minY == 0 ? 1 : maxY - minY;

    final stepX = data.length > 1 ? size.width / (data.length - 1) : 0;

    // 构造路径
    final path = Path();
    final points = <Offset>[];
    
    for (int i = 0; i < data.length; i++) {
      double x = (i * stepX).toDouble();
      double y = size.height - ((data[i] - minY) / rangeY) * size.height;
      points.add(Offset(x, y));
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // 绘制渐变阴影
    final shadowPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        trendColor.withOpacity(0.3),
        trendColor.withOpacity(0.05),
      ],
    );

    final shadowPaint = Paint()
      ..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(shadowPath, shadowPaint);

    // 绘制主线条
    final linePaint = Paint()
      ..color = trendColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, linePaint);

    // 绘制数据点（只在数据点较少时显示）
    if (data.length <= 10) {
      final pointPaint = Paint()
        ..color = trendColor
        ..style = PaintingStyle.fill;

      for (final point in points) {
        canvas.drawCircle(point, 3, pointPaint);
      }
    }

    // 绘制最后一个数据点（突出显示）
    if (points.isNotEmpty) {
      final lastPointPaint = Paint()
        ..color = trendColor
        ..style = PaintingStyle.fill;
      
      final lastPointOutlinePaint = Paint()
        ..color = isLight ? Colors.white : Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawCircle(points.last, 4, lastPointPaint);
      canvas.drawCircle(points.last, 4, lastPointOutlinePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}