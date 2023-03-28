import 'package:cloud_firestore/cloud_firestore.dart';

class TrafficValues{
  final num? fatGreen;
  final num? fatAmber;
  final num? satFatGreen;
  final num? satFatAmber;
  final num? sugarGreen;
  final num? sugarAmber;
  final num? saltGreen;
  final num? saltAmber;

  TrafficValues({
    this.fatGreen = 3.0,
    this.fatAmber = 17.5,
    this.satFatGreen = 1.5,
    this.satFatAmber = 5.0,
    this.sugarGreen = 5.0,
    this.sugarAmber = 22.5,
    this.saltGreen = 0.3,
    this.saltAmber = 1.5,
  });

  factory TrafficValues.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return TrafficValues(
      fatGreen: data?['fatGreen'],
      fatAmber: data?['fatAmber'],
      satFatGreen: data?['satFatGreen'],
      satFatAmber: data?['satFatAmber'],
      sugarGreen: data?['sugarGreen'],
      sugarAmber: data?['sugarAmber'],
      saltGreen: data?['saltGreen'],
      saltAmber: data?['saltAmber'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (fatGreen != null) "fatGreen": fatGreen,
      if (fatAmber != null) "fatAmber": fatAmber,
      if (satFatGreen != null) "satFatGreen": satFatGreen,
      if (satFatAmber != null) "satFatAmber": satFatAmber,
      if (sugarGreen != null) "sugarGreen": sugarGreen,
      if (sugarAmber != null) "sugarAmber": sugarAmber,
      if (saltGreen != null) "saltGreen": saltGreen,
      if (saltAmber != null) "saltAmber": saltAmber,
    };
  }
}