# Campus Assistant Flutter App — UI/UX Audit

**তারিখ:** ৩ নভেম্বর ২০২৬  
**পরিধি:** Flutter mobile, tablet ও web UI-এর source-code review; design tokens, theme, navigation, home, authentication এবং marketplace checkout।

## Executive summary

আপনার app-এ design system-এর ভালো ভিত্তি ইতিমধ্যেই আছে—light/dark semantic color tokens, spacing/radius tokens, shared button/input theme এবং responsive content-width constraints। তাই নতুন করে সব design বানানো দরকার নেই।

বর্তমান inconsistency-র মূল কারণ হলো: **system আছে, কিন্তু তার নিয়মগুলো সব জায়গায় সমানভাবে প্রয়োগ ও নথিবদ্ধ হয়নি।** তার সঙ্গে light theme-এর কিছু text contrast দুর্বল, disabled button-এর label প্রায় অদৃশ্য, home screen-এ অনেক competing promotion, এবং গুরুত্বপূর্ণ payment state-এ পরিষ্কার recovery path অনুপস্থিত।

সর্বোচ্চ অগ্রাধিকার হওয়া উচিত:

1. text ও button state-এর contrast ঠিক করা;
2. `DESIGN_SYSTEM_V1.md`-কে বাস্তব implementation-এর সঙ্গে মেলানো;
3. home-এ শিক্ষার্থীর মূল কাজকে promotion ও ad-এর আগে আনা;
4. checkout-এর cancel/failure/error state-এ পরিষ্কার পরবর্তী পদক্ষেপ দেখানো।

এগুলো ঠিক হলে visual polish করার আগেই app অনেক বেশি coherent, readable এবং trustworthy মনে হবে।

## কীভাবে audit করা হয়েছে

Review করা হয়েছে [app_colors.dart](../lib/core/theme/app_colors.dart), [app_theme.dart](../lib/core/theme/app_theme.dart), [theme tokens](../lib/core/theme/tokens/), [scaffold_with_navbar.dart](../lib/routes/scaffold_with_navbar.dart), [home_page.dart](../lib/features/home/home_page.dart), login/student sign-up এবং marketplace-এর theme, product ও checkout screen।

এটি **source-based audit**—চলমান app-এর screenshot, বাস্তব device-এ visual inspection, accessibility-tree test বা user interview করা হয়নি। তাই layout overflow, animation feel, বাস্তব font rendering এবং device-specific সমস্যা সরাসরি নিশ্চিত করে বলা হচ্ছে না। নিচের contrast সংখ্যা palette-এর hex color দিয়ে WCAG relative-luminance formula-তে হিসাব করা; পুরো screen বা gradient-এর প্রতিটি pixel আলাদাভাবে পরীক্ষা করা হয়নি।

## ভালো ভিত্তি—যা রাখা উচিত

- `AppColors`-এ brand, text, surface, border ও status-এর semantic role এবং light/dark value আছে। Feature-গুলো এই vocabulary ব্যবহার করলে theme বদলানো সহজ হবে।
- `Spacing`, `RadiusToken`, `ControlToken` ও `AppLayout`-এর মতো token আছে; page/form/dialog/sheet width-ও নির্দিষ্ট।
- Button, input, dialog, bottom sheet, snackbar এবং typography-এর কিছু default theme-এ কেন্দ্রীয়ভাবে সংজ্ঞায়িত।
- Student sign-up-এ verified তথ্য ব্যবহার করে form সংক্ষিপ্ত রাখার উদ্দেশ্য আছে—এটি friction কমানোর ভালো product decision।
- Marketplace-এর আলাদা কমলা palette স্পষ্টভাবে scoped `MarketTheme`-এর মধ্যে রাখা; এটি ইচ্ছাকৃত product-area variation, accidental color override নয়।

## অগ্রাধিকারভিত্তিক findings

### P1 — Light theme-এ primary text contrast কম

**প্রমাণ:** [app_colors.dart](../lib/core/theme/app_colors.dart)-এ light primary `#26A69A`, `onPrimary` সাদা। [app_theme.dart](../lib/core/theme/app_theme.dart)-এ AppBar, ElevatedButton ও FilledButton-এ এই foreground/background pairing ব্যবহৃত।

