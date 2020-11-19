import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trevo/Models/storyModel.dart';

class AddNewStory with ChangeNotifier{
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  void addNewStory(StoryModel storyModel,String uid) async{
//    Map<String,dynamic> data = {
//      'image': storyModel.image,
//      'title': storyModel.title,
//      'description': storyModel.description,
//      'tags':storyModel.tags
//    };
    return await _db.collection('users').doc(uid).collection('stories').doc().set(storyModel.toJson());
  }
}