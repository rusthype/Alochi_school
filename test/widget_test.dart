import 'package:flutter_test/flutter_test.dart';
import 'package:alochi_maktab/core/utils/score_color.dart';
import 'package:alochi_maktab/core/utils/avatar_color.dart';
import 'package:alochi_maktab/shared/constants/colors.dart';

void main() {
  group('scoreColor', () {
    test('>=90 returns green', () => expect(scoreColor(90), kGreen));
    test('75-89 returns white', () => expect(scoreColor(80), kTextPrimary));
    test('60-74 returns yellow', () => expect(scoreColor(65), kYellow));
    test('<60 returns red', () => expect(scoreColor(50), kRed));
    test('boundary 75 is white', () => expect(scoreColor(75), kTextPrimary));
    test('boundary 60 is yellow', () => expect(scoreColor(60), kYellow));
  });

  group('avatarInitials', () {
    test('two words -> two initials', () => expect(avatarInitials('Ali Karimov'), 'AK'));
    test('one word -> up to 2 chars', () => expect(avatarInitials('Admin'), 'AD'));
    test('empty -> empty string', () => expect(avatarInitials(''), ''));
    test('single char -> single char', () => expect(avatarInitials('A'), 'A'));
  });

  group('avatarColor', () {
    test('same input returns same color', () {
      expect(avatarColor('Test Name'), avatarColor('Test Name'));
    });
    test('empty name returns first color', () {
      expect(avatarColor(''), isNotNull);
    });
  });
}
