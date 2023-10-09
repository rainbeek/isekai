import 'package:live_bresto/data/model/profile.dart';
import 'package:test/test.dart';

void main() {
  test('有効期限が現在時刻よりも先の場合、有効となる', () {
    final current = DateTime.now();
    final profile = Profile(
      icon: '☺️',
      name: 'Test User',
      validUntil: current.add(const Duration(seconds: 1)),
    );

    expect(profile.isValid(current: current), true);
  });

  test('有効期限が現在時刻と一致する場合、無効となる', () {
    final current = DateTime.now();
    final profile2 = Profile(
      icon: '☺️',
      name: 'Test User',
      validUntil: current,
    );

    expect(profile2.isValid(current: current), false);
  });

  test('有効期限が現在時刻よりも前の場合、無効となる', () {
    final current = DateTime.now();
    final profile = Profile(
      icon: '☺️',
      name: 'Test User',
      validUntil: current.subtract(const Duration(seconds: 1)),
    );

    expect(profile.isValid(current: current), false);
  });
}
