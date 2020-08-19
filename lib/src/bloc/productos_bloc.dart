import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';

import 'package:form_val/src/models/modelo_producto.dart';
import 'package:form_val/src/providers/productos_providers.dart';

class ProductosBloc {
  final _productosController = new BehaviorSubject<List<ModeloProducto>>();
  final _cargandoController = new BehaviorSubject<bool>();

  final _productosProvider = new ProductosProvider();

  Stream<List<ModeloProducto>> get productosStream =>
      _productosController.stream;
  Stream<bool> get cargando => _cargandoController.stream;

  void cargarProductos() async {
    final productos = await _productosProvider.cargarProductos();
    _productosController.sink.add(productos);
  }

  void addProductos(ModeloProducto producto) async {
    _cargandoController.sink.add(true);
    await _productosProvider.crearProducto(producto);
    _cargandoController.sink.add(false);
  }

  Future<String>subirFoto(PickedFile foto) async {
    _cargandoController.sink.add(true);
    final fotoUrl = await _productosProvider.subirImage(foto);
    _cargandoController.sink.add(false);
    return fotoUrl;
  }

  void editarProducto(ModeloProducto producto) async {
    _cargandoController.sink.add(true);
    _productosProvider.editarProducto(producto);
    _cargandoController.sink.add(false);
  }

  Future<int> borrarProducto (String productoId) async {
    _cargandoController.sink.add(true);
    final entero = await _productosProvider.borrarProducto(productoId);
    _cargandoController.sink.add(false);
    return entero;
  }


  //Required
  dispose() {
    _productosController?.close();
    _cargandoController?.close();
  }
}
