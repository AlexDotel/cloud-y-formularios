import 'package:flutter/material.dart';

import 'package:form_val/src/bloc/provider.dart';
import 'package:form_val/src/models/modelo_producto.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    final productosBloc = ProductosBloc();
    productosBloc.cargarProductos();

    final estilo = TextStyle(
        fontSize: 20,
        fontStyle: FontStyle.italic,
        color: Theme.of(context).primaryColor);

    return Scaffold(
      appBar: AppBar(title: Text('HomePage')),
      body: _crearListado(productosBloc),
      floatingActionButton: _crearBotton(context),
    );
  }

  _crearBotton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () => Navigator.pushNamed(context, 'product'),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  Widget _crearListado(ProductosBloc productosBloc) {

    return StreamBuilder(
      stream: productosBloc.productosStream ,
      builder: (BuildContext context, AsyncSnapshot<List<ModeloProducto>>snapshot){
        if (snapshot.hasData) {
          final productos = snapshot.data;

          return ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, index) =>
                  _crearItem(context, productos[index], productos, index, productosBloc));
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget _crearItem(BuildContext context, ModeloProducto producto,
      List<ModeloProducto> productosLista, int index, ProductosBloc productosBloc) {

    return Dismissible(
      key: UniqueKey(),
      background: Container(color: Colors.red),
      onDismissed: (direccion) {
        //Aqui en el onDismiss tuvimos que usa la lista y el index, para actualizar el estado
        //ya que mientras no estuviera actualizado, seguiria esperando el item a pesar de
        //estar eliminado en la base de datos, tambien habia que borrarlo del estado de la app.
        productosBloc
            .borrarProducto(producto.id)
            .then((value) => setState(() {
                  productosLista.removeAt(index);
                }));
      },
      child: ListTile(
        trailing: Icon(Icons.cloud_done),
        leading: (producto.fotoUrl == null)
            ? Image(
                image: AssetImage('assets/img/original.png'),
                fit: BoxFit.cover,
                width: 50,
                height: 100,
              )
            : FadeInImage(
                image: NetworkImage(producto.fotoUrl),
                placeholder: AssetImage('assets/img/original.gif'),
                fit: BoxFit.cover,
                width: 50,
                height: 100,
              ),
        title: Text('${producto.titulo} - ${producto.valor}'),
        subtitle: Text('Disponible: ${producto.stock}'),
        onTap: () =>
            Navigator.pushNamed(context, 'product', arguments: producto),
      ),
    );
  }
}
