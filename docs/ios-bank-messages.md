# Real bank message import on iPhone

## What is implemented

On iOS 16+, the Runner app exposes **Import Bank SMS** through App Intents. A user-created Shortcuts Message automation supplies the sender and full message text. The intent writes to an encrypted, backup-excluded queue in the app's own container. No App Group, SMS-filter extension, URL containing message text, new server endpoint, or signing entitlement is required.

When Floosy is foregrounded and signed in, its iOS repository drains pending messages through the existing `SMSTransactionProcessor`. Transaction classification, bank mapping, card learning, currency handling and financial deduplication reuse the application's current implementation. Unlike Android inbox scanning, the import queue has no date cursor; a delayed or manually copied old message is not skipped by the Android import cutoff. Parsed transaction dates take priority over the supplied receipt date.

Successful/previously processed messages leave the queue. Processor failures remain pending. Messages that cannot produce a confirmed import remain visible for review, retry or removal under **Settings → Bank messages on iPhone**. The queue is account-bound: changing accounts does not import a previous account's messages into the new account.

## Set up a real-message automation

1. Install the latest physical-device IPA using the [installation guide](iphone-installation.md). The simulator build cannot receive cellular SMS.
2. Open Floosy, sign in, then enable **Settings → Bank messages on iPhone → Enable bank message import**.
   iOS does not show an Android-style SMS permission dialog. This switch and the Shortcuts automation are the setup required for this import path.
3. On the iPhone, open **Shortcuts → Automation → New Automation → Message**. Labels vary by iOS version.
4. Select the bank sender or a sufficiently specific **Message Contains** condition. Choose **Run Immediately**, or disable **Ask Before Running** on versions that show that setting.
5. Add **Floosy → Import Bank SMS**. Configure:
   - **Bank sender:** the automation's **Shortcut Input → Sender** variable.
   - **Message text:** **Shortcut Input → Content**, containing the complete original message. Do not pass the literal text `Shortcut Input`, a screenshot, or just the amount.
   - **Received at:** leave unset for new messages; the action uses the receipt/import instant. When importing an old message manually, select its original received date and time.
6. If your iOS version does not expose Sender as a usable text variable, create a sender-specific automation for each bank and enter that bank's exact SMS sender name. Do not hardcode one bank sender on a broad automation receiving other banks' messages.
7. Save and allow any first-run Shortcuts permission prompt while unlocked.
8. Receive a genuine bank SMS matching the trigger. Open Floosy, or refresh the import screen, to process it. Verify the transaction, amount, date, direction and associated card in **Transactions**. Account/card linking still requires user review where the message does not identify the card.

Apple documents [Message communication triggers](https://support.apple.com/guide/shortcuts/apdd711f9dff/ios) and [automations that can run without asking](https://support.apple.com/guide/shortcuts/apd602971e63/ios). Individual actions and device conditions can still require interaction.

## Test receipt before waiting for a new message

Copy an existing bank SMS from Messages. In Floosy's import screen, choose **Import a copied message**, enter its bank sender and original received time, and paste the complete text. Importing runs the real financial pipeline and can update your balances. Re-importing the same sender/body should not create a second financial transaction.

You can also run **Import Bank SMS** manually from a shortcut to verify action discovery and queueing, then attach the same action to the Message automation. Use your own message locally; do not commit it or a screenshot containing account details to the repository.

## Limits and recovery

- The app cannot enumerate the iOS SMS inbox or read old messages automatically. Apple's [message filtering API](https://developer.apple.com/documentation/identitylookup/sms-and-mms-message-filtering) is a different, restricted extension mechanism.
- Receipt is queued in the background when iOS runs the automation. Balance calculation and application sync are performed while Floosy is open; this is not an always-running background Flutter service.
- After a reboot, unlock the phone once so the protected queue becomes accessible. Import also depends on the automation remaining enabled and the app's personal signing certificate remaining valid.
- Disabling import pauses processing and rejects new queued input; it does not erase already queued messages. Disable the Shortcuts automation too when stopping tracking.
- Failed parsing/unknown senders remain under **Needs review**. Correct bank mapping or re-enter the message, then retry. An error does not silently discard the queued text.
- The queue has a 1,000-message limit and rejects overflow explicitly. Process or remove queued messages before retrying the shortcut.
- The App Intent is queued locally and does not return private balances or message bodies through Siri dialogs.

## Validation boundary

The Dart queue consumer and existing parser are validated locally using synthetic messages, including duplicate delivery, delayed timestamps, failed processing, failed acknowledgment, disabled imports and account changes. These temporary tests live in ignored `.diag`, not in the application repository.

Windows cannot compile the App Intents code or verify cellular Message automation delivery. Run **Floosy iPhone - Sign on Windows** in Codemagic, install the resulting IPA, and perform the device test above before treating native build, Shortcuts discovery or background receipt as verified.
