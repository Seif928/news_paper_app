import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_paper_app/core/service/news_country_service.dart';

class CountryState {
  final String countryCode;
  final String countryName;
  final bool isLoading;

  const CountryState({
    required this.countryCode,
    required this.countryName,
    required this.isLoading,
  });

  const CountryState.initial()
    : countryCode = '',
      countryName = '',
      isLoading = true;
}

class CountryCubit extends Cubit<CountryState> {
  final NewsCountryService _countryService;

  CountryCubit(this._countryService) : super(const CountryState.initial());

  Future<void> initialize() async {
    try {
      final country = await _countryService.loadOrDetect();

      emit(
        CountryState(
          countryCode: country.code,
          countryName: country.name,
          isLoading: false,
        ),
      );
    } catch (_) {
      emit(
        const CountryState(
          countryCode: 'eg',
          countryName: 'Egypt',
          isLoading: false,
        ),
      );
    }
  }

  Future<void> selectCountry({
    required String countryCode,
    required String countryName,
  }) async {
    final country = NewsCountry(
      code: countryCode.toLowerCase(),
      name: countryName,
    );

    await _countryService.save(country);

    emit(
      CountryState(
        countryCode: country.code,
        countryName: country.name,
        isLoading: false,
      ),
    );
  }
}
