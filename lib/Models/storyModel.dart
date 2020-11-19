class StoryModel{
  final String image;
  final String title;
  final List<String> tags;
  final String description;

  StoryModel({this.image, this.title, this.tags, this.description});

  Map toJson() => {
    'image': image,
    'title': title,
    'tags':tags,
    'description':description,
  };

  factory StoryModel.fromMap(Map json){
    return StoryModel(
      image : json['image'],
      title : json['title'],
      tags: json['tags'],
      description: json['description'],
    );
  }
}