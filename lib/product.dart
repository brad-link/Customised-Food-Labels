import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/intl.dart';

class Product {
  String? code;
  String? productName;
  num? carbs;
  num? carbs_100g;
  num? calories;
  num? calories_100g;
  num? fat;
  num? fat_100g;
  num? protein;
  num? protein_100g;
  num? sugar;
  num? sugar_100g;
  num? salt;
  num? salt_100g;
  num? satFat;
  num? sat_fat;
  num? sat_fat100g;
  num? satFat_100g;
  num? fibre;
  num? fibre_100g;
  String? serve_size;
  String? quantity;
  num? serving_quantity;
  String? image;
  num? portion;
  num? numOfPortions;
  String? dateAdded;
  DateTime? timeAdded;
  String? productID;

  Product({
    this.code,
    this.productName,
    this.carbs,
    this.carbs_100g,
    this.calories,
    this.calories_100g,
    this.fat,
    this.fat_100g,
    this.protein,
    this.protein_100g,
    this.sugar,
    this.sugar_100g,
    this.salt,
    this.salt_100g,
    this.satFat,
    this.satFat_100g,
    this.sat_fat,
    this.sat_fat100g,
    this.fibre,
    this.fibre_100g,
    this.serve_size,
    this.quantity,
    this.serving_quantity,
    this.image,
    this.portion,
    this.numOfPortions,
    this.dateAdded,
    this.timeAdded,
    this.productID,
  });


  setPortionValues(num portionIn, num numOfPortionsIn) {
    portion = portionIn;
    numOfPortions = numOfPortionsIn;
  }
  setDateTime(DateTime time, String day){
    dateAdded = day;
    timeAdded = time;
    String? timeString = DateFormat('h:mm:ss a').format(time);
    productID = (productName! + timeString);
  }

  int macroValue(num? size, num? serving, num? multiplier){
    int update = 0;
    if(size != null){
      update = ((size/100) * serving! * multiplier!).toInt();
    }
    return update;
  }

  Product setServingMacros(Product product){
    product.fat =  macroValue(product.fat_100g, product.portion, product.numOfPortions);
    product.calories= macroValue(product.calories_100g, product.portion, product.numOfPortions);
    product.carbs =  macroValue(product.carbs_100g, product.portion, product.numOfPortions);
    product.sugar = macroValue(product.sugar_100g, product.portion, product.numOfPortions);
    product.salt = macroValue(product.salt_100g, product.portion, product.numOfPortions);
    product.satFat = macroValue(product.sat_fat100g, product.portion, product.numOfPortions);
    product.protein = macroValue(product.protein_100g, product.portion, product.numOfPortions);

    return product;
  }

  factory Product.fromJson(final json) {
    var serving = json["product"]["serving_quantity"];
    num? serveSize;
    if (serving is String) {
      serveSize = num.parse(serving);
    } else {
      serveSize = serving;
    }
    return Product(
      code: json["code"].toString(),
      productName: json["product"]["product_name"].toString(),
      carbs: json["product"]["nutriments"]['carbohydrates_serving'],
      carbs_100g: json["product"]["nutriments"]['carbohydrates_100g'],
      calories: json["product"]["nutriments"]["energy-kcal_serving"],
      calories_100g: json["product"]["nutriments"]['energy-kcal_100g'],
      fat: json["product"]["nutriments"]['fat_serving'],
      fat_100g: json["product"]["nutriments"]['fat_100g'],
      protein: json["product"]["nutriments"]['proteins_serving'],
      protein_100g: json["product"]["nutriments"]['proteins_100g'],
      sugar: json["product"]["nutriments"]['sugars_serving'],
      sugar_100g: json["product"]["nutriments"]['sugars_100g'],
      salt: json["product"]["nutriments"]['salt_serving'],
      salt_100g: json["product"]["nutriments"]['salt_100g'],
      sat_fat: json["product"]["nutriments"]["saturated-fat"],
      sat_fat100g: json["product"]["nutriments"]["saturated-fat_100g"],
      fibre: json["product"]["nutriments"]["fiber"],
      fibre_100g: json["product"]["nutriments"]["fiber_100g"],
      serve_size: json["product"]["serving_size"].toString(),
      quantity: json["product"]["quantity"].toString(),
      serving_quantity: serveSize,
      image: json['product']["image_front_thumb_url"],
    );
  }


  Map<String, dynamic> toFirestore() {
    return {
      'code': code,
      'productName': productName,
      'carbs': carbs,
      'carbs_100g': carbs_100g,
      'calories': calories,
      'calories_100g': calories_100g,
      'fat': fat,
      'fat_100g': fat_100g,
      'protein': protein,
      'protein_100g': protein_100g,
      'sugar': sugar,
      'sugar_100g': sugar_100g,
      'salt': salt,
      'salt_100g': salt_100g,
      'sat_fat': sat_fat,
      'sat_fat100g': sat_fat100g,
      'fibre': fibre,
      'fibre_100g' : fibre_100g,
      'serve_size': serve_size,
      'quantity': quantity,
      'serving_quantity': serving_quantity,
      'image': image,
      'portion': portion,
      'numOfPortions': numOfPortions,
      'dateAdded': dateAdded,
      'timeAdded': timeAdded,
      'productID': productID,
    };
  }

  factory Product.fromFirestore(
      DocumentSnapshot doc
    //DocumentSnapshot<Map<String, dynamic>> snapshot,
    //SnapshotOptions? options,
  ) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    Timestamp timestamp = data['timeAdded'];
    DateTime? dateTime = timestamp.toDate();
    return Product(
      code: data['code'],
      productName: data['productName'],
      carbs: data['carbs'],
      carbs_100g: data['carbs_100g'],
      calories: data['calories'],
      calories_100g: data['calories_100g'],
      fat: data['fat'],
      fat_100g: data['fat_100g'],
      protein: data['protein'],
      protein_100g: data['protein_100g'],
      sugar: data['sugar'],
      sugar_100g: data['sugar_100g'],
      salt: data['salt'],
      salt_100g: data['salt_100g'],
      sat_fat: data['sat_fat'],
      sat_fat100g: data['sat_fat100g'],
      fibre: data['fibre'],
      fibre_100g: data['fibre_100g'],
      serve_size: data['serve_size'],
      quantity: data['quantity'],
      serving_quantity: data['serving_quantity'],
      image: data['image'],
      portion: data['portion'],
      numOfPortions: data['numOfPortions'],
      dateAdded: data['dateAdded'],
      timeAdded: timestamp.toDate(),
      productID: data['productID'],
    );
  }
}


