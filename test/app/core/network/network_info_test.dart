import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:resocoder_tdd_clean_arch/app/core/network/i_network_info.dart';

class MockConnectivityConnection extends Mock implements Connectivity {}

void main() {
  late NetworkInfo networkInfo;
  late MockConnectivityConnection mockConnectivityConnection;

  setUp(() {
    mockConnectivityConnection = MockConnectivityConnection();
    networkInfo = NetworkInfo(mockConnectivityConnection);
  });
  tearDown(() {
    mockConnectivityConnection;
    networkInfo;
  });

  group('isConnected |', () {
    test(
        'should forward the call to mockConnectivityConnection.checkConnectivity',
        () async {
      // arrange
      const tHasConnectionFuture = ConnectivityResult.ethernet;
      when(() => mockConnectivityConnection.checkConnectivity())
          .thenAnswer((_) async => tHasConnectionFuture);
      // act
      final result = await networkInfo.isConnected;
      // assert
      verify(() => mockConnectivityConnection.checkConnectivity()).called(1);
      expect(result, true);
    });
  });
}
