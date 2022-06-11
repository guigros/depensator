import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Expense {
  final String description;
  final double amount;

  Expense(this.description, this.amount);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Depensator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DepensatorHomePage(title: 'Accueil'),
    );
  }
}

class DepensatorHomePage extends StatefulWidget {
  const DepensatorHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<DepensatorHomePage> createState() => _DepensatorHomePageState();
}

class _DepensatorHomePageState extends State<DepensatorHomePage> {
  double depenseTotal = 1500;
  final salaire1Controller = TextEditingController();
  double charge1 = 0;
  final salaire2Controller = TextEditingController();
  double charge2 = 0;

  @override
  void initState() {
    salaire1Controller.addListener(() {
      setState(computeCharge);
    });

    salaire2Controller.addListener(() {
      setState(computeCharge);
    });

    super.initState();
  }

  void computeCharge() {
    double salaire1 = double.tryParse(salaire1Controller.text) ?? 0;
    double salaire2 = double.tryParse(salaire2Controller.text) ?? 0;
    double totalSalaire = salaire1 + salaire2;
    if (totalSalaire > 0) {
      double percent1 = salaire1 / totalSalaire;
      double percent2 = salaire2 / totalSalaire;

      charge1 = percent1 * depenseTotal;
      charge2 = percent2 * depenseTotal;
    }
  }

  void updateExpense(double expense) {
    depenseTotal = expense;
    setState(computeCharge);
  }

  @override
  void dispose() {
    salaire1Controller.dispose();
    salaire2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DepensesWidget(callback: updateExpense),
            TextField(
                decoration: const InputDecoration(labelText: "Salaire 1"),
                controller: salaire1Controller,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ]),
            TextField(
                decoration: const InputDecoration(labelText: "Salaire 2"),
                controller: salaire2Controller,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ]),
            Text(
              charge1.toString(),
            ),
            Text(
              charge2.toString(),
            )
          ],
        ),
      ),
    );
  }
}

class DepensesWidget extends StatefulWidget {
  final Function callback;
  const DepensesWidget({Key? key, required this.callback}) : super(key: key);

  @override
  _DepensesWidgetState createState() => _DepensesWidgetState();
}

class _DepensesWidgetState extends State<DepensesWidget> {
  double total = 1500;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        _navigateAndGetTotal(context);
      },
      style: OutlinedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      ),
      child: Text('Dépenses : $total €'),
    );
  }

  // A method that launches the ListOfExpenseScreen and awaits the result from
  // Navigator.pop.
  Future<void> _navigateAndGetTotal(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Depense list.
    final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DepenseListRoute()),
        ) ??
        total;

    setState(() {
      total = result;
      widget.callback(total);
    });
  }
}

class DepenseListRoute extends StatelessWidget {
  const DepenseListRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des dépenses'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context, 2000);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
