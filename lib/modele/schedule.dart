import 'package:flutter/material.dart';

class Schedule {
  int _idJour;
  String _jour;
  TimeOfDay? _opensAtAM;
  TimeOfDay? _closesAtAM;
  TimeOfDay? _opensAtPM;
  TimeOfDay? _closesAtPM;

  Schedule._(this._idJour, this._jour, this._opensAtAM, this._closesAtAM,
      this._opensAtPM, this._closesAtPM);

  factory Schedule(
      {required int idJour,
      required String jour,
      TimeOfDay? opensAtAM,
      TimeOfDay? closesAtAM,
      TimeOfDay? opensAtPM,
      TimeOfDay? closesAtPM}) {
    return Schedule._(
        idJour, jour, opensAtAM, closesAtAM, opensAtPM, closesAtPM);
  }

  String get day => _jour;

  TimeOfDay? get opensAtAM => _opensAtAM;

  // String get opensAtAMDisplay => _opensAtAM.toString() ?? "-";

  TimeOfDay? get closesAtPM => _closesAtPM;

  // String get closesAtPMDisplay => closesAtPM.toString() ?? "-";

  TimeOfDay? get opensAtPM => _opensAtPM;

  // String get opensAtPMDisplay => opensAtPM.toString() ?? "-";

  TimeOfDay? get closesAtAM => _closesAtAM;

  @override
  String toString() {
    return "$_jour : ${getHours()}";
  }

  String getHours() {
    String? morning;
    String? afternoon;
    String result = "";

    if (_opensAtAM != null && _closesAtAM != null) {
      morning =
          "${_reformat(_opensAtAM!.hour)}:${_reformat(_opensAtAM!.minute)} - ${_reformat(_closesAtAM!.hour)}:${_reformat(_opensAtAM!.minute)}";
    }
    if (_opensAtPM != null && _closesAtPM != null) {
      afternoon =
          "${_reformat(_opensAtPM!.hour)}:${_reformat(_opensAtPM!.minute)} - ${_reformat(_closesAtPM!.hour)}:${_reformat(_opensAtPM!.minute)}";
    }

    // No data
    if (morning == null && afternoon == null) return result += " - ";

    // Morning hours
    if (morning != null) result += morning;

    // Morning - Afternoon, coma-separated.
    if (morning != null && afternoon != null) result += " / ";

    return result + (afternoon ?? "");
  }

  String _reformat(int value) {
    if (value < 10) return '0$value';
    return value.toString();
  }

  String get amHours{
    if (_opensAtAM != null && _closesAtAM != null) {
      return
      "${_reformat(_opensAtAM!.hour)}:${_reformat(_opensAtAM!.minute)} - ${_reformat(_closesAtAM!.hour)}:${_reformat(_opensAtAM!.minute)}";
    }else{
      return "-";
    }
  }

  String get pmHours{
    if (_opensAtPM != null && _closesAtPM != null) {
      return "${_reformat(_opensAtPM!.hour)}:${_reformat(_opensAtPM!.minute)} - ${_reformat(_closesAtPM!.hour)}:${_reformat(_opensAtPM!.minute)}";
    }else{
      return "-";
    }
  }

  /// Creates a deep copy of [this].
  Schedule clone(){
    return Schedule(idJour: _idJour, jour: _jour, opensAtAM: _opensAtAM, closesAtAM: _closesAtAM, opensAtPM:_opensAtPM, closesAtPM: _closesAtPM);
  }

  set opensAtAM(TimeOfDay? value) {
    _opensAtAM = value;
  }

  set closesAtPM(TimeOfDay? value) {
    _closesAtPM = value;
  }

  set opensAtPM(TimeOfDay? value) {
    _opensAtPM = value;
  }

  set closesAtAM(TimeOfDay? value) {
    _closesAtAM = value;
  }
}
