require ["include", "environment", "variables", "relational", "comparator-i;ascii-numeric", "spamtest", "fileinto", "imap4flags", "regex"];

# Generated: Do not run this script on spam messages
if allof (environment :matches "vnd.proton.spam-threshold" "*",
          spamtest :value "ge" :comparator "i;ascii-numeric" "${1}")
{
  return;
}

# ========================= Notifications, temp =========================

if anyof(
    header :matches :comparator "i;ascii-casemap" "subject" [
      "*secure*link*log*in*",
      "*security*alert*",
      "*log*in to*portal",
      "*password updated*",
      "stay*logged*in on*device*",
      "*your payment*declined*"
    ],
    header :comparator "i;ascii-casemap" :regex "subject" [
      "your .* code is [0-9]{4,}",
      "your.*password.*(has been (chang|updat)ed|was reset)",
      "password.*reset.*request",
      "(reset|forg[oe]t).*password",
      "(log|sign)[- ]?in.*code",
      "^sign[- ]in to",
      "(new|suspicious).*[^[:alpha:]](log[- ]?|sign[- ])in",
      "code.*(log|sign)[- ]?in",
      "confirmation code: [[:alnum:]]{3}-[[:alnum:]]{3}",
      "verify your email",
      "access.*new.*computer",
      "two[- ]?factor.*(code|authentication|enabled)",
      "(security|sign[- ]?in|login|otp|verification|authentication|recovery|backup).*code",
      "(unusual|new).*sign[- ]?in",
      "personal access token",
      "login link",
      "verify your account",
      "password reset confirmation",
      "(registration|confirmation).*password",
      "authorization code",
      "update.*password"
    ]
) {
  fileinto "Notifications, temp";
  return;
}

# ========================= Proton =========================

if address :domain :regex "from" [
    "^(.+\\.)?proton\\.me$",
    "^proton(mail|drive)\\.zendesk\\.com$"
]
{
  fileinto "Proton";
  return;
}

# =================== Finance/Purchases, receipts/Recurring ===================

# ==================== Finance/Purchases, receipts ====================
if allof(
    anyof(
      header :matches :comparator "i;ascii-casemap" "subject" [
        "your*receipt*",
        "*has shipped*",
        "*delivery*scheduled*today*",
        "*receipt*for your payment*",
        "*invoice*for order*",
        "*update from seller*order id*",
        "*new scheduled*delivery date*",
        "*invoice/receipt*"
      ],
      header :comparator "i;ascii-casemap" :regex "subject" [
        "^order [0-9]{4,}:",
        "(order|purchase).*(confirm|placed|update|shipped|#)",
        "your.*(order|purchase)",
        "payment.*(receipt|received)",
        "(package|parcel|shipment|delivery).*(on (its|the) way|deliver(y|ed)|scheduled|update|ready for pickup|cleared customs|import fees? due|in your (country|region)|at carrier|out for delivery|arriv(ing|ed))",
        "we have your (package|parcel|shipment)",
        "(your|the) invoice (from|for|is|#|available)",
        "attempted to deliver a package"
      ]
    ),
    not header :comparator "i;ascii-casemap" :regex "subject" [
      "baggage receipt",
      "in order (to|for)",
      "tickets?|festival|concert",
      "[0-9]+% off",
      "black friday",
      "cyber monday",
      "clearance sale",
      "coupon",
      "boxing day sale",
      "savings alert",
      "off your (first|next)"
    ]
) {
  fileinto "Finance/Purchases, receipts";
  return;
}

# ==================== Finance/Bank, insurance, credit ====================

# ========================= Finance/Transfers =========================

# ========================= Employment/Alerts, listings =======================

if header :comparator "i;ascii-casemap" :regex "subject" [
    "is hiring for",
    ".+ is hiring$",
    "job alert",
    "jobs alert",
    "open jobs",
    "see who's hiring",
    "sees who's hiring",
    "jobs you may be interested"
] {
  fileinto "Employment/Alerts, listings";
  return;
}

# ========================= Employment ===========================

# ========================= Events, tickets, bookings/Calendar =========================

if exists "X-Pm-Calendar-Intent" {
  fileinto "Events, tickets, bookings/Calendar";
  return;
}

# ========================= Events, tickets, bookings =========================

if header :comparator "i;ascii-casemap" :regex "subject" [
    "check in for your (trip|flight) to",
    "(flight|trip).*ready for check[- ]?in",
    "(your|mobile) boarding pass|boarding pass(es)? for",
    "itinerary\\s+for",
    "travel\\s+(information|documents)\\s+for",
    "update to.*flight number.*for.*(trip|flight) to",
    "your flight.*(departs|arrives) at [0-9]{1,2}:[0-9]{2}",
    "your.*flight.*is now boarding",
    "flight.*to.*is (cancell?ed|delayed)",
    "(delay|cancell?ation) of your flight",
    "(book(ing|ed)|reservation).*(appointment|confirmed|reference)",
    "(appointment|class).*(scheduled|booked)",
    "your ticket(.*for|s are here)",
    "order (confirmation|confirmed).*(tickets?|event)",
    "tickets? (for|to) .*",
    "event.*reminder",
    "(new|upcoming|just added).*event",
    "departure.*gate.*flight.*to",
    "baggage.*available.*pickup.*in",
    "boarding announcement",
    "boarding passes",
    "booking change",
    "seat change for trip",
    "trip document",
    "(all set|set) for your trip"
] {
  fileinto "Events, tickets, bookings";
  return;
}

# ========================= Newsletters, blogs =========================

# ========================= Random =========================

if header :comparator "i;ascii-casemap" :regex "subject" [
    "updat(e|ed|ing).*(our|your|the).*((terms (and|&|of) (conditions|service|use))|privacy policy|cookie policy)"
] {
  fileinto "Random";
  return;
}

# ========================= Promo =========================

if allof(
    header :comparator "i;ascii-casemap" :regex "subject" [
      "black friday",
      "cyber monday",
      "prime day",
      "[0-9]+% off",
      "(save|deal|deals) (now|today|up to|big|huge)",
      "clearance sale",
      "coupon",
      "promo code",
      "(flash|big|huge|mid[- ]?season|seasonal|summer|winter|boxing day) sale",
      "on sale",
      "special offer"
    ],
    not header :comparator "i;ascii-casemap" :regex "subject" [
      "receipt",
      "invoice",
      "order confirm",
      "payment received",
      "confirmation"
    ]
) {
  fileinto "Promo";
  return;
}
