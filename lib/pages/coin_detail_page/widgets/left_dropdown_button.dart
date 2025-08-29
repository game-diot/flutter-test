import 'package:flutter/material.dart';

class BottomSheetSelector extends StatefulWidget {
  final List<String> options;
  final String initialValue;

  const BottomSheetSelector({
    super.key,
    required this.options,
    required this.initialValue,
  });

  @override
  State<BottomSheetSelector> createState() => _BottomSheetSelectorState();
}

class _BottomSheetSelectorState extends State<BottomSheetSelector> {
  late String _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: widget.options.map((option) {
            return ListTile(
              title: Center(
                child: Text(option, style: const TextStyle(fontSize: 16)),
              ),
              onTap: () {
                setState(() => _selectedValue = option);
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showBottomSheet,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Text(_selectedValue, style: const TextStyle(fontSize: 16)),
            ),
            Positioned(right: 0, child: const Icon(Icons.arrow_drop_down)),
          ],
        ),
      ),
    );
  }
}
