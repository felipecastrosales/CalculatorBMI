import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _infoText = 'Informe seus dados.';

  void _resetFields() {
    weightController.text = '';
    heightController.text = '';
    setState(() {
      _infoText = 'Informe seus dados.';
      _formKey = GlobalKey<FormState>();
    });
  }

  void _calculate() {
    setState(() {
      double weight = double.parse(weightController.text);
      double height = double.parse(heightController.text) / 100;
      double imc = weight / (height * height);
      print(imc);
      if (imc < 18.6) {
        _infoText = 'Abaixo do Peso (${imc.toStringAsPrecision(4)})';
      } else if (imc >= 18.6 && imc < 24.9) {
        _infoText = 'Peso Ideal (${imc.toStringAsPrecision(4)})';
      } else if (imc >= 24.9 && imc < 29.9) {
        _infoText = 'Levemente acima do Peso (${imc.toStringAsPrecision(4)})';
      } else if (imc >= 29.9 && imc < 34.9) {
        _infoText = 'Obesidade Grau I (${imc.toStringAsPrecision(4)})';
      } else if (imc >= 34.9 && imc < 39.9) {
        _infoText = 'Obesidade Grau II (${imc.toStringAsPrecision(4)})';
      } else if (imc >= 40) {
        _infoText = 'Obesidade Grau III (${imc.toStringAsPrecision(4)})';
      }
    });
  }

  static const _colorDefault = const Color(0xFF21e6c1);
  static const _colorFields = const Color(0xFF393e46);
  static const _colorBackground = const Color(0xFF222831);
  static const _colorLight = const Color(0xFFe4f9ff);

  final kLabelStyle = TextStyle(
      color: _colorDefault, fontWeight: FontWeight.bold, fontSize: 26);

  final kLightLabelStyle = TextStyle(color: _colorLight, fontSize: 20);

  final kBoxDecorationStyle = BoxDecoration(
    color: _colorFields,
    borderRadius: BorderRadius.circular(50),
      boxShadow: [
        BoxShadow(color: _colorDefault, spreadRadius: .2)
      ],
  );

  final _snackBar = SnackBar(
    backgroundColor: _colorDefault,
    duration: Duration(seconds: 3),
    content: Text('Veja se um dos campos está vazio.',
        style: TextStyle(color: _colorLight, fontSize: 18)),
  );

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _buildWeight() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 16),
          Text('Peso (kg)', style: kLabelStyle),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 100, vertical: 16),
            decoration: kBoxDecorationStyle,
            child: TextFormField(
              style: kLightLabelStyle,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              controller: weightController,
              validator: (value) {
                if (value.isEmpty) {
                  _scaffoldKey.currentState.showSnackBar(_snackBar);
                } return null;
              },
            ),
          ),
        ],
      );

  Widget _buildHeight() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('Altura (cm)', style: kLabelStyle),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 100, vertical: 16),
            decoration: kBoxDecorationStyle,
            child: TextFormField(
              style: kLightLabelStyle,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              controller: heightController,
              validator: (value) {
                if (value.isEmpty) {
                  _scaffoldKey.currentState.showSnackBar(_snackBar);
                } return null;
              },
            ),
          ),
        ],
      );

  Widget _buildSizedBox() =>
      Divider(color: _colorDefault, thickness: 1.5, indent: 75, endIndent: 75);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _colorBackground,
      appBar: AppBar(
        title: Text('Calculadora IMC', style: kLabelStyle),
        centerTitle: true,
        backgroundColor: _colorFields,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh, color: _colorDefault),
            onPressed: _resetFields,
          ),
        ],
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Icon(Icons.person, size: 120, color: _colorLight),
                _buildSizedBox(),
                _buildWeight(),
                SizedBox(height: 16),
                _buildHeight(),
                _buildSizedBox(),
                SizedBox(height: 16),
                Container(
                  height: 50.0,
                  child: RaisedButton(
                    color: _colorFields,
                    child: Text('Calcule', style: kLabelStyle),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        side: BorderSide(width: 1.5, color: _colorDefault)),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _calculate();
                      }
                    },
                  ),
                ),
                SizedBox(height: 24),
                Text(_infoText,
                    style: kLabelStyle, textAlign: TextAlign.center),
              ],
            ),
          )),
    );
  }
}