**প্রভাব:** সাদা text ও `#26A69A`-এর contrast প্রায় **3.00:1**—স্বাভাবিক আকারের text-এর WCAG AA লক্ষ্য 4.5:1-এর নিচে। একই primary color-এর AppBar title/icon-ও পড়তে কষ্ট হতে পারে। Marketplace-এর light primary `#D9480F`-এ সাদা text প্রায় **4.30:1**, সেটিও স্বাভাবিক text-এর 4.5:1 লক্ষ্য পূরণ করে না। এছাড়া bottom-nav-এর মতো ছোট text-এ `textSubtle #8A9997` বনাম সাদা surface প্রায় **2.96:1**।

**করণীয়:** Primary surface-এর জন্য contrast-পরীক্ষিত `onPrimary` নির্ধারণ করুন; প্রয়োজনে primary shade আরও গাঢ় করুন অথবা সেই surface-এ উপযুক্ত গাঢ় text ব্যবহার করুন। সব theme/market variant-এ button, AppBar, badge ও navigation label-এর foreground/background pairing যাচাই করুন। Gradient থাকলে শুধু দুই প্রান্ত নয়, মাঝের রঙও যাচাই করুন।

### P1 — Disabled button-এর label background-এর সঙ্গে মিশে যায়

**প্রমাণ:** [app_theme.dart](../lib/core/theme/app_theme.dart)-এর gradient builder disabled state-এ background `surfaceAlt` করে, কিন্তু button theme-এর foreground স্থিরভাবে `onPrimary` রাখে। ফলে light theme-এ সাদা text প্রায় `#EFF4F3`-এর উপর (**1.11:1**); dark theme-এও dark foreground প্রায় dark surface-এর উপর (**1.15:1**)।

**প্রভাব:** disabled কেন বা কোন control-টি disabled—ব্যবহারকারী বুঝতে নাও পারেন; text কার্যত অদৃশ্য হয়ে যেতে পারে।

**করণীয়:** Disabled foreground ও background আলাদা state-token হিসেবে নির্ধারণ করুন। Disabled state যেন সক্রিয় না দেখায়, কিন্তু label পড়া যায়—এবং শুধু opacity কমিয়ে text হারিয়ে না যায়। Loading state-এ spinner ও label-এর layout-ও স্থির রাখুন।

### P1 — Design-system documentation বাস্তব code-এর সঙ্গে মেলে না

**প্রমাণ:** [DESIGN_SYSTEM_V1.md](DESIGN_SYSTEM_V1.md) এখনও “Proposal” বলে এবং primary হিসেবে purple `#6C7BFF` উল্লেখ করে; বর্তমান [app_colors.dart](../lib/core/theme/app_colors.dart)-এ brand teal, এবং marketplace-এর জন্য আলাদা orange variant আছে। নথির issue inventory-তে এমন কিছু সমস্যা বর্তমান code-এ ইতিমধ্যে সমাধান হয়েছে, আবার কিছু recommendation-ও বাস্তব implementation-এর চেয়ে পিছিয়ে। [CLAUDE.md](../CLAUDE.md) একই document-কে source of truth বলে।

**প্রভাব:** নতুন screen বা refactor করতে গিয়ে developer পুরোনো palette/spec অনুসরণ করতে পারে; একই app-এর জন্য code ও documentation দুই রকম “truth” তৈরি হয়।

**করণীয়:** `DESIGN_SYSTEM_V1.md`-কে বর্তমান token ও component behavior অনুযায়ী update করুন, অথবা স্পষ্টভাবে archived/proposed হিসেবে চিহ্নিত করে নতুন approved spec-কে source of truth করুন। প্রতিটি token-এর নাম, মান ও usage এক জায়গায় রাখুন।

### P1 — Home-এ প্রয়োজনীয় কাজ ও promotion-এর অগ্রাধিকার অস্পষ্ট হতে পারে

**প্রমাণ:** [home_page.dart](../lib/features/home/home_page.dart)-এর section list-এ welcome/offer, student verification, profile nudge, rewards, subscription, favorites, ad, banner, skill-up ও marketplace—মোট 13টি content block আছে; এর মধ্যে promotion/reward/ad-ধরনের block core shortcuts ও academic action-এর সঙ্গে একই vertical feed-এ থাকে। কিছু block conditional বা নিচে scroll করলেই দেখা যেতে পারে।

**প্রভাব:** returning student-এর কাছে “এখন আমার জন্য সবচেয়ে জরুরি কাজ কী?”—তা প্রথম screen-এ স্পষ্ট নাও হতে পারে। একাধিক banner/CTA একসঙ্গে থাকলে app-এর প্রধান কাজ secondary মনে হয়।

