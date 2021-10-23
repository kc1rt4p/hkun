part of 'wallet_bloc.dart';

@immutable
abstract class WalletEvent {}

class InitializeWallet extends WalletEvent {}

class AddWalletAddress extends WalletEvent {
  final String walletAddress;

  AddWalletAddress(this.walletAddress);
}

class EnterWalletAddress extends WalletEvent {}
