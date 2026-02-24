import '../../core/constants.dart';

class EndPoints {
  // Base URLs
  static const String baseApiUrl = "${Constants.apiBaseUrl}";
  
  // Auth endpoints
  static const String signin = "${baseApiUrl}Auth/Signin";
  static const String verifyAccount = "${baseApiUrl}Auth/VerifyAccount";
  static const String resendActivationCode = "${baseApiUrl}Auth/ResendActivationCode";
  static const String login = "${baseApiUrl}Auth/Login";
  static const String refreshToken = "${baseApiUrl}Auth/RefreshToken";
  static const String forgotPassword = "${baseApiUrl}Auth/ForgtPassword";
  static const String verifyCodeResetPassword = "${baseApiUrl}Auth/VerifyCodeResetPassword";
  static const String resetPassword = "${baseApiUrl}Auth/ResetPassword";
  static const String getRoles = "${baseApiUrl}Auth/GetRoles";

  // Device endpoints
  static const String saveDeviceToken = "${baseApiUrl}device/save-token";
  
  // Users endpoints
  static const String users = "${baseApiUrl}users";
  static const String addRate = "${baseApiUrl}Users/AddRate";
  static const String detailsContractor = "${baseApiUrl}Users/DetailsContractor";
  static const String editContractor = "${baseApiUrl}Users/EditContractor";
  static const String readNotification = "${baseApiUrl}Users/ReadNotificatin";
  static const String deleteOldNotifications = "${baseApiUrl}Users/DeleteOldNotifications";
  static const String getStatistics = "${baseApiUrl}Users/GetStatistics";
  
  // Projects endpoints
  static const String getProjects = "${baseApiUrl}Projects/GetProjects";
  static const String detailsProject = "${baseApiUrl}Projects/DetailsProject";
  static const String createProject = "${baseApiUrl}Projects/CreateProject";
  static const String deleteProject = "${baseApiUrl}Projects/DeleteProject";
  
  // Jobs endpoints
  static const String getAllJobs = "${baseApiUrl}JobsContractor/GetAllJobs";
  static const String detailsJob = "${baseApiUrl}JobsContractor/DetailsJob";
  static const String createJob = "${baseApiUrl}JobsContractor/CreateJob";
  static const String updateJob = "${baseApiUrl}JobsContractor/UpdateJob";
  static const String deleteJob = "${baseApiUrl}JobsContractor/DeleteJob";
  
  // Offers endpoints
  static const String createOffer = "${baseApiUrl}Offers/CreateOffer";
  static const String deleteOffer = "${baseApiUrl}Offers/DeleteOffer";

  // Plans endpoints
  static const String pointOffers = "${baseApiUrl}PointOffers/GtAllPointOffers";
  static const String purchaseOfferPoint =
      "${baseApiUrl}Ballance/PurchaseOfferPoint";
  static const String purchasePoint = "${baseApiUrl}Ballance/PurchasePoint";
  
  // Notifications endpoints
  static const String getUserNotifications = "${baseApiUrl}Notifications/GetUserNotifications";
  static const String markAllAsRead = "${baseApiUrl}Notifications/MarkAllAsRead";

  static const String markAsRead = "${baseApiUrl}Notifications/MarkAsReadAsync";
  
  // Conversations endpoints
  static const String getConversations = "${baseApiUrl}Converstions/GetConverstions";
  static const String getConversationDetails = "${baseApiUrl}Converstions/GetConversationDetails";
  static const String sendMessage = "${baseApiUrl}Converstions/SendMessage";
  static const String createConversation = "${baseApiUrl}Converstions/CreateConversation";
  static const String getMessages = "${baseApiUrl}Converstions/GetMessages";
  static const String deleteConversation = "${baseApiUrl}Converstions/DeleteConversation";
  static const String deleteMessage = "${baseApiUrl}Converstions/DeleteMessage";
  static const String uploadConversationFiles = "${baseApiUrl}Converstions/UpladFiles";

  static const String cancelPlan = "${baseApiUrl}Subscription/cancel";

  // Categories endpoints
  static const String getCategories = "${baseApiUrl}Categories/GetCategories";
}
