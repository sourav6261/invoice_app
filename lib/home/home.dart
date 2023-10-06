import 'package:flutter/material.dart';
import 'package:invoice_generator/model/providernot.dart';
import 'package:invoice_generator/nontax/nontax.dart';
import 'package:invoice_generator/tax/taxscreen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double xOffset = 0;
  double yOffset = 0;

  bool isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    final countNotifier = context.watch<ProjectProvider>();
    return AnimatedContainer(
      transform: Matrix4.translationValues(xOffset, yOffset, 0)
        ..scale(isDrawerOpen ? 0.85 : 1.00)
        ..rotateZ(isDrawerOpen ? -50 : 0),
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            isDrawerOpen ? BorderRadius.circular(40) : BorderRadius.circular(0),
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 50,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // isDrawerOpen
                    //     ? GestureDetector(
                    //         child: const Icon(Icons.arrow_back_ios),
                    //         onTap: () {
                    //           setState(() {
                    //             xOffset = 0;
                    //             yOffset = 0;
                    //             isDrawerOpen = false;
                    //           });
                    //         },
                    //       )
                    //     : GestureDetector(
                    //         child: const Icon(Icons.menu),
                    //         onTap: () {
                    //           setState(() {
                    //             xOffset = 290;
                    //             yOffset = 80;
                    //             isDrawerOpen = true;
                    //           });
                    //         },
                    //       ),
                    Text(
                      "Createe Invoice",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 350,
              ),
              Column(
                children: <Widget>[
                  Center(
                    child: InkWell(
                      onTap: () {
                        countNotifier.incrementTaxableCount();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const InvoiceNonTaxable()));
                      },
                      child: Container(
                        height: 100,
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black),
                        ),
                        child: const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.insert_drive_file_rounded),
                              SizedBox(
                                width: 5,
                              ),
                              Text("Taxable")
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {
                        countNotifier.incrementNonTaxableCount();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ProjectDetailsScreen()));
                      },
                      child: Container(
                        height: 100,
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black),
                        ),
                        child: const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.insert_drive_file_rounded),
                              SizedBox(
                                width: 5,
                              ),
                              Text("Non Taxable")
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
