import 'package:core/core.dart';
import 'package:test/test.dart';

void main() {
  group('Result', () {
    test('Ok holds value', () {
      const result = Ok<int, String>(42);
      expect(result.value, 42);
    });

    test('Err holds error', () {
      const result = Err<int, String>('oops');
      expect(result.error, 'oops');
    });

    test('map transforms Ok value', () {
      const result = Ok<int, String>(2);
      final mapped = result.map((v) => v * 3);
      expect(mapped, isA<Ok<int, String>>());
      expect((mapped as Ok<int, String>).value, 6);
    });

    test('map passes through Err unchanged', () {
      const result = Err<int, String>('fail');
      final mapped = result.map((v) => v * 3);
      expect(mapped, isA<Err<int, String>>());
    });

    test('flatMap chains Ok', () {
      const result = Ok<int, String>(10);
      final chained = result.flatMap((v) => Ok<String, String>(v.toString()));
      expect((chained as Ok<String, String>).value, '10');
    });

    test('flatMap short-circuits on Err', () {
      const result = Err<int, String>('err');
      var called = false;
      result.flatMap((v) {
        called = true;
        return Ok<int, String>(v);
      });
      expect(called, isFalse);
    });

    test('isOk / isErr helpers', () {
      expect(const Ok<int, String>(1).isOk, isTrue);
      expect(const Ok<int, String>(1).isErr, isFalse);
      expect(const Err<int, String>('x').isOk, isFalse);
      expect(const Err<int, String>('x').isErr, isTrue);
    });
  });
}
