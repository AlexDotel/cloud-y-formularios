import 'dart:async';
import 'package:form_val/src/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators {

  final _emailController = BehaviorSubject<String>();
  final _pssController   = BehaviorSubject<String>();

  // Reemplazamos el 'StreamController<String>.broadcast();' por un BehaviorSubject en las
  // declaraciones de arriba, sigue funcionando igual.

  // final _emailController = StreamController<String>.broadcast();
  // final _pssController   = StreamController<String>.broadcast();

  //Obtener Valores del Stream
  Stream<String> get emailStream => _emailController.stream.transform(valMail);
  Stream<String> get pssStream   => _pssController.stream.transform(valPss);
  
  //Combinar los Streams para validar el boton
  //Los combinamos en la siguiente sentencia, para validar que ambos obtienen data correcta
  //implementados con la libreria rxdart
  Stream<bool>   get combi2      => 
    CombineLatestStream.combine2(emailStream, pssStream, (a, b) => true);

  //Insertar Valores al Stream
  Function(String) get changeEmail  => _emailController.sink.add;
  Function(String) get changePss    => _pssController.sink.add;

  //Obtener el ultimo valor insertado en los streams
  String get email => _emailController.value;
  String get pss   => _pssController.value;


  dispose(){

    _emailController?.close();
    _pssController?.close();

  }

  
  

}