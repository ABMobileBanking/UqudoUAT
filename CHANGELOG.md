## 3.6.2

* Added support for the latest version of the Omani ID for both citizens and residents.
* Fixed an issue on iOS 26.2 and later where activating the torch could cause the screen to freeze.

## 3.6.1

* Android SDK
  - Added **edge-to-edge display support**.
  - Fixed a **race condition** that could cause a crash when **scan review** was enabled.
  - Implemented additional safeguards to reduce or prevent minor crashes reported by customers.
* iOS SDK
  - Fixed minor layout issues on **iOS 26.x**.
  - Resolved **mapping inconsistencies** between platform and device models, and updated the mapping according to the latest **Xcode 26** device information. *
* Android & iOS SDK
  - Improved **NFC reading reliability** for documents supporting **chip authentication**, if **DG14** is malformed, it is now safely ignored.
  - Enhanced the **tracing mechanism** by adding missing trace points for unexpected errors.

## 3.6.0

* Android SDK:
  - Added support for 16KB page size alignment.
  - Edge-to-edge views are not yet fully supported in this release. Instead, a configuration option has been introduced to opt out. If you had previously applied this configuration based on support guidance, you can now remove it. Full support for edge-to-edge views will be included in the next release.
  - **Note**: You need to update compileSdk Version to 35 in order to build with this version of the SDK.
* iOS SDK:
  - In version 3.4.1 we improved RTL layout support so that right-to-left settings were applied only to SDK views. However, setting UIView.appearance().semanticContentAttribute = .forceRightToLeft at the global level still affected the SDK’s UINavigationBar. This has now been fixed.
  - Fixed an issue with the NFC progress bar where it disappeared when system text size (Display → Text Size) was set to Small or Medium.
* Document Classification:
  - Fixed an issue where the back side of Egyptian IDs was not recognized correctly.
* NFC:
  - Fixed an issue with Saudi IDs where a chip response SW_BYTES_REMAINING_00, a valid but unexpected response, was incorrectly treated as a fatal error.

## 3.5.0

* New Document Support:
    - Added support for Indonesian ID and Iraqi Resident ID documents.
* Document Classification Improvements:
    - Enhanced classification for Qatari ID. Previously, low scores on the back side could cause rejections during scanning; this issue has been addressed.
* Android SDK:
    - Upgraded CameraX library to version 1.4.2.
    - Fixed a potential crash during NFC reading of Emirates ID if the user removed the phone at a critical point in the final reading step.
* iOS SDK:
    - Updated the OpenSSL dependency to version 3.3.3001 for NFC reading functionality. Using version 1.x will cause the SDK to crash.
    - Fixed a rare crash related to camera selection. If the camera is unavailable, the SDK now safely ends the session with status code `SESSION_INVALIDATED_CAMERA_NOT_AVAILABLE`.
    - Removed legacy `assets.bundle` and optimized existing assets, reducing total asset size by about 2MB.
* NFC / Chip Reading Enhancements:
    - Improved support for EAC-CA (Chip Authentication), especially for passports. The SDK now handles defective chip implementations more gracefully by ignoring chip authentication failures. You can check if chip authentication was enabled in the verification object.
* Facial Liveness – New Active Liveness Feature:
    - Introduced a new active liveness option in the facial recognition configuration. The SDK randomly prompts the user to perform one of six actions: move closer, move further, tilt right, tilt left, turn right, or turn left. You can disable one gesture type (move, tilt, or turn) to reduce the pool to four actions.
    - ⚠️ Important: Enable this feature only if required by compliance, as it may reduce conversion rates. See the documentation for configuration details.
* New NFC/Reading Flow:
    - Added a dedicated NFC/Reading flow, allowing verification processes to begin from the NFC step. You must supply required data to unlock the chip. Refer to the documentation for full details.
* General:
    - Minor bug fixes and performance improvements.

## 3.4.2
* New Feature
    - Facial recognition is now supported when using the MRZ document type in combination with NFC. Previously, facial recognition was disabled with MRZ as it only involved scanning the machine-readable zone (MRZ) of the document. From this version onward, facial recognition can be enabled and if there is a successful NFC reading during onboarding, the user will proceed to the facial recognition step, otherwise the step is automatically skipped.
* Document Scanning
    - Enhanced speed and accuracy notifying users if their fingers are obstructing the document.
* Android
    - In version 3.4.1, we introduced timestamp synchronization to ensure analytics events reflect the correct time, even when the device's date and time are incorrectly set. However, the obfuscation process used during SDK compilation inadvertently altered a field, causing timestamps to default to January 1st, 1970. This issue has now been resolved. We strongly recommend updating to this version for accurate event tracing.
