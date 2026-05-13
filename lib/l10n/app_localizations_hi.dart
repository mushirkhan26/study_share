// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'स्टडी शेयर';

  @override
  String get welcomeBack => 'वापस स्वागत है!';

  @override
  String get loginToAccess => 'अपने अध्ययन नोट्स देखने के लिए लॉगिन करें';

  @override
  String get emailAddress => 'ईमेल पता';

  @override
  String get enterEmail => 'अपना ईमेल दर्ज करें';

  @override
  String get password => 'पासवर्ड';

  @override
  String get enterPassword => 'पासवर्ड दर्ज करें';

  @override
  String get forgotPassword => 'पासवर्ड भूल गए?';

  @override
  String get login => 'लॉगिन';

  @override
  String get dontHaveAccount => 'क्या आपके पास खाता नहीं है?';

  @override
  String get signUp => 'साइन अप करें';

  @override
  String get loginSuccessful => 'लॉगिन सफल!';

  @override
  String get loginFailed => 'लॉगिन विफल';

  @override
  String discoverBooks(String name) {
    return 'किताबें खोजें, $name';
  }

  @override
  String helloSeller(String name) {
    return 'नमस्ते विक्रेता, $name';
  }

  @override
  String get findSecondHandBooks => 'वरिष्ठों से पुरानी किताबें खोजें';

  @override
  String get searchBooksHint => 'किताबें, लेखक या विषय खोजें...';

  @override
  String get categories => 'श्रेणियां';

  @override
  String get recentlyAdded => 'हाल ही में जोड़ा गया';

  @override
  String get viewAll => 'सभी देखें';

  @override
  String get noBooksFound => 'कोई किताब नहीं मिली';

  @override
  String get needStudyNotes => 'अध्ययन नोट्स चाहिए?';

  @override
  String get getPDFsAndNotes =>
      'टॉपर्स से पीडीएफ और हस्तलिखित नोट्स प्राप्त करें।';

  @override
  String get browse => 'देखें';

  @override
  String get home => 'होम';

  @override
  String get search => 'खोजें';

  @override
  String get sell => 'बेचें';

  @override
  String get chat => 'चैट';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get more => 'अधिक';

  @override
  String get myUploads => 'मेरे अपलोड';

  @override
  String get savedMaterials => 'सहेजी गई सामग्री';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get logout => 'लॉगआउट';

  @override
  String get buyerProfile => 'खरीदार प्रोफ़ाइल';

  @override
  String get sellerProfile => 'विक्रेता प्रोफ़ाइल';

  @override
  String get logoutConfirm => 'क्या आप वाकई लॉगआउट करना चाहते हैं?';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get createAccount => 'खाता बनाएं';

  @override
  String get joinCommunity => 'स्टडी शेयर समुदाय में शामिल हों';

  @override
  String get fullName => 'पूरा नाम';

  @override
  String get enterName => 'अपना नाम दर्ज करें';

  @override
  String get college => 'कॉलेज/विश्वविद्यालय';

  @override
  String get enterCollege => 'कॉलेज का नाम दर्ज करें';

  @override
  String get iWantTo => 'मैं चाहता हूँ';

  @override
  String get buyBooks => 'किताबें खरीदना';

  @override
  String get sellBooks => 'किताबें बेचना';

  @override
  String get createPassword => 'पासवर्ड बनाएं';

  @override
  String get alreadyHaveAccount => 'क्या आपके पास पहले से खाता है?';

  @override
  String get accountCreated => 'खाता सफलतापूर्वक बनाया गया!';

  @override
  String get signupFailed => 'साइनअप विफल रहा';

  @override
  String get nameRequired => 'नाम आवश्यक है';

  @override
  String get searchBooks => 'किताबें खोजें';

  @override
  String get searchHint => 'शीर्षक या लेखक द्वारा खोजें...';

  @override
  String get courseCategory => 'कोर्स / श्रेणी';

  @override
  String get searching => 'खोज रहे हैं...';

  @override
  String resultsFound(int count) {
    return 'परिणाम ($count मिले)';
  }

  @override
  String get noBooksMatching =>
      'आपकी खोज से मेल खाने वाली कोई किताब नहीं मिली।';

  @override
  String get all => 'सभी';

  @override
  String get bca => 'BCA';

  @override
  String get btech => 'B.Tech';

  @override
  String get bsc => 'B.Sc';

  @override
  String get ba => 'BA';

  @override
  String get bcom => 'B.Com';

  @override
  String get novels => 'उपन्यास';

  @override
  String get other => 'अन्य';

  @override
  String get postBook => 'किताब पोस्ट करें';

  @override
  String get sellerProfileRequired => 'विक्रेता प्रोफ़ाइल आवश्यक';

  @override
  String get buyerProfileNotice =>
      'आप वर्तमान में खरीदार प्रोफ़ाइल का उपयोग कर रहे हैं। विज्ञापन पोस्ट करने और अपनी किताबें बेचने के लिए विक्रेता प्रोफ़ाइल पर स्विच करें।';

  @override
  String get switchToSeller => 'विक्रेता प्रोफ़ाइल पर स्विच करें';

  @override
  String get switchToSellerConfirm => 'विक्रेता प्रोफ़ाइल पर स्विच करें?';

  @override
  String get switchToSellerNotice =>
      'विक्रेता प्रोफ़ाइल पर स्विच करके, आप पुस्तक विज्ञापन पोस्ट कर सकेंगे और अपनी सामग्री अन्य छात्रों को बेच सकेंगे।';

  @override
  String get switchText => 'स्विच करें';

  @override
  String get accountUpgraded => 'खाता विक्रेता में अपग्रेड हो गया!';

  @override
  String get failedToUpgrade => 'अपग्रेड करने में विफल';

  @override
  String get bookPhoto => 'किताब के फोटो (अधिकतम 3) *';

  @override
  String get tapToAddPhoto => 'फोटो जोड़ने के लिए टैप करें';

  @override
  String get selectSource => 'स्रोत चुनें';

  @override
  String get camera => 'कैमरा';

  @override
  String get gallery => 'गैलरी';

  @override
  String get frontPhoto => 'मुख्य फोटो';

  @override
  String get selectFrontPhoto => 'मुख्य फोटो चुनें';

  @override
  String get addMorePhotos => 'और फोटो जोड़ें';

  @override
  String get limitReached => 'सीमा समाप्त (अधिकतम 3 फोटो)';

  @override
  String get bookDetails => 'किताब का विवरण';

  @override
  String get bookTitle => 'किताब का शीर्षक';

  @override
  String get titleHint => 'जैसे: Let Us C';

  @override
  String get authorName => 'लेखक का नाम';

  @override
  String get authorHint => 'जैसे: यशवंत कानिटकर';

  @override
  String get sellingPrice => 'विक्रय मूल्य (₹)';

  @override
  String get priceHint => 'जैसे: 150';

  @override
  String get originalPrice => 'मूल मूल्य (₹)';

  @override
  String get originalPriceHint => 'जैसे: 400';

  @override
  String get condition => 'स्थिति';

  @override
  String get courseTag => 'कोर्स/टैग';

  @override
  String get description => 'विवरण';

  @override
  String get descriptionHint =>
      'हमें किताब के बारे में और बताएं (जैसे: निशान, हाइलाइट्स, या आप क्यों बेच रहे हैं इसके बारे में विवरण शामिल करें।)';

  @override
  String get postAd => 'विज्ञापन पोस्ट करें';

  @override
  String get pleaseUploadPhoto => 'कृपया किताब की एक तस्वीर अपलोड करें!';

  @override
  String get adPostedSuccess => 'पुस्तक विज्ञापन सफलतापूर्वक पोस्ट किया गया!';

  @override
  String get failedToPostAd => 'विज्ञापन पोस्ट करने में विफल';

  @override
  String get required => 'आवश्यक';

  @override
  String get likeNew => 'बिल्कुल नई जैसी';

  @override
  String get good => 'अच्छी';

  @override
  String get old => 'पुरानी';

  @override
  String get wornOut => 'घिसी-पिटी';

  @override
  String get myAccount => 'मेरा खाता';

  @override
  String get activeAds => 'सक्रिय विज्ञापन';

  @override
  String get booksSold => 'बेची गई किताबें';

  @override
  String get earnings => 'कमाई';

  @override
  String get myAdsManage => 'मेरे विज्ञापन (किताबें प्रबंधित करें)';

  @override
  String get myAdsSubtitle => 'संपादित करें, हटाएं, या बिका हुआ चिह्नित करें';

  @override
  String get wishlist => 'इच्छा-सूची';

  @override
  String get wishlistSubtitle => 'आपके द्वारा सहेजी गई किताबें';

  @override
  String get myChats => 'मेरी चैट';

  @override
  String get myChatsSubtitle => 'खरीदारों/विक्रेताओं के साथ बातचीत';

  @override
  String get settingsSubtitle => 'सूचनाएं, गोपनीयता, और बहुत कुछ';

  @override
  String get accountSettings => 'खाता सेटिंग्स';

  @override
  String get editProfile => 'प्रोफ़ाइल संपादित करें';

  @override
  String get notifications => 'सूचनाएं';

  @override
  String get privacySecurity => 'गोपनीयता और सुरक्षा';

  @override
  String get preferences => 'प्राथमिकताएं';

  @override
  String get appearance => 'दिखावट (थीम मोड)';

  @override
  String get appLanguage => 'ऐप की भाषा';

  @override
  String get supportAbout => 'सहायता और जानकारी';

  @override
  String get helpCenter => 'सहायता केंद्र / अक्सर पूछे जाने वाले प्रश्न';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get aboutApp => 'ऐप के बारे में';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String get languageChangeNotice =>
      'भाषा बदलने से ऐप के यूजर इंटरफेस टेक्स्ट अपडेट हो जाएंगे।';

  @override
  String get unknownAuthor => 'अज्ञात लेखक';

  @override
  String get sellerDetails => 'विक्रेता विवरण';

  @override
  String get privateSeller => 'निजी विक्रेता';

  @override
  String get identityHidden => 'विक्रेता द्वारा पहचान छिपाई गई';

  @override
  String get studentSeller => 'छात्र विक्रेता';

  @override
  String get privateProfileRestricted =>
      'इस विक्रेता की प्रोफ़ाइल निजी है। संपर्क प्रतिबंधित है।';

  @override
  String get chatWithSeller => 'विक्रेता के साथ चैट करें';

  @override
  String get studyMaterials => 'अध्ययन सामग्री';

  @override
  String get noMaterialsShared => 'अभी तक कोई सामग्री साझा नहीं की गई है।';

  @override
  String get uploadStudyMaterial => 'अध्ययन सामग्री अपलोड करें';

  @override
  String get subject => 'विषय';

  @override
  String get subjectHint => 'जैसे: कंप्यूटर साइंस';

  @override
  String get type => 'प्रकार';

  @override
  String get pdf => 'PDF';

  @override
  String get image => 'छवि';

  @override
  String fileSelected(String fileName) {
    return 'चुनी गई फ़ाइल: $fileName';
  }

  @override
  String get tapToSelectFile => 'फ़ाइल चुनने के लिए टैप करें (छवि/PDF)';

  @override
  String get uploadNow => 'अभी अपलोड करें';

  @override
  String get materialUploaded => 'सामग्री अपलोड हो गई!';

  @override
  String get uploadFailed => 'अपलोड विफल रहा';

  @override
  String get allFieldsRequired => 'सभी क्षेत्र आवश्यक हैं';

  @override
  String get noAppToOpenFile => 'इस फ़ाइल को खोलने के लिए कोई ऐप नहीं मिला';

  @override
  String get noConversations => 'कोई सक्रिय बातचीत नहीं मिली।';

  @override
  String regarding(String title) {
    return 'विषय: $title';
  }

  @override
  String get bookNotAvailable => 'यह किताब अब उपलब्ध नहीं है।';

  @override
  String get lightMode => 'लाइट मोड';

  @override
  String get darkMode => 'डार्क मोड';

  @override
  String get systemDefault => 'सिस्टम डिफॉल्ट';

  @override
  String get darkModeNotice =>
      'डार्क मोड आंखों के तनाव को कम करने में मदद करता है और OLED स्क्रीन पर बैटरी बचाता है।';

  @override
  String get ourMission => 'हमारा मिशन';

  @override
  String get missionDescription =>
      'स्टडी शेयर छात्रों को पुराने अध्ययन सामग्री के लिए एक बाज़ार बनाकर पैसे बचाने और कचरे को कम करने में मदद करने के लिए डिज़ाइन किया गया है। हमारा मानना है कि हर छात्र की सस्ती शिक्षा संसाधनों तक आसान पहुँच होनी चाहिए।';

  @override
  String get ourTeam => 'हमारी टीम';

  @override
  String get madeWithLove => 'छात्रों के लिए ❤️ के साथ बनाया गया';

  @override
  String get howCanWeHelp => 'हम आपकी कैसे मदद कर सकते हैं?';

  @override
  String get searchHelpArticles => 'सहायता लेख खोजें...';

  @override
  String get stillHaveQuestions => 'अभी भी प्रश्न हैं?';

  @override
  String get contactSupportNotice =>
      'यदि आप हमारे अक्सर पूछे जाने वाले प्रश्नों में उत्तर नहीं पा सकते हैं, तो आप हमारी सहायता टीम से संपर्क कर सकते हैं।';

  @override
  String get contactSupport => 'सहायता से संपर्क करें';

  @override
  String get security => 'सुरक्षा';

  @override
  String get privacy => 'गोपनीयता';

  @override
  String get accountAction => 'खाता कार्रवाई';

  @override
  String get changePassword => 'पासवर्ड बदलें';

  @override
  String get changePasswordSubtitle =>
      'अपना खाता पासवर्ड नियमित रूप से अपडेट करें';

  @override
  String get twoFactorAuth => 'दो-चरणीय प्रमाणीकरण';

  @override
  String get twoFactorSubtitle => 'सुरक्षा की एक अतिरिक्त परत जोड़ें';

  @override
  String get activeSessions => 'सक्रिय सत्र';

  @override
  String get activeSessionsSubtitle =>
      'उन उपकरणों को प्रबंधित करें जहाँ आप लॉग इन हैं';

  @override
  String get privateProfile => 'निजी प्रोफ़ाइल';

  @override
  String get privateProfileSubtitle =>
      'केवल पंजीकृत उपयोगकर्ताओं को अपने विज्ञापन दिखाएं';

  @override
  String get showPhoneNumber => 'फ़ोन नंबर दिखाएं';

  @override
  String get showPhoneNumberSubtitle =>
      'खरीदारों को अपना नंबर देखने की अनुमति दें';

  @override
  String get deleteAccount => 'खाता हटाएं';

  @override
  String get deleteAccountSubtitle =>
      'अपने खाते और डेटा को स्थायी रूप से हटाएं';

  @override
  String get deleteAccountConfirmTitle => 'खाता हटाएं?';

  @override
  String get deleteAccountConfirmContent =>
      'क्या आप वाकई अपना खाता स्थायी रूप से हटाना चाहते हैं? इस कार्रवाई को पूर्ववत नहीं किया जा सकता।';

  @override
  String get delete => 'हटाएं';

  @override
  String get general => 'सामान्य';

  @override
  String get buying => 'खरीदना';

  @override
  String get selling => 'बेचना';

  @override
  String get otpSent => 'आपकी ईमेल पर OTP भेजा गया है!';

  @override
  String get verifyOTP => 'OTP सत्यापित करें';

  @override
  String enter6DigitCode(String email) {
    return '$email पर भेजे गए 6-अंकों का कोड दर्ज करें';
  }

  @override
  String get enterEmailToReset =>
      'अपना ईमेल पता दर्ज करें और हम आपको पासवर्ड रीसेट करने के लिए एक OTP भेजेंगे।';

  @override
  String get enterOTP => 'OTP दर्ज करें';

  @override
  String get otpHint => '6-अंकों का OTP';

  @override
  String get newPassword => 'नया पासवर्ड';

  @override
  String get newPasswordHint => 'नया पासवर्ड दर्ज करें';

  @override
  String get resetPassword => 'पासवर्ड रीसेट करें';

  @override
  String get sendOTP => 'OTP भेजें';

  @override
  String get changeEmail => 'ईमेल बदलें';

  @override
  String get passwordResetSuccess => 'पासवर्ड रीसेट सफल! कृपया लॉगिन करें।';

  @override
  String get enter6DigitOTP => 'कृपया 6-अंकों का OTP दर्ज करें';

  @override
  String get passwordTooShort => 'पासवर्ड कम से कम 6 अक्षरों का होना चाहिए';

  @override
  String get online => 'ऑनलाइन';

  @override
  String get initializingChat => 'चैट शुरू हो रही है, कृपया प्रतीक्षा करें...';

  @override
  String get typeAMessage => 'एक संदेश टाइप करें...';

  @override
  String get available => 'उपलब्ध';

  @override
  String get markSold => 'बिका हुआ चिह्नित करें';

  @override
  String get statusUpdated => 'स्थिति अपडेट की गई!';

  @override
  String get deleteAdConfirmTitle => 'विज्ञापन हटाएं?';

  @override
  String get deleteAdConfirmContent =>
      'क्या आप वाकई इस पुस्तक सूची को हटाना चाहते हैं?';

  @override
  String get adDeletedSuccess => 'विज्ञापन सफलतापूर्वक हटा दिया गया';

  @override
  String get noAdsPosted => 'आपने अभी तक कोई विज्ञापन पोस्ट नहीं किया है।';

  @override
  String get savedBooks => 'सहेजी गई किताबें';

  @override
  String get noSavedBooks => 'अभी तक कोई सहेजी गई किताबें नहीं हैं।';

  @override
  String get exploreBooks => 'किताबें खोजें';

  @override
  String get profileUpdated => 'प्रोफ़ाइल सफलतापूर्वक अपडेट की गई!';

  @override
  String get updateFailed => 'अपडेट विफल रहा';

  @override
  String get saveChanges => 'परिवर्तन सहेजें';

  @override
  String get fieldRequired => 'यह क्षेत्र आवश्यक है';

  @override
  String get markAllAsRead => 'सभी को पढ़ा हुआ चिह्नित करें';

  @override
  String get noNotifications => 'अभी तक कोई सूचना नहीं है';

  @override
  String get noActiveSessions => 'कोई सक्रिय सत्र नहीं मिला';

  @override
  String get current => 'वर्तमान';

  @override
  String ip(String ipAddress) {
    return 'IP: $ipAddress';
  }

  @override
  String lastActive(String date) {
    return 'पिछली बार सक्रिय: $date';
  }

  @override
  String get sessionRevoked => 'सत्र रद्द कर दिया गया';

  @override
  String get privacyPolicyTitle => 'स्टडी शेयर के लिए गोपनीयता नीति';

  @override
  String get lastUpdated => 'पिछली बार अपडेट किया गया: मई 2026';

  @override
  String get policyIntroTitle => '1. परिचय';

  @override
  String get policyIntroContent =>
      'स्टडी शेयर में आपका स्वागत है। हम आपकी गोपनीयता का सम्मान करते हैं और आपके व्यक्तिगत डेटा की सुरक्षा करना चाहते हैं। यह गोपनीयता नीति बताती है कि जब आप हमारे मोबाइल एप्लिकेशन का उपयोग करते हैं तो हम आपकी जानकारी कैसे एकत्र करते हैं, उपयोग करते हैं और साझा करते हैं।';

  @override
  String get policyDataTitle => '2. डेटा जो हम एकत्र करते हैं';

  @override
  String get policyDataContent =>
      'हम वह जानकारी एकत्र करते हैं जो आप सीधे हमें प्रदान करते हैं, जैसे कि जब आप खाता बनाते हैं, पुस्तक विज्ञापन पोस्ट करते हैं, या अन्य उपयोगकर्ताओं के साथ संवाद करते हैं। इसमें शामिल हो सकते हैं:\n\n• नाम और ईमेल पता\n• फ़ोन नंबर (वैकल्पिक)\n• कॉलेज या विश्वविद्यालय का नाम\n• आपके द्वारा पोस्ट की जाने वाली पुस्तकों की तस्वीरें';

  @override
  String get policyUsageTitle => '3. हम आपके डेटा का उपयोग कैसे करते हैं';

  @override
  String get policyUsageContent =>
      'हम एकत्र की गई जानकारी का उपयोग निम्नलिखित के लिए करते हैं:\n\n• हमारी सेवाएं प्रदान करना और बनाए रखना\n• खरीदारों और विक्रेताओं के बीच कनेक्शन की सुविधा प्रदान करना\n• आपको तकनीकी नोटिस और सहायता संदेश भेजना\n• उपयोग और रुझानों की निगरानी और विश्लेषण करना';

  @override
  String get policySharingTitle => '4. डेटा साझाकरण';

  @override
  String get policySharingContent =>
      'हम आपका व्यक्तिगत डेटा नहीं बेचते हैं। हम केवल अन्य उपयोगकर्ताओं के साथ जानकारी साझा करते हैं जैसा कि लेनदेन को सुविधाजनक बनाने के लिए आवश्यक है (जैसे, विज्ञापन पर अपना नाम दिखाना)। आपका फ़ोन नंबर केवल तभी साझा किया जाता है जब आप स्पष्ट रूप से उस सेटिंग को सक्षम करना चुनते हैं।';

  @override
  String get policyRightsTitle => '5. आपके अधिकार';

  @override
  String get policyRightsContent =>
      'आपको ऐप की सेटिंग्स के माध्यम से किसी भी समय अपनी व्यक्तिगत जानकारी तक पहुँचने, अपडेट करने या हटाने का अधिकार है। यदि आप अपना खाता हटाना चुनते हैं, तो आपका सारा डेटा हमारे सर्वर से स्थायी रूप से हटा दिया जाएगा।';

  @override
  String get policyContactTitle => '6. हमसे संपर्क करें';

  @override
  String get policyContactContent =>
      'यदि इस गोपनीयता नीति के बारे में आपके कोई प्रश्न हैं, तो कृपया हमसे support@studyshare.com पर संपर्क करें।';

  @override
  String get thankYouTrusting => 'स्टडी शेयर पर भरोसा करने के लिए धन्यवाद।';
}
