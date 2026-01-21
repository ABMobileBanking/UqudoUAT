var exec = require('cordova/exec');

function UqudoSDK() {
};

UqudoSDK.prototype.init = function () {
    if (arguments.length === 0) {
        exec(null, null, 'UqudoIdPlugin', 'init', []);
    } else {
        exec(arguments[0], null, 'UqudoIdPlugin', 'init', []);
    }
}

UqudoSDK.prototype.setLocale = function (locale) {
    exec(null, null, 'UqudoIdPlugin', 'setLocale', [locale]);
}

UqudoSDK.prototype.enroll = function (enrollmentObject, success, error) {
    exec(success, error, 'UqudoIdPlugin', 'enroll', [JSON.stringify(enrollmentObject)]);
}

UqudoSDK.prototype.recover = function (recoveryObject, success, error) {
    exec(success, error, 'UqudoIdPlugin', 'recover', [JSON.stringify(recoveryObject)]);
}

UqudoSDK.prototype.lookup = function (lookupObject, success, error) {
    exec(success, error, 'UqudoIdPlugin', 'lookup', [JSON.stringify(lookupObject)]);
}

UqudoSDK.prototype.reading = function (readingObject, success, error) {
    exec(success, error, 'UqudoIdPlugin', 'reading', [JSON.stringify(readingObject)]);
}

UqudoSDK.prototype.faceSession = function (faceSessionObject, success, error) {
    exec(success, error, 'UqudoIdPlugin', 'faceSession', [JSON.stringify(faceSessionObject)]);
}

UqudoSDK.prototype.isFacialRecognitionSupported = function (documentType, success, error) {
    exec(success, error, 'UqudoIdPlugin', 'isFacialRecognitionSupported', [documentType]);
}

UqudoSDK.prototype.isReadingSupported = function (documentType, success, error) {
    exec(success, error, 'UqudoIdPlugin', 'isReadingSupported', [documentType]);
}

UqudoSDK.prototype.isLookupSupported = function (documentType, success, error) {
    exec(success, error, 'UqudoIdPlugin', 'isLookupSupported', [documentType]);
}

UqudoSDK.prototype.isLookupFacialRecognitionSupported = function (documentType, success, error) {
    exec(success, error, 'UqudoIdPlugin', 'isLookupFacialRecognitionSupported', [documentType]);
}

UqudoSDK.prototype.isEnrollmentSupported = function (documentType, success, error) {
    exec(success, error, 'UqudoIdPlugin', 'isEnrollmentSupported', [documentType]);
}