* iOS
    - Resolved an issue affecting iOS 18.5 and above, where after denying camera permissions the first time, the permission prompt would persist and fail to redirect users to the settings page.
* Miscellaneous
    - Minor bug fixes.

## 3.4.1

* Document Scanning
    - Added support for Moroccan ID (MAR_ID) scanning, including NFC chip reading.
    - Added support for the latest Bahrain ID version.
* New Document Types
    - Introduced QAT_ID_NATIONAL, QAT_ID_RESIDENT, KWT_ID_NATIONAL and KWT_ID_RESIDENT.
    - Note: Previous SDK versions reported types such as OMN_ID_NATIONAL simply as OMN_ID. From this release onward, the exact selected document type will be returned.
* Tracing Enhancements (Analytics)
    - Added a new deviceIdentifier field (a UUID) to the tracing object. This value uniquely identifies all sessions from a given device (persisting until the app is reinstalled). You may still use more specific identifiers, such as phone number or email, if you already know the user.
* Android
    - Fixed an issue that prevented the use of Dynamic Feature Modules.
* iOS
    - Improved RTL layout support so that right-to-left settings apply only to SDK views.
* Miscellaneous
    - Various minor improvements and bug fixes.

## 3.4.0 

* Expanded Document Support:
  - Added support for SOM_ID (Somali ID)
  - Added support for BHR_VL (Bahrain Vehicle License)
  - Added support for JOR_VL (Jordan Vehicle License)
  - Added support for SAU_VL (Saudi Vehicle License)
* Enhanced Quality Check: Introduced a new verification step during document scanning to notify users if their fingers are obstructing the document
* General Improvements: Implemented minor enhancements and bug fixes for improved performance and stability

## 3.3.1

* Android: Resolved a random crash in the SDK initialization caused by "NullPointerException Attempt to invoke virtual method 'java.lang.String java.io.File.getPath()' on a null object reference"

## 3.3.0

* Added two new fields to the scan object in the SDK result:
- frontFrameImageId: Contains the reference to the complete frame image of the document's front side
- backFrameImageId: Contains the reference to the complete frame image of the document's back side
  These frame images capture the full background context of the scan, which is valuable for troubleshooting issues and meeting regulatory requirements that mandate documentation of the scanning environment.
* Enhanced face detection during selfie capture to ensure only a single face is present, preventing failed liveness checks and face matching due to multiple faces in the frame.
* Minor bug fixes and improvements

## 3.2.1

* Fixed regression bug introduced in version 3.2.0
* Added support for a new document type: TUN_ID (Tunisian ID)

## 3.2.0

* (Android SDK) Enhanced Security with Improved Root Detection: We've significantly strengthened the root detection mechanism in our Android SDK to provide greater protection against dynamic code injection and other malicious activities. This improvement ensures that the application remains secure even in compromised environments. However, we strongly recommend that customers implement their own additional root detection strategies as well. Rooted devices can compromise the integrity of the entire application and its data. UnsupportedDeviceException has been removed in favor of IllegalStateException if a rooted device is detected. Make sure to manage the exception to avoid your application to crash.
* (Android SDK) Resolved an issue where pressing the back button during the document scanning step would incorrectly return the user to the help page, even when the help page was disabled in the SDK configuration.
* (iOS SDK) Upgraded OpenSSL-Universal to version 1.1.2301. If you're using the native SDK (Objective-C or Swift), please update this dependency when upgrading to the new SDK version. For hybrid frameworks (excluding React Native), the dependency is automatically added to the package descriptor of the Uqudo plugin.
* Enhanced the speed and accuracy of the ID photo tampering detection feature.
* Improved the accuracy of the ID photo quality check, particularly for cases where the face is partially covered by a finger or other objects. In such cases, the scan will now be rejected, and appropriate feedback will be provided to the user.
* Starting with this version, the SDK will reject scans of ID documents presented on paper. If you prefer to allow scans through screens or paper and wish to assess related scores on your side, you can use the `allowNonPhysicalDocuments` configuration option available in the SDK.
* Added support for a new document type: UAE_PASSPORT_DIGITAL. This represents the digital version of the UAE passport. To accept this version, treat it as a distinct document type in your Enrollment Builder Configuration. Also, when selecting UAE_PASSPORT_DIGITAL, ensure that non-physical documents are enabled and tampering rejection is disabled for successful scanning.
* Enhanced support for Rwanda ID and Somaliland ID.
* Improved the KEN_ID lookup by requiring only the identity number, simplifying the process for the end user.
* Various minor bug fixes and improvements.

