import 'package:equatable/equatable.dart';

class LoyaltyCard extends Equatable{
  final int id;
  final String cardName;
  final String companyName;
  final String cardColor;
  final String cardNumber;

  const LoyaltyCard({
    required this.id,
    this.cardName = "",
    required this.companyName,
    required this.cardColor,
    required this.cardNumber,
  });

  @override

  List<Object?> get props => throw UnimplementedError();
}