UqudoSDK.prototype.EnrollmentBuilder = EnrollmentBuilder
UqudoSDK.prototype.DocumentBuilder = DocumentBuilder
UqudoSDK.prototype.FacialRecognitionConfigurationBuilder = FacialRecognitionConfigurationBuilder
UqudoSDK.prototype.BackgroundCheckConfigurationBuilder = BackgroundCheckConfigurationBuilder
UqudoSDK.prototype.AccountRecoveryConfigurationBuilder = AccountRecoveryConfigurationBuilder
UqudoSDK.prototype.AccountRecoveryBuilder = UqudoSDK.prototype.AccountRecoveryConfigurationBuilder
UqudoSDK.prototype.FaceSessionConfigurationBuilder = FaceSessionConfigurationBuilder
UqudoSDK.prototype.FaceSessionBuilder = UqudoSDK.prototype.FaceSessionConfigurationBuilder
UqudoSDK.prototype.ReadingConfigurationBuilder = ReadingConfigurationBuilder
UqudoSDK.prototype.ReadingBuilder = ReadingBuilder
UqudoSDK.prototype.LookupBuilder = LookupBuilder
UqudoSDK.prototype.DocumentType = Object.freeze(
    {
        BHR_ID: 'BHR_ID',
        GENERIC_ID: 'GENERIC_ID',
        KWT_ID: 'KWT_ID',
        OMN_ID: 'OMN_ID',
        PAK_ID: 'PAK_ID',
        PASSPORT: 'PASSPORT',
        SAU_ID: 'SAU_ID',
        UAE_ID: 'UAE_ID',
        UAE_DL: 'UAE_DL',
        UAE_VISA: 'UAE_VISA',
        UAE_VL: 'UAE_VL',
        QAT_ID: 'QAT_ID',
        NLD_DL: 'NLD_DL',
        DEU_ID: 'DEU_ID',
        SDN_ID: 'SDN_ID',
        SDN_DL: 'SDN_DL',
        SDN_VL: 'SDN_VL',
        GHA_ID: 'GHA_ID',
        NGA_DL: 'NGA_DL',
        NGA_VOTER_ID: 'NGA_VOTER_ID',
        NGA_NIN: 'NGA_NIN',
        GBR_DL: 'GBR_DL',
        SAU_DL: 'SAU_DL',
        ZAF_ID: 'ZAF_ID',
        ZAF_DL: 'ZAF_DL',
        EGY_ID: 'EGY_ID',
        RWA_ID: 'RWA_ID',
        KEN_ID: 'KEN_ID',
        GHA_DL: 'GHA_DL',
        GHA_VOTER_ID: 'GHA_VOTER_ID',
        GHA_SSNIT: 'GHA_SSNIT',
        UGA_ID: 'UGA_ID',
        IND_ID: 'IND_ID',
        OMN_ID_NATIONAL: 'OMN_ID_NATIONAL',
        OMN_ID_RESIDENT: 'OMN_ID_RESIDENT',
        SEN_ID: 'SEN_ID',
        UGA_VOTER_ID: 'UGA_VOTER_ID',
        DZA_ID: 'DZA_ID',
        TUR_ID: 'TUR_ID',
        GBR_ID: 'GBR_ID',
        COD_DL: 'COD_DL',
        OMN_DL: 'OMN_DL',
        OMN_VL: 'OMN_VL',
        COD_VOTER_ID: 'COD_VOTER_ID',
        USA_DL: 'USA_DL',
        QAT_DL: 'QAT_DL',
        BHR_DL: 'BHR_DL',
        PHL_DL: 'PHL_DL',
        RSL_ID: 'RSL_ID',
        IND_PAN: 'IND_PAN',
        SAU_ID_NATIONAL: 'SAU_ID_NATIONAL',
        SAU_ID_RESIDENT: 'SAU_ID_RESIDENT',
        NGA_BVN: 'NGA_BVN',
        LBN_ID: 'LBN_ID',
        LBN_DL: 'LBN_DL',
        MRZ: 'MRZ',
        IRQ_ID: 'IRQ_ID',
        UAE_ID_DIGITAL: 'UAE_ID_DIGITAL',
        QAT_VL :'QAT_VL',
        UAE_PASSPORT_DIGITAL: 'UAE_PASSPORT_DIGITAL',
        TUN_ID: 'TUN_ID',
        SOM_ID: 'SOM_ID',
        BHR_VL: 'BHR_VL',
        JOR_VL: 'JOR_VL',
        SAU_VL: 'SAU_VL',
        QAT_ID_NATIONAL: 'QAT_ID_NATIONAL',
        QAT_ID_RESIDENT: 'QAT_ID_RESIDENT',
        KWT_ID_NATIONAL: 'KWT_ID_NATIONAL',
        KWT_ID_RESIDENT: 'KWT_ID_RESIDENT',
        IDN_ID: 'IDN_ID',
        IRQ_ID_NATIONAL: 'IRQ_ID_NATIONAL',
        IRQ_ID_RESIDENT: 'IRQ_ID_RESIDENT',
        MAR_ID: 'MAR_ID'
    } 
);
var BackgroundCheckType = Object.freeze(
    {
        RDC: 'RDC',
        DOW_JONES: 'DOW_JONES'
    }
);
var AppearanceMode = Object.freeze(
    {
        SYSTEM: 'SYSTEM',
        LIGHT: 'LIGHT',
        DARK: 'DARK'
    });

var ObfuscationType = Object.freeze(
    {
        FILLED: 'FILLED',
        BLURRED: 'BLURRED',
        FILLED_WHITE: 'FILLED_WHITE'
    });

