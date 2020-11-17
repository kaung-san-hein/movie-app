import 'package:flutter/material.dart';
import 'package:movie_admin/widgets/progress_hud.dart';

class FormWrapper extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final String appbarTitle;
  final String btnLabel;
  final model;
  final Function handleDelete;
  final Function handleSave;
  final List<Widget> formItems;

  FormWrapper({
    @required this.formKey,
    this.appbarTitle = 'No Title',
    this.btnLabel = 'No Label',
    this.model,
    this.handleDelete,
    this.handleSave,
    this.formItems,
  }) : assert(formKey != null);

  @override
  _FormWrapperState createState() => _FormWrapperState();
}

class _FormWrapperState extends State<FormWrapper> {
  bool _isAsyncCall = false;

  void _handleSave() async {
    if (widget.formKey.currentState.validate()) {
      setState(() {
        _isAsyncCall = true;
      });
      // keyboard dismiss
      FocusScope.of(context).requestFocus(FocusNode());

      if (widget.handleSave != null) await widget.handleSave();

      setState(() {
        _isAsyncCall = false;
      });
    }
  }

  void _handleDelete() async {
    setState(() {
      _isAsyncCall = true;
    });

    if (widget.handleDelete != null) await widget.handleDelete();

    setState(() {
      _isAsyncCall = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appbarTitle),
      ),
      body: SafeArea(
        child: ProgressHUD(
          inAsyncCall: _isAsyncCall,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: widget.formKey,
              child: ListView(
                children: [
                  if (widget.formItems != null) ...widget.formItems,
                  RaisedButton(
                    child: Text(widget.btnLabel),
                    onPressed: _handleSave,
                  ),
                  widget.model == null
                      ? Container()
                      : RaisedButton(
                          child: Text("Delete"),
                          color: Colors.red,
                          onPressed: _handleDelete,
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
