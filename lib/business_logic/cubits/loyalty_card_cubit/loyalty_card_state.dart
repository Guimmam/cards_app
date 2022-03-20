part of 'loyalty_card_cubit.dart';

abstract class LoyaltyCardState extends Equatable {
  const LoyaltyCardState();

  @override
  List<Object> get props => [];
}

class LoyaltyCardInitial extends LoyaltyCardState {
  const LoyaltyCardInitial();
}

class LoyaltyCardLoading extends LoyaltyCardState {
  const LoyaltyCardLoading();
}

class LoyaltyCardLoaded extends LoyaltyCardState {
  final LoyaltyCard loyaltyCard;
  const LoyaltyCardLoaded(this.loyaltyCard);
}
