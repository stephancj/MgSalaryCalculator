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

  double netToBrut (double net) {
    double brut = 0;
    
    if(net >= 562300){
      //irsa = 27499.70 + 0.20*(0.98 * ((net + irsa) / 0.98) - 600001);
      _irsa = ((27499.70 + 0.20 * net - 122400.2) / 0.80 + 3000) - (_children * 2000);

    } 
    ////A VERIFIER
    else if (net >= 478500){
      //irsa = 12499.85 + 0.15*(0.98 * ((net + irsa) / 0.98) - 500001);
      _irsa = (12499.85 + 0.15 * net - 76500.15) / 0.85;
    } else if (net >=  389000){
      //irsa = 2499.85 + 0.10*(0.98 * ((net + irsa) / 0.98) - 400001);
      _irsa = ((0.098*net - 38316.477) / 0.902);
    }
    
    brut = (net + _irsa) / 0.98;
    return brut + 3000;
  }
}
