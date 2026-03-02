import 'package:app/app/config/routes/app_pages.dart';
import 'package:app/app/core/utils/colors_manager.dart';
import 'package:app/app/core/utils/scroll_behavior.dart';
import 'package:app/app/core/utils/strings_manager.dart';
import 'package:app/app/data/model/conversation.dart';
import 'package:app/app/widgets/appbar/appbar.dart';
import 'package:app/app/widgets/states/app_empty_state.dart';
import 'package:app/app/widgets/states/app_error_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../controllers/conversations_controller.dart';

class ConversationsView extends GetView<ConversationsController> {
  final bool showAppBar;

  const ConversationsView({super.key, this.showAppBar = true});

  @override
  ConversationsController get controller => Get.put(ConversationsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !showAppBar ? null : const CustomAppBar(),
      body: SafeArea(
        child: Obx(() {
          if (controller.hasError.value && controller.messages.isEmpty) {
            return AppErrorState(
              onRetry: () => controller.fetch(refresh: true),
            );
          }

          if (controller.isLoading.value && controller.messages.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show empty state when there are no conversations
          if (!controller.isLoading.value && controller.messages.isEmpty) {
            return const AppEmptyState(
              title: AppStrings.noConversations,
              description: AppStrings.noConversationsDescription,
              icon: Icons.chat_outlined,
            );
          }

          return RefreshIndicator(
            onRefresh: () async => await controller.fetch(refresh: true),
            child: ScrollConfiguration(
              behavior: CustomScrollBehavior(),
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo is ScrollUpdateNotification &&
                      scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent - 80) {
                    controller.loadMore();
                  }
                  return false;
                },
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: controller.messages.length +
                            (controller.isLoadingMore.value ? 1 : 0),
                        separatorBuilder: (_, __) => 1.verticalSpace,
                        itemBuilder: (context, index) {
                          if (index >= controller.messages.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ),
                            );
                          }

                          final message = controller.messages[index];
                          return _MessageCard(item: message);
                        },
                      ),
                    ),
                    if (controller.hasError.value &&
                        controller.messages.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              AppStrings.errorOccurred.tr,
                              style: Get.textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            8.verticalSpace,
                            TextButton(
                              onPressed: controller.loadMore,
                              child: Text(AppStrings.retry.tr),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({required this.item});

  final ConversationModel item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final chatTag =
            'chat_${item.conversationId}_${item.contractorId}_${DateTime.now().microsecondsSinceEpoch}';
        Get.toNamed(
          Routes.CHAT,
          arguments: {
            'conversationId': item.conversationId,
            'contractorId': item.contractorId,
            'projectId': item.projectId,
            'isProjectOwner': false,
            'chatTag': chatTag,
          },
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        decoration: BoxDecoration(
            color: item.isRead ? Colors.white : Colors.grey.shade200,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300),
            )),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 54.w,
                height: 54.w,
                decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const CircleAvatar(
                    child: Icon(Icons.person, color: Colors.white)),
              ),
              14.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.projectTitle,
                            style: Get.textTheme.bodySmall!.copyWith(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: null,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                        5.horizontalSpace,
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            item.lastMessage,
                            style: Get.textTheme.bodySmall!.copyWith(
                              fontSize: 10.sp,
                              color: AppColors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    4.verticalSpace,
                    Text(
                      item.userName,
                      style: Get.textTheme.bodySmall!.copyWith(
                        color: AppColors.primaryColor,
                        fontSize: 10.sp,
                      ),
                      maxLines: null,
                      overflow: TextOverflow.visible,
                    ),
                    7.verticalSpace,
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            DateFormat('yyyy-MM-dd – kk:mm')
                                .format(item.lastMessageAt),
                            style: Get.textTheme.bodySmall!.copyWith(
                              color: AppColors.grey,
                              fontSize: 10.sp,
                            ),
                            maxLines: null,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                        if (item.isRead)
                          Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: const BoxDecoration(
                              color: AppColors.errorColor,
                              shape: BoxShape.circle,
                            ),
                          )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
