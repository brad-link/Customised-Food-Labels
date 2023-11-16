import 'package:cfl_app/DataClasses/TrafficValues.dart';
import 'package:cfl_app/traffic_card2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'DataClasses/appUser.dart';
import 'components/database.dart';

class TrafficSettings extends StatelessWidget {
  //final dataBase = DatabaseService();



  const TrafficSettings({super.key});


  @override
  Widget build(BuildContext context) {

    final user = Provider.of<AppUser?>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Traffic Settings'),
      ),
      body: StreamBuilder<TrafficValues?>(
        stream: DatabaseService(uid: user?.uid).getMTLStream(),
        builder: (context, snapshot) {
          TrafficValues? mtl = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Text('No data found');
          }else {
            return ListView.builder(
              itemCount: 4,
              itemBuilder: (context, index) {
                num? value1;
                num? value2;
                int? choice;
                String? category;
                switch (index) {
                  case 0:
                    {
                      choice = 0;
                      category = 'Fat';
                      value1 = mtl?.fatGreen;
                      value2 = mtl?.fatAmber;
                      break;
                    }
                  case 1:
                    {
                      choice =1;
                      category = 'Saturates';
                      value1 = mtl?.satFatGreen;
                      value2 = mtl?.satFatAmber;
                      break;
                    }
                  case 2:
                    {
                      choice = 2;
                      category = 'Sugar';
                      value1 = mtl?.sugarGreen;
                      value2 = mtl?.sugarAmber;
                      break;
                    }
                  case 3:
                    {
                      choice = 3;
                      category = 'Salt';
                      value1 = mtl?.saltGreen;
                      value2 = mtl?.saltAmber;
                      break;
                    }
                }
                return TrafficCard2(
                  category: category,
                  value1: value1,
                  value2: value2,
                  choice: choice,
                );
              },
            );
          }
        },
      ),
    );
  }
}
