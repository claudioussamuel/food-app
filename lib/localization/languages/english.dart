//Add English Language Translations
class English {

  static Map<String, String> get language => {
        /* -- Common -- */
        'tAppName': 'Ayatum',
        'tEnglish': 'English',
        'tFrench': 'French',
        'tNext': 'Next',
        'tSkip': 'Skip',
        'tContinue': 'Continue',
        'tGetStarted': 'Get Started',
        'tSuccess': 'Success',
        'tYears': 'years',
        'tMonths': 'months',
        'tWeeks': 'weeks',
        'tWeek': 'week',
        'tDays': 'days',
        'tDay': 'day',
        'tHours': 'hours',
        'tHour': 'hour',
        'tMinutes': 'minutes',
        'tMinute': 'minute',
        'tMinutesAgo': 'minutes ago',
        'tMinuteAgo': 'minute ago',
        'tNow': 'now',
        'tAnd': 'and',

        /* -- Messages -- */

        'tHeadsUp': 'Heads Up',
        'tAlreadyLogin': 'You are currently signed in on another device!',
        'tNoSuchResultFound': 'Ops! No such result found.',
        'tNoUserFound': 'Ops! No user found. Login again.',

        /* -- Validations -- */
        'tPasswordCannotEmpty': 'Password cannot be empty',
        'tInvalidPasswordFormat': 'Password must be 8 characters, with an uppercase letter, number and symbol',
        'tEmailCannotEmpty': 'Email cannot be empty',
        'tInvalidEmailFormat': 'Email format is not valid',

        /* -- Loaders -- */
        'tLoading': 'Loading',
        'tLoadingData': 'Loading Data',
        'tSignupDataProcessing': 'Sit tight, we are processing your data.',
        'tLoginLoaderMessage': 'Logging you in...',

        /* -- SnackBar -- */
        'tAlert': 'Alert',
        'tOhSnap': 'Oh Snap',
        'tNoInternet': 'No Internet',
        'tNoInternetMessage': 'To perform this operation you need an active Internet Connection.',
        'tInternetState': 'Internet State',
        'tUnableToIdentifyInternetConnection': 'Unable to identify your active Internet Connection.',
        'tCongratulations': 'Congratulations',
        'tEmailSent': 'Email has been sent successfully.',
        'tEmailLinkToResetPassword': 'Email link to reset your password has been sent.',
        'tAccountCreateVerifyEmail': 'You Account has been created! Check your inbox to verify your email address.',
        'tSomethingWentWrongErrorMessage': 'Something went wrong. Try again.',

        /* -- On Boarding -- */
        'tOnBoardingTitle1': 'Quote',
        'tOnBoardingTitle2': 'Our concept',
        'tOnBoardingTitle3': 'Rich content',
        'tOnBoardingDescription1':
            'Albert Einstein said "If you can\'t explain a concept to a six year old, you don\'t fully understand it." Well Ayatum has comprehended the message',
        'tOnBoardingDescription2':
            'Discovering the content within the various modules will ignite your curiosity, enabling you to effortlessly excel in your homework and exams. Experience a sense of tranquility as you engage in learning like never before, where the process becomes truly captivating',
        'tOnBoardingDescription3':
            'Gain access to courses round the clock - Receive feedback on corrected exercises - Access corrected exam subjects - Your key to success.',

        // Todo: /* -- Login Sign up -- */

        // --TITLES
        'tLoginTitle': 'Welcome Back!',
        'tLoginSubTitle': 'Welcome back You’ve been missed!',
        'tSignupTitle': 'Create Account',
        'tSignupSubTitle': 'Join us and make things possible!',
        'tForgetPasswordTitle': 'Forget Password',
        'tForgetPasswordSubTitle':
            'Enter your registered email address associated with your account. A Link will be sent to you to change your password.',

        // --Fields
        'tWhoAreYou': 'Who are you',
        'tStudent': 'Student',
        'tTeacher': 'Teacher',
        'tUsername': 'Username',
        'tFirstName': 'First Name',
        'tLastName': 'Last Name',
        'tFullName': 'Full Name',
        'tMail': 'Mail',
        'tPhoneNo': 'Phone Number',
        'tPassword': 'Password',

        // --Placeholder [Todo: ADD --Fields next to this string]
        'tEnterYour': 'Enter your',

        // --Button & Others
        'tLogin': 'Login',
        'tSignup': 'Sign up',
        'tForgetPassword': 'Forget Password',
        'tResetPassword': 'Reset Password',
        'tOR': 'OR',
        'tConnectWith': 'Connect With', // [Todo: Connect with 'Facebook' 'Google']
        'tFacebook': 'Facebook',
        'tGoogle': 'Google',
        'tDoNotHaveAnAccount': 'Don\'t have an account',
        'tAlreadyHaveAnAccount': 'Already have an account',

        // Todo: /* -- Email Verification -- */
        'tEmailVerificationTitle': 'Verify your email address',
        'tEmailVerificationSubTitle':
            'Your account has been successfully registered. To complete the verification process click on the link we sent to your email address for verification.',
        'tResendEmailLink': 'Resend E-Mail Link',
        'tBackToLogin': 'Back to login',

        // Todo: /* -- Reset Email -- */
        'tResetPasswordSubTitle':
            'To update your password, we have sent an Email link to your email address. Follow the instructions on it and reset your password.',
        'tGoBack': 'Go Back',

        // Todo: /* -- Subscription -- */
        'tSubscribe': 'Subscribe',
        'tSubscriptionAppTitle': 'Subscription',
        'tMySubscriptions': 'Subscriptions',
        'tSubscriptionTitle': 'Choose Plans',
        'tSubscriptionSubTitle': 'Choose one of the plans listed below',
        'tSelectYourLevel': 'Select your Level',
        'tSelectALevel': 'Select a level',
        'tSelectCurrency': 'Select a Currency',
        'tMonthly': 'Monthly',
        'tMonth': 'Month',
        'tYear': 'Year',
        'tQuarter': 'Quarter',
        'tBiAnnual': 'Bi-Annual',
        'tAnnually': 'Annually',
        'tOneWeekFreeTrial': '1 Week Free Trial',
        'tThenPerMonth': 'Then €17.99 per month. ',
        'tCancelAnytime': 'Cancel anytime.',
        'tContinueToCheckout': 'Continue to Checkout',
        'tTermsOfUseDescriptionHeading' : 'You may purchase an auto-renewing subscription through an In-App Purchase. \nAuto-renewable subscription. ',
        't10GradeSubscriptions' : '\n• 10th Grade Subscriptions ',
        't11GradeSubscriptions' : '\n• 11th Grade Subscriptions ',
        't12GradeSubscriptions' : '\n• 12th Grade Subscriptions ',
        'tExamSubscriptions' : 'Exam Subscriptions',
        'tTermsOfUseDescriptionDescription' : '\nYour subscription will be charged to your iTunes account at confirmation of purchase and will automatically renew (at the duration selected) unless auto-renew is turned off at least 24 hours before the end of the current period. \n• Current subscription may not be cancelled during the active subscription period; however, you can manage your subscription and/or turn off auto-renewal by visiting your iTunes Account Settings after purchase.\n\n• By clicking on the \'Ok\' Button you are agreed with ',
        'tTermsOfUseDescriptionAndroid' : '\nWhen you subscribe, your Google Play account will be charged upon confirmation of the purchase. The subscription will automatically renew according to the selected duration, unless auto-renewal is disabled at least 24 hours before the current period concludes. \n The cost, billing cycle frequency, and the necessity of a subscription to access the app are clearly detailed in the subscription information. \n You have the option to manage your subscription and turn off auto-renewal by visiting your Google Play Account Settings post-purchase. Please note that the current subscription cannot be canceled during an active subscription period. We strive to provide transparent and accurate subscription details, ensuring compliance with Google Play\'s Subscriptions policy.',
        'tSubscriptionCancelsAndAutoRenews' : 'This subscription auto-renews each',
        'tByClickingContinueYouAreAgree' : 'By clicking the continue button you agree with Privacy Policy and Terms and Conditions.',
        'tSelectPaymentMethodError' : 'Select Payment Method to proceed further',

        // Todo: /* ----------------------- CONTENT ------------------------------ */

        // Todo: /* -- Home -- */
        'tGoodDay': 'Hello',
        'tCompletedCourse': 'Completed Videos',
        'tInProgressVideos': 'In Progress Videos',
        'tProgress': 'Progress',
        'tGood': 'Good',
        'tLevel': 'Level',
        'tLevels': 'Levels',
        'tModule': 'Module',
        'tModules': 'Modules',
        'tThemes': 'Themes',
        'tChapters': 'Chapters',
        'tSections': 'Sections',
        'tDefinition': 'Definition',
        'tFormulaSchema': 'Formula/Schema',

        // Todo: /* -- Search -- */
        'tSearchHere': 'Search here...',
        'tSearchResults': 'Search Results',

        // Todo: /* -- Profile -- */
        'tContactUs': 'Contact us',
        'tPrivacyPolicy': 'Privacy policy',
        'tBuySubscription': 'Buy Subscription',
        'tChangeLanguage': 'Change language',
        'tTermsOfService': 'Terms of Use',
        'tEditProfile': 'Edit Profile',
        'tSelectLanguage': 'Select Language',
        'tProfession': 'Profession',
        'tProfile': 'Profile',
        'tUpdate': 'Update',
        'tSchoolName': 'School Name',
        'tLogout': 'Logout',
        'tLogoutConfirmationMessage': 'Are you sure, you want to logout?',
        'tProfileRecordSaved': 'Your profile record has been saved successfully.',
        'tUnableToSelectImage': 'Unable to select Image.',
        'tProfileImageUpdated': 'Profile image has been updated.',
        'tDeleteAccount': 'Delete Account',
        'tAreYourSureToDeleteAccount': 'Are you sure you want to delete your account? This action is not reversible.',
        'tReAuthenticateUser': 'Re-Authenticate your Account.',

        // Todo: /* -- Notifications -- */
        'tNotifications': 'Notifications',

        // Todo: /* -- Detail Section -- */
        'tNoVideoLectureFound': 'No Video Lecture Found!',
        'tImages': 'Images',

        // Todo: /* -- Quiz -- */
        'tQuiz': 'Quiz',
        'tResult': 'Result',
        'tSelectOption': 'Select an option first!',
        'tResultOfAttemptedQuestions': 'Result of all attempted questions',
        'tNoQuestionsFound': 'No Questions at this stage! Check back later.',
        'tQuestion': 'Question',
        'tNextQuestion': 'Next Question',
        'tSelectAnswer': 'Select an answer',
        'tExercise': 'Exercise',

        // Todo: /* -- Payout -- */
        'tPaid': 'Paid',
        'tSave': 'Save',
        'tInAppPurchase': 'In App Purchase',
        'tPaystack': 'Credit/Debit Card',
        'tCinetPay': 'Mobile money',
        'tStripePay': 'Stripe Credit/Debit Card',
        'tCinetCheckout': 'Checkout',
        'tPaymentMethods': 'Payment Methods',
        'tPaystackEmail': 'Email',
        'tAddPaystackEmail': 'Add your email in the field below.',
        'tPaystackPayment': 'Payment.',
        'tSelectPaymentMethod': 'Select Payment Method.',
        'tNoSubscriptionsFound':
            'Either you have subscribed to all levels OR Currently no level is Live for subscription.',
        'tActivePlan': 'Active Plan',
        'tExpiredPlan': 'Expired Plan',
        'tPlanExpiry': 'Plan Expiry',
        'tPlanValid': 'From',
        'tNextBilling': 'To',
        'tSubscriptions': 'Subscriptions',
        'tPaymentSubscriptionAboutToExpireNotificationHeading': 'Payment Alert',
        'tPaymentSubscriptionAboutToExpireNotificationBody':
            'Your subscription plan is about to be over this week, therefore in order to get uninterrupted service please renew your plan at your earliest.',
        'tSuccessfullySubscribed': 'You have successfully subscribed',
        'tSomethingWentWrongWhileVerifyingTransaction': 'Something went wrong while verifying your transaction.',
        'tSelectPaymentMethodErrorHeading': 'Select Level and Plan',
        'tSelectPaymentMethodErrorBody': 'Select levels and Choose Plan to proceed.',
        'tPaymentSuccessful': 'Your payment has been made successfully.',
        'tPaymentFailed': 'Your payment failed.',
        'tTermsAndConditionsCheckBoxTitle': 'Terms And Conditions',
        'tTermsAndConditionsCheckBoxSubTitle': 'Agree to the Terms And Conditions in order to proceed further.',

        // Todo: /* -- Chat Module -- */
        'tSelectModule': 'Select module',
        'tLetsChat': 'Let\'s Start Chatting',
        'tNoChatGroupFound': 'No topic found. Why not create one?',
        'tGroupRequest': 'Topic creation Request',
        'tCreateNewGroup': 'Create New Topic',
        'tGroupLanguage': 'Language',
        'tTopic': 'Topic',
        'tEnterTopicName': 'Tell us about your topic',
        'tChatGroups': 'Sharing Center',
        'tChat': 'Let\'s Talk',
        'tChatModuleNoLevelSubscribedMessage': 'Not yet subscribed to any Level!',
        'tDeleteMessage': 'Delete Message',
        'tDeleteMessageWarning': 'Are you sure you want to delete this message?',
        'tDelete': 'Delete',
        'tCancel': 'Cancel',
        'tClose': 'Close',
        'tMessageTextFieldHintText': 'Type a message',
        'tCreateNewTopicEmptyValuesErrorMessage': 'Select value from dropdown and write your Topic and then submit.',
        'tChatTopicRequestSuccessMessageHeading': 'Request Submitted',
        'tChatTopicRequestSuccessMessageBody':
            'Your request has been submitted and is being reviewed by our team. Once Finalized you will be able to see this topic in the list.',
      };
}