var LivenessGesture = Object.freeze(
    {
        FACE_MOVE: 'FACE_MOVE',
        FACE_TILT: 'FACE_TILT',
        FACE_TURN: 'FACE_TURN'
    });

UqudoSDK.prototype.BackgroundCheckType = BackgroundCheckType;
UqudoSDK.prototype.AppearanceMode = AppearanceMode;
UqudoSDK.prototype.ObfuscationType = ObfuscationType;
UqudoSDK.prototype.LivenessGesture = LivenessGesture;
function EnrollmentBuilder() {
    return {
        setToken: function (token) {
            this.authorizationToken = token;
            return this;
        },

        setNonce: function (nonce) {
            this.nonce = nonce;
            return this;
        },

        setSessionId: function (sessionId) {
            this.sessionId = sessionId;
            return this;
        },

        setUserIdentifier: function (userIdentifier) {
            this.userIdentifier = userIdentifier;
            return this;
        },

        enableRootedDeviceUsage: function () {
            this.isRootedDeviceAllowed = true;
            return this;
        },

        disableSecureWindow: function () {
            this.isSecuredWindowsDisabled = true;
            return this;
        },
        setAppearanceMode: function (appearanceMode) {
            this.appearanceMode = appearanceMode;
            return this;
        },
        enableFacialRecognition: function () {
            if (arguments.length === 0) {
                this.facialRecognitionSpecification = new FacialRecognitionConfigurationBuilder().build();
            } else {
                this.facialRecognitionSpecification = arguments[0];
            }
            return this;
        },

        enableBackgroundCheck: function () {
            if (arguments.length === 0) {
                this.backgroundCheckConfiguration = new BackgroundCheckConfigurationBuilder().build();
            } else {
                this.backgroundCheckConfiguration = arguments[0];
            }
            return this;
        },

        returnDataForIncompleteSession: function () {
            this.isReturnDataForIncompleteSession = true;
            return this;
        },

        allowNonPhysicalDocuments: function () {
            this.isAllowNonPhysicalDocuments = true;
            return this;
        },

        disableTamperingRejection: function () {
            this.isDisableTamperingRejection = true;
            return this;
        },

        enableLookup: function () {
            if (arguments.length === 0) {
                this.lookupConfiguration = new LookupConfiguration([]);
            } else {
                this.lookupConfiguration = new LookupConfiguration(arguments[0]);
            }
            return this;
        },

        add: function (document) {
            if (this.documentList == null) {
                this.documentList = new Array();
            }
            this.documentList.push(document);
            return this;
        },

        build: function () {
            return new Enrollment(this.documentList, this.authorizationToken, this.nonce,
                this.isRootedDeviceAllowed, this.isSecuredWindowsDisabled, this.facialRecognitionSpecification,
                this.backgroundCheckConfiguration, this.lookupConfiguration, this.sessionId, this.userIdentifier, this.isReturnDataForIncompleteSession,
                this.appearanceMode,this.isAllowNonPhysicalDocuments,this.isDisableTamperingRejection);
        }
    }
}

function Enrollment(documentList, authorizationToken, nonce,
                    isRootedDeviceAllowed, isSecuredWindowsDisabled, facialRecognitionSpecification,
                    backgroundCheckConfiguration, lookupConfiguration, sessionId, userIdentifier, isReturnDataForIncompleteSession, appearanceMode,isAllowNonPhysicalDocuments,isDisableTamperingRejection) {
    this.documentList = documentList;
    this.authorizationToken = authorizationToken;
    this.nonce = nonce;
    this.isRootedDeviceAllowed = isRootedDeviceAllowed;
    this.isSecuredWindowsDisabled = isSecuredWindowsDisabled;
    this.facialRecognitionSpecification = facialRecognitionSpecification;
    this.backgroundCheckConfiguration = backgroundCheckConfiguration;
    this.lookupConfiguration = lookupConfiguration;
    this.sessionId = sessionId;
    this.userIdentifier = userIdentifier;
    this.isReturnDataForIncompleteSession = isReturnDataForIncompleteSession;
    this.appearanceMode = appearanceMode;
    this.isAllowNonPhysicalDocuments = isAllowNonPhysicalDocuments;
    this.isDisableTamperingRejection = isDisableTamperingRejection;
}

