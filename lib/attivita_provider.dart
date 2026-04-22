import 'package:flutter/material.dart';

class AttivitaProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _listaDati = [];
  List<Map<String, dynamic>> get listaDati => _listaDati;

  void aggiungiDato(Map<String, dynamic> dato) {
    _listaDati.add(dato);
    notifyListeners();
  }
}