**করণীয়:** Home-এর প্রথম viewport-এ role অনুযায়ী একটি প্রধান next action দিন—যেমন আজকের routine, recent study item বা pending task। Shortcuts ও academic content তার কাছাকাছি রাখুন; offers/subscription/reward-কে একটি সীমিত discovery area-তে রাখুন, ad-কে স্পষ্টভাবে চিহ্নিত করুন। কোন section ব্যবহারকারীর কাজে লাগছে তা analytics বা ছোট usability test দিয়ে মাপুন।

### P1 — Checkout-এ cancel/failure-এর পর persistent recovery path নেই

**প্রমাণ:** [bkash_web_view.dart](../lib/features/bkash/views/bkash_web_view.dart) success/failure/cancel-এর জন্য আলাদা result ফেরায়। কিন্তু [checkout_screen.dart](../lib/features/marketplace/presentation/screens/checkout_screen.dart) কেবল `success` handle করে; `failure` বা `cancel` হলে checkout-এ থাকা অবস্থায় নতুন status panel, retry action বা order-state explanation দেখায় না। WebView-এ toast আছে, তবে সেটি transient। একই screen-এ address load ও order submit error-এ raw `Error: $e` দেখানো হয়।

**প্রভাব:** ব্যবহারকারী বুঝতে নাও পারেন order তৈরি হয়েছে কি না, আবার payment করলে duplicate হবে কি না, অথবা কীভাবে নিরাপদে retry করবেন। Technical error text আস্থা কমাতে পারে।

**করণীয়:** `success`, `cancel`, `failure`, timeout ও network error-এর জন্য স্পষ্ট state/ব্যাখ্যা দিন। Order-এর বর্তমান status দেখিয়ে “আবার চেষ্টা করুন”, “অন্য payment method”, “Orders দেখুন” বা support—পরিস্থিতি অনুযায়ী পরবর্তী action দিন। User-facing error-এ backend exception সরাসরি না দেখিয়ে সংক্ষিপ্ত ভাষা, retry এবং প্রয়োজনে reference ID দিন।

### P2 — Button hierarchy একরকম দেখালেও usage rule অস্পষ্ট

**প্রমাণ:** [app_theme.dart](../lib/core/theme/app_theme.dart)-এ ElevatedButton ও FilledButton উভয়েই একই gradient ও foreground পায়। কিন্তু ElevatedButton-এর minimum width `double.infinity`, আর FilledButton-এর minimum width 64। ফলে নাম/semantic role আলাদা হলেও visual treatment প্রায় একই, sizing behavior আলাদা। AppBar primary solid fill, button gradient; standard Card-এর radius/elevation-ও Marketplace Card variant থেকে আলাদা।

**প্রভাব:** কোন action primary, secondary বা destructive—শুধু component type দেখে সবসময় বোঝা যায় না; একই control অন্য screen-এ ভিন্ন width/weight নিতে পারে।

**করণীয়:** ছোট, স্পষ্ট component rule নির্ধারণ করুন: প্রতি screen-এ একটি প্রধান action; secondary action outlined; tertiary action text; destructive action danger semantic role-এ। Primary CTA-তে contrast-পরীক্ষিত solid fill-কে default রাখুন; gradient hero/marketing surface-এ সংরক্ষণ করলে action hierarchy পরিষ্কার থাকবে। Full-width বনাম intrinsic-width sizing ব্যবহারের নিয়মও লিখুন।

### P2 — Token আছে, কিন্তু feature-level styling এখনও ছড়িয়ে আছে

**প্রমাণ:** `lib/features`-এ static source scan-এ 245টি `Colors.*` এবং 237টি `Color(0x...)` match পাওয়া গেছে; এই সংখ্যা literal match, unique component নয়—migration/intentional media case-ও এর মধ্যে থাকতে পারে। [scripts/check_colors.sh](../scripts/check_colors.sh) raw color count বাড়া ঠেকানোর ratchet, কিন্তু বর্তমান violation-গুলো নিজে থেকে semantic বা accessible কিনা যাচাই করে না।

**প্রভাব:** একটি palette পরিবর্তন বা dark-mode polish করলে অনেক screen-এ আলাদা করে কাজ করতে হয়; একই semantic state বিভিন্ন hue-তে দেখা দিতে পারে।

