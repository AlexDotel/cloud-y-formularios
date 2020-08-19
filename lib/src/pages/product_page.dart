import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_val/src/bloc/productos_bloc.dart';
import 'package:form_val/src/models/modelo_producto.dart';
import 'package:form_val/src/providers/productos_providers.dart';
import 'package:form_val/src/utils/utils.dart' as utils;
import 'package:image_downloader/image_downloader.dart';
import 'package:image_picker/image_picker.dart';

class ProductoPage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {

  File foto;
  PickedFile imagen;
  final _picker = ImagePicker();

  final productosBloc = ProductosBloc();

  final formKey = GlobalKey<FormState>();
  //Creamos el key del formulario con el que lo validaremos luego
  final scfldKey = GlobalKey<ScaffoldState>();
  //Creamos el key del Scaffold que es como un id
  bool _guardando = false;

  ModeloProducto producto = new ModeloProducto();
  //Instancia del producto para manejar datos con el POJO o modelo

  @override
  Widget build(BuildContext context) {
    final ModeloProducto prodData = ModalRoute.of(context).settings.arguments;
    if (prodData != null) producto = prodData;

    return Scaffold(
      key: scfldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _tomarFoto,
          )
        ],
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.all(16),
        child: Form(
            key:
                formKey, //Asignamo el Key creado arriba para validar el formulario
            child: Column(
              children: <Widget>[
                //Rellenamos el form con campos y Widgets
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(),
                _crearBoton(context),
              ],
            )),
      )),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: producto
          .titulo, //Asignamos el valor predeterminado de titulo como inicial
      textCapitalization: TextCapitalization
          .words, //Cada palabra sera una mayuscula automaticamente
      decoration: InputDecoration(
        labelText: 'Producto',
      ),
      onSaved: (valor) => producto.titulo = valor,
      //Aqui cuando validamos se dispara automaticamente el onSaved
      //Que en este caso lo usamos para asignar el valor obtenido a la
      //instancia del modelo producto creada.

      //Validamos el valor recibido para confirmar lo que queremos
      //en este caso queremos que sea mayor de 3 caracteres, asi que si lo cumple,
      //entonces devolvemos un null y la validacion de cumple, de lo contrario
      //devolvemos el error.
      validator: (valor) {
        if (valor.length < 3) {
          return 'Ingrese mas de 3 caracteres';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Precio',
      ),
      onSaved: (valor) => producto.valor = double.parse(valor),
      validator: (valor) {
        if (utils.esNumero(valor)) {
          //Aqui usamos el utils creado para validar que el valor recibido sea un numero

          return null;
        } else {
          return 'Solo Numeros';
        }
      },
    );
  }

  Widget _crearDisponible() {
    return SwitchListTile(
        value: producto.stock,
        title: Text('Disponible'),
        activeColor: Theme.of(context).primaryColor,
        onChanged: (valor) => setState(() {
              producto.stock = valor;
            }));
  }

  Widget _crearBoton(BuildContext context) {
    return RaisedButton.icon(
        label: Text('Guardar Producto'),
        icon: Icon(Icons.save),
        elevation: 0,
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        onPressed: (_guardando) ? null : _submit,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)));
  }

  void _submit() async {
    //Aqui realizamos la validacion del formulario a travez del key que lo controla o lo valida

    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();

    setState(() {
      _guardando = true;
    });

    if (imagen != null) {
      producto.fotoUrl = await productosBloc.subirFoto(imagen);
      //Aqui subimos la foto y tambien almacenamos el URL qeu retorna en firebase.

    
      var imageId = await ImageDownloader.downloadImage(producto.fotoUrl);
      // if (imageId == null) {
      // return;
    
    }

    if (producto.id == null) {
      productosBloc.addProductos(producto);
    } else {
      productosBloc.editarProducto(producto);
    }

    Timer(Duration(seconds: 2), () {
      setState(() {
        _guardando = false;
        Navigator.pushReplacementNamed(context, 'home');
      });
    });

    mostrarSnackbar('Guardando producto');
  }

  void mostrarSnackbar(String mensaje) {
    final snackbar = new SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
      action: SnackBarAction(
          label: 'VOLVER',
          onPressed: () => Navigator.pushReplacementNamed(context, 'home')),
    );

    scfldKey.currentState.showSnackBar(snackbar);
  }

  _mostrarFoto() {
    if (producto.fotoUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: FadeInImage(
            image: NetworkImage(producto.fotoUrl),
            placeholder: AssetImage('assets/img/original.gif'),
            height: 350.0,
            width: double.infinity,
            fit: BoxFit.cover),
      );
    } else {
      if (imagen != null) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image.file(
            foto,
            height: 350.0,
            width: double.infinity,
            fit: BoxFit.cover
          ),
        );
      } else {
        return Image.asset('assets/img/original.png');
      }
    }
  }

  void _seleccionarFoto() async {
    _procesarFoto(ImageSource.gallery);
  }

  void _tomarFoto() async {
    _procesarFoto(ImageSource.camera);
  }

  _procesarFoto(ImageSource source) async {
    imagen = await _picker.getImage(source: source);

    if (imagen != null) {
      producto.fotoUrl = null;
    }
    setState(() {
      foto = File(imagen.path);
    });
  }
}
