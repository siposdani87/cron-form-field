import 'package:flutter/material.dart';
import 'package:cron_form_field/cron_form_field.dart';
import 'package:cron_form_field/cron_expression.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter CronFormField Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController? _controller;
  //String _initialValue;
  String _valueChanged = '';
  String _valueToValidate = '';
  String _valueSaved = '';

  @override
  void initState() {
    super.initState();

    //_initialValue = '1 0 0 ? * * *';
    _controller = TextEditingController(text: '1 0 0 ? * * *');

    _setDelayedValue();
  }

  /// This implementation is just to simulate a load data behavior
  /// from a data base sqlite or from a API
  Future<void> _setDelayedValue() async {
    await Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        //_initialValue = '1 0-5 0 ? * * *';
        _controller?.text = '1 0-5 0 ? * * *';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter CronFormField Demo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              CronFormField(
                controller: _controller,
                // initialValue: _initialValue,
                labelText: 'Schedule',
                onChanged: (val) => setState(() => _valueChanged = val),
                validator: (val) {
                  setState(() => _valueToValidate = val ?? '');

                  return null;
                },
                onSaved: (val) => setState(() => _valueSaved = val ?? ''),
              ),
              const SizedBox(height: 30),
              const Text(
                'CronFormField data readable value:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(CronExpression.fromString(_valueChanged).toReadableString()),
              const SizedBox(height: 30),
              const Text(
                'CronFormField data value onChanged:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(_valueChanged),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  final formState = _formKey.currentState;

                  if (formState?.validate() == true) {
                    formState?.save();
                  }
                },
                child: const Text('Submit'),
              ),
              const SizedBox(height: 30),
              const Text(
                'CronFormField data value validator:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(_valueToValidate),
              const SizedBox(height: 30),
              const Text(
                'CronFormField data value onSaved:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(_valueSaved),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  final formState = _formKey.currentState;
                  formState?.reset();

                  setState(() {
                    _valueChanged = '';
                    _valueToValidate = '';
                    _valueSaved = '';
                    _controller?.clear();
                  });
                },
                child: const Text('Reset'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
