import 'package:cfl_app/DataClasses/appUser.dart';
import 'package:intl/intl.dart';
import 'database.dart';
import '../DataClasses/product.dart';
import '../DataClasses/dietLog.dart';

class AddProductToDB {
  //adds product to product collection
  //adds nutritional data for the product to the diet log for the day
  void add(AppUser user, DateTime date, Product product, num? portion,
      num servings) async {
    DietLog update = DietLog(
      date: date,
      fat: calculateServing(product.fat_100g, portion, servings),
      calories: calculateServing(product.calories_100g, portion, servings).toInt(),
      carbohydrates: calculateServing(product.carbs_100g, portion, servings),
      sugars: calculateServing(product.sugar_100g, portion, servings),
      salt: calculateServing(product.salt_100g, portion, servings),
      saturates: calculateServing(product.sat_fat100g, portion, servings),
      protein: calculateServing(product.protein_100g, portion, servings),
      fibre: calculateServing(product.fibre_100g, portion, servings),
    );
    product.setPortionValues(portion!, servings);
    String day = DateFormat('dd/MM/yyyy').format(date);
    product.setDateTime(DateTime.now(), day);
    await DatabaseService(uid: user.uid).addProduct(product);
    await DatabaseService().productsList(product);
    await DatabaseService(uid: user.uid).updateLog(update);
  }
  //calculates the serving from the portion and number of portions
  num calculateServing(num? size, num? portion, num? portions) {
    num update = 0;
    if (size != null) {
      update = ((size / 100) * portion! * portions!);
    }
    return update;
  }
}