## 3.1.3

* Introduced support for Qatar Vehicle License.
* Resolved an issue in document scanning that occasionally failed to recognize the latest version of the Bahraini passport.
* Resolved an issue where authentication exception during PACE in passport NFC was not properly handled.
* Implemented minor bug fixes.
* iOS: Optimized the SDK to reduce its size.
* iOS: Corrected RTL layout issues when using the Kurdish language.
* Android: Addressed a rare crash during the document scanning step when the help page is disabled.
* Android: Resolved a crash that occurred when the back button was pressed simultaneously during the document scanning step.

## 3.1.2

* To enhance the ID Document scan experience, we have improved the glare detection pipeline by masking the ID photo area. This prevents glare detection in this highly reflective region which is known to contain large holographic features. This is done without compromising the quality of ID photos, as our dedicated photo quality detection model handles this aspect better. We've also extended the masking to other reflective areas on ID document that don't affect the capture quality, including:
- Reflective security features (e.g. embossed stripes on the back of Emirates ID)
- Contactless chip areas
- Emblems and logos (e.g. UAE Emirates Vehicle License)
* We have streamlined the blur detection pipeline by removing redundant image processing components for improved accuracy and performance and fewer false positives.
* The ID Document detection model now accommodates larger tilt angles, ensuring high-quality capture even when the document is not perfectly straight.
* The distance requirements between the main camera and the ID document have been relaxed, permitting users to hold the ID document slightly farther away. This adjustment helps the camera focus more effectively and improves the overall user experience.
* Glare Detection: Replaced technical term "glare" - which is not universally understood - with a more user-friendly message: "Avoid light reflections on the ID document."
* ID Document Scan on Android: Changed the message "Hold on" to "Do not move."
* When allowNonPhysicalDocuments is set to false, We replaced the message: "Please provide physical document" with "Please provide the original document. No screens and printed copies allowed".
* Poor ID Photo Quality: New message will be shown: "Photo not clear. Please move to better lighting."
* New Telemetry and SDK Analytics Events.
  New ID Document Scan events added:
- SCAN_DOCUMENT_DARK_ENVIRONMENT_DETECTED
- SCAN_DOCUMENT_INCORRECT_DISTANCE_DETECTED
- SCAN_DOCUMENT_BLUR_DETECTED
- SCAN_DOCUMENT_INCORRECT_TYPE_DETECTED
- SCAN_DOCUMENT_INCORRECT_SIDE_DETECTED
- SCAN_DOCUMENT_GLARE_DETECTED
- SCAN_DOCUMENT_ID_PHOTO_BAD_QUALITY_DETECTED
- SCAN_DOCUMENT_SCREEN_DETECTED
- SCAN_DOCUMENT_PRINT_DETECTED
  New facial recognition events added:
- FACE_INCORRECT_POSITION_DETECTED
- FACE_INCORRECT_DISTANCE_DETECTED
- FACE_DARK_ENVIRONMENT_DETECTED
- FACE_BLUR_DETECTED
- FACE_MOUTH_COVER_DETECTED
- FACE_EYES_COVER_DETECTED
- FACE_EYES_CLOSED_DETECTED
- FACE_SPOTLIGHT_DETECTED
- FACE_SHADOW_DETECTED
- FACE_EYES_SHADOW_DETECTED

## 3.1.1

* Introducing the new document type UAE_ID_DIGITAL aimed at clearly distinguishing between the digital and physical versions. If you want to accept the digital version, it is necessary to treat this as a separate document type in your Enrollment Builder Configuration. Furthermore, if you select the document type UAE_ID_DIGITAL, make sure to enable non-physical documents and deactivate tampering rejection to ensure successful scanning. It's important to note that starting from this version onwards, selecting the document type UAE_ID while the user provides the digital version will result in rejection. Likewise, selecting UAE_ID_DIGITAL while the user provides the physical version will yield the same outcome.
* For Android, fixed crash during document scanning in the rare case the phone doesn't support high resolution. Please make sure to update to this version to prevent any potential crashes.
* Minor improvements

## 3.1.0

