class Person {
  String? name;
  String? phone;
  String? email;
  String? country;
  String? address;

  Person({this.name, this.phone, this.email, this.country, this.address});

  Person.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    country = json['country'];
    address = json['address'];
  }
}