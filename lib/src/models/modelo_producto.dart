// To parse this JSON data, do
//
//     final modeloProducto = modeloProductoFromJson(jsonString);

import 'dart:convert';

ModeloProducto modeloProductoFromJson(String str) =>
    ModeloProducto.fromJson(json.decode(str));

String modeloProductoToJson(ModeloProducto data) => json.encode(data.toJson());

class ModeloProducto {
  String id;
  String titulo;
  double valor;
  bool stock;
  String fotoUrl;

  ModeloProducto({
    this.id,
    this.titulo = '',
    this.valor = 0.0,
    this.stock = true,
    this.fotoUrl,
  });

  factory ModeloProducto.fromJson(Map<String, dynamic> json) => ModeloProducto(
        id: json["id"],
        titulo: json["titulo"],
        valor: json["valor"],
        stock: json["stock"],
        fotoUrl: json["fotoURL"],
      );

  Map<String, dynamic> toJson() => {
        // "id": id,
        "titulo": titulo,
        "valor": valor,
        "stock": stock,
        "fotoURL": fotoUrl,
      };
}