* Introducing a new configuration option for facial recognition, enabling 1:N face match verification. Once activated, following a successful facial recognition (confirming liveness and matching the face), the system initiates a search for the user's selfie within your tenant. If the selfie is not found, it is added, and the indexed facial features are stored in the database. The SDK result includes a unique ID in the face object, along with an indication of whether there was a match with a previously onboarded selfie. It's essential to store this unique ID in your system alongside the user's record, facilitating future searches for users with the same ID. Please be aware that this option requires a specific permission, otherwise, it will be disregarded. For further information or to explore this new feature, please reach out to your account manager.
* In iOS 17.4, a bug was introduced in the NFC popup, resulting in the progress bar no longer being visible. We've implemented a workaround to address this issue and ensure the progress bar is once again visible.

## 3.0.2

* Enhanced the screen resolution ratio to optimize facial recognition, aimed at reducing rejections caused by liveness check failures.
* Reactivated the 'forceReadingTimeout(timeout)' option for the NFC step, allowing users to skip NFC scanning if they're unable to complete it before the timeout expires, with a corresponding notification message.
* Resolved an iOS bug where customization of the back button layout was not being applied.
* Removed the debug executable check from the jailbroken security verification process on iOS. Please note that while the SDK performs this check, it's advised to conduct it within your application as well.
* Introduced a new 'InitializationException' for Android, thrown when the SDK fails to load native libraries due to a bug on certain Android devices. This exception enables your application to handle the issue gracefully instead of crashing.
* Addressed potential crashes on Android that could occur when the application transitions between background and foreground states during document scanning.

## 3.0.1

* Important improvement in the id photo tampering detection during document scanning to identify any alterations to the ID photo.
* Reduced the level of sensitivity for detecting glares during document scanning.
* Small improvement during scanning to identify printed copies. As per our previous release, the SDK will not reject scans of printed documents but will provide a score indicating the likelihood of a printed copy under the verification object in the SDK result.
* Included a new obfuscation type called "FILLED_WHITE" within the facial recognition configuration, which completely substitutes the background with a white color.
* Introduced a new configuration option called "disableTamperingRejection", directing the SDK not to dismiss the scan upon detecting tampering, specifically for ID photo tampering detection.
* Deprecated the configuration option called "enrollFace" within the facial recognition configuration, as it is related to the "Account Recovery Flow" deprecated in version 3.0.0. It is planned for removal in a future release.
* Android: upgraded the camera library to the latest stable version that fixes an important bug that could affect the scan on Samsung A24 devices.
* iOS: Addressed an issue on iPhone 14 and iPhone 15 base version where the camera failed to focus when documents were in close proximity.
* iOS: Refactored the implementation to identify whether the device has been rooted.

## 3.0.0

