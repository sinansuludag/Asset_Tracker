import 'package:flutter/material.dart';

class CurrencyAssetScreen extends StatefulWidget {
  const CurrencyAssetScreen({super.key});

  @override
  State<CurrencyAssetScreen> createState() => _CurrencyAssetScreenState();
}

class _CurrencyAssetScreenState extends State<CurrencyAssetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Varlıklarım'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Varlıklarım'),
      ),
    );
  }
}
