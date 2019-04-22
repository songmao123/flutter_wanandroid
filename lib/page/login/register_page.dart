import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/page/login/login_page.dart';

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

  String _phone, _password;
  bool _validate = false, _isCommitButtonEnable = false;

  @override
  void initState() {
    _phoneController.addListener(_commitButtonState);
    _passwordController.addListener(_commitButtonState);
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
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
              _textFormField('Phone Number', 'Enter your phone number',
                  TextInputType.phone, false),
              SizedBox(height: 20.0),
              _textFormField(
                  'Password', 'Enter your password', TextInputType.text, true),
              SizedBox(height: 20.0),
              _textFormField('Confirm Password', 'Enter your password again',
                  TextInputType.text, true),
              SizedBox(height: 60.0),
              _commitButton(),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _textFormField(String hintText, String labelText,
      TextInputType inputType, bool isPassword) {
    return TextFormField(
      decoration: InputDecoration(
        fillColor: Colors.green,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white70),
        labelText: labelText,
        labelStyle: TextStyle(
          fontSize: 16.0,
          color: Colors.white70,
        ),
      ),
      keyboardType: inputType,
      obscureText: isPassword,
      style: TextStyle(
        fontSize: 18.0,
        color: Colors.white,
      ),
      maxLines: 1,
      textInputAction: TextInputAction.next,
      validator: isPassword ? _validPassword : _validPhone,
      onSaved: (String value) {
        if (isPassword) {
          _password = value;
        } else {
          _phone = value;
        }
      },
      controller: isPassword ? _passwordController : _phoneController,
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
        textColor: Colors.white70,
        disabledTextColor: Colors.white70,
        padding: EdgeInsets.only(top: 14.0, bottom: 14.0),
        child: Text(
          'Register',
          style: TextStyle(fontSize: 16.0),
        ),
        onPressed: _isCommitButtonEnable ? _validParams : null,
      ),
    );
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
          _passwordController.text.length > 0;
    });
  }
}
