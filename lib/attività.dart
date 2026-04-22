import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'attivita_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class attivita extends StatefulWidget {
  const attivita({super.key});
  @override
  State<attivita> createState() => _attivitaState();
}

class _attivitaState extends State<attivita> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.secondarySystemBackground,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('workouts')
            .orderBy('data', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return Center(child: CupertinoActivityIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(
                "Errore caricamento dati",
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                  color: CupertinoColors.systemGrey,
                  fontSize: screenHeight*0.02,
                  fontWeight: FontWeight.normal,
                )
            )
            );
          }
          final docs = snapshot.data!.docs;
          return ListView(
            padding: EdgeInsets.only(
              left: screenWidth * 0.03,
              right: screenWidth * 0.03,
            ),
            children: [
              SizedBox(height: screenHeight * 0.06),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      },
                    child: Icon(
                      CupertinoIcons.back,
                      color: Colors.black,
                      size: screenHeight * 0.03,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "Riepilogo attività",
                    style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                      color: CupertinoColors.black,
                      fontSize: screenHeight * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(height: screenHeight * 0.04),
              if (docs.isEmpty)
                Center(
                  child: Text(
                    "Non ci sono attività registrate",
                    style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                      color: CupertinoColors.systemGrey,
                      fontSize: screenHeight*0.02,
                      fontWeight: FontWeight.normal,
                    )
                  ),
                ),
              ...docs.reversed.map((doc) => buildBox(
                  doc.data()
              )),
            ],
          );
        },
      )
    );
  }
  Widget buildBox(Map<String, dynamic> dati) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final Timestamp ts = dati['data'];
    final DateTime data = ts.toDate();
    String giorno = data.day.toString().padLeft(2, '0');
    String mese = data.month.toString().padLeft(2, '0');
    String anno = data.year.toString();
    int tempo = (dati['tempo'] ?? 0);
    int ora = tempo ~/ 3600;
    int min = (tempo % 3600) ~/ 60;
    int sec = tempo % 60;
    final calorie = dati['calorie'].toString();
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: screenWidth*0.05, right: screenWidth*0.03, top: screenHeight*0.01, bottom: screenHeight*0.02),
          width: double.infinity,
          decoration: BoxDecoration(
            color: CupertinoColors.white,
            boxShadow: [
              BoxShadow(
                color: CupertinoColors.systemGrey5,
                offset: Offset(0, 0),
                blurRadius: 10,
                spreadRadius: 2
              )
            ],
            borderRadius: BorderRadius.circular(screenWidth*0.03),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "$giorno / $mese / $anno",
                    style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                      color: CupertinoColors.systemGrey,
                      fontSize: screenHeight*0.02,
                      fontWeight: FontWeight.normal
                    ),
                  )
                ],
              ),
              SizedBox(height: screenHeight*0.02),
              Text(
                  "Attività",
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                    color: CupertinoColors.systemGrey,
                    fontSize: screenHeight*0.023,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: screenHeight*0.01),
              Text(
                dati['tipo'] == 'corsa' ? 'Corsa' : dati['tipo'] == 'palestra' ? 'Palestra' : 'Attività non disponibile',
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                    color: dati['tipo'] == '' ? CupertinoColors.systemGrey : CupertinoColors.black,
                    fontSize: (dati['tipo'] == '') ? screenHeight*0.018 : screenHeight*0.03,
                    fontWeight: dati['tipo'] == '' ? FontWeight.normal :FontWeight.bold
                ),
              ),
              SizedBox(height: screenHeight*0.02),
              Text(
                "Calorie",
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                    color: CupertinoColors.systemGrey,
                    fontSize: screenHeight*0.023,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: screenHeight*0.01),
              Text(
                calorie,
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                    color: dati['calorie'] == '0' ? CupertinoColors.systemGrey : CupertinoColors.black,
                    fontSize: screenHeight*0.03,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: screenHeight*0.02),
              Text(
                "Tempo",
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                    color: CupertinoColors.systemGrey,
                    fontSize: screenHeight*0.023,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: screenHeight*0.01),
              Row(
                children: [
                  Text(
                    "${ora}h",
                    style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                        color: ora == 0 ? CupertinoColors.systemGrey : CupertinoColors.black,
                        fontSize: screenHeight*0.03,
                        fontWeight: ora == 0 ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: screenWidth*0.02),
                  Text(
                    "${min}min",
                    style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                      color: min == 0 ? CupertinoColors.systemGrey : CupertinoColors.black,
                      fontSize: screenHeight*0.03,
                      fontWeight: min == 0 ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: screenWidth*0.02),
                  Text(
                    "${sec}sec",
                    style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                      color: sec == 0 ? CupertinoColors.systemGrey : CupertinoColors.black,
                      fontSize: screenHeight*0.03,
                      fontWeight: sec == 0 ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          )
        ),
        SizedBox(height: screenHeight * 0.03),
      ],
    );
  }
}
