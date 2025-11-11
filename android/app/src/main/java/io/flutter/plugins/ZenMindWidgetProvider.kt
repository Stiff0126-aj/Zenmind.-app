package com.example.zenmind_app

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews

class ZenMindWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.zenmind_widget)
            views.setTextViewText(R.id.widget_text, "¡Respira con ZenMind!")
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
