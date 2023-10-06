import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:invoice_generator/model/model.dart';
import 'package:invoice_generator/model/providernot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../home/home.dart';

class ProjectDetailsScreen extends StatefulWidget {
  const ProjectDetailsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProjectDetailsScreenState createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProjectProvider>().loadCounts();
  }

  String selectedValue = 'Select from the list'; // Initially selected value
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now(); // Initially selected date
  String projectName = '';
  String clientAddress = '';
  String _description = '';
  double _hours = 0;
  double _unitPrice = 0;
  bool isLibraryBooksSelected = false;
  bool isAccessTimeSelected = true;
  TextEditingController projectNameController = TextEditingController();
  TextEditingController clientAddressController = TextEditingController();
  TextEditingController gstNoController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController hoursController = TextEditingController();
  TextEditingController unitPriceController = TextEditingController();

  List<TextEditingController> listController = [TextEditingController()];
  double discountRate = 0.12; // 12% discount

  bool isQty = false;

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);
    final countNotifier = context.watch<ProjectProvider>();
    final iconSelectionProvider = Provider.of<ProjectProvider>(context);

    double subtotal = projectProvider.totalUnitPrice;
    double discountAmount = subtotal * discountRate;
    double total = subtotal - discountAmount;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Create Invoice",
                      style: TextStyle(fontSize: 20),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "CANCEL",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () => _selectDate(context),
                      child: Text(
                        "${selectedDate.toLocal()}"
                            .split(' ')[0], // Display selected date
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Container(
                    height: 150,
                    width: 380,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [Text("GSTIN:"), Text("Invoice:")],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("27AXIPT8068J1ZM"),
                                Text("#0${countNotifier.nonTaxableCount}")
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text("HSN No."),
                            Center(
                              child: SizedBox(
                                width: 100,
                                child: Center(
                                  child: DropdownButtonFormField<String>(
                                    decoration:
                                        const InputDecoration(labelText: ''),
                                    value: Provider.of<ProjectProvider>(context)
                                        .hsn,
                                    onChanged: (value) {
                                      Provider.of<ProjectProvider>(context,
                                              listen: false)
                                          .hsn = value!;
                                    },
                                    items: <String>[
                                      '998314',
                                      '998313',
                                      '998311'
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Container(
                    width: 380,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [Text("Project Details")],
                            ),
                            TextFormField(
                              controller: projectNameController,
                              decoration: const InputDecoration(
                                  labelText: 'Project Name'),
                              onChanged: (value) {
                                setState(() {
                                  projectName = value;
                                });
                              },
                            ),
                            TextFormField(
                              controller: clientAddressController,
                              decoration: const InputDecoration(
                                  labelText: "Client's Address"),
                              onChanged: (value) {
                                setState(() {
                                  clientAddress = value;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [Text("GST No.")],
                            ),
                            TextFormField(
                              decoration: const InputDecoration(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 30,
                      width: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.black),
                        color: iconSelectionProvider.isLibraryBooksSelected
                            ? Colors.grey
                            : Colors.white,
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isQty =
                                !isQty; // Toggle the label between "Hrs" and "Qty"
                          });
                          iconSelectionProvider.selectLibraryBooks();
                        },
                        child: Center(
                          child: Icon(
                            Icons.my_library_books,
                            color: iconSelectionProvider.isLibraryBooksSelected
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 30,
                      width: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.black),
                        color: iconSelectionProvider.isAccessTimeSelected
                            ? Colors.grey
                            : Colors.white,
                      ),
                      child: InkWell(
                        onTap: () {
                          iconSelectionProvider.selectAccessTime();
                          setState(() {
                            isQty =
                                !isQty; // Toggle the label between "Hrs" and "Qty"
                          });
                        },
                        child: Center(
                          child: Icon(
                            Icons.access_time,
                            color: iconSelectionProvider.isAccessTimeSelected
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Text("S No."),
                        const Text("Description"),
                        Text(
                          isQty ? 'Hrs' : 'Qty',
                          style: const TextStyle(fontSize: 18.0),
                        ),
                        const Text("Unit Price"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      height: 60,
                      width: MediaQuery.of(context).size.width / 1.13,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        shrinkWrap: true,
                        itemCount: listController.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0),
                                        height: 60,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  height: 30,
                                                  width: 80,
                                                  child: Flexible(
                                                    child: TextFormField(
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _description = value;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                SizedBox(
                                                  height: 30,
                                                  width: 54,
                                                  child: Flexible(
                                                    child: TextFormField(
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _hours = double.parse(
                                                              value);
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 23,
                                                ),
                                                SizedBox(
                                                  height: 30,
                                                  width: 80,
                                                  child: Flexible(
                                                    child: TextFormField(
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _unitPrice =
                                                              double.parse(
                                                                  value);
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final projectItem = ProjectItem(
                            description: _description,
                            hours: _hours,
                            unitPrice: _unitPrice,
                          );
                          projectProvider.addProjectItem(projectItem);
                          projectProvider.addProjectItems(projectItem);

                          // Clear the input fields
                          setState(() {
                            _description = '';
                            _hours = 0;
                            _unitPrice = 0;
                          });
                        }
                      },
                      child: const Text("Add New"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final projectItem = ProjectItem(
                            description: _description,
                            hours: _hours,
                            unitPrice: _unitPrice,
                          );
                          projectProvider.addProjectItems(projectItem);
                          projectProvider.addProjectItem(projectItem);

                          // Clear the input fields
                          setState(() {
                            _description = '';
                            _hours = 0;
                            _unitPrice = 0;
                          });
                        }
                      },
                      child: const Text('Add Item'),
                    ),
                  ],
                ),
                Center(
                  child: Container(
                    height: 240,
                    width: 380,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Subtotal"),
                              Text(
                                ' $subtotal',
                                style: const TextStyle(fontSize: 18.0),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Discount"),
                              Text(
                                ' $discountAmount',
                                style: const TextStyle(fontSize: 18.0),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 1.0,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Total"),
                              Text(
                                'Total: $total',
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 1.0,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             const OudtPut()));
                                  },
                                  child: const Text(
                                    "PREVIEW",
                                    style: TextStyle(color: Colors.black),
                                  )),
                              InkWell(
                                onTap: () async {
                                  if (_formKey.currentState!.validate()) {
                                    await generatePDF(context);
                                    // ignore: use_build_context_synchronously
                                    await viewPDF(context);
                                  }
                                },
                                child: Container(
                                  height: 40,
                                  width: 130,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 41, 54, 139),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "DOWNLOAD",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Text(
                            "Saved in Draft",
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),

                // ElevatedButton(
                //   onPressed: () async {
                //     if (_formKey.currentState!.validate()) {
                //       await generatePDF(context);
                //       await viewPDF(context);
                //     }
                //   },
                //   child: const Text('Submit'),
                // ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                  child: Container(
                    height: 100,
                    width: 380,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                      border: Border.all(color: Colors.black),
                    ),
                    child: const Center(
                      child: Text(
                        "CREATE NEW",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> generatePDF(BuildContext context) async {
    final pdf = pw.Document();

    final userData = Provider.of<ProjectProvider>(context, listen: false);

    // Add your logo image to the PDF
    final logoImage = pw.MemoryImage(
      (await rootBundle.load('assets/logo-light.png')).buffer.asUint8List(),
    );

    final currentDate =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    // final _formKey = GlobalKey<FormState>();
    // String projectName = '';
    // String clientAddress = '';
    // String description = '';
    // double hours = 0;
    // double unitPrice = 0;
    double discountRate = 0.12; // 12% discount
    double subtotal = userData.totalUnitPrice;
    double discountAmount = subtotal * discountRate;
    double total = subtotal - discountAmount;

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Logo and additional information
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Container(
                        width: 100.0, // Adjust the width of the logo as needed
                        child: pw.Image(logoImage),
                      ),
                      pw.SizedBox(width: 250.0),
                      pw.Text(currentDate),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 50.0),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Project Name:${userData.projectName}'),
                          pw.SizedBox(height: 10.0),
                          pw.Text("Invoice:#0${userData.nonTaxableCount}"),
                          pw.Text('Address details'),
                          pw.SizedBox(height: 10.0),
                          pw.Text("#To:${userData.recipient}"),
                        ],
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text('HSN Code: ${userData.hsn}'),
                          pw.SizedBox(height: 10.0),
                          pw.Text('GSTIN: 27AXIPT8068J1ZM'),
                          pw.SizedBox(height: 10.0),
                          pw.Text(
                              'From: Datart Solutions 203,\n Pentagon 2, Magarpatta,\n Hadapsar, Pune 411028'),
                        ],
                      ),
                    ),
                  ]),
              pw.SizedBox(
                height: 20.0,
              ), // Add spacing
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(height: 16.0),
                  pw.SizedBox(height: 16.0),
                  pw.Table(
                    columnWidths: {
                      0: const pw.FixedColumnWidth(30), // S.No
                      1: const pw.FixedColumnWidth(200), // Description
                      2: const pw.FixedColumnWidth(50), // Hrs
                      3: const pw.FixedColumnWidth(60), // Unit Price
                      4: const pw.FixedColumnWidth(60), // Total
                    },
                    border: pw.TableBorder.all(),
                    // Number of header rows
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Text('S.No',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text('Description',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text('Hrs',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text('Unit Price',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ],
                      ),
                      ...userData.projectItems.map((item) {
                        return pw.TableRow(
                          children: [
                            pw.Text(
                                '${userData.projectItems.indexOf(item) + 1}'),
                            pw.Text(item.description),
                            pw.Text(item.hours.toString()),
                            pw.Text(item.unitPrice.toString()),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                  pw.SizedBox(height: 16.0),
                  pw.Text(
                    'Total: ${total.toStringAsFixed(2)}', // Format the total as needed
                    style: pw.TextStyle(
                        fontSize: 18.0, fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),

              pw.SizedBox(height: 20.0), // Add spacing

              // Payment Information (Bank Details)
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Payment Information:'),
                  pw.SizedBox(height: 3.0),
                  pw.Text('Bank Name: HDFC Bank'),
                  pw.SizedBox(height: 3.0),
                  pw.Text('Name: Datart Solutions'),
                  pw.SizedBox(height: 3.0),
                  pw.Text('Account No: 50200078927660'),
                  pw.SizedBox(height: 3.0),
                  pw.Text('IFSC Code: HDFC0000486'),
                  pw.SizedBox(height: 3.0),
                  pw.Text('Account Type: Current'),
                ],
              ),

              // Additional information
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text('Datart Solutions'),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text('Yash Tatiya, Director'),
                ],
              ),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/example.pdf");
    await file.writeAsBytes(await pdf.save());
  }

  // Function to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000), // Set the minimum date
      lastDate: DateTime(2101), // Set the maximum date
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> viewPDF(BuildContext context) async {
    final pdfFile = File("${(await getTemporaryDirectory()).path}/example.pdf");

    try {
      await Printing.layoutPdf(
        onLayout: (format) async => pdfFile.readAsBytes(),
      );
    } on PlatformException catch (e) {
      'Error viewing PDF: $e';
    }
  }
}
