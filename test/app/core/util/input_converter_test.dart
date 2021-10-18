import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resocoder_tdd_clean_arch/app/core/util/input_converter.dart';

void main() {
  late InputConverter inputConverter;
  setUp(() {
    inputConverter = InputConverter();
  });
  tearDown(() {
    inputConverter;
  });

  group('stringToUnsignedInt |', () {
    test('should an integer when the string represents an unsigned integer',
        () async {
      // arrange
      const String str = '123';
      // act
      final result = inputConverter.stringToUnsignedInteger(str);
      // assert
      expect(result, const Right(123));
    });
    test('should return a Failure when the string is no an integer', () async {
      // arrange
      const String str = 'abc';
      // act
      final result = inputConverter.stringToUnsignedInteger(str);
      // assert
      expect(result, Left(InvalidInputFailure()));
    });
    test('should return a Failure when the string is a negative integer',
        () async {
      // arrange
      const String str = '-123';
      // act
      final result = inputConverter.stringToUnsignedInteger(str);
      // assert
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
