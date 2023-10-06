// providers.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model.dart';

class ProjectProvider extends ChangeNotifier {
  ProjectDetails projectDetails =
      ProjectDetails(projectName: '', clientAddress: '');

  double get totalUnitPrice {
    double totalPrice = 0;
    for (var item in projectDetails.items) {
      totalPrice += item.unitPrice;
    }
    return totalPrice;
  }

  final List<ProjectItem> _projectItems = [];
  List<ProjectItem> get projectItems => _projectItems;

  void addProjectItems(ProjectItem projectItem) {
    _projectItems.add(projectItem);
    notifyListeners(); // Notify listeners when the data changes
  }

  void addProjectItem(ProjectItem item) {
    projectDetails.items.add(item);
    notifyListeners();
  }

  int _counter = 0;

  int get counter => _counter;

  void incrementCounter() {
    _counter++;
    notifyListeners();
  }

  // Other methods for updating project details
  int taxableCount = 0;
  int nonTaxableCount = 0;

  Future<void> loadCounts() async {
    final prefs = await SharedPreferences.getInstance();
    taxableCount = prefs.getInt('taxableCount') ?? 0;
    nonTaxableCount = prefs.getInt('nonTaxableCount') ?? 0;
    notifyListeners();
  }

  Future<void> saveCounts() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('taxableCount', taxableCount);
    prefs.setInt('nonTaxableCount', nonTaxableCount);
  }

  void incrementTaxableCount() {
    taxableCount++;
    notifyListeners();
    saveCounts(); // Save counts when they change
  }

  void incrementNonTaxableCount() {
    nonTaxableCount++;
    notifyListeners();
    saveCounts(); // Save counts when they change
  }

  bool _isLibraryBooksSelected = false;
  bool _isAccessTimeSelected = false;

  bool get isLibraryBooksSelected => _isLibraryBooksSelected;
  bool get isAccessTimeSelected => _isAccessTimeSelected;

  void selectLibraryBooks() {
    _isLibraryBooksSelected = true;
    _isAccessTimeSelected = false;
    notifyListeners();
  }

  void selectAccessTime() {
    _isLibraryBooksSelected = false;
    _isAccessTimeSelected = true;
    notifyListeners();
  }

  String name = '';
  String nickname = '';
  String age = '';
  String projectName = '';
  String recipient = '';
  String hsn = '998311';
  String description = '';
  String hrsOrQty = '';
  String unitPrice = '';
}
