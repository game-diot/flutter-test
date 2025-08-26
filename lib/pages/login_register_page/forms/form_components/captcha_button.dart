import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../network/Get/services/splash_page/register_send_verification_code.dart';

class CaptchaButton extends StatefulWidget {
  final TextEditingController controller;
  final String phoneSuffix;

  const CaptchaButton({required this.controller, required this.phoneSuffix, Key? key}) : super(key: key);

  @override
  State<CaptchaButton> createState() => _CaptchaButtonState();
}

class _CaptchaButtonState extends State<CaptchaButton> {
  int _countdown = 0;
  Timer? _timer;
  bool _isSending = false;

  void _startCountdown() {
    setState(() {
      _countdown = 30;
      _isSending = true;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _countdown--;
        if (_countdown == 0) {
          _timer?.cancel();
          _isSending = false;
        }
      });
    });
  }

  void _sendCaptcha() async {
    final phone = widget.controller.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('请输入手机号')));
      return;
    }

    try {
      final response = await RegisterSendVerificationCodeService.sendCaptcha(
        to: phone,
        type: '1',
        sendType: '1',
        areaCode: widget.phoneSuffix.replaceAll("+", ""),
      );

      if (response != null && response.code == 0) {
        _startCountdown();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('验证码发送成功')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response?.msg ?? '发送失败')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('网络请求失败：$e')));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: _isSending ? null : _sendCaptcha,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isSending ? Colors.grey : Color(0xFFedb023),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(_isSending ? '$_countdown 秒' : '发送验证码'),
      ),
    );
  }
}
