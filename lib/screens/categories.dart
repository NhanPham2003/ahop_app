import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../consts/colors.dart';
import '../services/utils.dart';
import '../widgets/category_widget.dart';
import '../widgets/text_widget.dart';

class CategoriesScreen extends StatelessWidget {
  CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final utils = Utils(context);
    Color color = utils.color;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TextWidget(
          text: 'Danh Mục',
          color: color,
          textSize: 24,
          isTitle: true,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('category').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Map<String, dynamic>> catInfo = snapshot.data!.docs.map((document) {
              return {
                'imgPath': document['imageUrl'],
                'catText': document['title'],
              };
            }).toList();

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 240 / 250,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: List.generate(catInfo.length, (index) {
                  return CategoriesWidget(
                    catText: catInfo[index]['catText'],
                    imgPath: catInfo[index]['imgPath'],
                    passedColor: AppColor.primaryColor,
                  );
                }),
              ),
            );
          }
        },
      ),
    );
  }
}
