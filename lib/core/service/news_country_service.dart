import 'package:geocoder_pro/geocoder_pro.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';

class NewsCountry {
  final String code;
  final String name;

  const NewsCountry({required this.code, required this.name});
}

class NewsCountryService {
  static const _boxName = 'app_settings';
  static const _countryCodeKey = 'news_country_code';
  static const _countryNameKey = 'news_country_name';

  // تحميل الدولة المحفوظة، أو تحديدها في أول تشغيل.
  Future<NewsCountry> loadOrDetect() async {
    final box = Hive.box(_boxName);
    final savedCode = await box.get(_countryCodeKey) as String?;
    final savedName = await box.get(_countryNameKey) as String?;

    if (savedCode != null &&
        savedCode.isNotEmpty &&
        savedName != null &&
        savedName.isNotEmpty) {
      return NewsCountry(code: savedCode, name: savedName);
    }

    return detectAndSave();
  }

  // GPS أولًا، والخدمة تدعم IP fallback.
  Future<NewsCountry> detectAndSave() async {
    try {
      // 1. التأكد إن خدمة الموقع شغالة.
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        throw Exception('Location service is disabled');
      }

      // 2. طلب إذن الموقع.
      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception('Location permission denied');
      }

      // 3. الحصول على الإحداثيات.
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 10),
        ),
      );

      // 4. تحويل الإحداثيات إلى بيانات الدولة.
      final geoData = await GeocoderPro.nominatim().getDataFromCoordinates(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      final code = geoData?.countryCode.trim().toLowerCase();
      final name = geoData?.country.trim();

      if (code == null || code.isEmpty || name == null || name.isEmpty) {
        throw Exception('Could not determine country');
      }

      final country = NewsCountry(code: code, name: name);

      // 5. حفظ الدولة في Hive.
      await save(country);

      return country;
    } catch (_) {
      // لو التحديد فشل، نستخدم مصر كقيمة افتراضية.
      const fallback = NewsCountry(code: 'eg', name: 'Egypt');

      await save(fallback);

      return fallback;
    }
  }

  // حفظ الدولة التي اختارها المستخدم.
  Future<void> save(NewsCountry country) async {
    final box = Hive.box(_boxName);
    await box.put(_countryCodeKey, country.code.toLowerCase());

    await box.put(_countryNameKey, country.name);
  }
}
