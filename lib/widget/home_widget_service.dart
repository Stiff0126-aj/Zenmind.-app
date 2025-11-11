import 'package:home_widget/home_widget.dart';

class HomeWidgetService {
  static const _widgetName = 'ZenMindWidgetProvider';
  static const _widgetAndroidName = 'ZenMindWidgetProvider';

  static Future<void> updateWidget(String message) async {
    await HomeWidget.saveWidgetData<String>('zenmind_message', message);
    await HomeWidget.updateWidget(
      name: _widgetName,
      iOSName: _widgetAndroidName,
    );
  }

  static Future<String?> getMessage() async {
    return await HomeWidget.getWidgetData<String>('zenmind_message');
  }
}
