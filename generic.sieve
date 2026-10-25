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
      "your.*password.*has been (chang|updat)ed",
      "password.*reset.*request",
      "your.*password.*was reset",
      "(reset|forg[oe]t).*password",
      "(log|sign)[- ]?in.*code",
      "^sign[- ]in to",
      "(new|suspicious).*[^[:alpha:]](log[- ]?|sign[- ])in",
      "code.*(log|sign)[- ]?in",
      "confirmation code: [[:alnum:]]{3}-[[:alnum:]]{3}",
      "verify your email",
      "access.*new.*computer",
      "two[- ]?factor.*(code|authentication|enabled)",
      "(recovery|backup).*code",
      "(security|sign[- ]?in|login|otp|verification|authentication).*code",
      "(unusual|new).*sign[- ]?in"
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
        "(package|parcel|shipment).*on (its|the) way",
        "(package|parcel|shipment).*deliver(y|ed)",
        "we have your (package|parcel|shipment)"
      ]
    ),
    not header :comparator "i;ascii-casemap" :regex "subject" [
      "baggage receipt",
      "in order (to|for)",
      "tickets?|festival|concert"
    ]
) {
  fileinto "Finance/Purchases, receipts";
  return;
}

# ==================== Finance/Bank, insurance, credit ====================

# ========================= Finance/Transfers =========================

# ========================= Employment/Alerts, listings =======================

# ========================= Employment ===========================

# ========================= Events, tickets, bookings/Calendar =========================

if anyof(
    exists "X-Pm-Calendar-Intent"
) {
  fileinto "Events, tickets, bookings/Calendar";
  return;
}

# ========================= Events, tickets, bookings =========================

if header :comparator "i;ascii-casemap" :regex "subject" [
    "check in for your (trip|flight) to",
    "(flight|trip).*ready for check[- ]?in",
    "(your|mobile) boarding pass|boarding pass(es)? for",
    "your.*travel (information|itinerary|documents) for",
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
    "baggage.*available.*pickup.*in"
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

if anyof(
    header :comparator "i;ascii-casemap" :regex "subject" [
      "black friday",
      "cyber monday",
      "prime day",
      "[0-9]+% off",
      "(save|deal|deals) (now|today|up to|big|huge)",
      "clearance",
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
