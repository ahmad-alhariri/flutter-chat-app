import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/enums/enums.dart';

class BaseViewModel extends ChangeNotifier {
  ViewState _state = ViewState.Idle;
  String? _errorMessage;

  ViewState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get isBusy => _state == ViewState.Busy;

  void setState(ViewState viewState, {String? message}) {
    _state = viewState;
    if (viewState == ViewState.Error) {
      _errorMessage = message;
    } else {
      _errorMessage = null; // Clear error on other states
    }
    notifyListeners();
  }
}