function FacialRecognitionConfigurationBuilder() {
    this.enrollFace = false;

    return {
        enrollFace: function () {
            this.enrollFace = true;
            return this;
        },

        setScanMinimumMatchLevel: function (scanMinimumMatchLevel) {
            this.scanMinimumMatchLevel = scanMinimumMatchLevel;
            return this;
        },

        setReadMinimumMatchLevel: function (readMinimumMatchLevel) {
            this.readMinimumMatchLevel = readMinimumMatchLevel;
            return this;
        },

        setLookupMinimumMatchLevel: function (lookupMinimumMatchLevel) {
            this.lookupMinimumMatchLevel = lookupMinimumMatchLevel;
            return this;
        },

        setMaxAttempts: function (maxAttempts) {
            this.maxAttempts = maxAttempts;
            return this;
        },

        allowClosedEyes: function () {
            this.isAllowClosedEyes = true;
            return this;
        },

        enableAuditTrailImageObfuscation: function (obfuscationType) {
            this.obfuscationType = obfuscationType;
            return this;
        },

        enableOneToNVerification: function () {
            this.isOneToNVerificationEnabled = true;
            return this;
        },

        enableActiveLiveness: function (gesture) {
            this.enableActiveLiveness = true;
            if (gesture) {
                this.disableLivenessGesture = gesture;
            }
            return this;
        },

        build: function () {
            return new FacialRecognitionConfiguration(this.enrollFace, this.scanMinimumMatchLevel, this.readMinimumMatchLevel,
                this.lookupMinimumMatchLevel, this.maxAttempts,this.isAllowClosedEyes,this.obfuscationType,this.isOneToNVerificationEnabled,
                this.enableActiveLiveness, this.disableLivenessGesture);
        }
    }
}


class FacialRecognitionConfiguration {
    constructor(enrollFace = false, scanMinimumMatchLevel, readMinimumMatchLevel, lookupMinimumMatchLevel, maxAttempts, isAllowClosedEyes,obfuscationType,isOneToNVerificationEnabled, enableActiveLiveness, disableLivenessGesture) {
        this.enrollFace = enrollFace;
        this.scanMinimumMatchLevel = scanMinimumMatchLevel;
        this.readMinimumMatchLevel = readMinimumMatchLevel;
        this.lookupMinimumMatchLevel = lookupMinimumMatchLevel;
        this.maxAttempts = maxAttempts;
        this.allowClosedEyes = isAllowClosedEyes;
        this.obfuscationType = obfuscationType;
        this.isOneToNVerificationEnabled = isOneToNVerificationEnabled;
        this.enableActiveLiveness = enableActiveLiveness;
        this.disableLivenessGesture = disableLivenessGesture;
    }

}

function BackgroundCheckConfigurationBuilder() {
    this.disableConsent = false;
    this.backgroundCheckType = BackgroundCheckType.RDC;
    this.monitoringEnabled = false;
    this.skipView = false;

    return {
        disableConsent: function () {
            this.disableConsent = true;
            return this;
        },

        setBackgroundCheckType: function (backgroundCheckType) {
            this.backgroundCheckType = backgroundCheckType;
            return this;
        },

        enableMonitoring: function () {
            this.monitoringEnabled = true;
            return this;
        },

        skipView: function () {
            this.skipView = true;
            return this;
        },


        build: function () {
            return new BackgroundCheckConfiguration(this.disableConsent, this.backgroundCheckType, this.monitoringEnabled, this.skipView);
        }
    }
}

class BackgroundCheckConfiguration {
    constructor(disableConsent = false, backgroundCheckType, monitoringEnabled = false, skipView) {
        this.disableConsent = disableConsent;
        this.backgroundCheckType = backgroundCheckType;
        this.monitoringEnabled = monitoringEnabled;
        this.skipView = skipView;

    }
}

