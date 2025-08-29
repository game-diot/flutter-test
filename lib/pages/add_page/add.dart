import 'package:flutter/material.dart';
import '../../localization/lang.dart'; // 假设你有语言包工具

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
              // 顶部导航栏
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        Lang.t('publish'), // 多语言
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 20),

              // 标题输入框
              TextField(
                maxLength: 30,
                decoration: InputDecoration(
                  hintText: Lang.t('enter_post_title'), // 多语言
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(241, 245, 249, 0.1),
                      width: 0.1,
                    ),
                  ),
                  counterText: '',
                ),
              ),
              const SizedBox(height: 24),

              // 正文输入框
              const Expanded(
                child: TextField(
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: '请输入内容（选填）', // 这里也可以改成 Lang.t(...)
                    border: InputBorder.none,
                  ),
                ),
              ),

              // 发布按钮
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // 发布功能逻辑
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFedb023),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    Lang.t('publish'), // 多语言
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(41, 46, 56, 1),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
