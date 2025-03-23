// // import 'dart:typed_data';
// // import 'package:mesa_bloc/app/models/modelCategoria/category_data.dart';
// // import 'package:universal_io/io.dart';

// // abstract class CategoryRepository {
// //   Future<List<CategoryData>> getAllCategory();
// //   Future<String> uploadCategoryImage({
// //     required String categoryId,
// //     File? imageFile,
// //     Uint8List? imageBytes,
// //     required String fileName,
// //   });
// // }


// // import 'dart:typed_data';
// // import 'package:cached_network_image/cached_network_image.dart';
// // import 'package:file_picker/file_picker.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:mesa_bloc/app/blocs/category/category_bloc.dart';
// // import 'package:mesa_bloc/app/blocs/category/category_state.dart';
// // import 'package:mesa_bloc/app/models/modelCategoria/category_data.dart';

// // class CategoryList extends StatelessWidget {
// //   const CategoryList({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return BlocProvider(
// //       create: (context) => CategoryBloc()..add(GetAllCategory()),
// //       child: BlocConsumer<CategoryBloc, CategoryState>(
// //         listener: (context, state) {
// //           if (state.error.isNotEmpty) {
// //             _showSnackBar(context, state.error, Colors.red);
// //           }
// //         },
// //         builder: (context, state) {
// //           return Container(
// //             padding: const EdgeInsets.all(16.0),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   "All Categories",
// //                   style: Theme.of(context).textTheme.titleLarge?.copyWith(
// //                         fontWeight: FontWeight.bold,
// //                         color: Colors.black87,
// //                       ),
// //                 ),
// //                 const SizedBox(height: 20),
// //                 _buildTableContainer(context, state),
// //               ],
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }

// //   Widget _buildTableContainer(BuildContext context, CategoryState state) {
// //     return SizedBox(
// //       height: MediaQuery.of(context).size.height * 0.7,
// //       child: _buildTableContent(context, state),
// //     );
// //   }

// //   Widget _buildTableContent(BuildContext context, CategoryState state) {
// //     if (state.loading) {
// //       return const Center(child: CircularProgressIndicator(color: Colors.blue));
// //     }

// //     if (state.listCategory.isEmpty) {
// //       return const Center(
// //         child: Padding(
// //           padding: EdgeInsets.symmetric(vertical: 20.0),
// //           child: Text(
// //             "No categories available",
// //             style: TextStyle(color: Colors.grey, fontSize: 16),
// //           ),
// //         ),
// //       );
// //     }

// //     return SingleChildScrollView(
// //       scrollDirection: Axis.horizontal,
// //       child: DataTable(
// //         columnSpacing: 30,
// //         dataRowHeight: 70,
// //         headingRowHeight: 50,
// //         horizontalMargin: 20,
// //         columns: const [
// //           DataColumn(label: Text("Image")),
// //           DataColumn(label: Text("Name")),
// //           DataColumn(label: Text("Description")),
// //           DataColumn(label: Text("Edit")),
// //           DataColumn(label: Text("Delete")),
// //         ],
// //         rows: state.listCategory
// //             .map((category) => _buildTableRow(context, category))
// //             .toList(),
// //       ),
// //     );
// //   }

// //   DataRow _buildTableRow(BuildContext context, CategoryData category) {
// //     return DataRow(
// //       cells: [
// //         DataCell(
// //           GestureDetector(
// //             onTap: () => _handleImageUpdate(context, category.id ?? ''),
// //             child: _buildCategoryImage(category.images),
// //           ),
// //         ),
// //         DataCell(
// //           Text(category.nombre.isNotEmpty ? category.nombre : "Unnamed"),
// //         ),
// //         DataCell(
// //           Text(category.description?.isNotEmpty == true
// //               ? category.description!
// //               : "No description"),
// //         ),
// //         const DataCell(Icon(Icons.edit, color: Colors.blue)),
// //         const DataCell(Icon(Icons.delete, color: Colors.red)),
// //       ],
// //     );
// //   }

