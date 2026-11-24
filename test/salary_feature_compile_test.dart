import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:floosy/features/ai/presentation/screens/ai_chat_screen.dart';
import 'package:floosy/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:floosy/features/settings/presentation/screens/settings_screen.dart';

void main() {
  test('salary-aware home, settings, and local advisor screens compile', () {
    expect(const DashboardScreen(), isA<Widget>());
    expect(const SettingsScreen(), isA<Widget>());
    expect(const AIChatScreen(), isA<Widget>());
  });
}
