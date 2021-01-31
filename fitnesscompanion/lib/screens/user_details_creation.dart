import 'package:flutter/material.dart';
import 'package:fitnesscompanion/api/firebase_api.dart';
import 'package:fitnesscompanion/models/user_details.dart';
import 'package:fitnesscompanion/widgets/color_loader.dart';

class UserDetailsCreation extends StatefulWidget {
  @override
  _UserDetailsCreationState createState() => _UserDetailsCreationState();
}

class _UserDetailsCreationState extends State<UserDetailsCreation> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formPersonalKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formBodyKey = GlobalKey<FormState>();

  int _counter = 0;

  double _exerciseSlider = 0;
  double _weeklyTargetSlider = 0;

  double _exercise = 1.2;
  int _weeklyTarget = 0;

  int _dailyCals = 0;

  int userAge = 0;

  UserDetails _userDetails = UserDetails();
  int _findAge(String givenDate) {
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    DateTime birthDate;
    List<String> split = givenDate.split('/');
    givenDate = split[2] + '-' + split[1] + '-' + split[0];
    birthDate = DateTime.parse(givenDate);
    int age = date.year - birthDate.year;
    int month1 = date.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month2 == month1) {
      int day1 = date.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  void _submitForm() {
    if (_counter == 0) {
      if (!_formPersonalKey.currentState.validate()) {
        return;
      }
    }

    if (_counter == 1) {
      if (!_formBodyKey.currentState.validate()) {
        return;
      }
    }

    setState(() {
      if (_counter == 0) {
        _formPersonalKey.currentState.save();
        _counter = _counter + 1;
      } else if (_counter == 1) {
        _formBodyKey.currentState.save();
        _counter = _counter + 1;
      } else if (_counter == 2) {
        userAge = _findAge(_userDetails.birthDate);
        if (_userDetails.gender == 'Male') {
          _dailyCals = ((10.0 * double.parse(_userDetails.weight) +
                          6.25 * double.parse(_userDetails.height) -
                          5.0 * userAge +
                          5.0) *
                      _exercise)
                  .round() +
              _weeklyTarget;
        } else if (_userDetails.gender == 'Female') {
          _dailyCals = ((10.0 * double.parse(_userDetails.weight) +
                          6.25 * double.parse(_userDetails.height) -
                          5 * userAge -
                          161) *
                      _exercise)
                  .round() +
              _weeklyTarget;
        }
        _counter = _counter + 1;
        setUserInfo(_userDetails, _dailyCals);
      }
    });
  }

  Widget _buildUserDetailNameField(String detail) {
    return TextFormField(
      maxLength: 32,
      decoration: InputDecoration(
        labelText: "$detail",
        labelStyle: TextStyle(color: Colors.white),
      ),
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.words,
      style: TextStyle(fontSize: 16, color: Colors.white),
      cursorColor: Colors.white,
      validator: (String value) {
        if (value.isEmpty) {
          return '$detail is required';
        }
        if (!RegExp(r"^[A-Z]+[a-zA-Z]*$").hasMatch(value)) {
          return 'A name can only contain characters';
        }
        return null;
      },
      onSaved: (String value) {
        if (detail == 'First Name') {
          _userDetails.firstName = value;
        } else if (detail == 'Last Name') {
          _userDetails.lastName = value;
        }
      },
    );
  }

  Widget _buildUserDetailAgeField(String detail) {
    return TextFormField(
      maxLength: 10,
      decoration: InputDecoration(
        labelText: "$detail",
        labelStyle: TextStyle(color: Colors.white),
      ),
      keyboardType: TextInputType.datetime,
      style: TextStyle(fontSize: 16, color: Colors.white),
      cursorColor: Colors.white,
      validator: (String value) {
        if (value.isEmpty) {
          return '$detail is required';
        }

        if (!RegExp(
                r"^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[13-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$")
            .hasMatch(value)) {
          return 'Birthdate should be on dd/mm/yyyy format';
        }

        return null;
      },
      onSaved: (String value) {
        List<String> zeroFix = value.split('/');
        if (zeroFix[0].length == 1) {
          zeroFix[0] = '0' + zeroFix[0];
        }
        if (zeroFix[1].length == 1) {
          zeroFix[1] = '0' + zeroFix[1];
        }
        _userDetails.birthDate =
            zeroFix[0] + '/' + zeroFix[1] + '/' + zeroFix[2];
        print(_userDetails.birthDate);
      },
    );
  }

  Widget _buildUserDetailHeightField(String detail) {
    return TextFormField(
      maxLength: 3,
      decoration: InputDecoration(
        labelText: "$detail",
        labelStyle: TextStyle(color: Colors.white),
      ),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 16, color: Colors.white),
      cursorColor: Colors.white,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Enter your height in cm';
        }
        if (!RegExp(r"^[0-9]*$").hasMatch(value)) {
          return 'Height should be on XXX form';
        }

        return null;
      },
      onSaved: (String value) {
        _userDetails.height = value;
      },
    );
  }

  Widget _buildUserDetailWeightField(String detail) {
    return TextFormField(
      maxLength: 7,
      decoration: InputDecoration(
        labelText: "$detail",
        labelStyle: TextStyle(color: Colors.white),
      ),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 16, color: Colors.white),
      cursorColor: Colors.white,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Enter your height in kg';
        }
        if (!RegExp(r"^(0|[1-9]\d*)(\.\d+)?$").hasMatch(value)) {
          return 'Weight should be on XXX.XXX form';
        }

        return null;
      },
      onSaved: (String value) {
        _userDetails.weight = value;
      },
    );
  }

  Widget _buildUserDetailGenderField(String detail) {
    return TextFormField(
      maxLength: 6,
      decoration: InputDecoration(
        labelText: "$detail",
        labelStyle: TextStyle(color: Colors.white),
      ),
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.words,
      style: TextStyle(fontSize: 16, color: Colors.white),
      cursorColor: Colors.white,
      validator: (String value) {
        if (value.isEmpty) {
          return '$detail is required';
        }
        if (value != 'Male' && value != 'Female') {
          return 'Please choose between Male or Female';
        }
        return null;
      },
      onSaved: (String value) {
        _userDetails.gender = value;
      },
    );
  }

  Widget _exerciseText(double sliderVal) {
    if (sliderVal == 0) {
      return Text(
        'Sedentary (little or no exercise)\n',
        style: TextStyle(fontSize: 16, color: Colors.white),
      );
    } else if (sliderVal == 1) {
      return Text(
        'Lightly active (light exercise/ sports 1-3 days/week)',
        style: TextStyle(fontSize: 16, color: Colors.white),
      );
    } else if (sliderVal == 2) {
      return Text(
        'Moderately active (moderate exersice/ sports 3-5 days/week)',
        style: TextStyle(fontSize: 16, color: Colors.white),
      );
    } else if (sliderVal == 3) {
      return Text(
        'Very active (hard exersice/ sports 6-7 days/week)',
        style: TextStyle(fontSize: 16, color: Colors.white),
      );
    } else if (sliderVal == 4) {
      return Text(
        'Extra active (very hard exersice/ sports & physical job or 2x training)',
        style: TextStyle(fontSize: 16, color: Colors.white),
      );
    } else {
      return Text(
        'Error',
        style: TextStyle(fontSize: 16, color: Colors.white),
      );
    }
  }

  Widget _weeklyTargetText(double sliderVal) {
    if (sliderVal == -4.0) {
      return Text(
        'Lose 1kg per week',
        style: TextStyle(fontSize: 16, color: Colors.white),
      );
    } else if (sliderVal == -3.0) {
      return Text(
        'Lose 0.75kg per week',
        style: TextStyle(fontSize: 16, color: Colors.white),
      );
    } else if (sliderVal == -2.0) {
      return Text(
        'Lose 0.5kg per week',
        style: TextStyle(fontSize: 16, color: Colors.white),
      );
    } else if (sliderVal == -1.0) {
      return Text(
        'Lose 0.25kg per week',
        style: TextStyle(fontSize: 16, color: Colors.white),
      );
    } else if (sliderVal == 0.0) {
      return Text(
        'Maintain your weight',
        style: TextStyle(fontSize: 16, color: Colors.white),
      );
    } else if (sliderVal == 1.0) {
      return Text(
        'Gain 0.25kg per week',
        style: TextStyle(fontSize: 16, color: Colors.white),
      );
    } else if (sliderVal == 2.0) {
      return Text(
        'Gain 0.5kg per week',
        style: TextStyle(fontSize: 16, color: Colors.white),
      );
    } else if (sliderVal == 3.0) {
      return Text(
        'Gain 0.75kg per week',
        style: TextStyle(fontSize: 16, color: Colors.white),
      );
    } else if (sliderVal == 4.0) {
      return Text(
        'Gain 1kg per week',
        style: TextStyle(fontSize: 16, color: Colors.white),
      );
    } else {
      return Text(
        'Error!',
        style: TextStyle(fontSize: 16, color: Colors.white),
      );
    }
  }

  Widget _formPacket(int counter) {
    if (counter == 0) {
      return Form(
        key: _formPersonalKey,
        child: Column(
          children: <Widget>[
            _buildUserDetailNameField('First Name'),
            _buildUserDetailNameField('Last Name'),
            _buildUserDetailAgeField('Age'),
          ],
        ),
      );
    } else if (counter == 1) {
      return Form(
        key: _formBodyKey,
        child: Column(
          children: <Widget>[
            _buildUserDetailHeightField('Height'),
            _buildUserDetailWeightField('Weight'),
            _buildUserDetailGenderField('Gender'),
          ],
        ),
      );
    } else if (counter == 2) {
      return Container(
        child: Column(
          children: <Widget>[
            Text(
              'Select your weekly exercise',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            Slider(
              divisions: 4,
              min: 0,
              max: 4.0,
              value: _exerciseSlider,
              onChanged: (val) {
                if (val == 0) {
                  _exercise = 1.2;
                } else if (val == 1.0) {
                  _exercise = 1.375;
                } else if (val == 2.0) {
                  _exercise = 1.55;
                } else if (val == 3.0) {
                  _exercise = 1.725;
                } else if (val == 4.0) {
                  _exercise = 1.9;
                }
                setState(() {
                  _exerciseSlider = val;
                });
              },
            ),
            _exerciseText(_exerciseSlider),
            SizedBox(height: 64),
            Text(
              'Select your desired goal',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            Slider(
              divisions: 8,
              min: -4.0,
              max: 4.0,
              value: _weeklyTargetSlider,
              onChanged: (val) {
                if (val == -4.0) {
                  _weeklyTarget = -1100;
                } else if (val == -3.0) {
                  _weeklyTarget = -825;
                } else if (val == -2.0) {
                  _weeklyTarget = -550;
                } else if (val == -1.0) {
                  _weeklyTarget = -275;
                } else if (val == 0) {
                  _weeklyTarget = 0;
                } else if (val == 1.0) {
                  _weeklyTarget = 275;
                } else if (val == 2.0) {
                  _weeklyTarget = 550;
                } else if (val == 3.0) {
                  _weeklyTarget = 825;
                } else if (val == 4.0) {
                  _weeklyTarget = 1100;
                }
                setState(() {
                  _weeklyTargetSlider = val;
                });
              },
            ),
            _weeklyTargetText(_weeklyTargetSlider),
          ],
        ),
      );
    } else {
      return Container(
        child: Center(
          child: ColorLoader(
            color1: Colors.green,
            color2: Colors.orange,
            color3: Colors.blue,
          ),
        ),
      );
    }
  }

  Widget _buttonText(int counter) {
    if (counter == 0) {
      return Text(
        'Please enter your details and proceed',
        style: TextStyle(fontSize: 16, color: Colors.white),
      );
    } else if (counter == 1) {
      return Text(
        'Almost there!',
        style: TextStyle(fontSize: 16, color: Colors.white),
      );
    } else if (counter == 2) {
      return Text(
        'Let\'s go!',
        style: TextStyle(fontSize: 16, color: Colors.white),
      );
    } else {
      return Text(
        '',
        style: TextStyle(fontSize: 16, color: Colors.white),
      );
    }
  }

  Widget _expandedSection(int counter) {
    if (counter == 0) {
      return Expanded(child: Container());
    } else if (counter == 1) {
      return Expanded(child: Container());
    } else if (counter == 2) {
      return Expanded(child: Container());
    } else {
      return Container();
    }
  }

  Widget _buttonSection(int counter) {
    if (counter == 0) {
      return ButtonTheme(
        child: FlatButton(
          padding: EdgeInsets.all(8.0),
          onPressed: () => _submitForm(),
          child: _buttonText(_counter),
        ),
      );
    } else if (counter == 1) {
      return ButtonTheme(
        child: FlatButton(
          padding: EdgeInsets.all(8.0),
          onPressed: () => _submitForm(),
          child: _buttonText(_counter),
        ),
      );
    } else if (counter == 2) {
      return ButtonTheme(
        child: FlatButton(
          padding: EdgeInsets.all(8.0),
          onPressed: () => _submitForm(),
          child: _buttonText(_counter),
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      body: Container(
        color: Colors.deepPurple[900],
        child: Padding(
          padding: EdgeInsets.fromLTRB(32, 96, 32, 32),
          child: Column(
            children: <Widget>[
              Image.asset(
                'assets/launcher_icon.png',
                scale: 4,
              ),
              SizedBox(height: 32),
              _formPacket(_counter),
              SizedBox(height: 32),
              _expandedSection(_counter),
              _buttonSection(_counter),
            ],
          ),
        ),
      ),
    );
  }
}
