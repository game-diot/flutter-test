import 'dart:convert';
import 'dart:io';
import '../../network/Get/models/home_page/home_data_section.dart';

typedef OnDataReceived = void Function(List<SymbolItem> data);

class SymbolWebSocketService {
  final String url;
  WebSocket? _socket;
  final OnDataReceived onData;

  SymbolWebSocketService({required this.url, required this.onData});

  void connect() async {
    try {
      _socket = await WebSocket.connect(url);
      _socket!.listen(
        (message) {
          final decoded = json.decode(message) as List;
          final dataList = decoded.map((e) => SymbolItem.fromJson(e)).toList();
          onData(dataList);
        },
        onError: (error) => print('WebSocket error: $error'),
        onDone: () => print('WebSocket closed'),
      );
    } catch (e) {
      print('WebSocket connect error: $e');
    }
  }

  void disconnect() {
    _socket?.close();
  }
}