// //   /// 📌 **Manejo seguro de imágenes**
// //   Widget _buildCategoryImage(String? imageUrl) {
// //     final fixedUrl = _fixImageUrl(imageUrl);
// //     print('lo que hay $fixedUrl');
// //     return SizedBox(
// //       width: 50,
// //       height: 50,
// //       child: fixedUrl.isNotEmpty
// //           ? ClipRRect(
// //               borderRadius: BorderRadius.circular(8),
// //               child: CachedNetworkImage(
// //                 imageUrl: fixedUrl,
// //                 fit: BoxFit.cover,
// //                 progressIndicatorBuilder: (_, __, progress) => Center(
// //                   child: CircularProgressIndicator(
// //                     value: progress.progress,
// //                     color: Colors.blue,
// //                     strokeWidth: 2,
// //                   ),
// //                 ),
// //                 errorWidget: (_, __, ___) => const _PlaceholderIcon(),
// //               ),
// //             )
// //           : const _PlaceholderIcon(),
// //     );
// //   }

// //   /// 📌 **Corrección de URL**
// //   String _fixImageUrl(String? url) {
// //     if (url == null || url.isEmpty) return ''; // Devuelve cadena vacía si no hay URL
// //     if (url.contains("localhost")) {
// //       return url.replaceAll("localhost", "192.168.253.237");
// //     }
// //     if (!url.startsWith("http")) {
// //       return "http://192.168.253.237:8081/$url";
// //     }
// //     return url;
// //   }

// //   /// 📌 **Manejo de selección y carga de imagen**
// //   Future<void> _handleImageUpdate(BuildContext context, String categoryId) async {
// //     debugPrint("📌 Click en la imagen detectado. Iniciando selección de archivo...");

// //     try {
// //       final result = await FilePicker.platform.pickFiles(
// //         type: FileType.image,
// //         allowMultiple: false,
// //         withData: true,
// //       );

// //       if (result == null || result.files.isEmpty) {
// //         _showSnackBar(context, "No se seleccionó ningún archivo", Colors.orange);
// //         return;
// //       }

// //       final file = result.files.first;
// //       if (file.bytes == null) {
// //         _showSnackBar(context, "No se proporcionó una imagen válida", Colors.red);
// //         return;
// //       }

// //       Uint8List imageBytes = file.bytes!;
// //       debugPrint("✅ Archivo seleccionado: ${file.name}");
// //       debugPrint("📏 Tamaño: ${imageBytes.length} bytes");
// //       debugPrint("🖼 Extensión: ${file.extension}");

// //       if (!context.mounted) return;

// //       context.read<CategoryBloc>().add(
// //             UpdateCategoryImage(
// //               categoryId: categoryId,
// //               imageBytes: imageBytes,
// //               fileName: file.name,
// //             ),
// //           );

// //       _showSnackBar(context, "Imagen actualizada con éxito", Colors.green);
// //     } catch (e) {
// //       debugPrint("❌ Error crítico: $e");
// //       _showSnackBar(context, "Error al seleccionar imagen", Colors.red);
// //     }
// //   }

// //   /// 📌 **Manejo de mensajes de error y éxito**
// //   void _showSnackBar(BuildContext context, String message, Color color) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(content: Text(message), backgroundColor: color),
// //     );
// //   }
// // }

// // /// 📌 **Icono de imagen de respaldo**
// // class _PlaceholderIcon extends StatelessWidget {
// //   const _PlaceholderIcon();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       width: 50,
// //       height: 50,
// //       decoration: BoxDecoration(
// //         color: Colors.grey[200],
// //         borderRadius: BorderRadius.circular(8),
// //       ),
// //       child: const Center(
// //         child: Icon(Icons.image_not_supported, color: Colors.grey, size: 28),
// //       ),
// //     );
// //   }
// // }



// import 'dart:typed_data';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mesa_bloc/app/blocs/category/category_bloc.dart';
// import 'package:mesa_bloc/app/blocs/category/category_state.dart';
// import 'package:mesa_bloc/app/models/modelCategoria/category_data.dart';
// //import 'package:mesa_bloc/app/screens/subcategory_screen.dart'; // 🔹 Importa la pantalla de subcategorías

// class CategoryList extends StatefulWidget {
//   const CategoryList({super.key});

//   @override
//   _CategoryListState createState() => _CategoryListState();
// }

