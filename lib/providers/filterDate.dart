import 'package:flutter/cupertino.dart';


class FilterDate {
   static int year = DateTime.now().year;
   static int month = DateTime.now().month;
}


// class FilterDate{
//
//    int year = DateTime.now().year;
//    int month = DateTime.now().month;
//    FilterDate({this.year, required this.month});
//   //
//   // getFilterContext(){
//   //   return{'year': year, 'month': month};
//   // }
//   // setFilerContext({required int year,required int month}){
//   //   print("before Class");
//   //   print(this.year);
//   //   print(this.month);
//   //   this.year = year;
//   //   this.month = month;
//   //   print("from Class");
//   //   print(this.year);
//   //   print(this.month);
//   // }
//
//
// }