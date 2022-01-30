class Foods{
  String food_id;
  String food_name;
  String food_pic_url;
  String food_price;

  Foods({required this.food_id, required this.food_name, required this.food_pic_url, required this.food_price});

  factory Foods.fromJson(Map<String,dynamic> json){
    return Foods(
        food_id: json["yemek_id"] as String,
        food_name: json["yemek_adi"] as String,
        food_pic_url: json["yemek_resim_adi"] as String,
        food_price: json["yemek_fiyat"] as String
    );
  }
}