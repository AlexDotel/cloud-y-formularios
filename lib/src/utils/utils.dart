
//Utilizaremos este codigo para validar que el valor es numerico
import 'package:flutter/material.dart';

bool esNumero ( String s ){

  if(s.isEmpty) return false;

  final n = num.tryParse(s);

  return (n == null ) ? false : true;

}



void mostrarAlerta(BuildContext context, String msj){

  showDialog(
    context: context,
    builder: (context){

      return AlertDialog(
        title:  Text('Informacion Incorrecta'),
        content:  msj.contains('INVALID_PASSWORD')?
                    Text('Contraseña incorrecta, intentelo de nuevo'):
                    Text(msj),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: ()=>Navigator.of(context).pop(),
          )
        ],
      );

    }
  );

}