**করণীয়:** পুরো app একবারে rewrite করবেন না। প্রথমে top user journeys (home, auth, study, marketplace, chat)-এ raw color-গুলো semantic token-এ migrate করুন; তারপর component-ভিত্তিক ধাপে এগোন। `success/warning/danger/info` status-কে decorative accent হিসেবে ব্যবহার করবেন না।

### P2 — Typography ও বাংলা accessibility স্পষ্টভাবে সংজ্ঞায়িত নয়

**প্রমাণ:** [app_theme.dart](../lib/core/theme/app_theme.dart)-এ global text theme মূলত Outfit font-এ apply করা হয়েছে; semantic type scale সম্পূর্ণভাবে নির্ধারিত নয়। `FontSizeToken` আছে, কিন্তু feature-গুলোতে inline `TextStyle` ও size override ব্যবহৃত হয়। Repo guidance বলে GoogleFonts একবার theme-এ ব্যবহার এবং বাংলা content-এর জন্য Hind Siliguri/Tiro Bangla বিবেচনা করতে; বাস্তবে community/inbox-এর একাধিক widget-এ `GoogleFonts.outfit()` inline call আছে। `lib` scan-এ `AppLocalizations`, `supportedLocales` বা generated localization setup পাওয়া যায়নি।

**প্রভাব:** headline/body/caption-এর hierarchy screen-ভেদে বদলাতে পারে; Outfit-এ বাংলা glyph fallback কেমন দেখায় তা নিশ্চিত নয়। ছোট text বা OS text scaling-এ layout ভাঙার ঝুঁকিও রয়েছে।

**করণীয়:** `display/headline/title/body/label`-এর semantic text style একবার নির্ধারণ করুন; feature code-এ arbitrary size কমান। বাংলা/ইংরেজি string, error, form label ও number/currency formatting-এর localization পরিকল্পনা করুন। বাংলা font/fallback বাস্তব Android, iOS ও web-এ দেখে নিন; system text scaling বন্ধ না করে overflow ঠিক করুন।

### P2 — Custom bottom navigation-এ selection ও accessibility state যাচাই দরকার

**প্রমাণ:** [scaffold_with_navbar.dart](../lib/routes/scaffold_with_navbar.dart)-এ main navigation custom `GestureDetector` দিয়ে তৈরি; height 60 এবং label size `FontSizeToken.xs` (11 px)। Theme-এ `NavigationBarThemeData` আছে, কিন্তু custom bar সেটি ব্যবহার করে না। Tab-গুলো role অনুযায়ী বদলায়—student 5টি, teacher 3টি, staff 2টি।

**প্রভাব:** নির্বাচিত tab-এর অবস্থা মূলত color/indicator-এ প্রকাশিত; screen reader-এর কাছে `selected` state স্পষ্ট কি না এবং 11 px label ছোট viewport/text scaling-এ পড়া যায় কি না তা নিশ্চিত নয়। Role ভেদে tab কমানো ভালো tailoring হতে পারে, তবে লুকানো feature-এর বিকল্প entry point পরিষ্কার থাকা দরকার।

**করণীয়:** Android TalkBack/iOS VoiceOver-এ label, selected state ও tap action পরীক্ষা করুন। প্রয়োজনে `NavigationBar` বা explicit semantic selection ব্যবহার করুন; compact width ও বড় system font-এ Community label-সহ সব tab যাচাই করুন।

## গুরুত্বপূর্ণ user flow

### Sign-in ও student onboarding

বর্তমান কাঠামোয় splash/onboarding থেকে login বা verification-based account creation-এ যাওয়া যায়। Login form constrained width ও scroll ব্যবহার করে; student sign-up-এ verified record থেকে কিছু তথ্য আগেই পূরণ করার উদ্দেশ্য আছে। এগুলো ভালো ভিত্তি—এখন login, verification code, password error, retry এবং back-navigation-এ একই heading, field, CTA, loading ও error pattern নিশ্চিত করা দরকার।

### Marketplace purchase

বর্তমান purchase journey-এর মূল ধাপ: **Marketplace → product detail → cart → address/payment selection → bKash WebView → result/order**। Checkout-এ address, summary ও bKash/Cash on Delivery choice আছে। সবচেয়ে গুরুত্বপূর্ণ উন্নতি হলো WebView থেকে ফিরে আসার পর order/payment status স্থায়ীভাবে দেখানো; transient toast-কে একমাত্র confirmation হিসেবে না রাখা।

