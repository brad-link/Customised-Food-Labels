class Product{
  final String code;
  final String productName;
  final num? carbs;
  final num? carbs_100g;
  final num? calories;
  final num? calories_100g;
  final num? fat;
  final num? fat_100g;
  final num? protein;
  final num? protein_100g;
  final num? sugar;
  final num? sugar_100g;
  final num? salt;
  final num? salt_100g;
  final num? satFat;
  final num? sat_fat;
  final num? sat_fat100g;
  final num? satFat_100g;
  final String? serve_size;
  final String? quantity;
  final num? serving_quantity;


  Product({
    required this.code,
    required this.productName,
    required this.carbs,
    required this.carbs_100g,
    required this.calories,
    required this.calories_100g,
    required this.fat,
    required this.fat_100g,
    required this.protein,
    required this.protein_100g,
    required this.sugar,
    required this.sugar_100g,
    required this.salt,
    required this.salt_100g,
    required this.satFat,
    required this.satFat_100g,
    required this.sat_fat,
    required this.sat_fat100g,
    required this.serve_size,
    required this.quantity,
    required this.serving_quantity,
  });

  factory Product.fromJson(final json){
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
      satFat: json["product"]["nutriments"]['saturated_fat_serving'],
      satFat_100g: json["product"]["nutriments"]['saturated_fat_100g'],
      sat_fat: json["product"]["nutriments"]["saturated-fat"],
      sat_fat100g: json["product"]["nutriments"]["saturated-fat_100g"],
      serve_size: json["product"]["serving_size"].toString(),
      quantity: json["product"]["quantity"].toString(),
      serving_quantity: json["product"]["serving_quantity"],

    );
  }
}