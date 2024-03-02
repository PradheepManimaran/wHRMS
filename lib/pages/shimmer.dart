
// import 'package:flutter/material.dart';

// class Shimmer{
//    Widget _buildShimmerLoading() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         const SizedBox(height: 10.0),
//         _buildCircularShimmerLoading(),
//         _buildShimmerLoadingRow(),
//         _buildShimmerLoadingRow(),
//         _buildShimmerLoadingRow(),
//         _buildShimmerLoadingRow(),
//         _buildShimmerLoadingRow(),
//         _buildShimmerLoadingRow(),
//       ],
//     );
//   }

//    Widget _buildCircularShimmerLoading() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
//       height: 120,
//       child: Shimmer.fromColors(
//         baseColor: Colors.grey[300]!,
//         highlightColor: Colors.grey[100]!,
//         period: const Duration(seconds: 1),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircleAvatar(
//               backgroundColor: Colors.grey[100]!,
//               radius: 60,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//    Widget _buildShimmerLoadingRow() {
//     return SizedBox(
//       height: 120,
//       child: Card(
//         elevation: 1,
//         margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
//         child: Row(
//           children: [
//             SizedBox(
//               width: 120,
//               child: CircleAvatar(
//                 backgroundColor: Colors.grey[100]!,
//                 radius: 40,
//               ),
//             ),
//             Expanded(
//               child: ListTile(
//                 title: Container(
//                   color: Colors.white,
//                   height: 16,
//                 ),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       color: Colors.white,
//                       height: 16,
//                     ),
//                     Container(
//                       color: Colors.white,
//                       height: 14,
//                     ),
//                     Container(
//                       color: Colors.white,
//                       height: 14,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }