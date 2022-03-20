import 'package:bloc/bloc.dart';
import 'package:cards_app/data/dataproviders/loyalty_cards_repository.dart';
import 'package:cards_app/data/models/loyalty_card_model.dart';
import 'package:equatable/equatable.dart';

part 'loyalty_card_state.dart';

class LoyaltyCardCubit extends Cubit<LoyaltyCardState> {
  final LoyaltyCardsRepository loyaltyCardsRepository;

  LoyaltyCardCubit(this.loyaltyCardsRepository) : super(LoyaltyCardInitial());
}
