import 'package:app/app/core/utils/strings_manager.dart';
import 'package:get/get.dart';

extension StringExtension on String? {
  String get orEmpty {
    return this ?? '';
  }
}

extension BoolExtension on bool? {
  bool get orEmpty {
    return this ?? false;
  }
}

extension IntExtension on int? {
  int get orEmpty {
    return this ?? -1;
  }
}

extension DoubleExtension on double? {
  double get orEmpty {
    return this ?? 0.0;
  }
}

extension IntExtensions on int {
  String get toFormattedPrice {
    if (this >= 1000000000) {
      double priceInBillions = this / 1000000000;
      return '${priceInBillions.toStringAsFixed(priceInBillions.truncateToDouble() == priceInBillions ? 0 : 2)} ${AppStrings.bilion.tr}';
    } else if (this >= 1000000) {
      double priceInMillions = this / 1000000;
      return '${priceInMillions.toStringAsFixed(priceInMillions.truncateToDouble() == priceInMillions ? 0 : 2)} ${AppStrings.milion.tr}';
    } else if (this >= 1000) {
      double priceInThousands = this / 1000000;
      return '${priceInThousands.toStringAsFixed(priceInThousands.truncateToDouble() == priceInThousands ? 0 : 2)} ${AppStrings.milion.tr}';
    } else {
      return '${toDouble()}';
    }
  }
}

extension DateTimeExtension on DateTime? {
  DateTime get orEmpty {
    return this ?? DateTime.now();
  }
}

extension ListExtension on List? {
  List get orEmpty {
    return this ?? [];
  }
}

extension MapExtension on Map? {
  Map get orEmpty {
    return this ?? {};
  }
}

extension RunesExtension on Runes? {
  Runes get orEmpty {
    return this ?? Runes('');
  }
}

extension SetExtension on Set? {
  Set get orEmpty {
    return this ?? <dynamic>{};
  }
}
