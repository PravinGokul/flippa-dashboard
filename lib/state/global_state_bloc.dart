import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'global_state_bloc.freezed.dart';

@freezed
abstract class GlobalState with _$GlobalState {
  const factory GlobalState({
    @Default(Locale('en', 'US')) Locale locale,
    @Default('USD') String currency,
    @Default(1.0) double exchangeRate, // Relative to USD
    @Default(ThemeMode.system) ThemeMode themeMode,
  }) = _GlobalState;
}

@freezed
abstract class GlobalEvent with _$GlobalEvent {
  const factory GlobalEvent.changeLanguage(Locale locale) = _ChangeLanguage;
  const factory GlobalEvent.changeCurrency(String currencyCode) = _ChangeCurrency;
  const factory GlobalEvent.toggleTheme(ThemeMode mode) = _ToggleTheme;
}

class GlobalBloc extends Bloc<GlobalEvent, GlobalState> {
  GlobalBloc() : super(const GlobalState()) {
    on<_ToggleTheme>((event, emit) {
      emit(state.copyWith(themeMode: event.mode));
    });
    
    on<_ChangeLanguage>((event, emit) {
      emit(state.copyWith(locale: event.locale));
    });

    on<_ChangeCurrency>((event, emit) {
      double rate = 1.0;
      if (event.currencyCode == 'INR') rate = 83.0;
      if (event.currencyCode == 'EUR') rate = 0.92;
      
      emit(state.copyWith(
        currency: event.currencyCode,
        exchangeRate: rate,
      ));
    });
  }
}
