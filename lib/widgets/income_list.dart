import '../widgets/delete_confim.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/income_provider.dart';
import '../screens/add_income.dart';
import 'animated_expention.dart';
import 'package:readmore/readmore.dart';

class IncomeItemListWidget extends StatelessWidget {
  const IncomeItemListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Provider.of<IncomeProvider>(context,  listen: false).loadItems();
    print("rebuild w-------------");

    var incomeProvider = Provider.of<IncomeProvider>(context, listen: true);
    // incomeProvider.loadItems();
    onEdit(IncomeType income) {
      // Navigator.of(context).push(AddIncomeScreen(income: income));
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AddIncomeScreen(income: income),
        ),
      );
    }

    onDelete(item) {
      incomeProvider.removeItem(item);
    }

    List<IncomeType> items = incomeProvider.items;


    return incomeProvider.isLoading? Container(
      height: MediaQuery.of(context).size.height * 0.5,
        color: Colors.white,
        child: Center(
          child: SpinKitSpinningLines(
            color: Theme.of(context).colorScheme.secondary,
            size: 60.0,
          ),
        ),) :
        incomeProvider.itemCount==0?  SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [


              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: (){
                    Navigator.of(context).pushNamed(AddIncomeScreen.routeName);
                  },
                      child: Row(
                    children: [
                      const Icon(Icons.add, size: 40,),
                      Text("Add Income"),
                    ],
                  ))
                ],
              ),
              const SizedBox(height: 20),
              Text("No income found in this month",
                  softWrap: true, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54)),
            ],
          ),
        ):
     ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: items.length,
      // itemCount: incomeProvider.itemCount,
      itemBuilder: (context, index) {
        IncomeType item = items[index];
        return Dismissible(
          key: Key("${item.id}"),
          direction: DismissDirection.horizontal,
          onDismissed: (direction) {
            // incomeProvider.removeItem(item);
            onDelete(item);
          },
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                    "Delete warning",
                    style: TextStyle(color: Colors.red),
                  ),
                  content:
                      const Text("Are you sure you want to delete this item?"),
                  actions: <Widget>[
                    TextButton(
                      child: const Text("No"),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    TextButton(
                      child: const Text("Yes"),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                );
              },
            );
          },
          background: Container(
            color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          secondaryBackground: Container(
            color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          child: AnimatedExpansionTile(title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${item.source} "),
              const SizedBox(width:10),
              Text("${item.amount} ৳", style: TextStyle().copyWith(color: Theme.of(context).colorScheme.primary),),
            ],
          ), body: Container(

            // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Expanded(
                      flex: 2,
                      child: Text(
                        "Source",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Text(":  ${item.source}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Expanded(
                        child: PopupMenuButton(
                          iconSize: 20,
                          tooltip: "tap for edit or delete",
                          padding: EdgeInsets.zero,
                          onSelected: (value) async {
                            if (value == '1') {
                              onEdit(item);
                            } else {
                              if (await showDeleteWarning(context)) {
                                onDelete(item);
                              }
                            }
                          },
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                  value: '1',
                                  // child: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary, )
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary,
                                    ),
                                    onPressed: null,
                                  )),
                              PopupMenuItem<String>(
                                  value: '2',
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color:
                                      Theme.of(context).colorScheme.error,
                                    ),
                                    onPressed: null,
                                  )
                                // child: Icon(Icons.delete, color: Theme.of(context).colorScheme.error, )
                              )
                            ];
                          },
                        )),
                  ],
                ),
                // Row(
                //
                //   children: [
                //     const Expanded(
                //       flex: 2,
                //       child: Text(
                //         "Source:",
                //         style: TextStyle(
                //           fontSize: 14,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ),
                //     Expanded(
                //       flex: 8,
                //       child: Text(
                //         item.source,
                //         style: const TextStyle(
                //           fontSize: 14,
                //           fontWeight: FontWeight.normal,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 8),
                Row(
                  children: [
                    const Expanded(
                      flex: 2,
                      child: Text(
                        "Amount",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,

                      child: Text(
                        ":  ${item.amount} ৳",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Expanded(
                      flex: 2,
                      child: Text(
                        "Date",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(":  ${DateFormat.yMMMd().format(item.dateTime)}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Expanded(
                      flex: 2,
                      child: Text(
                        "Time",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(":  ${DateFormat('hh:mm a').format(item.dateTime)}"
                        ,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(":",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

            ReadMoreText(
              item.description,
              trimLines: 2,
              colorClickableText: Colors.redAccent,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'Show more',
              trimExpandedText: '   Show less',
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
                // Text(
                //   item.description,
                //   style: const TextStyle(
                //     fontSize: 14,
                //   ),
                // ),
              ],
            ),
          ),),
          // child: Card(
          //   elevation: 0,
          //   child: ExpansionTile(
          //
          //     // expandedAlignment: Alignment.topLeft,
          //     title: Row(
          //       children: [
          //         Text("${item.source} "),
          //         const SizedBox(width: 10),
          //         Text("৳${item.amount}"),
          //       ],
          //     ),
          //     children: [
          //       Padding(
          //         padding:
          //             const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Row(
          //               mainAxisAlignment: MainAxisAlignment.end,
          //               children: [
          //                 const Expanded(
          //                   flex: 2,
          //                   child: Text(
          //                     "Source",
          //                     style: TextStyle(
          //                       fontSize: 14,
          //                       fontWeight: FontWeight.bold,
          //                     ),
          //                   ),
          //                 ),
          //                 Expanded(
          //                   flex: 6,
          //                   child: Text(":  ${item.source}",
          //                     style: const TextStyle(
          //                       fontSize: 14,
          //                       fontWeight: FontWeight.normal,
          //                     ),
          //                   ),
          //                 ),
          //                 Expanded(
          //                   child: PopupMenuButton(
          //                   iconSize: 20,
          //                   tooltip: "tap for edit or delete",
          //                   padding: EdgeInsets.zero,
          //                   onSelected: (value) async {
          //                     if (value == '1') {
          //                       onEdit(item);
          //                     } else {
          //                       if (await showDeleteWarning(context)) {
          //                         onDelete(item);
          //                       }
          //                     }
          //                   },
          //                   itemBuilder: (context) {
          //                     return [
          //                       PopupMenuItem(
          //                           value: '1',
          //                           // child: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary, )
          //                           child: IconButton(
          //                             icon: Icon(
          //                               Icons.edit,
          //                               color: Theme.of(context)
          //                                   .colorScheme
          //                                   .primary,
          //                             ),
          //                             onPressed: null,
          //                           )),
          //                       PopupMenuItem<String>(
          //                           value: '2',
          //                           child: IconButton(
          //                             icon: Icon(
          //                               Icons.delete,
          //                               color:
          //                                   Theme.of(context).colorScheme.error,
          //                             ),
          //                             onPressed: null,
          //                           )
          //                           // child: Icon(Icons.delete, color: Theme.of(context).colorScheme.error, )
          //                           )
          //                     ];
          //                   },
          //                 )),
          //               ],
          //             ),
          //             // Row(
          //             //
          //             //   children: [
          //             //     const Expanded(
          //             //       flex: 2,
          //             //       child: Text(
          //             //         "Source:",
          //             //         style: TextStyle(
          //             //           fontSize: 14,
          //             //           fontWeight: FontWeight.bold,
          //             //         ),
          //             //       ),
          //             //     ),
          //             //     Expanded(
          //             //       flex: 8,
          //             //       child: Text(
          //             //         item.source,
          //             //         style: const TextStyle(
          //             //           fontSize: 14,
          //             //           fontWeight: FontWeight.normal,
          //             //         ),
          //             //       ),
          //             //     ),
          //             //   ],
          //             // ),
          //             // const SizedBox(height: 8),
          //             Row(
          //               children: [
          //                 const Expanded(
          //                   flex: 2,
          //                   child: Text(
          //                     "Amount",
          //                     style: TextStyle(
          //                       fontSize: 14,
          //                       fontWeight: FontWeight.bold,
          //                     ),
          //                   ),
          //                 ),
          //                 Expanded(
          //                   flex: 7,
          //
          //                   child: Text(
          //                     ":  ${item.amount}",
          //                     style: const TextStyle(
          //                       fontSize: 14,
          //                       fontWeight: FontWeight.normal,
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //             const SizedBox(height: 8),
          //             Row(
          //               children: [
          //                 const Expanded(
          //                   flex: 2,
          //                   child: Text(
          //                     "Date",
          //                     style: TextStyle(
          //                       fontSize: 14,
          //                       fontWeight: FontWeight.bold,
          //                     ),
          //                   ),
          //                 ),
          //                 Expanded(
          //                   flex: 7,
          //                   child: Text(":  ${DateFormat.yMMMd().format(item.dateTime)}",
          //                     style: const TextStyle(
          //                       fontSize: 14,
          //                       fontWeight: FontWeight.normal,
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //             const SizedBox(height: 8),
          //             Row(
          //               children: [
          //                 const Expanded(
          //                   flex: 2,
          //                   child: Text(
          //                     "Time",
          //                     style: TextStyle(
          //                       fontSize: 14,
          //                       fontWeight: FontWeight.bold,
          //                     ),
          //                   ),
          //                 ),
          //                 Expanded(
          //                   flex: 7,
          //                   child: Text(":  ${DateFormat('hh:mm a').format(item.dateTime)}"
          //                     ,
          //                     style: const TextStyle(
          //                       fontSize: 14,
          //                       fontWeight: FontWeight.normal,
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //             const SizedBox(height: 8),
          //             Row(
          //               children: const [
          //                  Expanded(
          //                    flex: 2,
          //                    child: Text(
          //                     "Description",
          //                     style: TextStyle(
          //                       fontSize: 14,
          //                       fontWeight: FontWeight.bold,
          //                     ),
          //                 ),
          //                  ),
          //                 Expanded(
          //                   flex: 7,
          //                    child: Text(":",
          //                     style: TextStyle(
          //                       fontSize: 14,
          //                       fontWeight: FontWeight.normal,
          //                     ),
          //                 ),
          //                  ),
          //               ],
          //             ),
          //
          //             const SizedBox(height: 8),
          //             Text(
          //               item.description,
          //               style: const TextStyle(
          //                 fontSize: 14,
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        );
      }, separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10),
    );
  }
}
