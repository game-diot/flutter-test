import 'package:flutter/material.dart';
import '../models/symbol_item.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class SymbolCarousel extends StatelessWidget {
  final List<SymbolItem> coinList;

  const SymbolCarousel({Key? key, required this.coinList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLight = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light;

    if (coinList.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isLight
                ? Color.fromRGBO(134, 144, 156, 0.4)
                : Colors.grey.withOpacity(0.4),
            width: 0.4,
          ),
        ),
      ),
      height: 150,
      width: double.infinity,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.85),
        itemCount: coinList.length,
        itemBuilder: (context, index) {
          final item = coinList[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: _buildCard(context, item, isLight),
          );
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context, SymbolItem item, bool isLight) {
    final price = item.miniKlinePriceList.isNotEmpty
        ? item.miniKlinePriceList[0]
        : 0.0;
    final change = item.miniKlinePriceList.length > 1
        ? item.miniKlinePriceList[1]
        : 0.0;
    final lineData = item.miniKlinePriceList.take(10).toList();

    return Container(
      decoration: BoxDecoration(
        color: isLight ? Colors.white : Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isLight
                ? Colors.black.withOpacity(0.05)
                : Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.alias,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isLight ? Colors.black : Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            '价格：¥${price.toStringAsFixed(2)}',
            style: TextStyle(color: isLight ? Colors.black : Colors.white),
          ),
          Text(
            '涨幅：${change.toStringAsFixed(2)}%',
            style: TextStyle(color: change >= 0 ? Colors.green : Colors.red),
          ),
          SizedBox(height: 8),
          Expanded(
            child: CustomPaint(
              painter: LineChartPainter(lineData, isLight),
              size: Size(double.infinity, 60),
            ),
          ),
        ],
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  final List<double> data;
  final bool isLight;

  LineChartPainter(this.data, this.isLight);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isLight ? Colors.orange : Colors.yellowAccent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();

    if (data.isEmpty) return;

    double minY = data.reduce((a, b) => a < b ? a : b);
    double maxY = data.reduce((a, b) => a > b ? a : b);
    double rangeY = maxY - minY == 0 ? 1 : maxY - minY;

    final stepX = size.width / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      double x = i * stepX;
      double y = size.height - ((data[i] - minY) / rangeY) * size.height;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
