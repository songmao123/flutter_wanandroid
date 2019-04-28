import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/page/ui/login/login_page.dart';

class RegisterPage extends AbstractLoginPage {
  @override
  Widget buildContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _registerTitleWidget(),
        RegisterAreaWidget(),
      ],
    );
  }

  Widget _registerTitleWidget() {
    return Container(
      alignment: AlignmentDirectional.center,
      child: Text(
        'Register',
        style: TextStyle(
            fontSize: 60.0, color: Colors.white, fontFamily: 'Pacifico'),
      ),
    );
  }

  @override
  void onCloseClick(BuildContext context) {
    Navigator.of(context).pop();
  }
}

class RegisterAreaWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RegisterAreaState();
}

class RegisterAreaState extends State<RegisterAreaWidget> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController(text: '18922851675');
  final _passwordController = TextEditingController(text: '123456');
  final _confirmPasswordController = TextEditingController(text: '123456');

  String _phone, _password, _confirmPassword;
  bool _validate = false, _isCommitButtonEnable = false;

  @override
  void initState() {
    _phoneController.addListener(_commitButtonState);
    _passwordController.addListener(_commitButtonState);
    _confirmPasswordController.addListener(_commitButtonState);
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _loginFormWidget();
  }

  Widget _loginFormWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
      child: Theme(
        data: ThemeData(
          hintColor: Colors.white70,
          primarySwatch: Colors.teal,
        ),
        child: Form(
          key: _formKey,
          autovalidate: _validate,
          child: Column(
            children: <Widget>[
              _textFormField(
                  'User Name', 'Enter your account', TextInputType.phone, 0),
              SizedBox(height: 20.0),
              _textFormField(
                  'Password', 'Enter your password', TextInputType.text, 1),
              SizedBox(height: 20.0),
              _textFormField('Confirm Password', 'Enter your password again',
                  TextInputType.text, 2),
              SizedBox(height: 60.0),
              _commitButton(),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _textFormField(
      String hintText, String labelText, TextInputType inputType, int type) {
    return TextFormField(
      decoration: InputDecoration(
        fillColor: Colors.green,
        hintText: hintText,
        hintStyle:
            TextStyle(color: Colors.white70, fontFamily: "Montserrat-Medium"),
        labelText: labelText,
        labelStyle: TextStyle(
            fontSize: 16.0,
            color: Colors.white70,
            fontFamily: "Montserrat-Medium"),
      ),
      keyboardType: inputType,
      obscureText: type == 0 ? false : true,
      style: TextStyle(
          fontSize: 18.0, color: Colors.white, fontFamily: "Montserrat-Medium"),
      maxLines: 1,
      textInputAction: TextInputAction.next,
      validator: type == 0 ? _validPhone : _validPassword,
      onSaved: (String value) {
        if (type == 0) {
          _phone = value;
        } else if (type == 1) {
          _password = value;
        } else {
          _confirmPassword = value;
        }
      },
      controller: _detectController(type),
    );
  }

  Widget _commitButton() {
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        color: Colors.teal,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        disabledColor: Colors.grey[400],
        textColor: Colors.white,
        disabledTextColor: Colors.white70,
        padding: EdgeInsets.only(top: 14.0, bottom: 14.0),
        child: Text(
          'Register',
          style: TextStyle(fontSize: 16.0, fontFamily: "Montserrat-Bold"),
        ),
        onPressed: _isCommitButtonEnable ? _validParams : null,
      ),
    );
  }

  TextEditingController _detectController(int type) {
    if (type == 0) {
      return _phoneController;
    } else if (type == 1) {
      return _passwordController;
    } else {
      return _confirmPasswordController;
    }
  }

  void _validParams() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
//      Navigator.push(
//        context,
//        MaterialPageRoute(
//          builder: (context) {},
//        ),
//      );
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  String _validPhone(String value) {
    if (value.length != 11) {
      return 'Password input valid phone number.';
    }
    return null;
  }

  String _validPassword(String value) {
    if (value.length < 6) {
      return 'Password length must greater than 6.';
    }
    return null;
  }

  void _commitButtonState() {
    setState(() {
      _isCommitButtonEnable = _phoneController.text.length > 0 &&
          _passwordController.text.length > 0 &&
          _passwordController.text.length > 0;
    });
  }
}
