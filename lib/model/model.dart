// models.dart
class ProjectDetails {
  String projectName;
  String clientAddress;
  List<ProjectItem> items = [];

  ProjectDetails({required this.projectName, required this.clientAddress});
}

class ProjectItem {
  String description;
  double hours;
  double unitPrice;

  ProjectItem({
    required this.description,
    required this.hours,
    required this.unitPrice,
  });
}

class ReportData {
  final String projectName;
  final String clientAddress;
  final List<ProjectItem> projectItems; // Assuming you have a ProjectItem class

  ReportData({
    required this.projectName,
    required this.clientAddress,
    required this.projectItems,
  });
}