* Introduced a new verification object result within the SDK, including all details pertinent to the verification process. This feature supports your business logic by easily identifying potential issues. Refer to https://docs.uqudo.com/docs/kyc/uqudo-sdk/sdk-result/data-structure/verification-object for comprehensive information.
* Added Data Consistency Check within the verification object, supporting your business logic by highlighting inconsistencies throughout the entire KYC journey, including optical scanning, NFC, and lookup stages.
* Added source detection during document scanning to ensure that users display physical documents, eliminating screens and printed copies. In this release, the SDK will not reject scans of printed documents but will provide a score indicating the likelihood of a printed copy under the verification object in the SDK result. Please note that low-light conditions may affect the result, potentially increasing the score for printed copies and leading to false positives. We are committed to improving this aspect in future releases, refining quality check procedures to ensure optimal image quality. Eventually, printed documents above a certain score will be rejected directly from the SDK, similar to how screens are handled.
* Added an option to permit scanning of non-physical documents (where the SDK won't reject scans upon detecting a screen). The SDK result includes a score indicating whether the document was scanned from a screen, as described in the verification object above.
* Added ID photo tampering detection during document scanning to identify any alterations to the ID photo. The SDK will reject scans above a certain score and provide an appropriate message. Score information is returned in the SDK result within the verification object.
* Enhanced identification of low-light conditions during document scanning by introducing stricter criteria. Suboptimal lighting can affect document recognition, particularly for non-physical documents.
* Improved scanning capabilities for Turkish IDs.
* Added NFC support for the latest version of the QAT ID for residents.
* Added NFC support for IRQ ID.
* Added support for passport chip authentication during NFC reading.
* Implemented countermeasures for NFC replay attacks on documents lacking authentication mechanisms.
* Addressed an issue on iPhone 14 Pro/Pro Max and iPhone 15 Pro/Pro Max where the camera failed to focus when documents were in close proximity.
* Resolved an issue where a specific version of the QAT ID's back side for citizens was not being recognized.
* In the Lookup Flow, removed NGA virtual NIN in favor of the actual NIN (National Identification Number) written on the document, as the virtual NIN service has been suspended by the Nigerian government.
* Overall enhancements to the scanning process to improve scan quality.
* Backported the latest changes from SDK version 2.7.4.
* For Android application development, targeting SDK 34 is now mandatory.
* Deprecated the enableUpload feature in the SDK, planned for removal in a future release.
* Deprecated the forceReadingIfSupported function in the ReadingConfiguration builder and made it the default behavior, eliminating the option to skip the reading step (NFC) unless the device lacks NFC support. The forceReading option remains available for those wishing to restrict usage to devices with NFC support only.
* Deprecated the forceReadingTimeout function in the ReadingConfiguration, making it a no-op operation.
* Deprecated the Account Recovery Flow feature in the SDK, planned for removal in a future release. Use Face Session Flow instead.
* Various minor bug fixes and improvements.

## 2.7.4

* Added compatibility for applications designed to target targetSdk version 34 on the Android platform
* Corrected an issue related to NFC reading for passports specifically when PACE access control is the sole supported mechanism. IMPORTANT: If you have activated the NFC reading step for passports in our SDK, kindly update the SDK to this latest release

## 2.7.3

* Corrected the lookup flow process associated with the Nigerian National Identification Number (NIN), which now necessitates entering the 16 alphanumeric characters of the virtual NIN
* Added compatibility for applications designed to target compileSdk version 34 on the Android platform

## 2.7.2

* Added scan support for Iraqi ID.
* Added two new session status codes:
    - SESSION_INVALIDATED_CAMERA_NOT_AVAILABLE: If the camera is not available, the SDK drops the session with this status. Possible reasons for the camera not being available include:
        - Hardware Failure: Hardware issues or malfunctions can render the camera module inoperable.
        - Privacy Settings: The user may have disabled the camera functionality through privacy settings or restrictions on the device.
        - Camera in Use by Another App: If another application is actively using the camera, attempts to access it from a different app may fail. Possible scenarios:
        - Camera is in Use by System Process: System-level processes or services may temporarily take control of the camera (e.g., on iOS, the camera might be used by the system camera app, FaceTime, or other built-in features).
        - Background Camera Use: Some apps may continue to use the camera even when in the background (e.g., video conferencing apps might continue to stream video).
        - Camera Hardware Limitations: Certain devices or hardware configurations may impose limitations on camera access (e.g., restricting access to the camera when certain power-saving features are enabled).
        - Device-Specific Behavior: Device manufacturers and operating system providers may implement different policies or behaviors regarding camera access, leading to variations across devices and platforms.
    - SESSION_INVALIDATED_CAMERA_PERMISSION_NOT_GRANTED: If the end user denies camera access, the SDK drops the session with this status.
      In both cases, it's necessary to manage the error codes and interact with the end user accordingly.
* In Android, fixed a bug where, in rare cases during the scanning step, if the application was put in the background and subsequently killed by the OS, the session ID was lost, and the user wasn't able to proceed with the KYC session.
* Improved the quality detection during scanning and fixed a bug where the back side of the Rwand ID was hard to scan.
* Improved HTTP retry mechanism when interacting with the server during sudden and temporary connection failures.
* Minor bug fixes and improvements.

## 2.7.1

* We have introduced a new document type called MRZ. This document type allows you to scan documents with MRZ type TD1 or TD3. Additionally, you can enable the reading module, and if the issuer is supported, the SDK will guide the user to the reading/NFC step. Please note that no additional features are available for the MRZ document type
* Added full support for Qatari ID scanning

## 2.7.0

* In this latest release, we've revamped the facial recognition step. We've eliminated the nodding step, transforming facial recognition into a straightforward process easy as capturing a selfie. Under the hood, numerous enhancements have been implemented to ensure speed, simplicity, and enhanced accuracy. There are no changes in terms of business logic for your integration process
* Within the iOS native SDK, we have marked several properties under UQEnrollmentBuilder and UQLookupBuilder associated with facial recognition as deprecated. In their place, we've introduced a dedicated entity called UQFacialRecognitionConfig. This entity serves to enable facial recognition and customize the corresponding settings. See the documentation for details
* We have added a new configuration option for facial recognition that allows closed eyes during facial recognition. By default is disabled. See the documentation for details
* Improved scanning for Bahrain ID
* Added support for Lebanon ID and Driving License
* Minor improvements and minor bug fixes

## 2.6.0-1

* Fixed bug in the flutter plugin that prevent ios app to build successfully. The bug was introduced in version 2.6.0.

## 2.6.0

* Added new feature "Lookup Flow". The "Lookp Flow" it's the same as the "Enrollment Flow" with the only difference that the first step is not the automatic scanning of a document through the camera phone but the user is asked to manually type in some information of the document that can be used to perform the lookup on the government database. Only one document at the time is supported. Other features like facial recognition and background check can be enabled in the same way as per the "Enrollment Flow". Please check the integration documentation https://docs.uqudo.com/docs/uqudo-sdk/integration for details
* Improved document detection during scanning
* Improved id photo quality detection during scanning
* Minor improvements and minor bug fixes

## 2.5.4

* Fixed bug that was introduced in version 2.5.3 related to the reading module (NFC) for GHA ID
* Added driving license information for SAU ID reading module (NFC)
* Added full support for SAU DL (driving license)

## 2.5.3

* Significant improvements for the scanning part related to SAU_ID in order to support all the valid versions currently in use and to support all the variations possible for the residency card
* Added new document type SAU_ID_NATIONAL and SAU_ID_RESIDENT if you want to enforce only national ID for citizens or only national ID for residents
* Add new reading module (NFC) for Saudi ID, the latest version of the national id for citizens
* Significant improvements for the id photo quality detection during the scanning of the document
* Added new document type IND_PAN for Indian PAN card
* For iOS we made an important improvement for the NFC session management

## 2.5.2

* Added new document type QAT_DL for Qatar driving license
* Added new document type BHR_DL for Bahrain driving license
* Added new document type PHL_DL for Philippines driving license
* Added new document type RSL_ID for Somaliland national id

## 2.5.1

* Added new document type USA_DL for United States of America driving license

## 2.5.0

* Added new document type COD_VOTER_ID for Democratic Republic of the Congo driving license
* Added new document type OMN_DL for Oman driving license
* Added new document type OMN_VL for Oman vehicle license
* From this version on in the SDK result all the fields containing a date will have an additional field with the same name plus the suffix "Formatted" that will contain the same date formatted in ISO-8601 format, e.g. '2011-12-03'
* For Android we did a small change to make sure your application can build and run on x86_64 architecture. This will allow you to test your application on x86_64 emulator but the SDK part, armeabi-v7a and arm64-v8a remain the only supported architectures
* For iOS we made sure that portrait mode is always enforced
* For iOS fixed bug where an application applying the navigation bar appearance throughout the entire app using UINavigationBar.appearance() was affecting the SDK navigation bar layout
* For iOS we made sure to close any open NFC session after tapping the skip button
* Minor bug fixes and improvements

## 2.4.0

* Added new document type GBR_ID for UK resident id
* Added new document type COD_DL for Democratic Republic of the Congo driving license
* Improved glare detection during document scanning
* From this version on we will start using the Analytics feature of the SDK internally to push the events to our API. The feature will continue be available to your application as well, nothing has change in that regard. This will allow us in the future to provide to our customers accurate statistics of the onboarding flow. The data sent are totally anonuymous and don't include any personal data.
* Fixed issue in the reading module (NFC) for Bahrain ID that could potentially failing for some versions of the identity card
* Minor bug fixes and improvements
* For Android we pushed the target SDK to version 33
* For Android we updagraded a few dependencies including the camera library. The dependencies upgrade will require you to upgrade gradle to version 7.5

## 2.3.2

* Fixed issue on the iOS SDK where the camera doesn't get activated when the scanner help page is disabled and the camera permission is given for the first time

## 2.3.1

* Fixed bug in the Face Session flow for iOS

## 2.3.0

* Added new document type DZA_ID (Algerian ID)
* Added new document type TUR_ID (Turkish ID)
* Added NFC support for Algerian ID
* Added NFC support for Turkish ID
* Improved quality detection during the scanning of the document
* Deprecated enableRootedDeviceUsage(), it is ignored from this version and no rooted device is allowed
* Minor bug fixes and improvements

## 2.2.1

* Minor bug fixes

## 2.2.0

* Added new document type Senegal National ID and Uganda Voter ID
* Added support to read the chip of Senegal ID through NFC
* Added new configuration option enableAgeVerification for the document scanning that allows to reject the scan if the age is not above or equals the one defined in the configuration
* We replaced the 5 images in the facial recognition popup when the face doesn't match. The images can now be replaced with your own images
* Improved glare detection during document scanning
* Removed additional dependency for the Android SDK
* Minor bug fixes and minor improvements
