import 'package:equatable/equatable.dart';

class LoyaltyCard extends Equatable {
  final String id;
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

  static LoyaltyCard fromJson(Map<String, dynamic> json) => LoyaltyCard(
        id: json['id'],
        cardName: json['cardName'],
        companyName: json['companyName'],
        cardFormat: json['cardFormat'],
        cardColor: json['cardColor'],
        cardNumber: json['cardNumber'],
        isSync: json['isSync'],
      );

  @override
  List<Object?> get props => throw UnimplementedError();
}
