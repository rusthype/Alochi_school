import 'dart:io';
import 'package:flutter/foundation.dart';

bool get isDesktop =>
    !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);

bool get isMobile =>
    !kIsWeb && (Platform.isAndroid || Platform.isIOS);

bool get isWeb => kIsWeb;
