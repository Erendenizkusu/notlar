class Notlar {
  int? notID;
  late int kategoriID;
  late String kategoriBaslik;
  late String notBaslik;
  late String notIcerik;
  late int notOncelik;
  late String notTarih;

  Notlar(this.kategoriID, this.notBaslik, this.notIcerik,this.notTarih, this.notOncelik);

  Notlar.withID(this.notID, this.kategoriID, this.notBaslik, this.notIcerik, this.notTarih, this.notOncelik);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['notID'] = notID;
    map['kategoriID'] = kategoriID;
    map['notBaslik'] = notBaslik;
    map['notIcerik'] = notIcerik;
    map['notTarih'] = notTarih;
    map['notOncelik'] = notOncelik;
    return map;
  }

  Notlar.fromMap(Map<String, dynamic> map) {
    notID = map['notID'];
    kategoriID = map['kategoriID'];
    notBaslik = map['notBaslik'];
    kategoriBaslik = map['kategoriBaslik'];
    notIcerik = map['notIcerik'];
    notTarih = map['notTarih'];
    notOncelik = map['notOncelik'];
  }

  @override
  String toString() {
    return 'Notlar{notID: $notID, kategoriID: $kategoriID, notBaslik: $notBaslik, notIcerik: $notIcerik, notTarih: $notTarih, notOncelik: $notOncelik}';
  }
}
