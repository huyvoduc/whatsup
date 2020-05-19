import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:whatsup/common/widgets/dialogs/dialog_extention.dart';
import 'package:whatsup/common/widgets/simple_button.dart';
import 'package:whatsup/common/widgets/simple_icon_button.dart';
import 'package:whatsup/presentation/theme/theme_color.dart';
import 'package:whatsup/common/extensions/string_extension.dart';
import 'package:whatsup/utils/dimension.dart';

class SaveResponse {
  bool result;
  String message;
  bool willPop;

  SaveResponse({
    this.result,
    this.message,
    this.willPop = true,
  });
}

class ChangeValueScreen extends StatefulWidget {
  final String value;
  final String title;
  final String hint;
  final String description;
  final bool willShowLoading;
  final TextInputType inputType;
  final bool digitOnly;
  final Future<SaveResponse> Function(String value) onSave;

  const ChangeValueScreen({
    Key key,
    @required this.value,
    @required this.title,
    this.hint,
    this.willShowLoading = true,
    this.description,
    this.inputType,
    this.digitOnly = false,
    this.onSave,
  }) : super(key: key);

  @override
  _ChangeValueScreenState createState() => _ChangeValueScreenState();
}

class _ChangeValueScreenState extends State<ChangeValueScreen> {
  TextEditingController _textController;
  final StreamController<bool> _streamController =
      StreamController<bool>.broadcast();
  bool _isLoading = false;

  @override
  void initState() {
    _textController = TextEditingController(text: widget.value);
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    _streamController.close();
    super.dispose();
  }

  ThemeData _themeData;
  TextTheme get _textTheme => _themeData.textTheme;

  @override
  Widget build(BuildContext context) {
    _themeData = Theme.of(context);
    return WillPopScope(
      onWillPop: _onBackkeyProcessed,
      child: StreamBuilder<Object>(
        initialData: _isLoading,
        stream: _streamController.stream,
        builder: (context, snapshot) {
          bool _isShowloading = false;

          if (snapshot.hasData && !snapshot.hasError && snapshot.data) {
            _isShowloading = true;
          }

          return Stack(
            children: <Widget>[
              Scaffold(
                backgroundColor: AppColor.primaryColor,
                appBar: AppBar(
                  title: Text(widget.title ?? ''),
                  centerTitle: true,
                  elevation: 0,
                  leading: SimpleIconButton(
                    height: 40,
                    width: 40,
                    icon: Icon(Icons.arrow_back),
                    borderColor: Colors.transparent,
                    borderRadius: 0,
                    onPressed: _onBackkeyProcessed,
                  ),
                  actions: <Widget>[
                    SimpleButton(
                      height: 40,
                      width: 60,
                      text: 'Save',
                      borderColor: Colors.transparent,
                      borderRadius: 0,
                      bgColors: const [Colors.transparent, Colors.transparent],
                      onPressed: _handleSaveClick,
                    )
                  ],
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      color: Colors.white10,
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: widget.hint ?? '',
                          hintStyle: const TextStyle(color: Colors.white30),
                          contentPadding: const EdgeInsets.all(
                            8,
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        keyboardType: widget.inputType,
                        inputFormatters: widget.digitOnly == true
                            ? <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly
                              ]
                            : [],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.description ?? '',
                        style: _textTheme.title.copyWith(
                          color: Colors.white30,
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: hideKeyboard,
                        child: Container(
                          color: AppColor.primaryColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              !_isShowloading || !widget.willShowLoading
                  ? const SizedBox()
                  : _buildLoading(),
            ],
          );
        },
      ),
    );
  }

  void _showLoading() {
    _isLoading = true;
    _streamController.add(_isLoading);
  }

  void _hideLoading() {
    _isLoading = false;
    _streamController.add(_isLoading);
  }

  Widget _buildLoading() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.black12.withOpacity(0.5),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            _themeData.accentColor,
          ),
        ),
      ),
    );
  }

  //handle click
  Future<bool> _onBackkeyProcessed() async {
    if (!_isLoading) {
      Navigator.pop(context);
    }
    return false;
  }

  void _handleSaveClick() {
    hideKeyboard();
    if (widget.onSave != null) {
      if (widget.willShowLoading) {
        _showLoading();
      }

      widget.onSave(_textController.text).then((response) {
        _hideLoading();
        if (!response.message.isNullOrEmpty()) {
          _showNotiDialog(response.message, willPop: response.willPop);
        }
      });
    }
  }

  void _showNotiDialog(String message, {bool willPop = false}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return successNotiedPopup(
          width: Dimension.getWidth(0.9),
          height: Dimension.getWidth(0.9),
          styleTextTitle: _textTheme.title.copyWith(
            color: Colors.green,
            fontSize: 22,
          ),
          styleTextContent: _textTheme.title.copyWith(
            color: _themeData.accentColor,
          ),
          content: message,
          iconPopup: const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 100,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        );
      },
    ).then((_) {
      if (willPop == true) {
        Navigator.pop(context);
      }
    });
  }

  //function
  void hideKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
