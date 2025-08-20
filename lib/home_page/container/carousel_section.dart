import 'package:flutter/material.dart';
import '../models/symbol_item.dart';

class SymbolCarousel extends StatelessWidget {
  final List<SymbolItem> coinList;

  const SymbolCarousel({Key? key, required this.coinList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (coinList.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color.fromRGBO(134, 144, 156, 0.4), // 上边框颜色
            width: 0.4, // 上边框宽度
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
            child: _buildCard(context, item),
          );
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context, SymbolItem item) {
    final price = item.miniKlinePriceList.isNotEmpty
        ? item.miniKlinePriceList[0]
        : 0.0;
    final change = item.miniKlinePriceList.length > 1
        ? item.miniKlinePriceList[1]
        : 0.0;
    final lineData = item.miniKlinePriceList.take(10).toList(); // 只取前10个价格画图

    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text('价格：¥${price.toStringAsFixed(2)}'),
          Text('涨幅：${change.toStringAsFixed(2)}%'),
          SizedBox(height: 8),
          Expanded(
            child: CustomPaint(
              painter: LineChartPainter(lineData),
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

  LineChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange
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
