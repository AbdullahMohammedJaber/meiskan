 

class RegisterRequest {
  final String password, address, name, email, phone;

  RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "phone": phone,
      "name": name,
      "address": address,
    };
  }
}

class ForgotPasswordRequest {
  final String email;

  ForgotPasswordRequest({
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}

class GetOffersRequest {
  final bool showOnlineOnly;
  final int page, perPage, uid;

  GetOffersRequest({
    required this.page,
    required this.perPage,
    required this.uid,
    required this.showOnlineOnly,
  });

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'page_size': perPage,
      'user_id': uid,
      'show_online_only': showOnlineOnly,
    };
  }
}

class AddOfferRequest {
  int? uid;
  String? type;
  int? quantity;
  int? minReservationAmount;
  String? terms;
  int? wilayaId;
  int? price;
  int? currencyId, forCurrencyId;
  int? dealingDurationId;
  List<int>? banksIds;
  List<int>? paymentMethodBanksIds;

  AddOfferRequest({
    required this.uid,
    required this.type,
    required this.quantity,
    required this.minReservationAmount,
    required this.terms,
    required this.wilayaId,
    required this.price,
    required this.currencyId,
    required this.forCurrencyId,
    required this.dealingDurationId,
    required this.banksIds,
    required this.paymentMethodBanksIds,
  });

  Map<String, dynamic> toJson() => {
        'user_id': uid,
        'type': type,
        'for_currency_id': forCurrencyId,
        'quantity': quantity,
        'min_reservation_amount': minReservationAmount,
        'terms': terms,
        'wilaya_id': wilayaId,
        'price': price,
        'currency_id': currencyId,
        'dealing_duration_id': dealingDurationId,
        'banks_ids': banksIds,
        'payment_method_banks_ids': paymentMethodBanksIds,
      };
}