function DocumentBuilder() {
    return {
        setDocumentType: function (documentType) {
            this.documentType = documentType;
            return this;
        },

        disableHelpPage: function () {
            this.isHelpPageDisabled = true;
            return this;
        },

        disableExpiryValidation: function () {
            this.isExpiredDocumentAllowed = true;
            return this;
        },

        enableReading: function () {
            if (arguments.length === 0) {
                this.readingConfiguration = new ReadingConfigurationBuilder().build();
            } else {
                this.readingConfiguration = arguments[0];
            }
            return this;
        },

        disableUserDataReview: function () {
            this.isUserDataReviewDisabled = true;
            return this;
        },

        setFaceScanMinimumMatchLevel: function (faceScanMinimumMatchLevel) {
            this.faceScanMinimumMatchLevel = faceScanMinimumMatchLevel;
            return this;
        },

        setFaceReadMinimumMatchLevel: function (faceReadMinimumMatchLevel) {
            this.faceReadMinimumMatchLevel = faceReadMinimumMatchLevel;
            return this;
        },

        enableScanReview: function (isFrontSideReviewEnabled, isBackSideReviewEnabled) {
            this.isBackSideReviewEnabled = isBackSideReviewEnabled;
            this.isFrontSideReviewEnabled = isFrontSideReviewEnabled;
            return this;
        },

        enableUpload: function () {
            this.isUploadEnabled = true;
            return this;
        },

        enablePhotoQualityDetection: function () {
            this.isPhotoQualityDetectionEnabled = true;
            return this;
        },

        enableAgeVerification: function (minAge) {
            this.minimumAge = minAge;
            return this;
        },

        build: function () {
            return new Document(this.documentType,
                this.readingConfiguration,
                this.isHelpPageDisabled,
                this.faceScanMinimumMatchLevel,
                this.faceReadMinimumMatchLevel,
                this.isExpiredDocumentAllowed,
                this.isUserDataReviewDisabled,
                this.isFrontSideReviewEnabled,
                this.isBackSideReviewEnabled,
                this.isUploadEnabled,
                this.isPhotoQualityDetectionEnabled,
                this.minimumAge);
        }
    };
}

function ReadingConfigurationBuilder() {
    this.forceReadingValue = false;
    this.forceReadingIfSupportedValue = false;
    this.timeoutInSeconds = -1;

    return {
        forceReading: function (value) {
            this.forceReadingValue = value;
            return this;
        },

        forceReadingIfSupported: function (value) {
            this.forceReadingIfSupportedValue = value;
            return this;
        },
        forceReadingTimeout: function (value) {
            this.timeoutInSecondsValue = value;
            return this;
        },

        build: function () {
            return new ReadingConfiguration(this.forceReadingValue, this.forceReadingIfSupportedValue, this.timeoutInSecondsValue);
        }
    }
}

class ReadingConfiguration {
    constructor(forceReading = false, forceReadingIfSupported = false, timeoutInSeconds) {
        this.forceReading = forceReading;
        this.forceReadingIfSupported = forceReadingIfSupported;
        this.timeoutInSeconds = timeoutInSeconds;

    }
}

