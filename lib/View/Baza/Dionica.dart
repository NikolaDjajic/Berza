class Dionica{
  final int? id;
  final int kolicina;
  final String slika;
  final String dionicaId;
  final String simbol;
  final String ime;
  final double cijena;

  const Dionica({this.id,required this.kolicina,required this.slika, required this.dionicaId,required this.simbol, required this.ime, required this.cijena});

  factory Dionica.fromJson(Map<String,dynamic> json) => Dionica(
    id: json['id'],
    kolicina : json['kolicina'],
    slika: json['slika'],
    dionicaId: json['dionicaId'],
    simbol: json['simbol'],
    ime: json['ime'],
    cijena: json['cijena']
  );

  Map<String,dynamic> toJson() => {
    'id': id,
    'kolicina' : kolicina,
    'slika': slika,
    'dionicaId': dionicaId,
    'simbol': simbol,
    'ime': ime,
    'cijena': cijena
  };
}