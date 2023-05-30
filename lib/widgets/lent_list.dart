import 'package:cash_flow/widgets/animated_expention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

import '../providers/assets_provider.dart';
import '../screens/add_assets.dart';
import 'delete_confim.dart';

class LentList extends StatelessWidget {
  const LentList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("rebuild w-------------");
    var assetsProvider = Provider.of<AssetsProvider>(context, listen: true);
    onEdit(AssetsType assets) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AddAssetsScreen(assets: assets),
        ),
      );
    }

    onDelete(item) {
      assetsProvider.removeItem(item);
    }

    List<AssetsType> items = assetsProvider.lentsItems;

    return assetsProvider.isLoading? Container(
      height: MediaQuery.of(context).size.height * 0.5,
      color: Colors.white,
      child: Center(
        child: SpinKitSpinningLines(
          color: Theme.of(context).colorScheme.secondary,
          size: 60.0,
        ),
      ),) :
    assetsProvider.lentItemCount ==0?  SizedBox(
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
                Navigator.of(context).pushNamed(AddAssetsScreen.routeName);
              },
                  child: Row(
                    children: const [
                      Icon(Icons.add, size: 40,),
                      Text("Add Asset"),
                    ],
                  ))
            ],
          ),
          const SizedBox(height: 20),
          Text("No asset added",
              softWrap: true, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54)),
        ],
      ),
    ): ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: assetsProvider.lentItemCount,
      itemBuilder: (BuildContext context, int index) {
        var item = items[index];
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
          child: AnimatedExpansionTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${item.name.length>20? item.name.substring(0, 20): item.name} "),
                const SizedBox(width:10),
                Text("${item.amount} ৳", style: TextStyle().copyWith(color: Theme.of(context).colorScheme.primary),),
              ],
            ),
            body: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.03,
                ),
              ),
              elevation: 0,
              margin: const EdgeInsets.only(top: 0, bottom: 0, right: 10, left: 10),
              child: Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Expanded(
                            flex: 2,
                            child: Text(
                              "Name",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Text(":  ${item.name}",
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
                            flex: 5,

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
                            flex: 5,
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
                            flex: 5,
                            child: Text(":  ${DateFormat('hh:mm a').format(item.dateTime)}",
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
                            flex: 5,
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
                    ],
                  )
              ),
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Container(height: 10,color: Colors.white,);
      },

    );
  }
}