function ReadingBuilder() {
    return {
        setToken: function (token) {
            this.authorizationToken = token;
            return this;
        },

        setSessionId: function (sessionId) {
            this.sessionId = sessionId;
            return this;
        },

        setUserIdentifier: function (userIdentifier) {
            this.userIdentifier = userIdentifier;
            return this;
        },

        setNonce: function (nonce) {
            this.nonce = nonce;
            return this;
        },

        setDocumentType: function (documentType) {
            this.documentType = documentType;
            return this;
        },

        setDocumentNumber: function (documentNumber) {
            this.documentNumber = documentNumber;
            return this;
        },

        setDateOfBirth: function (dateOfBirth) {
            this.dateOfBirth = dateOfBirth;
            return this;
        },

        setDateOfExpiry: function (dateOfExpiry) {
            this.dateOfExpiry = dateOfExpiry;
            return this;
        },

        setMrz: function (mrz) {
            this.mrz = mrz;
            return this;
        },

        returnDataForIncompleteSession: function () {
            this.isReturnDataForIncompleteSession = true;
            return this;
        },

        disableSecureWindow: function () {
            this.isSecuredWindowsDisabled = true;
            return this;
        },

        enableFacialRecognition: function () {
            if (arguments.length === 0) {
                this.facialRecognitionSpecification = new FacialRecognitionConfigurationBuilder().build();
            } else {
                this.facialRecognitionSpecification = arguments[0];
            }
            return this;
        },

        enableBackgroundCheck: function () {
            if (arguments.length === 0) {
                this.backgroundCheckConfiguration = new BackgroundCheckConfigurationBuilder().build();
            } else {
                this.backgroundCheckConfiguration = arguments[0];
            }
            return this;
        },

        enableLookup: function () {
            this.isLookupEnabled = true;
            return this;
        },

        setAppearanceMode: function (appearanceMode) {
            this.appearanceMode = appearanceMode;
            return this;
        },

        build: function () {
            return new Reading(this.authorizationToken, this.sessionId, this.userIdentifier, this.nonce,
                this.documentType, this.documentNumber, this.dateOfBirth, this.dateOfExpiry, this.mrz,
                this.isReturnDataForIncompleteSession, this.isSecuredWindowsDisabled,
                this.facialRecognitionSpecification, this.backgroundCheckConfiguration,
                this.isLookupEnabled, this.appearanceMode);
        }
    }
}

function Reading(authorizationToken, sessionId, userIdentifier, nonce, documentType,
                documentNumber, dateOfBirth, dateOfExpiry, mrz, isReturnDataForIncompleteSession,
                isSecuredWindowsDisabled, facialRecognitionSpecification, backgroundCheckConfiguration,
                isLookupEnabled, appearanceMode) {
    this.authorizationToken = authorizationToken;
    this.sessionId = sessionId;
    this.userIdentifier = userIdentifier;
    this.nonce = nonce;
    this.documentType = documentType;
    this.documentNumber = documentNumber;
    this.dateOfBirth = dateOfBirth;
    this.dateOfExpiry = dateOfExpiry;
    this.mrz = mrz;
    this.isReturnDataForIncompleteSession = isReturnDataForIncompleteSession;
    this.isSecuredWindowsDisabled = isSecuredWindowsDisabled;
    this.facialRecognitionSpecification = facialRecognitionSpecification;
    this.backgroundCheckConfiguration = backgroundCheckConfiguration;
    this.isLookupEnabled = isLookupEnabled;
    this.appearanceMode = appearanceMode;
}

function Document(documentType, readingConfiguration, isHelpPageDisabled,
                  faceScanMinimumMatchLevel, faceReadMinimumMatchLevel, isExpiredDocumentValidateDisabled,
                  isUserDataReviewDisabled, isFrontSideReviewEnabled, isBackSideReviewEnabled,
                  isUploadEnabled, isPhotoQualityDetectionEnabled, minimumAge) {
    this.documentType = documentType;
    this.readingConfiguration = readingConfiguration;
    this.isHelpPageDisabled = isHelpPageDisabled;
    this.faceScanMinimumMatchLevel = faceScanMinimumMatchLevel;
    this.faceReadMinimumMatchLevel = faceReadMinimumMatchLevel;
    this.isExpiredDocumentValidateDisabled = isExpiredDocumentValidateDisabled;
    this.isUserDataReviewDisabled = isUserDataReviewDisabled;
    this.isFrontSideReviewEnabled = isFrontSideReviewEnabled;
    this.isBackSideReviewEnabled = isBackSideReviewEnabled;
    this.isUploadEnabled = isUploadEnabled;
    this.isPhotoQualityDetectionEnabled = isPhotoQualityDetectionEnabled;
    this.minimumAge = minimumAge;

}

function AccountRecoveryBuilder() {}

