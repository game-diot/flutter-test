import 'package:flutter/material.dart';
import 'widgets/add_app_bar.dart';
import 'widgets/add_title_field.dart';
import 'widgets/add_content_field.dart';
import 'widgets/add_publish_button.dart';

class AddPage extends StatelessWidget {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AddAppBar(onBackPressed: () => Navigator.pop(context)),
              const SizedBox(height: 20),
              const AddTitleField(),
              const SizedBox(height: 24),
              const Expanded(child: AddContentField()),
              AddPublishButton(
                onPressed: () {
                  // 发布功能逻辑
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
