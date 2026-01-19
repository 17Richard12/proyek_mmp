# Setup Authentication

 This project uses Firebase Authentication. Follow these steps to configure the platform-specific settings.

 ## Android Setup

 1.  **Add `google-services.json`**:
     *   Download `google-services.json` from the Firebase Console (Project Settings > General > Your Apps > Android).
     *   Place it in `android/app/google-services.json`.
     *   *Note: A file already exists, verify it matches your project.*

 2.  **SHA-1 Fingerprint**:
     *   Generate your SHA-1 fingerprint:
         *   Run `keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android` (Mac/Linux).
         *   Or `./gradlew signingReport` in `android/`.
     *   Add the SHA-1 to your Firebase Console under Project Settings > General > Your Apps > Android > Add fingerprint.
     *   **Crucial for Google Sign-In.**

 ## iOS Setup

 1.  **Add `GoogleService-Info.plist`**:
     *   Download `GoogleService-Info.plist` from Firebase Console (iOS App).
     *   Open the project in Xcode (`ios/Runner.xcworkspace`).
     *   Drag and drop the file into the `Runner` folder in Xcode (ensure "Copy items if needed" is checked).

 2.  **Info.plist Configuration**:
     *   Open `ios/Runner/Info.plist`.
     *   Add the `CFBundleURLTypes` for Google Sign-In (reverse client ID):
         ```xml
         <key>CFBundleURLTypes</key>
         <array>
             <dict>
                 <key>CFBundleTypeRole</key>
                 <string>Editor</string>
                 <key>CFBundleURLSchemes</key>
                 <array>
                     <!-- Copied from GoogleService-Info.plist key REVERSED_CLIENT_ID -->
                     <string>com.googleusercontent.apps.910249466722-xxxxxxxxxxxx</string>
                 </array>
             </dict>
         </array>
         ```

 ## Web Setup

 *   Already configured in `lib/firebase_options.dart`.
 *   Ensure "Google" provider is enabled in Firebase Console > Authentication > Sign-in method.
 *   Add the Authorized Domain (e.g., `localhost`) in Firebase Console.
