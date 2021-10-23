part of 'wallet_bloc.dart';

@immutable
abstract class WalletState {}

class WalletInitial extends WalletState {}

class InitializeWalletDone extends WalletState {
  final num hkunBalance;
  final MarketDataModel hkunInfo;

  InitializeWalletDone(this.hkunBalance, this.hkunInfo);
}

class WalletError extends WalletState {
  final String message;

  WalletError(this.message);
}

class PromptWalletAddress extends WalletState {}

class WalletLoading extends WalletState {}
