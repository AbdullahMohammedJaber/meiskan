 import 'package:app/app/modules/contractor/contractor_profile/controllers/contractor_profile_id_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class ContractorProfileId extends StatefulWidget {
 
  const ContractorProfileId({super.key,});

  @override
  State<ContractorProfileId> createState() => _ContractorProfileIdState();
}

class _ContractorProfileIdState extends State<ContractorProfileId> {
   late ContractorProfileIdController controller;
   @override
  void initState() {
    super.initState();

    controller =
        Get.put(ContractorProfileIdController(), tag: UniqueKey().toString());
  }

  @override
  void dispose() {
    Get.delete<ContractorProfileIdController>();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الملف الشخصي"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasError.value) {
          return Center(
            child: ElevatedButton(
              onPressed: controller.fetchContractorDetails,
              child: const Text("إعادة المحاولة"),
            ),
          );
        }

        final contractor = controller.contractorDetailed.value;

        if (contractor == null) {
          return const Center(child: Text("لا توجد بيانات"));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              /// صورة البروفايل
              CircleAvatar(
                radius: 55,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: contractor.imageUrl != null
                    ? NetworkImage(contractor.imageUrl!)
                    : null,
                child: contractor.imageUrl == null
                    ? const Icon(Icons.person, size: 50)
                    : null,
              ),

              const SizedBox(height: 10),

              /// الاسم
              Text(
                contractor.fullName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              /// التقييم
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 5),
                  Text(
                    contractor.rateStars.toString(),
                    style: const TextStyle(fontSize: 16),
                  )
                ],
              ),

              const SizedBox(height: 20),

              /// معلومات التواصل
              _buildCard(
                title: "معلومات التواصل",
                children: [
                  _buildItem("رقم الهاتف", contractor.phoneNumber),
                  _buildItem("البريد الإلكتروني", contractor.email),
                  _buildItem("بريد التواصل", contractor.emailContact),
                ],
              ),

              const SizedBox(height: 15),

              /// الاشتراك
              if (contractor.subscription != null)
                _buildCard(
                  title: "معلومات الاشتراك",
                  children: [
                    _buildItem(
                        "الباقة", contractor.subscription!.planName),
                    _buildItem(
                        "العروض المتبقية",
                        contractor.subscription!.remainingOffers.toString()),
                    _buildItem(
                        "تاريخ التجديد",
                        contractor.subscription!.nextBillingDate
                            .toString()),
                  ],
                ),

              const SizedBox(height: 15),

              /// الخبرة
              if (contractor.experiancDes.isNotEmpty)
                _buildCard(
                  title: "الخبرة",
                  children: [
                    Text(
                      contractor.experiancDes,
                      style: const TextStyle(fontSize: 15),
                    )
                  ],
                ),

              const SizedBox(height: 15),

              /// إحصائيات
              _buildCard(
                title: "الإحصائيات",
                children: [
                  _buildItem(
                      "عدد العروض", contractor.offers.length.toString()),
                  _buildItem(
                      "عدد الوظائف", contractor.jobs.length.toString()),
                  _buildItem(
                      "عدد العمليات",
                      contractor.transactions.length.toString()),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  /// كارد رئيسي
  Widget _buildCard({
    required String title,
    required List<Widget> children,
  }) {
    if (children.isEmpty) return const SizedBox();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          ...children
        ],
      ),
    );
  }

  /// عنصر معلومة (لا يظهر إذا كان null أو فارغ)
  Widget _buildItem(String title, String? value) {
    if (value == null || value.isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            "$title : ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          )
        ],
      ),
    );
  }
}