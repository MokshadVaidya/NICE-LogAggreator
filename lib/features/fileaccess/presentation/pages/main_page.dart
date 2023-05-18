
import 'package:flutter/material.dart';
import 'package:log_aggregator/features/fileaccess/presentation/pages/dialogbox.dart';

class SelectFiles extends StatefulWidget {
  SelectFiles({super.key});

  @override
  State<SelectFiles> createState() => _SelectFilesState();
}

class _SelectFilesState extends State<SelectFiles> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nice Systems",style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("assets/mainBackground.jpg"))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(80),
              child: Text(
                "Log\nAggregator",
                style: TextStyle(color: Colors.white, fontSize: 60),
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (
                        BuildContext context,
                      ) {
                        return AlertDialog(content: StatefulBuilder(
                          builder: (context, setState) {
                            return const DialogBox();
                          },
                        ));
                      });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40)),
                      child: const Center(child: Text("Select Files for user stories",style: TextStyle(fontWeight: FontWeight.bold),)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
