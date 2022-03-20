import 'package:flutter/material.dart';

import '../models/loyalty_card_model.dart';

abstract class LoyaltyCardsRepository {
  Future<void> addNewLoyaltyCard(LoyaltyCard loyaltyCard) async {}
  Future<void> updateLoyaltyCard(int id, LoyaltyCard loyaltyCard) async {}
  Future<void> removeLoyaltyCard(int id) async {}
}
