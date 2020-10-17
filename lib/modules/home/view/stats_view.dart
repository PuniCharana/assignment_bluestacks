import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StatsView extends StatelessWidget {
  StatsView(this._stats, this._statsCategory, this._gradient);

  final String _stats;
  final String _statsCategory;
  final LinearGradient _gradient;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 90,
        decoration: BoxDecoration(gradient: _gradient),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              _stats,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Text(
              _statsCategory,
              style: TextStyle(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
