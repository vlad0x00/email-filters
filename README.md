# Email filters

Sieve filters for email (currently used in Protonmail). There's two sieve files -- `generic.sieve` and `specific.sieve`. `generic.sieve` contains regexes that sort emails based on title or metadata using regex and keyword matching. `specific.sieve` contains specific email addresses for cases that `generic.sieve` is not able to handle because the emails are not formatted in a way that can be easily captured by regex/keywords. For privacy reasons, `specific.sieve` is .gitignored.

Currently, the following dirs can be sorted into:
- `Notifications, temp`: notifs and other temporary emails that don't need to be stored
- `Proton`: official Proton emails
- `Finance/Purchases, receipts`: purchases and related emails, such as shipping
- `Finance/Purchases, receipts/Recurring`: confirmations of recurring payments
- `Finance/Bank, insurance, credit`: banks/insurance
- `Finance/Transfers`: money transfer confirmations
- `Employment`: emails related to current or past jobs
- `Employment/Alerts, listings`: job postings
- `Events, tickets, bookings`: anything event related such as tickets
- `Events, tickets, bookings/Calendar`: event related, but specifically calendar invitations
- `Newsletters, blogs`: articles from newsletters and blogs I'm interested in
- `Random`: unsorted, but recognized emails that are relatively unimportant
- `Promo`: promotions
