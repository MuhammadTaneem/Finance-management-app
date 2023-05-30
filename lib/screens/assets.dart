import 'package:cash_flow/providers/assets_provider.dart';
import 'package:cash_flow/screens/add_assets.dart';
import 'package:cash_flow/widgets/deposite_list.dart';
import 'package:cash_flow/widgets/lent_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/investment_list.dart';

class AssetsScreen extends StatefulWidget {
  const AssetsScreen({Key? key}) : super(key: key);
  static const routeName = '/assets';

  @override
  _AssetsScreenState createState() => _AssetsScreenState();
}

class _AssetsScreenState extends State<AssetsScreen>
    with SingleTickerProviderStateMixin {
  int _expandedTileIndex = -1; // -1 indicates no tile is expanded
  late AnimationController _animationController;
  late Animation<double> _animation;
  final List<Widget> _widgets = [ const InvestmentList(), const DepositList(), const LentList() ];
  final GlobalKey<RefreshIndicatorState> _refreshAssetIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
      reverseCurve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion(int tileIndex) {
    setState(() {
      if (_expandedTileIndex == tileIndex) {
        _expandedTileIndex = -1; // Close the current tile
        _animationController.reverse(); // Reverse the animation
      } else {
        _expandedTileIndex = tileIndex; // Open a different tile
        _animationController.forward(); // Play the animation
      }
    });
  }

  decorationFunc(index, context){
    return _expandedTileIndex == index
        ?BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 1.0,
        ),
      ),
      // borderRadius: BorderRadius.only(t)
      color: Colors.grey[100],
    ): BoxDecoration(
      color: Colors.grey[100],
    );
  }
  Future<void> _refreshPage() async {
    await Provider.of<AssetsProvider>(context, listen: false).loadItems();
  }

  Widget _buildTile(int index) {
    List<Item> _items = Provider.of<AssetsProvider>(context, listen: true).totalAmount;
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            _toggleExpansion(index);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),

          decoration: decorationFunc(index,context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [

                    Text(_items[index].name),
                    const SizedBox(height: 1, width: 10,),
                    Text("${_items[index].amount} ৳", style: TextStyle().copyWith(color: Theme.of(context).colorScheme.primary),),
                    // Text("${_items[index].amount}"),
                  ],
                ),
                _expandedTileIndex == index
                    ? const Icon(
                  Icons.expand_less,
                  color: Colors.teal,
                )
                    : Icon(
                  Icons.expand_circle_down_rounded,
                  color: Colors.grey[700],
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 400),
          // vsync: this,
          child: Container(
            color: Colors.grey[200],
            child: _expandedTileIndex == index
                ? _widgets[index]
                : SizedBox.shrink(),
          ),
        ),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool showFAB = true;
    return RefreshIndicator(
      key: _refreshAssetIndicatorKey,
      onRefresh: _refreshPage,
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            return _buildTile(index);
          },
        ),
      ),
    );
  }
}