### Home ও প্রধান navigation

Student-এর জন্য Home, Study, Career, Community, Profile; teacher/staff-এর জন্য ছোট tab set আছে। Role-ভিত্তিক navigation উদ্দেশ্যপূর্ণ, কিন্তু প্রতিটি role-এর প্রধান কাজ Home-এর প্রথম viewport থেকে কত দ্রুত পাওয়া যায়—এটি বাস্তব user task দিয়ে যাচাই করা উচিত।

## প্রস্তাবিত consistency rules

1. **Brand:** core app-এর teal-ই brand রাখুন; market-এর orange-কে scoped variant হিসেবে রাখুন। নতুন accent যোগ করার আগে সেটি semantic status নয় তা নিশ্চিত করুন।
2. **Buttons:** primary/secondary/tertiary/destructive—চারটি role; একই screen-এ একাধিক সমান-জোরের CTA নয়। সব interactive target-এর minimum touch area 48×48 dp লক্ষ্য করুন।
3. **Contrast:** normal text 4.5:1, large text 3:1 লক্ষ্য; icon/control-এর state-ও শুধু hue দিয়ে বোঝাবেন না।
4. **Type:** semantic text styles, সংযত font weight, বাংলা/ইংরেজি rendering এবং system text scale—সব theme-এ একই hierarchy।
5. **Surface:** page background, card, border, shadow ও radius-এর সীমিত scale; শুধু elevation বাড়িয়ে hierarchy তৈরি নয়।
6. **Flow:** loading, empty, error, success, cancel ও retry—প্রতিটি গুরুত্বপূর্ণ task-এ একই ভাষা ও predictable next action।
7. **Navigation:** selected state ও screen-reader semantics; role-specific tab লুকালে অন্য entry point থাকা।

## বাস্তবায়নের roadmap

### ধাপ ১ — ব্যবহারকারী-দৃশ্যমান high-risk সমস্যা

- light/dark এবং marketplace primary contrast ঠিক করুন; disabled button-এর foreground state আলাদা করুন।
- checkout cancel/failure/error-এর persistent recovery message ও order-status path যোগ করুন।
- পুরোনো design-system document-কে update/archive করে একটি সত্যিকারের source of truth নির্ধারণ করুন।

### ধাপ ২ — Core UI system

- button role ও width rules, typography scale, বাংলা fallback/localization, navigation semantics লিখিতভাবে স্থির করুন।
- Home-এ primary student task ও promotional content-এর অগ্রাধিকার নির্ধারণ করুন।
- core journey-তে raw color/style override token ও shared component-এ migrate করুন।

### ধাপ ৩ — Visual/accessibility QA

- Light/dark × Android/iOS × ছোট phone/tablet/web-এ Home, Login, Study, Product detail, Checkout ও Profile-এর screenshot review করুন।
- 200% text scaling, TalkBack/VoiceOver, empty/error/loading state এবং 360 dp-এর কাছাকাছি সংকীর্ণ viewport পরীক্ষা করুন।
- 5–8 জন target student-কে “একটি resource খুঁজুন”, “account তৈরি করুন”, “payment cancel করে order status বুঝুন”—এ ধরনের task দিয়ে usability test করুন।

## “Done” বলার আগে যাচাই

- Primary CTA, AppBar title এবং normal-size text-এর contrast সব theme/variant-এ মাপা হয়েছে।
- Disabled/loading/error state-এ label পড়া যায় এবং state শুধু color দিয়ে বোঝানো হয় না।
- Checkout success, cancel, failure ও retry প্রতিটিতে ব্যবহারকারী জানেন order-এর অবস্থা ও পরবর্তী পদক্ষেপ।
- বাংলা/ইংরেজি text এবং system text scaling-এ মূল flow-গুলো ভাঙে না।
- Screen reader selected navigation tab ও actionable control-এর নাম/অবস্থা জানায়।
- নতুন UI-তে raw color বাড়ে না; বিদ্যমান raw color debt feature-by-feature কমে।

**সারকথা:** পুরো app নতুন করে redesign করার প্রয়োজন নেই। বর্তমান token/theme foundation-কে সত্যিকারের একক standard বানিয়ে contrast, disabled state, home hierarchy এবং checkout feedback ঠিক করাই সবচেয়ে কম ঝুঁকির, সবচেয়ে বেশি প্রভাবের পথ।
