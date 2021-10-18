import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

abstract class INetworkInfo extends Equatable {
  Future<bool> get isConnected;
}

class NetworkInfo implements INetworkInfo {
  final Connectivity connectionChecker;

  NetworkInfo(this.connectionChecker);
  @override
  Future<bool> get isConnected async {
    final ConnectivityResult connectivityResult =
        await connectionChecker.checkConnectivity();
    return connectivityResult == ConnectivityResult.none ? false : true;
  }

  @override
  List<Object?> get props => [connectionChecker];

  @override
  bool? get stringify => throw UnimplementedError();
}
