import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:mime_type/mime_type.dart';
import 'package:image_picker/image_picker.dart';

import 'package:form_val/src/prefs/shared_preferences.dart';
import 'package:form_val/src/models/modelo_producto.dart';

class ProductosProvider {
  final String _url = 'https://flutter-c4a13.firebaseio.com';
  final _prefs = new PreferenciasUsuario();

  Future<bool> crearProducto(ModeloProducto producto) async {
    final url = '$_url/productos.json?auth=${_prefs.token}';

    final resp = await http.post(url, body: modeloProductoToJson(producto));

    final decodedData = json.decode(resp.body);

    print(decodedData);

    return true;
  }

  Future<bool> editarProducto(ModeloProducto producto) async {
    // https://flutter-c4a13.firebaseio.com/productos/-M83ANQe56wX_97Pe_0w

    final url = '$_url/productos/${producto.id}.json?auth=${_prefs.token}';

    final resp = await http.put(url, body: modeloProductoToJson(producto));

    final decodedData = json.decode(resp.body);

    print(decodedData);

    return true;
  }

  Future<List<ModeloProducto>> cargarProductos() async {
    final url = '$_url/productos.json?auth=${_prefs.token}';
    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);

    // print(decodedData);

    final List<ModeloProducto> listaProductos = new List();

    if (decodedData == null) return [];
    
    if( decodedData['error'] != null ) return [];
    //Verificamos si tiene un error




    decodedData.forEach((id, producto) {
      final prodTemporal = ModeloProducto.fromJson(producto);
      prodTemporal.id = id;
      listaProductos.add(prodTemporal);
    });

    print(listaProductos);
    return listaProductos;
  }

  Future<int> borrarProducto(String id) async {
    final url = '$_url/productos/$id.json?auth=${_prefs.token}';

    final resp = await http.delete(url);

    final decoded = json.decode(resp.body);

    print(decoded);

    return decoded;
  }

  Future<String> subirImage(PickedFile imagen) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/djk1ynigl/image/upload?upload_preset=qwaxkdor');
    //Declaramos la URL valira pero parseada a un Uri
    // (Esta URL la tomamos de la prueba de carga del Postman)

    final mimeType = mime(imagen.path).split("/");
    //Esto extrae el tipo de imagen, esto nos quedaria de la siguiente forma: image/jpg
    //Indicando que es de tipo imagen y que es jpg en este caso.

    final imageUploadRequest = http.MultipartRequest(
      'POST',
      url,
    );
    //Aqui declaramos un request multiparte, que recibe un verbo
    //http, en este caso, el verbo POST porque queremos subir. Y la URL
    //Mas abajo completamos las partes.

    final file = await http.MultipartFile.fromPath('file', imagen.path,
        contentType: MediaType(mimeType[0], mimeType[1]));
    //Aqui enviaremos el archivo, como en el request de Postman
    //Ponemos el campo 'file', que es propio del API de Cloudinary
    //Ponemos la ruta y especificamos el tipo mediante el mimeType
    //Que creamos arriba.

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    // Aqui finalmente cargamos el archivo y nos devuelve un streamResponse.

    final resp = await http.Response.fromStream(streamResponse);
    // Aqui recibimos la respuesta tradicional, un json, en el body de la respusta.

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('ALGO VA MAL');
      print(resp.body);
      return null;
    }

    final respData = jsonDecode(resp.body);
    print(respData);

    return respData['secure_url'];
  }
}
