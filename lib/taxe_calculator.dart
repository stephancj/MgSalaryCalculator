import 'dart:math';

import 'package:flutter/material.dart';

class ImpotRevenuCalculator extends StatefulWidget {
  const ImpotRevenuCalculator({super.key});

  @override
  _ImpotRevenuCalculatorState createState() => _ImpotRevenuCalculatorState();
}

class _ImpotRevenuCalculatorState extends State<ImpotRevenuCalculator> {
  final TextEditingController _salaireController = TextEditingController();
  final TextEditingController _netController = TextEditingController();
  double _brutSalary = 0,
      _netSalary = 0,
      _baseIrsa = 0,
      _employeCnaps = 0,
      _employeOstie = 0,
      _children = 0,
      _irsa = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculateur d\'impôt sur le revenu'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _salaireController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Salaire brut',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _netSalary =
                        brutToNetSalary(double.parse(_salaireController.text));
                    _netController.text = _netSalary.toString();
                  });
                },
                child: const Text('Calculer'),
              ),
              TextField(
                controller: _netController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Salaire net',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _brutSalary =
                        netToBrutSalary(double.parse(_netController.text));
                    _salaireController.text = _brutSalary.toString();
                  });
                },
                child: const Text('Calculer Brut'),
              ),
              const SizedBox(height: 20),
              Text('Le montant de l\'IRSA est de ${_irsa.floor()} MGA'),
            ],
          ),
        ),
      ),
    );
  }

  double brutToNetSalary(double brut) {
    double net = 0;
    _employeCnaps = brut > 2000000 ? 20000 : brut * 0.01;
    _employeOstie = brut > 2000000 ? 20000 : brut * 0.01;
    _baseIrsa = brut - _employeCnaps - _employeOstie;

    _irsa = max(
        3000,
        0 +
            min(max(0, _baseIrsa - 350000), 50000) * 0.05 +
            min(max(0, _baseIrsa - 400000), 100000) * 0.1 +
            min(max(0, _baseIrsa - 500000), 100000) * 0.15 +
            max(0, _baseIrsa - 600000) * 0.2 -
            2000 * _children);

    net = _baseIrsa - _irsa;

    return net;
  }

  double netToBrutSalary(double net) {
    _employeCnaps = net / 0.99 * 0.01;
    _employeOstie = net / 0.99 * 0.01;
    _baseIrsa = net / 0.99;
    _irsa = max(
        3000,
        0 +
            min(max(0, _baseIrsa - 350000), 50000) * 0.05 +
            min(max(0, _baseIrsa - 400000), 100000) * 0.1 +
            min(max(0, _baseIrsa - 500000), 100000) * 0.15 +
            max(0, _baseIrsa - 600000) * 0.2 -
            2000 * _children);

    double totalDeductions = _employeCnaps + _employeOstie + _irsa;
    double gross = net + totalDeductions;
    return gross;
  }
}
