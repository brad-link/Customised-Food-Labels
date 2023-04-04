import 'package:cfl_app/components/dietLog.dart';

class MetabolicRate{
  final String gender;
  final int age;
  final int height;
  final int weight;

  MetabolicRate(this.gender, this.age, this.height, this.weight);
/*
  DietaryRequirements generate(gender, age, height, weight){
    num bmr = (10* weight)+(6.25*height)-(5* age);
    if(gender == 'Male'){
      bmr = bmr + 5;

      return
    } else{
      return
    }
  }*/
}