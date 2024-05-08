import 'package:flutter/material.dart';

class PlanPage extends StatefulWidget {
  @override
  _PlanPageState createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  TextEditingController _ageController = TextEditingController();
  TextEditingController _heightFeetController = TextEditingController();
  TextEditingController _heightInchesController = TextEditingController();
  TextEditingController _weightController = TextEditingController();

  String _gender = 'Male';
  String _activityLevel = 'Moderate';
  String _eatingPlan = 'Maintain weight';

  double _resultCalories = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calorie Calculator'),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              _showInfoDialog(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Age'),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter age'),
            ),
            SizedBox(height: 16.0),
            Text('Gender'),
            DropdownButton<String>(
              value: _gender,
              onChanged: (newValue) {
                setState(() {
                  _gender = newValue!;
                });
              },
              items: ['Male', 'Female'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            Text('Height'),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _heightFeetController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Feet'),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: TextField(
                    controller: _heightInchesController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Inches'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text('Weight'),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter weight (lbs)'),
            ),
            SizedBox(height: 16.0),
            Text('Activity Level'),
            DropdownButton<String>(
              value: _activityLevel,
              onChanged: (newValue) {
                setState(() {
                  _activityLevel = newValue!;
                });
              },
              items: ['Moderate', 'Intense', 'Very Intense'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            Text('Eating Plan'),
            DropdownButton<String>(
              value: _eatingPlan,
              onChanged: (newValue) {
                setState(() {
                  _eatingPlan = newValue!;
                });
              },
              items: ['Maintain weight', 'Mild weight loss', 'Weight loss', 'Extreme weight loss'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _calculateCalories();
              },
              child: Text('Calculate'),
            ),
            SizedBox(height: 16.0),
            Text('Result: ${_resultCalories.toInt()} Calories/day'),
          ],
        ),
      ),
    );
  }

  void _calculateCalories() {
    double age = double.parse(_ageController.text);
    double heightFeet = double.parse(_heightFeetController.text);
    double heightInches = double.parse(_heightInchesController.text);
    double weight = double.parse(_weightController.text);

    double heightInInches = (heightFeet * 12) + heightInches;

    double bmr = _gender == 'Male'
        ? (66 + (6.2 * weight) + (12.7 * heightInInches) - (6.76 * age))
        : (655.1 + (4.35 * weight) + (4.7 * heightInInches) - (4.7 * age));

    double activityFactor = 1.0;
    if (_activityLevel == 'Moderate') {
      activityFactor = 1.55;
    } else if (_activityLevel == 'Intense') {
      activityFactor = 1.725;
    } else if (_activityLevel == 'Very Intense') {
      activityFactor = 1.9;
    }

    _resultCalories = bmr * activityFactor;

    // Adjust calories based on eating plan
    if (_eatingPlan == 'Mild weight loss') {
      _resultCalories *= 0.9;
    } else if (_eatingPlan == 'Weight loss') {
      _resultCalories *= 0.8;
    } else if (_eatingPlan == 'Extreme weight loss') {
      _resultCalories *= 0.61;
    }

    setState(() {});
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Calorie Calculator Information'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'This Calorie Calculator is based on several equations, and the results of the calculator are based on an estimated average. The Harris-Benedict Equation was one of the earliest equations used to calculate basal metabolic rate (BMR), which is the amount of energy expended per day at rest. It was revised in 1984 to be more accurate and was used up until 1990, when the Mifflin-St Jeor Equation was introduced. The Mifflin-St Jeor Equation also calculates BMR, and has been shown to be more accurate than the revised Harris-Benedict Equation. The Katch-McArdle Formula is slightly different in that it calculates resting daily energy expenditure (RDEE), which takes lean body mass into account, something that neither the Mifflin-St Jeor nor the Harris-Benedict Equation do. Of these equations, the Mifflin-St Jeor Equation is considered the most accurate equation for calculating BMR with the exception that the Katch-McArdle Formula can be more accurate for people who are leaner and know their body fat percentage. The three equations used by the calculator are listed below:',
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Harris-Benedict Equation:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('For men: BMR = 66 + (6.2 * weight) + (12.7 * height in inches) - (6.76 * age)'),
                Text('For women: BMR = 655.1 + (4.35 * weight) + (4.7 * height in inches) - (4.7 * age)'),
                SizedBox(height: 8.0),
                Text(
                  'Mifflin-St Jeor Equation:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('For men: BMR = (10 * weight in kg) + (6.25 * height in cm) - (5 * age) + 5'),
                Text('For women: BMR = (10 * weight in kg) + (6.25 * height in cm) - (5 * age) - 161'),
                SizedBox(height: 8.0),
                Text(
                  'Katch-McArdle Formula:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('RDEE = 370 + (21.6 * lean body mass in kg)'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PlanPage(),
  ));
}

