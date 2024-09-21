class Kategori{
  int? kategoriID;
  late String kategoriBaslik;

  Kategori(this.kategoriBaslik); //kategori okurken kullan



  Map<String,dynamic> toMap(){
    var map = <String,dynamic>{};
    map['kategoriID'] = kategoriID;
    map['kategoriBaslik'] = kategoriBaslik;
    return map;
  }
  Kategori.fromMap(Map<String,dynamic> map){
    this.kategoriID = map['kategoriID'];
    this.kategoriBaslik = map['kategoriBaslik'];
  }

  @override
  String toString() {
    return 'Kategori{kategoriID: $kategoriID, kategoriBaslik: $kategoriBaslik}';
  }

}