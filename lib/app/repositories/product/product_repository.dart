


import 'dart:typed_data';

import 'package:mesa_bloc/app/models/modelProducto/product_data.dart';
import 'package:universal_io/io.dart';

abstract class ProductRepository {
  Future<List<ProductData>> getProductsByCategory(String categoryId);

  Future<String> updateProductImage({
    required String productId,
    required String fileName,
    Uint8List? imageBytes,
    File? imageFile
  });

  Future<bool> saveProduct(ProductData productData);

  Future<bool> removeProduct(String productId);

}

