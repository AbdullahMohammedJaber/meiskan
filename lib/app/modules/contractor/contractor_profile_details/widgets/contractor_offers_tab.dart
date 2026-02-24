import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../data/model/offer.dart';
import '../../../../widgets/cards/offer_card.dart';

class ContractorOffersTab extends StatelessWidget {
  final List<ProjectOffer> offers;

  const ContractorOffersTab({super.key, required this.offers});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 25.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(
          offers.length,
          (index) {
            final offer = offers[index];
            return Column(
              children: [
                OfferCard(
                  offer: offer,
                  showShowProjectButton: true,
                ),
                if (index != offers.length - 1) const Divider(),
              ],
            );
          },
        ),
      ),
    );
  }
}
