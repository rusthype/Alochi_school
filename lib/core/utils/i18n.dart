import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLocalizations extends ChangeNotifier {
  String _lang = 'uz';
  String get lang => _lang;

  static final AppLocalizations instance = AppLocalizations._();
  AppLocalizations._();

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _lang = prefs.getString('app_lang') ?? 'uz';
    notifyListeners();
  }

  Future<void> setLang(String lang) async {
    _lang = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_lang', lang);
    notifyListeners();
  }

  String get(String key) => _translations[_lang]?[key] ?? _translations['uz']![key] ?? key;

  static const _translations = {
    'uz': {
      'app_name': "A'lochi Maktab",
      'login': 'Kirish',
      'logging_in': 'Kirish...',
      'username': 'Foydalanuvchi nomi',
      'password': 'Parol',
      'admin_panel': 'Boshqaruv tizimi',
      'dashboard': 'Boshqaruv paneli',
      'classes': 'Sinflar',
      'students': "O'quvchilar",
      'teachers': "O'qituvchilar",
      'org': 'ORG Struktura',
      'schedule': 'Dars Jadvali',
      'attendance': 'Davomat',
      'bsb': 'BSB / ChSB',
      'ai': 'AI Tahlil',
      'tasks': 'Topshiriqlar',
      'messages': 'Xabarlar',
      'settings': 'Sozlamalar',
      'total_students': "Jami o'quvchilar",
      'total_teachers': "Jami o'qituvchilar",
      'avg_score': "O'rtacha baho",
      'attendance_rate': 'Davomat',
      'save': 'Saqlash',
      'cancel': 'Bekor qilish',
      'delete': "O'chirish",
      'search': 'Qidirish',
      'loading': 'Yuklanmoqda...',
      'no_data': "Ma'lumot topilmadi",
      'role_readonly': "Lavozim (o'zgartirib bo'lmaydi)",
      'school_rating': 'Maktab reytingi',
      'new_employees': 'Hodim olish',
      'inventory': 'Inventarizatsiya',
      'dynamics': 'Dinamika',
      'reports': 'Hisobotlar',
      'announcements': 'Yangiliklar',
    },
    'ru': {
      'app_name': "A'lochi Maktab",
      'login': 'Войти',
      'logging_in': 'Вход...',
      'username': 'Имя пользователя',
      'password': 'Пароль',
      'admin_panel': 'Система управления',
      'dashboard': 'Панель управления',
      'classes': 'Классы',
      'students': 'Ученики',
      'teachers': 'Учителя',
      'org': 'ORG Структура',
      'schedule': 'Расписание',
      'attendance': 'Посещаемость',
      'bsb': 'ИКУ / СрБ',
      'ai': 'AI Анализ',
      'tasks': 'Задания',
      'messages': 'Сообщения',
      'settings': 'Настройки',
      'total_students': 'Всего учеников',
      'total_teachers': 'Всего учителей',
      'avg_score': 'Средний балл',
      'attendance_rate': 'Посещаемость',
      'save': 'Сохранить',
      'cancel': 'Отмена',
      'delete': 'Удалить',
      'search': 'Поиск',
      'loading': 'Загрузка...',
      'no_data': 'Данные не найдены',
      'role_readonly': 'Роль (нельзя изменить)',
      'school_rating': 'Рейтинг школы',
      'new_employees': 'Найм сотрудников',
      'inventory': 'Инвентаризация',
      'dynamics': 'Динамика',
      'reports': 'Отчёты',
      'announcements': 'Новости',
    },
    'en': {
      'app_name': "A'lochi Maktab",
      'login': 'Sign In',
      'logging_in': 'Signing in...',
      'username': 'Username',
      'password': 'Password',
      'admin_panel': 'Management System',
      'dashboard': 'Dashboard',
      'classes': 'Classes',
      'students': 'Students',
      'teachers': 'Teachers',
      'org': 'ORG Structure',
      'schedule': 'Schedule',
      'attendance': 'Attendance',
      'bsb': 'BSB / ChSB',
      'ai': 'AI Analysis',
      'tasks': 'Tasks',
      'messages': 'Messages',
      'settings': 'Settings',
      'total_students': 'Total Students',
      'total_teachers': 'Total Teachers',
      'avg_score': 'Average Score',
      'attendance_rate': 'Attendance',
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'search': 'Search',
      'loading': 'Loading...',
      'no_data': 'No data found',
      'role_readonly': 'Role (read-only)',
      'school_rating': 'School Rating',
      'new_employees': 'Hire Employees',
      'inventory': 'Inventory',
      'dynamics': 'Dynamics',
      'reports': 'Reports',
      'announcements': 'News',
    },
  };
}
