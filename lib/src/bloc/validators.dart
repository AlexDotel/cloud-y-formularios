import 'dart:async';

class Validators{

  final valMail = StreamTransformer <String, String> .fromHandlers(
    handleData: ( mailRecibido , sink ){

      Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      //El de arriba es un patron para validad un email.
      RegExp regExp = new RegExp(pattern);
      //Esta es una expresion regular que valida que se cumple al patron de arriba.

      regExp.hasMatch(mailRecibido) ? sink.add(mailRecibido) : sink.addError('Email no es correcto');

    }

  ); 

  final valPss = StreamTransformer <String, String> .fromHandlers(
    handleData: ( pssRecibida , sink ){

      pssRecibida.length >= 6 ? sink.add(pssRecibida) : sink.addError('Mas de seis caracteres');

    }

  ); 


}