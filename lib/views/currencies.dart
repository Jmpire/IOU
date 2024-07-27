import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'package:projectx/main.dart';
import 'package:projectx/res/key.dart';
import 'package:projectx/values/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyListScreen extends StatefulWidget {
  const CurrencyListScreen({super.key});

  @override
  State<CurrencyListScreen> createState() => _CurrencyListScreenState();
}

class _CurrencyListScreenState extends State<CurrencyListScreen> {
  late Future<Map<String, dynamic>> futureCurrencies;
  Map<String, dynamic>? currencies;
  List<Map<String, dynamic>> filteredCurrencies = [];
  String selectedCurrency = MainApp.selectedAppCurrency;
  bool showSearchBar = true;
  bool isScrollingDown = false;
  TextEditingController searchController = TextEditingController();
  late ScrollController _scrollViewController;

  @override
  void initState() {
    super.initState();
    futureCurrencies = fetchCurrencies();
    _scrollViewController = ScrollController();
    _scrollViewController.addListener(_scrollListener);
    searchController.addListener(_filterCurrencies);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterCurrencies);
    searchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollViewController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (!isScrollingDown) {
        setState(() {
          isScrollingDown = true;
          showSearchBar = false;
        });
      }
    } else if (_scrollViewController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (isScrollingDown) {
        setState(() {
          isScrollingDown = false;
          showSearchBar = true;
        });
      }
    }
  }

  Future<Map<String, dynamic>> fetchCurrencies() async {
    final response = await get(
      Uri.parse('https://api.freecurrencyapi.com/v1/currencies?apikey=$key'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      setState(() {
        currencies = data['data'] as Map<String, dynamic>;
        filteredCurrencies = currencies!.entries
            .map((e) => {'code': e.key, ...e.value as Map<String, dynamic>})
            .toList();
      });
      return data;
    } else {
      throw Exception('Failed to load currencies');
    }
  }

  void _filterCurrencies() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredCurrencies = currencies!.entries
          .where((entry) =>
              entry.key.toLowerCase().contains(query) ||
              (entry.value['name'] as String).toLowerCase().contains(query))
          .map((e) => {'code': e.key, ...e.value as Map<String, dynamic>})
          .toList();
    });
  }

  void _onCurrencySelected(String currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedCurrency', currency);
    setState(() {
      selectedCurrency = currency;
      MainApp.selectedAppCurrency = currency;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.appBackgroundColor,
        appBar: AppBar(
          title: const Text('Select App Currency',
              style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: AppColors.background,
          surfaceTintColor: AppColors.background,
        ),
        body: SafeArea(
            child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              child: Container(
                height: showSearchBar ? 70 : 0,
                padding: const EdgeInsets.all(8.0),
                child: showSearchBar? TextField(
                  style: TextStyle(color: AppColors.blackText),
                  controller: searchController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0)),
                    labelText: 'Search',
                    labelStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0)),
                    prefixIcon:const Icon(Icons.search, color: Colors.grey,),
                  ),
                ): Container(),
              ),
            ),
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: futureCurrencies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: AppColors.background,
                    ));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('${snapshot.error}'));
                  } else if (!snapshot.hasData || currencies == null) {
                    return const Center(child: Text('No data found'));
                  }

                  return ListView.builder(
                    controller: _scrollViewController,
                    itemCount: filteredCurrencies.length,
                    itemBuilder: (context, index) {
                      final currency = filteredCurrencies[index];
                      return ListTile(
                        title: Text('${currency['code']}', style: TextStyle(color: AppColors.blackText),),
                        selectedColor: AppColors.orange,
                        subtitle:
                            Text('${currency['name']} (${currency['symbol']})', style: const TextStyle(color: Colors.grey),),
                        onTap: () => _onCurrencySelected(currency['code']),
                        selected: selectedCurrency == currency['code'],
                      );
                    },
                  );
                },
              ),
            ),
            if (selectedCurrency.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Selected Currency: $selectedCurrency',
                    style: const TextStyle(color: Colors.green)),
              ),
          ],
        )));
  }
}
