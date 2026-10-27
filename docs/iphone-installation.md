# Install a personal iPhone test build from Windows

## SMS support

Floosy's SMS inbox reader uses an Android platform channel. Installing the iPhone build does not enable automatic SMS import. Apple's message filtering extensions do not provide the Android inbox-reading API or permit writing message data into the containing app's shared container. See [Apple's message filtering documentation](https://developer.apple.com/documentation/identitylookup/sms-and-mms-message-filtering).

The iPhone build can be used to try sign-in, transactions, budgets, items and the other available screens. An iPhone SMS import feature would require a separate, supported input flow.

## Build the device IPA in Codemagic

1. Push the current project, including `codemagic.yaml`, to the repository connected to Codemagic.
2. Refresh the branch configuration in Codemagic.
3. Start a build using **Floosy iPhone - Sign on Windows** (`ios-device-unsigned`).
4. Download **floosy-iphone-unsigned.ipa** from the successful build's artifacts.

This workflow builds for a physical iPhone in release mode. The IPA is unsigned and needs local signing before installation. The simulator ZIP produced by the other workflow cannot be installed on an iPhone.

## Sign and install using Sideloadly

1. Download the Windows version from [Sideloadly's official site](https://sideloadly.io/) and follow its Apple component requirements.
2. Connect the unlocked iPhone using a USB cable and accept **Trust This Computer**.
3. Open Sideloadly, select the iPhone, and load `floosy-iphone-unsigned.ipa`.
4. Enter your Apple ID directly in Sideloadly and complete its signing and installation prompts. These credentials are not needed by this repository or Codemagic.
5. On iPhone, trust the developer under **Settings > General > VPN & Device Management**.
6. Enable **Settings > Privacy & Security > Developer Mode**, if required, and follow the restart prompts.
7. Open Floosy.

Sideloadly supports free Apple IDs. Free-account signatures last seven days and need refreshing; the free account also has a three-app limit. See [Sideloadly's FAQ](https://sideloadly.io/faq).

For TestFlight distribution, use an Apple Developer Program membership and a separately configured signing and App Store Connect workflow. See [Codemagic's signing guide](https://docs.codemagic.io/yaml-code-signing/signing-ios/).
