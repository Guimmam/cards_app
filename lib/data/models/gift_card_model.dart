// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:ffi';

class GiftCard {
  final String id;
  final String number;
  final double balance;
  final String link;
  GiftCard({
    required this.id,
    required this.number,
    required this.balance,
    this.link = "",
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'number': number,
      'balance': balance,
      'link': link,
    };
  }

  factory GiftCard.fromMap(Map<String, dynamic> map) {
    return GiftCard(
      id: map['id'] as String,
      number: map['number'] as String,
      balance: map['balance'] as double,
      link: map['link'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory GiftCard.fromJson(String source) =>
      GiftCard.fromMap(json.decode(source) as Map<String, dynamic>);
}
