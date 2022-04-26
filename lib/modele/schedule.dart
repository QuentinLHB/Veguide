import 'package:flutter/material.dart';
// import 'package:json_serializable/json_serializable.dart';
// import 'package:json_annotation/json_annotation.dart';

// part 'schedule.g.dart';

/// Class storing business hours for a day.
// @JsonSerializable()
class Schedule {
  int _idJour;
  String _day;
  TimeOfDay? _opensAtAM;
  TimeOfDay? _closesAtAM;
  TimeOfDay? _opensAtPM;
  TimeOfDay? _closesAtPM;

  Schedule._(this._idJour, this._day, this._opensAtAM, this._closesAtAM,
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

  /// Gets the day name.
  String get day => _day;

  /// Gets the morning opening hour.
  TimeOfDay? get opensAtAM => _opensAtAM;

  /// Gets the morning closing hour.
  TimeOfDay? get closesAtPM => _closesAtPM;


  /// Gets the afternoon opening hour.
  TimeOfDay? get opensAtPM => _opensAtPM;

  /// Gets the afternoon closing hour.
  TimeOfDay? get closesAtAM => _closesAtAM;

  /// Formats [this] in the following format:
  /// '[day] : hh:mm - hh:mm / hh:mm - hh:mm'.
  @override
  String toString() {
    return "$_day : ${getHours()}";
  }

  /// Formats the hours in the following format:
  /// hh:mm - hh:mm / hh:mm - hh:mm
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

  /// Reformats to add a leading 0 if needed.
  String _reformat(int value) {
    if (value < 10) return '0$value';
    return value.toString();
  }

  /// Gets morning hours as a string in a hh:mm format.
  String get amHours{
    if (_opensAtAM != null && _closesAtAM != null) {
      return
      "${_reformat(_opensAtAM!.hour)}:${_reformat(_opensAtAM!.minute)} - ${_reformat(_closesAtAM!.hour)}:${_reformat(_opensAtAM!.minute)}";
    }else{
      return "-";
    }
  }
  /// Gets afternoon hours as a string in a hh:mm format.
  String get pmHours{
    if (_opensAtPM != null && _closesAtPM != null) {
      return "${_reformat(_opensAtPM!.hour)}:${_reformat(_opensAtPM!.minute)} - ${_reformat(_closesAtPM!.hour)}:${_reformat(_opensAtPM!.minute)}";
    }else{
      return "-";
    }
  }

  /// Creates a deep copy of [this].
  Schedule clone(){
    return Schedule(idJour: _idJour, jour: _day, opensAtAM: _opensAtAM, closesAtAM: _closesAtAM, opensAtPM:_opensAtPM, closesAtPM: _closesAtPM);
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

  // /// Connect the generated [_$PersonFromJson] function to the `fromJson`
  // /// factory.
  // factory Schedule.fromJson(Map<String, dynamic> json) => _$ScheduleFromJson(json);
  //
  // /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  // Map<String, dynamic> toJson() => _$ScheduleToJson(this);
}
