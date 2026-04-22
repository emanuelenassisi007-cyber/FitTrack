import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'attivita_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class grafici extends StatefulWidget {
  const grafici({super.key});

  @override
  State<grafici> createState() => _graficiState();
}

class _graficiState extends State<grafici> {
  final TextEditingController controller = TextEditingController();
  List<PesoEntry> pesi = [];
  void aggiungiPeso() {
    final value = double.tryParse(controller.text);

    if (value != null) {
      setState(() {
        pesi.add(PesoEntry(value, DateTime.now()));
      });
      controller.clear();
    }
  }
  @override
  Widget build(BuildContext context) {
    final bool hasData = pesi.isNotEmpty;
    double minY = 0;
    double maxY = 10;
    if (hasData) {
      final values = pesi.map((e) => e.peso).toList();
      final actualMin = values.reduce((a, b) => a < b ? a : b);
      final actualMax = values.reduce((a, b) => a > b ? a : b);
      minY = (actualMin - 1).floorToDouble();
      maxY = (actualMax + 1).ceilToDouble();
    }
    double yInterval = (maxY - minY) / 4;
    if (yInterval <= 0) yInterval = 1;
    double minX = 0;
    double maxX = 0;

    if (hasData) {
      minX = pesi.first.data.millisecondsSinceEpoch.toDouble();
      maxX = pesi.last.data.millisecondsSinceEpoch.toDouble();
      if (minX == maxX) {
        minX -= 86400000; // -1 giorno
        maxX += 86400000; // +1 giorno
      }
    } else {
      maxX = DateTime.now().millisecondsSinceEpoch.toDouble();
      minX = DateTime.now().subtract(Duration(days: 1)).millisecondsSinceEpoch.toDouble();
    }
    double xInterval = (maxX - minX);
    if (hasData && pesi.length > 1) {
      xInterval = (maxX - minX) / (pesi.length > 5 ? 4 : pesi.length - 1);
    } else {
      xInterval = 86400000;
    }
    pesi.sort((a, b) => a.data.compareTo(b.data));
    final dati = Provider.of<AttivitaProvider>(context).listaDati;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.secondarySystemBackground,
      child: Padding(
        padding: EdgeInsets.only(left: screenWidth*0.04, right: screenWidth*0.04, top: screenHeight*0.03),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.02),
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
                    "Grafici",
                    style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                      color: CupertinoColors.black,
                      fontSize: screenHeight * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: screenHeight * 0.025),
                  SizedBox(
                    height: screenHeight * 0.055,
                    child: CupertinoTextField(
                      controller: controller,
                      placeholder: "Inserisci il peso",
                      placeholderStyle: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                        color: CupertinoColors.systemGrey,
                        fontSize: screenHeight * 0.017,
                      ),
                      style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                        fontSize: screenHeight * 0.018,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                      keyboardType: TextInputType.number,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(screenWidth * 0.025),
                        color: CupertinoColors.white,
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.systemGrey5,
                            blurRadius: 4,
                          )
                        ],
                      ),
                      prefix: Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.03),
                        child: Icon(
                          Icons.scale,
                          color: CupertinoColors.systemGrey,
                          size: screenHeight * 0.024,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.018),
                  CupertinoButton(
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.014),
                    color: CupertinoColors.activeBlue,
                    borderRadius: BorderRadius.circular(8),
                    onPressed: () async {
                      final double? pesoValue = double.tryParse(controller.text);

                      if (pesoValue == null) return;

                      final DateTime now = DateTime.now();

                      setState(() {
                        pesi.add(PesoEntry(pesoValue, now));
                      });

                      controller.clear();

                      await FirebaseFirestore.instance.collection('pesoGrafico').add({
                        'peso': pesoValue,
                        'dataPeso': Timestamp.fromDate(now),
                      });
                    },
                    child: Text(
                      "Aggiungi",
                      style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                        color: CupertinoColors.white,
                        fontSize: screenHeight * 0.018,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.025),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('pesoGrafico')
                        .orderBy('dataPeso')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CupertinoActivityIndicator());
                      }

                      final docs = snapshot.data!.docs;

                      if (docs.isEmpty) {
                        return Container(
                          height: screenHeight * 0.30,
                          child: Center(child: Text(
                              "Nessun dato",
                            style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                              color: CupertinoColors.systemGrey,
                              fontSize: screenHeight * 0.02,
                              fontWeight: FontWeight.normal,
                            ),
                          )
                          ),
                        );
                      }

                      final pesi = docs.map((doc) {
                        final data = doc.data();
                        final Timestamp ts = data['dataPeso'];
                        final date = ts.toDate();
                        final peso = (data['peso'] as num).toDouble();

                        return PesoEntry(peso, date);
                      }).toList();

                      final spots = pesi
                          .map((e) => FlSpot(
                        e.data.millisecondsSinceEpoch.toDouble(),
                        e.peso,
                      ))
                          .toList();

                      final values = pesi.map((e) => e.peso).toList();
                      double minY = 0;
                      double maxY = 10;

                      if (values.isNotEmpty) {
                        final actualMin = values.reduce((a, b) => a < b ? a : b);
                        final actualMax = values.reduce((a, b) => a > b ? a : b);

                        minY = actualMin - 1;
                        maxY = actualMax + 1;
                      }

                      final minX = pesi.first.data.millisecondsSinceEpoch.toDouble();
                      final maxX = pesi.last.data.millisecondsSinceEpoch.toDouble();

                      double yInterval = (maxY - minY) / 4;
                      if (yInterval <= 0) yInterval = 1;

                      double xInterval = (maxX - minX);
                      if (pesi.length > 1) {
                        xInterval = (maxX - minX) / 4;
                      } else {
                        xInterval = 86400000;
                      }

                      return Container(
                        height: screenHeight * 0.30,
                        padding: EdgeInsets.fromLTRB(
                          screenWidth * 0.02,
                          screenWidth * 0.04,
                          screenWidth * 0.08,
                          screenWidth * 0.02,
                        ),
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemGrey6,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: LineChart(
                          LineChartData(
                            minY: minY,
                            maxY: maxY,
                            minX: minX,
                            maxX: maxX,

                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              horizontalInterval: yInterval,
                              getDrawingHorizontalLine: (_) => FlLine(
                                color: CupertinoColors.systemGrey4.withOpacity(0.3),
                                strokeWidth: 1,
                              ),
                            ),

                            borderData: FlBorderData(show: false),

                            lineBarsData: [
                              LineChartBarData(
                                spots: spots,
                                isCurved: true,
                                curveSmoothness: 0.35,
                                preventCurveOverShooting: true,
                                barWidth: 3,
                                color: CupertinoColors.systemBlue,
                                dotData: FlDotData(
                                  show: true,
                                  getDotPainter: (spot, percent, barData, index)
                                  => FlDotCirclePainter(
                                    radius: 3,
                                    color: CupertinoColors.systemBlue,
                                    strokeWidth: 1,
                                    strokeColor: CupertinoColors.white,
                                  ),
                                ),
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      CupertinoColors.systemBlue.withOpacity(0.2),
                                      CupertinoColors.systemBlue.withOpacity(0.0),
                                    ],
                                  ),
                                ),
                              ),
                            ],

                            titlesData: FlTitlesData(
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),

                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: xInterval,

                                  reservedSize: 30,
                                  getTitlesWidget: (value, meta) {
                                    final date =
                                    DateTime.fromMillisecondsSinceEpoch(value.toInt());

                                    return SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      space: 8,
                                      angle: 0.5,
                                      child: Text(
                                        "${date.day}/${date.month}",
                                        style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                                          fontSize: screenHeight*0.012,
                                          color: CupertinoColors.systemGrey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 45,
                                  interval: yInterval,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      value.toStringAsFixed(1),
                                      style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                                        fontSize: screenHeight*0.012,
                                        color: CupertinoColors.systemGrey,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: screenHeight*0.03),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  "Storico",
                  style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                    color: CupertinoColors.black,
                    fontSize: screenHeight*0.025,
                  ),
                ),
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('pesoGrafico')
                    .orderBy('dataPeso')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CupertinoActivityIndicator());
                  }
                  final docs = snapshot.data!.docs;
                  return GridView.count(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: screenWidth * 0.02,
                    crossAxisSpacing: screenWidth * 0.02,
                    childAspectRatio: 1.6,
                    children: docs.reversed.map((doc) {
                      final data = doc.data();

                      final Timestamp ts = data['dataPeso'];
                      final DateTime date = ts.toDate();

                      final giorno = date.day.toString().padLeft(2, '0');
                      final mese = date.month.toString().padLeft(2, '0');
                      final anno = date.year.toString();

                      final peso = data['peso'].toString();

                      return Container(
                        padding: EdgeInsets.all(screenWidth * 0.02),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(screenWidth * 0.025),
                          color: CupertinoColors.white,
                          boxShadow: [
                            BoxShadow(
                              color: CupertinoColors.systemGrey5,
                              blurRadius: 4,
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "$giorno / $mese / $anno",
                              style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                                color: CupertinoColors.systemGrey,
                                fontSize: screenHeight * 0.018,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              "$peso kg",
                              style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                                color: CupertinoColors.black,
                                fontSize: screenHeight * 0.03,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          )
        )
      )
    );
  }
}
class PesoEntry {
  final double peso;
  final DateTime data;

  PesoEntry(this.peso, this.data,);
}
