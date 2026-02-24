import 'package:app/app/core/base/base_viewmodel.dart';
import 'package:app/app/data/model/conversation.dart';
import 'package:app/app/services/conversation_services.dart';
 
import 'package:get/get.dart';

class ConversationsController extends BaseController {
  final messages = <ConversationModel>[].obs;
  final hasError = false.obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final currentPage = 0.obs;
  final hasMoreData = true.obs;
  final itemsPerPage = 10; // Define items per page
  final conversationId = "".obs; // Track current conversation
  final projectId = "".obs; // Track current project ID

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch({bool refresh = false}) async {
    if (!refresh &&
        (isLoading.value || isLoadingMore.value || !hasMoreData.value)) {
      return;
    }

    final int previousPage = currentPage.value;
    final bool previousHasMore = hasMoreData.value;

    if (refresh) {
      currentPage.value = 1;
      hasMoreData.value = true;
    } else if (currentPage.value == 0) {
      currentPage.value = 1;
    }

    final bool showFullScreenLoader = messages.isEmpty;
    if (showFullScreenLoader) {
      isLoading.value = true;
    } else if (!refresh) {
      isLoadingMore.value = true;
    }

    hasError.value = false;

    final failureOrSuccess = await ConversationServices.getConversations(
      projectId: projectId.value.isNotEmpty ? projectId.value : null,
      pageNumber: refresh ? 1 : currentPage.value,
      pageSize: itemsPerPage,
    );

    if (showFullScreenLoader) {
      isLoading.value = false;
    } else {
      isLoadingMore.value = false;
    }

    failureOrSuccess.fold(
      (failure) {
        hasError.value = true;
        if (refresh) {
          currentPage.value = previousPage;
          hasMoreData.value = previousHasMore;
        } else if (!showFullScreenLoader) {
          currentPage.value = previousPage;
        }
        handleError(failure, () => fetch(refresh: refresh));
      },
      (paginatedResult) {
        final List<ConversationModel> fetchedConversations =
            paginatedResult.conversations;
        final int returnedPage =
            paginatedResult.pageNumber <= 0 ? 1 : paginatedResult.pageNumber;
        final bool isFirstPage = refresh || returnedPage <= 1;

        if (fetchedConversations.isEmpty) {
          if (refresh) {
            messages.clear();
            currentPage.value = 1;
          } else {
            currentPage.value = previousPage;
          }
          hasMoreData.value = false;
          return;
        }

        if (isFirstPage) {
          messages.assignAll(fetchedConversations);
        } else {
          messages.addAll(fetchedConversations);
        }

        final bool hasMore = returnedPage < paginatedResult.totalPages &&
            messages.length < paginatedResult.totalCount;
        hasMoreData.value = hasMore;
        currentPage.value = hasMore ? returnedPage + 1 : returnedPage;
      },
    );
  }

  Future<void> loadMore() async {
    if (!hasMoreData.value || isLoading.value || isLoadingMore.value) {
      return;
    }
    await fetch();
  }
}