// class _CategoryListState extends State<CategoryList> {
//   int currentPage = 0;
//   final int rowsPerPage = 10; // Número de filas por página

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => CategoryBloc()..add(GetAllCategory()),
//       child: BlocConsumer<CategoryBloc, CategoryState>(
//         listener: (context, state) {
//           if (state.error.isNotEmpty) {
//             _showSnackBar(context, state.error, Colors.red);
//           }
//         },
//         builder: (context, state) {
//           return Container(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "All Categories",
//                   style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                 ),
//                 const SizedBox(height: 20),
//                 _buildTableContainer(context, state),
//                 const SizedBox(height: 20),
//                 _buildPaginationControls(state),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildTableContainer(BuildContext context, CategoryState state) {
//     return SizedBox(
//       height: MediaQuery.of(context).size.height * 0.6,
//       child: Column(
//         children: [
//           _buildTableHeader(), // 🔹 Encabezado fijo
//           Expanded(child: _buildTableContent(context, state)), // 🔹 Scroll solo en las filas
//         ],
//       ),
//     );
//   }

//   Widget _buildTableHeader() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey[200], // Fondo gris para destacar el encabezado
//         border: const Border(bottom: BorderSide(color: Colors.black, width: 1)),
//       ),
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//       child: Row(
//         children: const [
//           SizedBox(width: 80, child: Text("Image", style: TextStyle(fontWeight: FontWeight.bold))),
//           Expanded(child: Text("Name", style: TextStyle(fontWeight: FontWeight.bold))),
//           Expanded(child: Text("Description", style: TextStyle(fontWeight: FontWeight.bold))),
//           SizedBox(width: 60, child: Text("Edit", style: TextStyle(fontWeight: FontWeight.bold))),
//           SizedBox(width: 60, child: Text("Delete", style: TextStyle(fontWeight: FontWeight.bold))),
//           SizedBox(width: 60, child: Text("Option", style: TextStyle(fontWeight: FontWeight.bold))),
//         ],
//       ),
//     );
//   }

//   Widget _buildTableContent(BuildContext context, CategoryState state) {
//     if (state.loading) {
//       return const Center(child: CircularProgressIndicator(color: Colors.blue));
//     }

//     if (state.listCategory.isEmpty) {
//       return const Center(
//         child: Padding(
//           padding: EdgeInsets.symmetric(vertical: 20.0),
//           child: Text(
//             "No categories available",
//             style: TextStyle(color: Colors.grey, fontSize: 16),
//           ),
//         ),
//       );
//     }

//     // Obtener las categorías de la página actual
//     int startIndex = currentPage * rowsPerPage;
//     int endIndex = (startIndex + rowsPerPage) > state.listCategory.length
//         ? state.listCategory.length
//         : (startIndex + rowsPerPage);
//     List<CategoryData> currentCategories = state.listCategory.sublist(startIndex, endIndex);

//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: DataTable(
//         columnSpacing: 30,
//         dataRowHeight: 70,
//         headingRowHeight: 50,
//         horizontalMargin: 20,
//         columns: const [
//           DataColumn(label: Text("Image")),
//           DataColumn(label: Text("Name")),
//           DataColumn(label: Text("Description")),
//           DataColumn(label: Text("Edit")),
//           DataColumn(label: Text("Delete")),
//           DataColumn(label: Text("Option")),
//         ],
//         rows: currentCategories.map((category) => _buildTableRow(context, category)).toList(),
//       ),
//     );
//   }