function AccountRecoveryConfigurationBuilder() {
    return {
        /**
         * Pass the token received from Uqudo to authenticate the SDK
         */
        setToken: function (token) {
            this.token = token;
            return this;
        },

        /**
         * Pass the enrollment identifier for the account to be recovered
         */
        setEnrollmentIdentifier: function (identifier) {
            this.enrollmentIdentifier = identifier;
            return this;
        },

        /**
         * You can pass your custom nonce to provide security to the enrollment process
         */
        setNonce: function (nonce) {
            this.nonce = nonce;
            return this;
        },

        /**
         * Whether you want the sdk to run on the rooted devices or not. By default it is false
         */
        enableRootedDeviceUsage: function () {
            this.isRootedDeviceAllowed = true;
            return this;
        },

        /**
         * To allow user to capture/record screenshot or video of the screen on the device app is installed.
         * Default is screenshot and video recording of the screen is not allowed
         */
        disableSecureWindow: function () {
            this.isSecuredWindowsDisabled = true;
            return this;
        },

        /**
         * Set this to use the value passed for facialRecognition for Account Recovery
         */
        setMinimumMatchLevel: function (value) {
            this.minimumMatchLevel = value;
            return this;
        },

        /**
         * @returns Intent with the configuration and the token needed to authorize the activity to
         * recover the account
         */

        setMaxAttempts: function (maxAttempts) {
            this.maxAttempts = maxAttempts;
            return this;
        },

        allowClosedEyes: function () {
            this.isAllowClosedEyes = true;
            return this;
        },

        returnDataForIncompleteSession: function () {
            this.isReturnDataForIncompleteSession = true;
            return this;
        },

        setAppearanceMode: function (appearanceMode) {
            this.appearanceMode = appearanceMode;
            return this;
        },
        build: function () {
            return new AccountRecoveryConfiguration(this.token, this.enrollmentIdentifier, this.nonce, this.isRootedDeviceAllowed, this.isSecuredWindowsDisabled, this.minimumMatchLevel, this.maxAttempts, this.isReturnDataForIncompleteSession, this.appearanceMode,this.isAllowClosedEyes);
        }
    }
}

function AccountRecoveryConfiguration(token, enrollmentIdentifier, nonce, isRootedDeviceAllowed, isSecuredWindowsDisabled, minimumMatchLevel, maxAttempts, isReturnDataForIncompleteSession, appearanceMode,isAllowClosedEyes) {

    this.token = token;
    this.enrollmentIdentifier = enrollmentIdentifier;
    this.nonce = nonce;
    this.isRootedDeviceAllowed = isRootedDeviceAllowed;
    this.isSecuredWindowsDisabled = isSecuredWindowsDisabled;
    this.minimumMatchLevel = minimumMatchLevel;
    this.maxAttempts = maxAttempts;
    this.allowClosedEyes = isAllowClosedEyes;
    this.isReturnDataForIncompleteSession = isReturnDataForIncompleteSession;
    this.appearanceMode = appearanceMode;


}

function FaceSessionBuilder() {
}

function FaceSessionConfigurationBuilder() {

    return {
        setToken: function (token) {
            this.token = token;
            return this;
        },

        setSessionId: function (sessionId) {
            this.sessionId = sessionId;
            return this;
        },

        setNonce: function (nonce) {
            this.nonce = nonce;
            return this;
        },

        setUserIdentifier: function (userIdentifier) {
            this.userIdentifier = userIdentifier;
            return this;
        },

        enableRootedDeviceUsage: function () {
            this.isRootedDeviceAllowed = true;
            return this;
        },

        disableSecureWindow: function () {
            this.isSecuredWindowsDisabled = true;
            return this;
        },

        setMinimumMatchLevel: function (value) {
            this.minimumMatchLevel = value;
            return this;
        },

        setMaxAttempts: function (maxAttempts) {
            this.maxAttempts = maxAttempts;
            return this;
        },

        allowClosedEyes: function () {
            this.isAllowClosedEyes = true;
            return this;
        },

        returnDataForIncompleteSession: function () {
            this.isReturnDataForIncompleteSession = true;
            return this;
        },

        setAppearanceMode: function (appearanceMode) {
            this.appearanceMode = appearanceMode;
            return this;
        },

        enableAuditTrailImageObfuscation: function (obfuscationType) {
            this.obfuscationType = obfuscationType;
            return this;
        },

        enableActiveLiveness: function (gesture) {
            this.enableActiveLiveness = true;
            if (gesture) {
                this.disableLivenessGesture = gesture;
            }
            return this;
        },

        build: function () {
            return new FaceSessionConfiguration(this.token, this.sessionId, this.nonce, this.userIdentifier, this.isRootedDeviceAllowed, this.isSecuredWindowsDisabled, this.minimumMatchLevel, this.maxAttempts, this.isReturnDataForIncompleteSession, this.appearanceMode,this.isAllowClosedEyes,this.obfuscationType, this.enableActiveLiveness, this.disableLivenessGesture);
        }
    }
}

