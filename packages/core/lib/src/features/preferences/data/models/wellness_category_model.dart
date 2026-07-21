import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/wellness_category.dart';

class WellnessCategoryModel extends WellnessCategory{
  const WellnessCategoryModel({
    required super.id,
    required super.name,
    super.iconUrl,
});


  factory WellnessCategoryModel.fromFireStore(DocumentSnapshot<Map<String,dynamic>> doc){
    final data=doc.data()!;
    return WellnessCategoryModel(
      id: doc.id,
      name: data['name'] as String? ?? '',
      iconUrl: data['iconUrl'] as String?,
    );
  }
}