//   DataRow _buildTableRow(BuildContext context, CategoryData category) {
//     return DataRow(
//       cells: [
//         DataCell(
//           GestureDetector(
//             onTap: () => _handleImageUpdate(context, category.id ?? ''),
//             child: SizedBox(
//               width: 60,
//               height: 60,
//               child: _buildCategoryImage(category.images),
//             ),
//           ),
//         ),
//         DataCell(Text(category.nombre.isNotEmpty ? category.nombre : "Unnamed")),
//         DataCell(
//           Text(category.description?.isNotEmpty == true
//               ? category.description!
//               : "No description"),
//         ),
//         DataCell(
//           IconButton(
//             icon: const Icon(Icons.edit, color: Colors.blue),
//             onPressed: () {},
//           ),
//         ),
//         DataCell(
//           IconButton(
//             icon: const Icon(Icons.delete, color: Colors.red),
//             onPressed: () {},
//           ),
//         ),
//         DataCell(
//           IconButton(
//             icon: const Icon(Icons.arrow_forward_ios, color: Colors.purple),
//             onPressed: () {},
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildPaginationControls(CategoryState state) {
//     int totalPages = (state.listCategory.length / rowsPerPage).ceil();

//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         ElevatedButton(
//           onPressed: currentPage > 0
//               ? () {
//                   setState(() {
//                     currentPage--;
//                   });
//                 }
//               : null,
//           child: const Text("Anterior"),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Text("Página ${currentPage + 1} de $totalPages"),
//         ),
//         ElevatedButton(
//           onPressed: (currentPage + 1) * rowsPerPage < state.listCategory.length
//               ? () {
//                   setState(() {
//                     currentPage++;
//                   });
//                 }
//               : null,
//           child: const Text("Siguiente"),
//         ),
//       ],
//     );
//   }














//   /// 📌 **Manejo seguro de imágenes (ahora circular)**
//   Widget _buildCategoryImage(String? imageUrl) {
//     final fixedUrl = _fixImageUrl(imageUrl);
//     print('Imagen cargada: $fixedUrl');

//     return SizedBox(
//       width: 50,
//       height: 50,
//       child: fixedUrl.isNotEmpty
//           ? ClipOval( // 🔹 Hace la imagen circular
//               child: CachedNetworkImage(
//                 imageUrl: fixedUrl,
//                 fit: BoxFit.cover,
//                 progressIndicatorBuilder: (_, __, progress) => Center(
//                   child: CircularProgressIndicator(
//                     value: progress.progress,
//                     color: Colors.blue,
//                     strokeWidth: 2,
//                   ),
//                 ),
//                 errorWidget: (_, __, ___) => const _PlaceholderIcon(),
//               ),
//             )
//           : const _PlaceholderIcon(),
//     );
//   }

//   /// 📌 **Corrección de URL**
//   String _fixImageUrl(String? url) {
//     if (url == null || url.isEmpty) return ''; 
//     if (url.contains("localhost")) {
//       return url.replaceAll("localhost", "192.168.172.237");
//     }
//     if (!url.startsWith("http")) {
//       return "http://192.168.172.237:8081/$url";
//     }
//     return url;
//   }

//   /// 📌 **Manejo de selección y carga de imagen**
//   Future<void> _handleImageUpdate(BuildContext context, String categoryId) async {
//     debugPrint("📌 Click en la imagen detectado. Iniciando selección de archivo...");

//     try {
//       final result = await FilePicker.platform.pickFiles(
//         type: FileType.image,
//         allowMultiple: false,
//         withData: true,
//       );

//       if (result == null || result.files.isEmpty) {
//         _showSnackBar(context, "No se seleccionó ningún archivo", Colors.orange);
//         return;
//       }

//       final file = result.files.first;
//       if (file.bytes == null) {
//         _showSnackBar(context, "No se proporcionó una imagen válida", Colors.red);
//         return;
//       }

//       Uint8List imageBytes = file.bytes!;
//       debugPrint("✅ Archivo seleccionado: ${file.name}");
//       debugPrint("📏 Tamaño: ${imageBytes.length} bytes");
//       debugPrint("🖼 Extensión: ${file.extension}");

//       if (!context.mounted) return;

//       context.read<CategoryBloc>().add(
//             UpdateCategoryImage(
//               categoryId: categoryId,
//               imageBytes: imageBytes,
//               fileName: file.name,
//             ),
//           );

//       _showSnackBar(context, "Imagen actualizada con éxito", Colors.green);
//     } catch (e) {
//       debugPrint("❌ Error crítico: $e");
//       _showSnackBar(context, "Error al seleccionar imagen", Colors.red);
//     }
//   }

//   /// 📌 **Manejo de mensajes de error y éxito**
//   void _showSnackBar(BuildContext context, String message, Color color) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), backgroundColor: color),
//     );
//   }
// }

// /// 📌 **Icono de imagen de respaldo**
// class _PlaceholderIcon extends StatelessWidget {
//   const _PlaceholderIcon();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 50,
//       height: 50,
//       decoration: const BoxDecoration(
//         shape: BoxShape.circle,
//         color: Colors.grey,
//       ),
//       child: const Center(
//         child: Icon(Icons.image_not_supported, color: Colors.white, size: 28),
//       ),
//     );
//   }
// }






// import 'dart:typed_data';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mesa_bloc/app/blocs/category/category_bloc.dart';
// import 'package:mesa_bloc/app/blocs/category/category_state.dart';
// import 'package:mesa_bloc/app/models/modelCategoria/category_data.dart';
// import 'package:mesa_bloc/app/presentation/category/cataegory_edit.dart';
// import 'package:mesa_bloc/app/presentation/category/category_add.dart';
// import 'package:mesa_bloc/app/presentation/category/category_delete.dart';
// //import 'package:mesa_bloc/app/presentation/category/category_delete.dart';
// import 'package:mesa_bloc/app/utils/app_colors.dart';
// //import 'package:mesa_bloc/app/screens/subcategory_screen.dart'; // 🔹 Importa la pantalla de subcategorías

// class CategoryList extends StatefulWidget {
//   const CategoryList({super.key});

//   @override

//   _CategoryListState createState() => _CategoryListState();
// }

// class _CategoryListState extends State<CategoryList> {
//   int currentPage = 0;
//   final int rowsPerPage = 10; // Número de filas por página

//   @override
//   void initState() {
//     context.read<CategoryBloc>().add(GetAllCategory());
//     super.initState();
//   }

//   @override
//  Widget build(BuildContext context) {
//   return BlocBuilder<CategoryBloc, CategoryState>(
//     builder: (context, state) {
//       if (state.error.isNotEmpty) {
//         Future.delayed(Duration.zero, () {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(state.error),
//               backgroundColor: Theme.of(context).primaryColor,
//             ),
//           );
//         });
//       }
//       return Container(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text( "Todas las Catagorias", style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                     fontWeight: FontWeight.bold, color: Colors.black87,
//                 )),

//                 ElevatedButton.icon( style: TextButton.styleFrom( 
//                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12 )),
//                   onPressed: () => CategoryAdd.show(context),
//                   icon: const Icon(Icons.add),
//                   label: const Text("Add New"),
//                 ),
//               ],
//             ),
            
//             const SizedBox(height: 20),
//             _buildTableContainer(context, state),
//             const SizedBox(height: 20),
//             _buildPaginationControls(state),
//           ],
//         ),
//       );
//     },
//   );
// }


//   Widget _buildTableContainer(BuildContext context, CategoryState state) {
//     return SizedBox(
//       height: MediaQuery.of(context).size.height * 0.6,
//       child: Column(
//         children: [
//           _buildTableHeader(), // 🔹 Encabezado fijo
//           Expanded(child: _buildTableContent(context, state)), // 🔹 Scroll solo en las filas
//         ],
//       ),
//     );
//   }

//   Widget _buildTableHeader() {
//   return Container(
//     height: 60,
//     decoration: BoxDecoration(
//       color: AppColor.sideMenu, // Fondo azul
//       borderRadius: const BorderRadius.only(
//         topLeft: Radius.circular(30), // Bordes superiores ovalados
//         topRight: Radius.circular(30),
//       ),
//       border: const Border(bottom: BorderSide(color: Colors.black, width: 1)),
//     ),
//     padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//     child: Row(
//       children: [
//         SizedBox(width: 80, child: Text("", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColor.green))),
//         Expanded(child: Text("NOMBRE", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColor.green))),
//         Expanded(child: Text("DESCRIPCION", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColor.green))),
//         Expanded(child: Text("ESTADO", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColor.green))),
//         SizedBox(width: 60, child: Text("EDIT", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColor.green))),
//         SizedBox(width: 60, child: Text("DELETE", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColor.green))),
//         SizedBox(width: 60, child: Text("", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange))),
//       ],
//     ),
//   );
// }


//   Widget _buildTableContent(BuildContext context, CategoryState state) {
//     if (state.loading) {
//       return const Center(child: CircularProgressIndicator(color: Colors.blue));
//     }

//     if (state.listCategory.isEmpty) {
//       return const Center(
//         child: Padding(
//           padding: EdgeInsets.symmetric(vertical: 20.0),
//           child: Text(
//             "No categories available",
//             style: TextStyle(color: Colors.grey, fontSize: 16),
//           ),
//         ),
//       );
//     }

//     // 🔹 PAGINACIÓN: MOSTRAR SOLO 10 FILAS POR PÁGINA
//     int startIndex = currentPage * rowsPerPage;
//     int endIndex = (startIndex + rowsPerPage) > state.listCategory.length
//         ? state.listCategory.length
//         : (startIndex + rowsPerPage);
//     //int startIndex = currentPage * rowsPerPage;
//     //int endIndex = (startIndex + rowsPerPage).clamp(0, state.listCategory.length);
//      List<CategoryData> currentCategories = state.listCategory.sublist(startIndex, endIndex);

//     return SingleChildScrollView(
//       scrollDirection: Axis.vertical,
//       child: SizedBox(
//         width: MediaQuery.of(context).size.width *1.2,
//         child: ListView.builder(

//           shrinkWrap: true,
//           itemCount: currentCategories.length,
//           itemBuilder: (context, index) {
//             return _buildTableRow(context, currentCategories[index]);
//           }
//         ),
//       ),
//     );
    
//   }

//   Widget _buildTableRow(BuildContext context, CategoryData category) {
//     return Container(
//       decoration: const BoxDecoration(
//         border: Border(bottom: BorderSide(color: Colors.black12)),
//       ),
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//       child: Row(
//         children: [
//           SizedBox(
//             width: 50,
//             child: GestureDetector(
//               onTap: () => _handleImageUpdate(context, category.id ?? ''),
//               child: SizedBox(
//                 width: 50,
//                 height: 50,
//                 child: _buildCategoryImage(category.images),
//               ),
//             ),
//           ),
//           const SizedBox( width: 40),
//           Expanded(child: Text(category.nombre.isNotEmpty ? category.nombre : "Unnamed", 
//             style: TextStyle( fontWeight: FontWeight.bold) ,)),
//           Expanded(
//             child: Text(category.description?.isNotEmpty == true
//                 ? category.description!
//                 : "No description"),
//           ),

//           const SizedBox(width: 5),
//           Expanded(child: Icon(category.activo ? Icons.toggle_off : Icons.toggle_on,
//             color:  category.activo ? AppColor.blueLight : AppColor.primaryColor,
//             size: 35,
//           )),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 40),
//             child: SizedBox(
//               width: 40,
//               child: IconButton(
//                 icon: Icon(Icons.edit, color: AppColor.blueDark),
//                 onPressed: () {
//                   showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return EditCategoryDialog(category: category);
//                 },
//               );
//                 },
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: SizedBox(
//               width: 40,
//               child: IconButton(
//                 icon: const Icon(Icons.delete, color: Colors.red),
//                 onPressed: () {
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//             return DeleteCategoryDialog(categoryId: category.id ?? '');
//                     },
//                   );
//                 },
//               ),
//             ),
//           ),

//           SizedBox(
//             width: 40,
//             child: IconButton(
//               icon: const Icon(Icons.arrow_forward_ios, color: Colors.purple),
//               onPressed: () {
                
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPaginationControls(CategoryState state) {
//   int totalPages = (state.listCategory.length / rowsPerPage).ceil();

//   return Row(
//     mainAxisAlignment: MainAxisAlignment.start,
//     children: [
//       TextButton(
//         onPressed: currentPage > 0
//             ? () {
//                 setState(() {
//                   currentPage--;
//                 });
//               }
//             : null,
//         child: Text(
//           "Anterior",
//           style: TextStyle(
//             color: currentPage > 0 ? AppColor.sideMenu : Colors.grey,
//           ),
//         ),
//       ),
//       Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 0),
//         child: Container(
//           width: 35,
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: AppColor.sideMenu,
//             borderRadius: BorderRadius.circular(30),
//           ),
//           child: Text(
//             "${currentPage + 1}",
//             style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ),
//       TextButton(
//         onPressed: (currentPage + 1) * rowsPerPage < state.listCategory.length
//             ? () {
//                 setState(() {
//                   currentPage++;
//                 });
//               }
//             : null,
//         child: Text(
//           "Siguiente",
//           style: TextStyle(
//             color: (currentPage + 1) * rowsPerPage < state.listCategory.length ? AppColor.sideMenu : Colors.grey,
//           ),
//         ),
//       ),
//       Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 80),
//         child: Text("Página ${currentPage + 1} de $totalPages"),
//       ),
//     ],
//   );
// }


















//   /// 📌 **Manejo seguro de imágenes (ahora circular)**
//   Widget _buildCategoryImage(String? imageUrl) {
//   final fixedUrl = _fixImageUrl(imageUrl);
//   print('Imagen cargada: $fixedUrl');

//   return SizedBox(
//     width: 50, // Asegura que el contenedor sea de 50x50
//     height: 50,
//     child: fixedUrl.isNotEmpty
//         ? ClipRRect(
//             borderRadius: BorderRadius.circular(25), // 🔹 Hace la imagen redonda sin deformarla
//             child: CachedNetworkImage(
//               imageUrl: fixedUrl,
//               width: 50,
//               height: 50,
//               fit: BoxFit.cover, // Asegura que la imagen cubra el contenedor sin distorsión
//               progressIndicatorBuilder: (_, __, progress) => Center(
//                 child: CircularProgressIndicator(
//                   value: progress.progress,
//                   color: Colors.blue,
//                   strokeWidth: 2,
//                 ),
//               ),
//               errorWidget: (_, __, ___) => const _PlaceholderIcon(),
//             ),
//           )
//         : const _PlaceholderIcon(),
//   );
// }



//   /// 📌 **Corrección de URL**
//   String _fixImageUrl(String? url) {
//     if (url == null || url.isEmpty) return ''; 
//     if (url.contains("localhost")) {
//       return url.replaceAll("localhost", "192.168.9.237");
//     }
//     if (!url.startsWith("http")) {
//       return "http://192.168.9.237:8081/$url";
//     }
//     return url;
//   }

//   /// 📌 **Manejo de selección y carga de imagen**
//   Future<void> _handleImageUpdate(BuildContext context, String categoryId) async {
//     debugPrint("📌 Click en la imagen detectado. Iniciando selección de archivo...");

//     try {
//       final result = await FilePicker.platform.pickFiles(
//         type: FileType.image,
//         allowMultiple: false,
//         withData: true,
//       );

//       if (result == null || result.files.isEmpty) {
//         _showSnackBar(context, "No se seleccionó ningún archivo", Colors.orange);
//         return;
//       }

//       final file = result.files.first;
//       if (file.bytes == null) {
//         _showSnackBar(context, "No se proporcionó una imagen válida", Colors.red);
//         return;
//       }

//       Uint8List imageBytes = file.bytes!;
//       debugPrint("✅ Archivo seleccionado: ${file.name}");
//       debugPrint("📏 Tamaño: ${imageBytes.length} bytes");
//       debugPrint("🖼 Extensión: ${file.extension}");

//       if (!context.mounted) return;

//       context.read<CategoryBloc>().add(
//             UpdateCategoryImage(
//               categoryId: categoryId,
//               imageBytes: imageBytes,
//               fileName: file.name,
//             ),
//           );

//       _showSnackBar(context, "Imagen actualizada con éxito", Colors.green);
//     } catch (e) {
//       debugPrint("❌ Error crítico: $e");
//       _showSnackBar(context, "Error al seleccionar imagen", Colors.red);
//     }
//   }

//   /// 📌 **Manejo de mensajes de error y éxito**
//   void _showSnackBar(BuildContext context, String message, Color color) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), backgroundColor: color),
//     );
//   }
// }

// /// 📌 **Icono de imagen de respaldo**
// class _PlaceholderIcon extends StatelessWidget {
//   const _PlaceholderIcon();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 50,
//       height: 50,
//       decoration: const BoxDecoration(
//         shape: BoxShape.circle,
//         color: Colors.grey,
//       ),
//       child: const Center(
//         child: Icon(Icons.image_not_supported, color: Colors.white, size: 28),
//       ),
//     );
//   }
// }
