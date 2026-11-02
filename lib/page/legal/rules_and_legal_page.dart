import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

enum LegalTab { rules, terms, privacy }

class RulesAndLegalPage extends StatefulWidget {
  final LegalTab initialTab;

  const RulesAndLegalPage({super.key, this.initialTab = LegalTab.rules});

  @override
  State<RulesAndLegalPage> createState() => _RulesAndLegalPageState();
}

class _RulesAndLegalPageState extends State<RulesAndLegalPage> {
  late LegalTab _selectedTab;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            "assets/background/darkbackground.jpg",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.white10,
            elevation: 0,
            leadingWidth: 10.w,
            leading: Padding(
              padding: EdgeInsets.only(bottom: 2.5, left: 2.w),
              child: onPress(
                ontap: () => Get.back(),
                child: Icon(
                  RemixIcons.arrow_left_s_line,
                  size: 24.sp,
                  color: MyColors.white,
                ),
              ),
            ),
            title: text_widget(
              _getPageTitle(),
              fontSize: 17.sp,
              color: Colors.white.withValues(alpha: 0.90),
              fontWeight: FontWeight.w600,
            ),
            centerTitle: false,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Container(height: 1, color: Colors.white12),
            ),
          ),
          body: Column(
            children: [
              SizedBox(height: 1.5.h),
              _buildTabBar(),
              SizedBox(height: .5.h),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 1.5.h,
                  ),
                  child: Column(
                    children: [
                      _buildAppleDisclaimerBanner(),
                      SizedBox(height: 2.h),
                      _buildTabContent(),
                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getPageTitle() {
    switch (_selectedTab) {
      case LegalTab.rules:
        return "Official Contest Rules";
      case LegalTab.terms:
        return "Terms & Conditions";
      case LegalTab.privacy:
        return "Privacy Policy";
    }
  }

  Widget _buildTabBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Container(
        padding: EdgeInsets.all(0.5.h),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          children: [
            _buildTabItem("Rules", LegalTab.rules),
            _buildTabItem("Terms", LegalTab.terms),
            _buildTabItem("Privacy", LegalTab.privacy),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(String title, LegalTab tab) {
    final isSelected = _selectedTab == tab;
    return Expanded(
      child: onPress(
        ontap: () => setState(() => _selectedTab = tab),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 1.h),
          decoration: BoxDecoration(
            color: isSelected ? MyColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: text_widget(
              title,
              fontSize: 14.5.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? Colors.black : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppleDisclaimerBanner() {
    return Container(
      padding: EdgeInsets.all(1.25.h),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: MyColors.primary.withValues(alpha: 0.6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: MyColors.primary, size: 18.sp),
          SizedBox(width: 2.w),
          Expanded(
            child: text_widget(
              "Apple Inc. is not a sponsor of, and is not involved in any manner with, any contest, sweepstakes, raffle, or games conducted in this app.",
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white.withValues(alpha: 0.85),
              maxline: 100,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case LegalTab.rules:
        return _buildOfficialRulesContent();
      case LegalTab.terms:
        return _buildTermsContent();
      case LegalTab.privacy:
        return _buildPrivacyContent();
    }
  }

  Widget _buildOfficialRulesContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Official Poker Run Contest Rules"),
        _buildParagraph(
          "These Official Contest Rules apply to all Poker Run events organized and operated using The Poker Run App. By participating in any Poker Run event, entrants agree to be bound by these rules.",
        ),
        _buildHighlightCard(
          "Mandatory Sponsor & Platform Disclosures",
          "• Apple Inc. is NOT a sponsor or administrator of any contest, sweepstakes, raffle, or tournament in this app.\n"
              "• Apple Inc. has no affiliation, connection, or responsibility for any contest, prize, or promotion hosted on this platform.\n"
              "• Each Poker Run event is independently organized and sponsored by the respective Event Organizer or The Poker Run App LLC.",
        ),
        _buildSubHeader("1. Eligibility"),
        _buildParagraph(
          "Poker Run events are open only to individuals who meet the age and legal requirements specified by the event organizer and applicable jurisdiction (typically 18 years or older, or 21+ where alcohol or gaming laws apply). Void where prohibited by law.",
        ),
        _buildSubHeader("2. How It Works"),
        _buildParagraph(
          "A Poker Run is an event of skill and navigation where participants travel along a designated route containing multiple checkpoints (stops):\n"
          "• At each checkpoint, participants check in using the app (via QR code or GPS verification) to receive a playing card from a standard virtual 52-card deck.\n"
          "• Participants must complete all required stops to assemble a complete five-card poker hand.\n"
          "• Additional cards or card replacements may be purchased if permitted by the individual event organizer rules.",
        ),
        _buildSubHeader("3. Hand Rankings & Winner Determination"),
        _buildParagraph(
          "Winners are determined strictly based on standard five-card poker hand rankings:\n"
          "1. Royal Flush (A, K, Q, J, 10 of same suit)\n"
          "2. Straight Flush (Five cards in sequence of same suit)\n"
          "3. Four of a Kind (Four cards of the same rank)\n"
          "4. Full House (Three of a kind plus a pair)\n"
          "5. Flush (Five cards of same suit, not in sequence)\n"
          "6. Straight (Five cards in sequence, not same suit)\n"
          "7. Three of a Kind (Three cards of same rank)\n"
          "8. Two Pair (Two different pairs)\n"
          "9. One Pair (Two cards of same rank)\n"
          "10. High Card (Highest card plays)\n\n"
          "Tiebreaker: In the event of a tie between hands of equal rank, ties will be resolved by the rank of the highest unshared kicker card or by organizer tiebreaker procedures as published in the event details.",
        ),
        _buildSubHeader("4. Prizes & Distribution"),
        _buildParagraph(
          "Prizes are provided and distributed directly by the independent Event Organizer. The Poker Run App LLC and Apple Inc. are not responsible for prize fulfillment or tax liabilities. Winners are solely responsible for all federal, state, and local taxes associated with prize acceptance.",
        ),
        _buildSubHeader("5. Free Alternate Method of Entry (AMOE)"),
        _buildParagraph(
          "Where required by law, participants may enter a contest or sweepstakes without purchase by contacting the event organizer prior to the event start date in accordance with applicable local sweepstakes regulations.",
        ),
        _buildSubHeader("6. General Conditions & Conduct"),
        _buildParagraph(
          "Participants must operate vehicles in a safe and lawful manner at all times. A Poker Run is NOT a speed race. Speed or time of completion does not impact hand ranking or winning probability. Participants must follow all traffic laws and local ordinances.",
        ),
        SizedBox(height: 3.h),
      ],
    );
  }

  Widget _buildTermsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Terms & Conditions"),
        _buildParagraph(
          "Last updated: 2026\n\n"
          "Welcome to The Poker Run App. These Terms & Conditions govern your access to and use of our mobile application and related services.",
        ),
        _buildSubHeader("1. Acceptance of Terms"),
        _buildParagraph(
          "By creating an account, downloading, or using The Poker Run App, you agree to comply with and be bound by these Terms. If you do not agree to these Terms, please do not use the application.",
        ),
        _buildSubHeader("2. User Accounts"),
        _buildParagraph(
          "You must provide accurate, current, and complete information during registration. You are responsible for maintaining the confidentiality of your account credentials and for all activities under your account.",
        ),
        _buildSubHeader("3. Safety & Traffic Compliance"),
        _buildParagraph(
          "The Poker Run App is intended for recreational entertainment. We strongly advocate for safe driving, boating, and riding practices. You agree not to interact with the mobile app while operating any moving vehicle.",
        ),
        _buildSubHeader("4. Contest & Event Participation"),
        _buildParagraph(
          "All contests and Poker Runs hosted through the app are subject to the Official Contest Rules. Apple Inc. is not a sponsor or involved with any events or prizes.",
        ),
        _buildSubHeader("5. Limitation of Liability"),
        _buildParagraph(
          "To the maximum extent permitted by applicable law, The Poker Run App LLC and its officers, directors, employees, and agents shall not be liable for any indirect, incidental, special, or consequential damages resulting from your participation in any event.",
        ),
        _buildSubHeader("6. Contact Us"),
        _buildParagraph(
          "If you have questions regarding these Terms, contact us at:\n"
          "The Poker Run App LLC\n"
          "Cabot, Arkansas 72023\n"
          "Email: admin@thepokerrunapp.com\n"
          "Phone: 501-918-9189",
        ),
        SizedBox(height: 3.h),
      ],
    );
  }

  Widget _buildPrivacyContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Privacy Policy"),
        _buildParagraph(
          "The Poker Run App LLC is committed to protecting your privacy. This Privacy Policy explains how we handle information in our mobile application.",
        ),
        _buildHighlightCard(
          "No Cross-App Tracking",
          "• We DO NOT track you across third-party websites or applications.\n"
              "• We DO NOT sell, rent, or trade your personal information to data brokers or advertising networks.\n"
              "• No tracking cookies are collected within this mobile app.",
        ),
        _buildSubHeader("1. Information We Collect"),
        _buildParagraph(
          "We collect only the minimum information necessary to provide app services:\n"
          "• Account Details: Name, email address, phone number, and rider profile info.\n"
          "• Location Data: While participating in an active Poker Run, the app accesses your device location solely to verify checkpoint arrival and map navigation.\n"
          "• Game Data: Event registration, check-ins, and card draws.",
        ),
        _buildSubHeader("2. How We Use Information"),
        _buildParagraph(
          "We use your information exclusively to:\n"
          "• Facilitate check-ins and scoring during Poker Runs.\n"
          "• Announce event results and determine leaderboard rankings.\n"
          "• Provide customer support and account management.",
        ),
        _buildSubHeader("3. Data Retention & Deletion"),
        _buildParagraph(
          "You may request deletion of your account and associated personal data at any time through the Account Settings screen in the app or by emailing admin@thepokerrunapp.com.",
        ),
        _buildSubHeader("4. Children's Privacy"),
        _buildParagraph(
          "Our app is not intended for children under 13 years of age. We do not knowingly collect personal information from children.",
        ),
        _buildSubHeader("5. Contact Information"),
        _buildParagraph(
          "For privacy inquiries or data requests:\n"
          "The Poker Run App LLC\n"
          "1592 Calcutta Dr, Cabot, AR 72023\n"
          "Email: admin@thepokerrunapp.com",
        ),
        SizedBox(height: 3.h),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: text_widget(
        title,
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildSubHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 2.h, bottom: 0.8.h),
      child: text_widget(
        title,
        fontSize: 15.5.sp,
        fontWeight: FontWeight.bold,
        color: MyColors.primary,
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return text_widget(
      text,
      fontSize: 13.5.sp,
      fontWeight: FontWeight.w400,
      color: Colors.white.withValues(alpha: 0.85),
      maxline: 100,
    );
  }

  Widget _buildHighlightCard(String title, String content) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.5.h),
      padding: EdgeInsets.all(1.5.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          text_widget(
            title,
            fontSize: 14.5.sp,
            fontWeight: FontWeight.bold,
            color: MyColors.primary,
          ),
          SizedBox(height: 0.8.h),
          text_widget(
            content,
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white.withValues(alpha: 0.90),
            maxline: 20,
          ),
        ],
      ),
    );
  }
}
