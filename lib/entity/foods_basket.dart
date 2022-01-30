class FoodsBasketClass{
  String basket_id;
  String bfood_name;
  String bfood_pic_url;
  String bfood_price;
  String bfood_count;
  String bfood_username;

  FoodsBasketClass(
  {required this.basket_id,
  required this.bfood_name,
  required this.bfood_pic_url,
  required this.bfood_price,
  required this.bfood_count,
  required this.bfood_username});
  
  factory FoodsBasketClass.fromJson(Map<String,dynamic> json){
    return FoodsBasketClass(
      basket_id: json["sepet_yemek_id"] as String,
      bfood_name: json["yemek_adi"] as String,
      bfood_pic_url: json["yemek_resim_adi"] as String,
      bfood_price: json["yemek_fiyat"] as String,
      bfood_count: json["yemek_siparis_adet"] as String,
      bfood_username: json["kullanici_adi"] as String,
    );
  }
}