import 'package:flutter/material.dart';
import 'package:form_val/src/bloc/provider.dart';
import 'package:form_val/src/providers/nuevo_usuario_provider.dart';
import 'package:form_val/src/utils/utils.dart' as utils;

class RegistroPage extends StatelessWidget {
  final usuarioProvider = UsuarioProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        crearFondo(context),
        loginForm(context),
      ],
    ));
  }

  Widget crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final fondoMorado = Container(
      height: size.height * 0.40,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Color.fromRGBO(101, 19, 104, 1),
              Color.fromRGBO(255, 171, 178, 1),
              // rgb(255, 171, 178)
            ]),
      ),
    );

    final circulo = Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Color.fromRGBO(255, 255, 255, .1)),
    );

    final circuloG = Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Color.fromRGBO(255, 255, 255, .1)),
    );

    final logo = Container(
        height: size.height * 0.35,
        alignment: Alignment.center,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.account_circle,
                color: Colors.white,
                size: 100,
              ),
              SizedBox(
                height: 10.0,
                width: double.infinity,
              ),
              Text(
                'DaPerezBraids',
                style: TextStyle(color: Colors.white, fontSize: 25),
              )
            ],
          ),
        ));

    return Stack(
      children: <Widget>[
        fondoMorado,
        Positioned(child: circuloG, top: 90, left: 30),
        Positioned(child: circulo, top: 250, left: 230),
        Positioned(child: circulo, top: 10, left: 300),
        Positioned(child: circulo, top: -50, left: -50),
        logo
      ],
    );
  }

  Widget loginForm(BuildContext context) {
    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        SafeArea(
            child: Container(
          height: size.height * 0.3,
        )),
        Container(
          width: size.width * .85,
          margin: EdgeInsets.only(bottom: 5),
          padding: EdgeInsets.symmetric(vertical: 50),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 2.0,
                  offset: Offset(0.0, .5),
                  // spreadRadius: 3
                )
              ]),
          child: Column(
            children: <Widget>[
              Text(
                'Registro',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 30,
              ),
              _crearEmail(bloc),
              SizedBox(
                height: 15,
              ),
              _crearPss(bloc),
              SizedBox(
                height: 50,
              ),
              _crearBoton(bloc),
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        FlatButton(
          child: Text('Ya tengo cuenta'),
          onPressed: () => Navigator.pushNamed(context, 'login'),
        ),
        SizedBox(
          height: 200,
        ),
      ],
    ));
  }

  Widget _crearEmail(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.alternate_email,
                  color: Color.fromRGBO(101, 19, 104, 1),
                  size: 20,
                ),
                hintText: 'ejemplo@correo.com',
                labelText: 'Correo Electronico',
                counterText: snapshot.data,
                errorText: snapshot.error),

            onChanged: (valor) => bloc.changeEmail(valor),
            // onChanged: bloc.changeEmail, ESta linea es la misma de arriba, simplificad
          ),
        );
      },
    );
  }

  Widget _crearPss(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.pssStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.lock_outline,
                  color: Color.fromRGBO(101, 19, 104, 1),
                  size: 20,
                ),
                labelText: 'Contraseña',
                counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: (valor) => bloc.changePss(valor),
          ),
        );
      },
    );
  }

  Widget _crearBoton(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.combi2,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RaisedButton(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              child: Text('Registro'),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
            color: Color.fromRGBO(101, 19, 104, .8),
            textColor: Colors.white,
            onPressed:
                snapshot.hasData ? () => _registro(context, bloc) : null);
      },
    );
  }

  _registro(BuildContext context, LoginBloc bloc) async {
    final Map info = await usuarioProvider.nuevoUsuario(bloc.email, bloc.pss);

    if (info['ok']) {
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      utils.mostrarAlerta(context, info['mensaje']);
    }
  }
}
