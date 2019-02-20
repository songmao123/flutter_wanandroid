import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/page/login/register_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract class AbstractLoginPage extends StatelessWidget {
  final String _assetBgImage;

  AbstractLoginPage(this._assetBgImage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: GestureDetector(
        child: _loginBodyWidget(context),
        onTap: () {
          FocusScope.of(context).requestFocus(
            FocusNode(),
          );
        },
      ),
    );
  }

  Widget _loginBodyWidget(BuildContext context) {
    return Stack(
      children: <Widget>[
        _backgroundWidget(),
        _closeWidget(context),
        buildContent(context),
      ],
    );
  }

  Widget _closeWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 30.0, top: 50.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          splashColor: Colors.white30,
          highlightColor: Colors.black12,
          borderRadius: BorderRadius.circular(35.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.close,
              size: 35.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _backgroundWidget() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(_assetBgImage),
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
          ),
        ),
      ),
    );
  }

  @protected
  Widget buildContent(BuildContext context);
}

class LoginPage extends AbstractLoginPage {
  LoginPage(String assetBgImage) : super(assetBgImage);

  @override
  Widget buildContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _loginTitleWidget(),
        LoginAreaWidget(),
        _registerWidget(context),
      ],
    );
  }

  Widget _loginTitleWidget() {
    return Container(
      alignment: AlignmentDirectional.center,
      child: Text(
        'Login',
        style: TextStyle(
            fontSize: 60.0, color: Colors.white, fontFamily: 'Pacifico'),
      ),
    );
  }

  Widget _registerWidget(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegisterPage(_assetBgImage),
            ),
          );
        },
        splashColor: Colors.white30,
        highlightColor: Colors.black12,
        borderRadius: BorderRadius.circular(5.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          child: Container(
            padding: EdgeInsets.only(bottom: 5.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white),
              ),
            ),
            child: Text(
              'Not account yet? Create one',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginAreaWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginAreaState();
}

class LoginAreaState extends State<LoginAreaWidget> {
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
              _forgetPasswordWidget(),
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

  Widget _forgetPasswordWidget() {
    return Container(
      alignment: AlignmentDirectional.topEnd,
      child: FlatButton(
        onPressed: () {
          Fluttertoast.showToast(msg: 'Developing...');
        },
        splashColor: Colors.white30,
        highlightColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
        child: Text(
          'Forget password?',
          style: TextStyle(color: Colors.white),
        ),
      ),
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
          'Login',
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