function FaceSessionConfiguration(token, sessionId, nonce, userIdentifier, isRootedDeviceAllowed, isSecuredWindowsDisabled, minimumMatchLevel, maxAttempts, isReturnDataForIncompleteSession, appearanceMode,isAllowClosedEyes,obfuscationType, enableActiveLiveness, disableLivenessGesture) {
    this.token = token;
    this.sessionId = sessionId;
    this.nonce = nonce;
    this.userIdentifier = userIdentifier;
    this.isRootedDeviceAllowed = isRootedDeviceAllowed;
    this.isSecuredWindowsDisabled = isSecuredWindowsDisabled;
    this.minimumMatchLevel = minimumMatchLevel;
    this.maxAttempts = maxAttempts;
    this.allowClosedEyes = isAllowClosedEyes;
    this.isReturnDataForIncompleteSession = isReturnDataForIncompleteSession;
    this.appearanceMode = appearanceMode;
    this.obfuscationType = obfuscationType;
    this.enableActiveLiveness = enableActiveLiveness;
    this.disableLivenessGesture = disableLivenessGesture;

}

function LookupBuilder() {
    return {
        setToken: function (token) {
            this.authorizationToken = token;
            return this;
        },

        setNonce: function (nonce) {
            this.nonce = nonce;
            return this;
        },

        setSessionId: function (sessionId) {
            this.sessionId = sessionId;
            return this;
        },

        setUserIdentifier: function (userIdentifier) {
            this.userIdentifier = userIdentifier;
            return this;
        },

        disableSecureWindow: function () {
            this.isSecuredWindowsDisabled = true;
            return this;
        },

        setAppearanceMode: function (appearanceMode) {
            this.appearanceMode = appearanceMode;
            return this;
        },

        enableFacialRecognition: function () {
            if (arguments.length === 0) {
                this.facialRecognitionSpecification = new FacialRecognitionConfigurationBuilder().build();
            } else {
                this.facialRecognitionSpecification = arguments[0];
            }
            return this;
        },

        enableBackgroundCheck: function () {
            if (arguments.length === 0) {
                this.backgroundCheckConfiguration = new BackgroundCheckConfigurationBuilder().build();
            } else {
                this.backgroundCheckConfiguration = arguments[0];
            }
            return this;
        },

        returnDataForIncompleteSession: function () {
            this.isReturnDataForIncompleteSession = true;
            return this;
        },

        setDocumentType: function (documentType) {
            this.documentType = documentType;
            return this;
        },

        build: function () {
            return new Lookup(this.documentType, this.authorizationToken, this.nonce, this.isSecuredWindowsDisabled, this.facialRecognitionSpecification,
                this.backgroundCheckConfiguration, this.sessionId, this.userIdentifier, this.isReturnDataForIncompleteSession, this.appearanceMode);
        }
    }
}

function Lookup(documentType, authorizationToken, nonce, isSecuredWindowsDisabled, facialRecognitionSpecification,
                backgroundCheckConfiguration, sessionId, userIdentifier, isReturnDataForIncompleteSession, appearanceMode) {
    this.documentType = documentType;
    this.authorizationToken = authorizationToken;
    this.nonce = nonce;
    this.isSecuredWindowsDisabled = isSecuredWindowsDisabled;
    this.facialRecognitionSpecification = facialRecognitionSpecification;
    this.backgroundCheckConfiguration = backgroundCheckConfiguration;
    this.sessionId = sessionId;
    this.userIdentifier = userIdentifier;
    this.isReturnDataForIncompleteSession = isReturnDataForIncompleteSession;
    this.appearanceMode = appearanceMode;
}

module.exports = new UqudoSDK();
