import 'package:fit_track/attivit%C3%A0.dart';
import 'package:fit_track/grafici.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'attivita_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => AttivitaProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _calorieController = TextEditingController();
  final TextEditingController _oraController = TextEditingController();
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _secController = TextEditingController();
  List<Map<String, dynamic>> listaDati = [];
  DateTime selectedDate = DateTime.now();
  void showPicker() {
    final screenHeight = MediaQuery.of(context).size.height;
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SizedBox(
          height: screenHeight*0.35,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: selectedDate,
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                selectedDate = newDate;
              });
            },
          ),
        );
      },
    );
  }
  @override
  void dispose() {
    _calorieController.dispose();
    _oraController.dispose();
    _minController.dispose();
    _secController.dispose();
    super.dispose();
  }
  
  int selectIndex = 0;
  bool erroreCalorie = false;
  bool isValid = false;
  @override
  Widget build(BuildContext context) {
    final String year = selectedDate.year.toString();
    final String month = selectedDate.month.toString().padLeft(2, '0');
    final String day = selectedDate.day.toString().padLeft(2, '0');
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    if(_calorieController.text.isNotEmpty 
        && _oraController.text.isNotEmpty
        && _secController.text.isNotEmpty
        && _minController.text.isNotEmpty
        && selectIndex != 0) {
      isValid = true;
    } 
    final provider = Provider.of<AttivitaProvider>(context, listen: false);
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.secondarySystemBackground,
      child: Padding(
        padding: EdgeInsets.only(left: screenWidth*0.06, right: screenWidth*0.06, top: screenHeight*0.03),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight*0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "FitTrack",
                  style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle.copyWith(
                    color: CupertinoColors.black,
                    fontSize: screenHeight*0.04,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight*0.03),
            Text(
              "Data di allenamento",
              style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                  color: CupertinoColors.systemGrey,
                  fontSize: screenHeight*0.02,
                  fontWeight: FontWeight.normal
              ),
            ),
            SizedBox(height: screenHeight*0.01),
            GestureDetector(
              onTap: showPicker,
              child: Container(
                padding: EdgeInsets.only(left: screenWidth*0.03),
                width: double.infinity,
                height: screenHeight*0.05,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenWidth*0.03),
                    color: CupertinoColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: CupertinoColors.systemGrey5,
                      offset: Offset(0, 0),
                      blurRadius: 5,
                    )
                  ]
                ),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.calendar_today,
                      color: Colors.black,
                      size: screenHeight*0.03,
                    ),
                    SizedBox(width: screenWidth*0.03),
                    Text(
                      "$day / $month / $year",
                      style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                        color: CupertinoColors.black,
                        fontSize: screenHeight*0.023,
                        fontWeight: FontWeight.normal
                    ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight*0.03),
            Text(
              "Calorie consumate",
              style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                  color: CupertinoColors.systemGrey,
                  fontSize: screenHeight*0.02,
                  fontWeight: FontWeight.normal
              ),
            ),
            SizedBox(height: screenHeight*0.01),
            SizedBox(
              height: screenHeight*0.05,
              child: CupertinoTextField(
                controller: _calorieController,
                padding: EdgeInsets.only(left: screenWidth*0.03),
                keyboardType: TextInputType.number,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenWidth*0.03),
                    color: CupertinoColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: CupertinoColors.systemGrey5,
                        offset: Offset(0, 0),
                        blurRadius: 5,
                      )
                    ]
                ),
                prefix: Padding(
                  padding: EdgeInsets.only(left: screenWidth*0.03),
                  child: Icon(
                    CupertinoIcons.flame_fill,
                    color: Colors.black,
                    size: screenHeight*0.03,
                  ),
                )
              ),
            ),
            SizedBox(height: screenHeight*0.03),
            Text(
              "Tempo",
              style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                  color: CupertinoColors.systemGrey,
                  fontSize: screenHeight*0.02,
                  fontWeight: FontWeight.normal
              ),
            ),
            SizedBox(height: screenHeight*0.01),
            Row(
              children: [
                SizedBox(
                  height: screenHeight*0.05,
                  width: screenWidth*0.27,
                  child: CupertinoTextField(
                      placeholder: '00',
                      placeholderStyle: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                          color: CupertinoColors.systemGrey,
                          fontSize: screenHeight*0.021,
                          fontWeight: FontWeight.normal
                      ),
                      controller: _oraController,
                      padding: EdgeInsets.only(left: screenWidth*0.03),
                      keyboardType: TextInputType.number,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(screenWidth*0.03),
                          color: CupertinoColors.white,
                          boxShadow: [
                            BoxShadow(
                              color: CupertinoColors.systemGrey5,
                              offset: Offset(0, 0),
                              blurRadius: 5,
                            )
                          ]
                      ),
                      suffix: Padding(
                        padding: EdgeInsets.only(right: screenWidth*0.05),
                        child: Text(
                          "h",
                          style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                            color: CupertinoColors.systemGrey,
                            fontSize: screenHeight*0.021,
                            fontWeight: FontWeight.normal
                        ),
                        )
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),
                        _MaxFormatter(23)
                      ],
                  ),
                ),
                SizedBox(width: screenWidth*0.03),
                SizedBox(
                  height: screenHeight*0.05,
                  width: screenWidth*0.27,
                  child: CupertinoTextField(
                    placeholder: '00',
                    placeholderStyle: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                        color: CupertinoColors.systemGrey,
                        fontSize: screenHeight*0.021,
                        fontWeight: FontWeight.normal
                    ),
                    controller: _minController,
                    padding: EdgeInsets.only(left: screenWidth*0.03),
                    keyboardType: TextInputType.number,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(screenWidth*0.03),
                        color: CupertinoColors.white,
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.systemGrey5,
                            offset: Offset(0, 0),
                            blurRadius: 5,
                          )
                        ]
                    ),
                    suffix: Padding(
                        padding: EdgeInsets.only(right: screenWidth*0.05),
                        child: Text(
                          "min",
                          style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                              color: CupertinoColors.systemGrey,
                              fontSize: screenHeight*0.021,
                              fontWeight: FontWeight.normal
                          ),
                        )
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(2),
                      _MaxFormatter(59)
                    ],
                  ),
                ),
                SizedBox(width: screenWidth*0.03),
                SizedBox(
                  height: screenHeight*0.05,
                  width: screenWidth*0.28,
                  child: CupertinoTextField(
                    placeholder: '00',
                    placeholderStyle: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                        color: CupertinoColors.systemGrey,
                        fontSize: screenHeight*0.021,
                        fontWeight: FontWeight.normal
                    ),
                    controller: _secController,
                    padding: EdgeInsets.only(left: screenWidth*0.03),
                    keyboardType: TextInputType.number,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(screenWidth*0.03),
                        color: CupertinoColors.white,
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.systemGrey5,
                            offset: Offset(0, 0),
                            blurRadius: 5,
                          )
                        ]
                    ),
                    suffix: Padding(
                        padding: EdgeInsets.only(right: screenWidth*0.05),
                        child: Text(
                          "sec",
                          style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                              color: CupertinoColors.systemGrey,
                              fontSize: screenHeight*0.021,
                              fontWeight: FontWeight.normal
                          ),
                        )
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(2),
                      _MaxFormatter(59)
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight*0.03),
            Text(
              "Attività svolta",
              style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                  color: CupertinoColors.systemGrey,
                  fontSize: screenHeight*0.02,
                  fontWeight: FontWeight.normal
              ),
            ),
            SizedBox(height: screenHeight*0.01),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectIndex = 1;
                    });
                  },
                  child: Container(
                    width: screenWidth*0.42,
                    height: screenHeight*0.05,
                    decoration: BoxDecoration(
                        color: selectIndex == 1 ? CupertinoColors.activeBlue : Colors.white,
                        borderRadius: BorderRadius.circular(screenWidth*0.03),
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.systemGrey5,
                            offset: Offset(0, 0),
                            blurRadius: 5,
                          )
                        ]
                    ),
                    child: Center(
                      child: Text(
                        "Corsa",
                        style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                            color: selectIndex == 1 ? CupertinoColors.white : Colors.black,
                            fontSize: screenHeight*0.023,
                            fontWeight: FontWeight.normal
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: screenWidth*0.03),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        selectIndex = 2;
                      });
                    },
                  child: Container(
                    width: screenWidth*0.42,
                    height: screenHeight*0.05,
                    decoration: BoxDecoration(
                        color: selectIndex == 2 ? CupertinoColors.activeBlue : Colors.white,
                        borderRadius: BorderRadius.circular(screenWidth*0.03),
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.systemGrey5,
                            offset: Offset(0, 0),
                            blurRadius: 5,
                          )
                        ]
                    ),
                    child: Center(
                      child: Text(
                        "Palestra",
                        style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                            color: selectIndex == 2 ? CupertinoColors.white : Colors.black,
                            fontSize: screenHeight*0.023,
                            fontWeight: FontWeight.normal
                        ),
                      ),
                    ),
                  )
                )
              ],
            ),
            SizedBox(height: screenHeight*0.04),
            GestureDetector(
              onTap: () {
                if (_calorieController.text.isEmpty || selectIndex == 0) {
                  setState(() {
                    erroreCalorie = true;
                  });
                  showCupertinoDialog(
                    context: context,
                    builder: (_) => CupertinoAlertDialog(
                      title: Text(
                          "Errore",
                        style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                            color: CupertinoColors.black,
                            fontSize: screenHeight*0.02,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      content: Text(
                        "Compila tutti i campi obbligatori",
                        style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                            color: CupertinoColors.black,
                            fontSize: screenHeight*0.017,
                            fontWeight: FontWeight.normal
                        ),
                      ),
                      actions: [
                        CupertinoDialogAction(
                          child: Text(
                            "OK",
                            style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                                color: CupertinoColors.black,
                                fontSize: screenHeight*0.017,
                                fontWeight: FontWeight.normal
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),
                  );
                  return;
                }
                final ora = _oraController.text.isEmpty
                    ? '00'
                    : _oraController.text.padLeft(2, '0');

                final min = _minController.text.isEmpty
                    ? '00'
                    : _minController.text.padLeft(2, '0');

                final sec = _secController.text.isEmpty
                    ? '00'
                    : _secController.text.padLeft(2, '0');
                provider.aggiungiDato({
                  'year': year,
                  'month': month,
                  'day': day,
                  'calorie': _calorieController.text.isEmpty ? '0' : _calorieController.text,
                  'ora': ora,
                  'min': min,
                  'sec': sec,
                  'attivita': selectIndex.toString(),
                });
                final int calorie = int.parse(_calorieController.text);

                final int oreInt = int.parse(ora);
                final int minInt = int.parse(min);
                final int secInt = int.parse(sec);

                final int tempoTotale = oreInt * 3600 + minInt * 60 + secInt;

                final String tipo = selectIndex == 1 ? "corsa" : "palestra";

                final DateTime data = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                );
                FirebaseFirestore.instance.collection('workouts').add({
                  'calorie': calorie,
                  'tempo': tempoTotale,
                  'tipo': tipo,
                  'data': Timestamp.fromDate(data),
                });
                if (isValid) {
                  showCupertinoModalPopup(
                    context: context,
                    barrierColor: Colors.transparent,
                    builder: (_) {
                      Future.delayed(const Duration(seconds: 2), () {
                        Navigator.of(context).pop();
                      });

                      return SafeArea(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: screenHeight*0.03),
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: screenWidth*0.2),
                              padding: EdgeInsets.all(screenWidth*0.03),
                              decoration: BoxDecoration(
                                color: CupertinoColors.activeGreen,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "Dati inseriti correttamente",
                                textAlign: TextAlign.center,
                                style: CupertinoTheme.of(context)
                                    .textTheme
                                    .textStyle
                                    .copyWith(color: CupertinoColors.white),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
              child: Container(
                width: double.infinity,
                height: screenHeight*0.06,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBlue,
                  borderRadius: BorderRadius.circular(screenWidth*0.03),
                ),
                child: Center(
                  child: Text(
                    "Conferma",
                    style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                        color: CupertinoColors.white,
                        fontSize: screenHeight*0.025,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight*0.04),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => const attivita(),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.only(left: screenWidth*0.05, right: screenWidth*0.05),
                width: double.infinity,
                height: screenHeight*0.1,
                decoration: BoxDecoration(
                    color: CupertinoColors.white,
                    borderRadius: BorderRadius.circular(screenWidth*0.03)
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Riepilogo Attività",
                      style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                          color: Colors.black,
                          fontSize: screenHeight*0.025,
                          fontWeight: FontWeight.normal
                      ),
                    ),
                    Spacer(),
                    Icon(
                      CupertinoIcons.forward,
                      color: Colors.black,
                      size: screenHeight*0.025,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight*0.02),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => const grafici(),
                    ),
                  );
                },
              child: Container(
                padding: EdgeInsets.only(left: screenWidth*0.05, right: screenWidth*0.05),
                width: double.infinity,
                height: screenHeight*0.1,
                decoration: BoxDecoration(
                    color: CupertinoColors.white,
                    borderRadius: BorderRadius.circular(screenWidth*0.03)
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Grafici",
                      style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                          color: Colors.black,
                          fontSize: screenHeight*0.025,
                          fontWeight: FontWeight.normal
                      ),
                    ),
                    Spacer(),
                    Icon(
                      CupertinoIcons.forward,
                      color: Colors.black,
                      size: screenHeight*0.025,
                    )
                  ],
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}
class _MaxFormatter extends TextInputFormatter {
  final int max;
  _MaxFormatter(this.max);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text.isEmpty) return newValue;
    
    final intValue = int.tryParse(newValue.text);
    if (intValue == null || intValue > max) {
      return oldValue;
    }

    return newValue;
  }
}
