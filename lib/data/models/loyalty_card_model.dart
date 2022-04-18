import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class LoyaltyCard extends Equatable {
  final int id;
  final String cardName;
  final String companyName;
  final int cardColor;
  final String cardNumber;
  final String cardFormat;
  final bool isSync;

  const LoyaltyCard({
    required this.id,
    this.isSync = false,
    this.cardName = "",
    this.cardFormat = "code128",
    required this.companyName,
    required this.cardColor,
    required this.cardNumber,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'cardName': cardName,
        'companyName': companyName,
        'cardColor': cardColor,
        'cardNumber': cardNumber,
        'cardFormat': cardFormat,
        'isSync': isSync,
      };

  @override
  List<Object?> get props => throw UnimplementedError();
}
