import 'package:flutter/material.dart';

import 'package:flutter_app/models/quote.dart';

import '../services/quotes_service.dart';
import '../widgets/quote_dialog.dart';

import 'quotes_screen.dart';
import 'random_quote_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;
  final QuotesService _quotesService = QuotesService();

  // Use a GlobalKey to access the QuotesScreen state
  final GlobalKey<QuotesScreenState> _quotesScreenKey = GlobalKey();

  // Modified to pass the key to QuotesScreen
  late final List<Widget> _screens = [
    QuotesScreen(key: _quotesScreenKey),
    const RandomQuoteScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Function to handle saving a new quote
  Future<void> _addQuote(Quote quote) async {
    await _quotesService.addQuote(quote);
    // Refresh the quotes list in QuotesScreen
    _quotesScreenKey.currentState?.refreshQuotes();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Zitat erfolgreich hinzugefügt')),
    );
  }

  // Show the dialog to add a new quote
  void _showAddQuoteDialog() {
    showDialog(
      context: context,
      builder: (context) => QuoteDialog(onSave: _addQuote),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CineLines'), centerTitle: true),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.format_quote),
            label: 'Zitate',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Zufällig'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: _showAddQuoteDialog,
              tooltip: 'Zitat hinzufügen',

              child: const Icon(Icons.add, semanticLabel: "Zitat hinzufügen"),
            )
          : null, // Only show FAB on the Quotes screen
    );
  }
}
