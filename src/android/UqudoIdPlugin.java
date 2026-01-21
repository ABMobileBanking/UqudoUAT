package io.uqudo.cordova.plugin;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.util.Log;


import androidx.activity.result.ActivityResult;
import androidx.appcompat.app.AppCompatDelegate;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.jetbrains.annotations.NotNull;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Locale;
import java.util.UUID;

import io.uqudo.sdk.core.DocumentBuilder;
import io.uqudo.sdk.core.SessionStatus;
import io.uqudo.sdk.core.SessionStatusCode;
import io.uqudo.sdk.core.UqudoBuilder;
import io.uqudo.sdk.core.UqudoSDK;
import io.uqudo.sdk.core.analytics.Trace;
import io.uqudo.sdk.core.analytics.Tracer;
import io.uqudo.sdk.core.builder.BackgroundCheckConfigurationBuilder;
import io.uqudo.sdk.core.builder.FacialRecognitionConfigurationBuilder;
import io.uqudo.sdk.core.builder.ReadingConfigurationBuilder;
import io.uqudo.sdk.core.domain.model.BackgroundCheckType;
import io.uqudo.sdk.core.domain.model.Document;
import io.uqudo.sdk.core.domain.model.DocumentType;
import io.uqudo.sdk.core.domain.model.ObfuscationType;
import io.uqudo.sdk.core.domain.model.LivenessGesture;

import java.text.SimpleDateFormat;
import java.util.TimeZone;

/**
 * This class echoes a string called from JavaScript.
 */
public class UqudoIdPlugin extends CordovaPlugin {

    private CallbackContext callback = null;
    private CallbackContext traceCallback = null;
    private static final int REQUEST_CODE_ENROLLMENT = 1001;
    private static final int REQUEST_CODE_ACCOUNT_RECOVERY = 1002;
    private static final int REQUEST_CODE_FACE_SESSION = 1003;
    public static final int REQUEST_CODE_LOOKUP = 1004;
    public static final int REQUEST_CODE_READING = 1005;

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        Context context = this.cordova.getActivity().getApplicationContext();
        switch (action) {
            case "init":
                traceCallback = callbackContext;
                initSDK(context);
                return true;
            case "setLocale":
                setLocale(args.getString(0), context);
            case "enroll": {
                callback = callbackContext;
                String message = args.getString(0);
                this.enroll(message, context);
                return true;
            }
            case "recover": {
                callback = callbackContext;
                String message = args.getString(0);
                this.recover(message, context);
                return true;
            }
            case "faceSession": {
                callback = callbackContext;
                String message = args.getString(0);
                this.faceSession(message, context);
                return true;
            }
            case "reading": {
                callback = callbackContext;
                String message = args.getString(0);
                this.reading(message, context);
                return true;
            }
            case "isFacialRecognitionSupported": {
                callback = callbackContext;
                String message = args.getString(0);
                this.isFacialRecognitionSupported(message, context);
                return true;
            }
            case "isReadingSupported": {
                callback = callbackContext;
                String message = args.getString(0);
                this.isReadingSupported(message, context);
                return true;
            }
            case "isLookupSupported": {
                callback = callbackContext;
                String message = args.getString(0);
                this.isLookupSupported(message, context);
                return true;
            }
            case "isLookupFacialRecognitionSupported": {
                callback = callbackContext;
                String message = args.getString(0);
                this.isLookupFacialRecognitionSupported(message, context);
                return true;
            }
            case "isEnrollmentSupported": {
                callback = callbackContext;
                String message = args.getString(0);
                this.isEnrollmentSupported(message, context);
                return true;
            }
            case "lookup": {
                callback = callbackContext;
                String message = args.getString(0);
                this.lookup(message, context);
                return true;
            }
        }
        return false;
    }

    private void initSDK(Context context) {
        UqudoSDK.init(context, new TraceObject());
    }

    private class TraceObject implements Tracer {
        @Override
        public void trace(@NotNull Trace trace) {
            try {
                JSONObject json = new JSONObject();
                json.put("category", trace.getCategory());
                json.put("sessionId", trace.getSessionId());
                json.put("event", trace.getEvent());
                json.put("page", trace.getPage());
                json.put("statusCode", trace.getStatusCode());
                json.put("status", trace.getStatus());
                json.put("statusMessage", trace.getStatusMessage());
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
                dateFormat.setTimeZone(TimeZone.getTimeZone("UTC"));
                json.put("timestamp", dateFormat.format(trace.getTimestamp()));
                json.put("documentType", trace.getDocumentType());
                String data = json.toString();
                PluginResult result = new PluginResult(PluginResult.Status.OK, data);
                result.setKeepCallback(true);
                traceCallback.sendPluginResult(result);
            } catch (Exception e) {
                Log.e("UqudoIdPlugin", e.getMessage(), e);
            }
        }
    }

    private void setLocale(String locale, Context context) {
        System.out.println("----locale" + locale);
        try {
            if (locale != null) {
                Locale myLocale = new Locale(locale);
                Resources res = context.getResources();
                Configuration conf = res.getConfiguration();
                conf.locale = myLocale;
                res.updateConfiguration(conf, res.getDisplayMetrics());
            }
        } catch (Exception e) {
            Log.e("UqudoPlugin", e.getMessage(), e);
        }
    }

    private void enroll(String message, Context context) {
        if (message != null && message.length() > 0) {
            try {
                JSONObject json = new JSONObject(message);
                UqudoBuilder.Enrollment enrollment = new UqudoBuilder.Enrollment();
                if (json.has("isSecuredWindowsDisabled") && json.getBoolean("isSecuredWindowsDisabled")) {
                    enrollment.disableSecureWindow();
                }
                if (json.has("isRootedDeviceAllowed") && json.getBoolean("isRootedDeviceAllowed")) {
                    enrollment.enableRootedDeviceUsage();
                }
                if (json.has("nonce")) {
                    enrollment.setNonce(json.getString("nonce"));
                }
                if (json.has("sessionId")) {
                    enrollment.setSessionId(json.getString("sessionId"));
                }
                if (json.has("userIdentifier")) {
                    enrollment.setUserIdentifier(UUID.fromString(json.getString("userIdentifier")));
                }
                if (json.has("isReturnDataForIncompleteSession") && json.getBoolean("isReturnDataForIncompleteSession")) {
                    enrollment.returnDataForIncompleteSession();
                }
                if (json.has("isAllowNonPhysicalDocuments") && json.getBoolean("isAllowNonPhysicalDocuments")) {
                    enrollment.allowNonPhysicalDocuments();
                }
                if (json.has("isDisableTamperingRejection") && json.getBoolean("isDisableTamperingRejection")) {
                    enrollment.disableTamperingRejection();
                }
                if (json.has("facialRecognitionSpecification")) {
                    FacialRecognitionConfigurationBuilder faceBuilder = new FacialRecognitionConfigurationBuilder();
                    JSONObject faceObject = json.getJSONObject("facialRecognitionSpecification");
                    if (faceObject.has("enrollFace") && faceObject.getBoolean("enrollFace")) {
                        faceBuilder.enrollFace();
                    }
                    if (faceObject.has("scanMinimumMatchLevel") && faceObject.getInt("scanMinimumMatchLevel") > 0) {
                        faceBuilder.setScanMinimumMatchLevel(faceObject.getInt("scanMinimumMatchLevel"));
                    }
                    if (faceObject.has("readMinimumMatchLevel") && faceObject.getInt("readMinimumMatchLevel") > 0) {
                        faceBuilder.setReadMinimumMatchLevel(faceObject.getInt("readMinimumMatchLevel"));
                    }
                    if (faceObject.has("maxAttempts") && faceObject.getInt("maxAttempts") > 0) {
                        faceBuilder.setMaxAttempts(faceObject.getInt("maxAttempts"));
                    }
                    if (faceObject.has("allowClosedEyes") && faceObject.getBoolean("allowClosedEyes")) {
                        faceBuilder.allowClosedEyes();
                    }
                    if (faceObject.has("obfuscationType")){
                        if (faceObject.getString("obfuscationType").equals("FILLED")){
                            faceBuilder.enableAuditTrailImageObfuscation(ObfuscationType.FILLED);
                        } else if (faceObject.getString("obfuscationType").equals("BLURRED")){
                            faceBuilder.enableAuditTrailImageObfuscation(ObfuscationType.BLURRED);
                        } else if (faceObject.getString("obfuscationType").equals("FILLED_WHITE")){
                            faceBuilder.enableAuditTrailImageObfuscation(ObfuscationType.FILLED_WHITE);
                        }
                    }

                    if (faceObject.has("isOneToNVerificationEnabled") && faceObject.getBoolean("isOneToNVerificationEnabled")) {
                        faceBuilder.enableOneToNVerification();
                    }
                    
                    if (faceObject.has("enableActiveLiveness") && faceObject.getBoolean("enableActiveLiveness")) {
                        LivenessGesture disableGesture = null;
                        if (faceObject.has("disableLivenessGesture")) {
                            String gesture = faceObject.getString("disableLivenessGesture");
                            switch (gesture) {
                                case "FACE_MOVE":
                                    disableGesture = LivenessGesture.FACE_MOVE;
                                    break;
                                case "FACE_TILT":
                                    disableGesture = LivenessGesture.FACE_TILT;
                                    break;
                                case "FACE_TURN":
                                    disableGesture = LivenessGesture.FACE_TURN;
                                    break;
                            }
                        }
                        faceBuilder.enableActiveLiveness(disableGesture);
                    }
                    enrollment.enableFacialRecognition(faceBuilder.build());
                }

                if (json.has("lookupConfiguration")) {
                    JSONObject lookupObject = json.getJSONObject("lookupConfiguration");
                    if (lookupObject.has("documentList")) {
                        JSONArray lookupDocuments = lookupObject.getJSONArray("documentList");
                        if (lookupDocuments.length() > 0) {
                            DocumentType[] documents = new DocumentType[lookupDocuments.length()];
                            for (int i = 0; i < lookupDocuments.length(); i++) {
                                String parsedDocument = lookupDocuments.getString(i);
                                documents[i] = DocumentType.valueOf(parsedDocument);
                            }
                            enrollment.enableLookup(documents);
                        } else {
                            enrollment.enableLookup();
                        }
                    } else {
                        enrollment.enableLookup();
                    }
                }

                if (json.has("backgroundCheckConfiguration")) {
                    BackgroundCheckConfigurationBuilder backgroundCheckConfigurationBuilder = new BackgroundCheckConfigurationBuilder();
                    JSONObject backgroundObject = json.getJSONObject("backgroundCheckConfiguration");
                    if (backgroundObject.has("disableConsent") && backgroundObject.getBoolean("disableConsent")) {
                        backgroundCheckConfigurationBuilder.disableConsent();
                    }
                    if (backgroundObject.has("backgroundCheckType")) {
                        backgroundCheckConfigurationBuilder.setBackgroundCheckType(BackgroundCheckType.valueOf(backgroundObject.getString("backgroundCheckType")));
                    }
                    if (backgroundObject.has("monitoringEnabled") && backgroundObject.getBoolean("monitoringEnabled")) {
                        backgroundCheckConfigurationBuilder.enableMonitoring();
                    }
                    if (backgroundObject.has("skipView") && backgroundObject.getBoolean("skipView")) {
                        backgroundCheckConfigurationBuilder.skipView();
                    }
                    enrollment.enableBackgroundCheck(backgroundCheckConfigurationBuilder.build());
                }
                enrollment.setToken(json.getString("authorizationToken"));
                JSONArray documentList = json.getJSONArray("documentList");
                for (int i = 0; i < documentList.length(); i++) {
                    JSONObject documentJson = documentList.getJSONObject(i);
                    DocumentBuilder documentBuilder = new DocumentBuilder(context);
                    documentBuilder.setDocumentType(DocumentType.valueOf(documentJson.getString("documentType")));
                    if (documentJson.has("isHelpPageDisabled") && documentJson.getBoolean("isHelpPageDisabled")) {
                        documentBuilder.disableHelpPage();
                    }
                    if (documentJson.has("isExpiredDocumentValidateDisabled") && documentJson.getBoolean("isExpiredDocumentValidateDisabled")) {
                        documentBuilder.disableExpiryValidation();
                    }
                    if (documentJson.has("isFrontSideReviewEnabled") || documentJson.has("isBackSideReviewEnabled")) {
                        documentBuilder.enableScanReview(documentJson.optBoolean("isFrontSideReviewEnabled", false), documentJson.optBoolean("isBackSideReviewEnabled", false));
                    }
                    if (documentJson.has("isUploadEnabled") && documentJson.getBoolean("isUploadEnabled")) {
                        documentBuilder.enableUpload();
                    }
                    if (documentJson.has("minimumAge") && documentJson.getInt("minimumAge") > 0) {
                        documentBuilder.enableAgeVerification(documentJson.getInt("minimumAge"));
                    }

                    if (documentJson.has("readingConfiguration")) {
                        JSONObject readConfiguration = documentJson.getJSONObject("readingConfiguration");
                        if (readConfiguration.has("forceReading")) {
                            ReadingConfigurationBuilder readingConfigurationBuilder = new ReadingConfigurationBuilder();
                            if (readConfiguration.has("forceReading")) {
                                readingConfigurationBuilder.forceReading(readConfiguration.getBoolean("forceReading"));
                            }
                            if (readConfiguration.has("forceReadingIfSupported")) {
                                readingConfigurationBuilder.forceReadingIfSupported(readConfiguration.getBoolean("forceReadingIfSupported"));
                            }

                            if (readConfiguration.has("timeoutInSeconds")) {
                                readingConfigurationBuilder.forceReadingTimeout(readConfiguration.getInt("timeoutInSeconds"));
                            }


                            documentBuilder.enableReading(readingConfigurationBuilder.build());
                        } else {
                            documentBuilder.enableReading();
                        }
                    }
                    if (documentJson.has("faceScanMinimumMatchLevel") && documentJson.getInt("faceScanMinimumMatchLevel") > 0) {
                        documentBuilder.setFaceScanMinimumMatchLevel(documentJson.getInt("faceScanMinimumMatchLevel"));
                    }
                    if (documentJson.has("faceReadMinimumMatchLevel") && documentJson.getInt("faceReadMinimumMatchLevel") > 0) {
                        documentBuilder.setFaceReadMinimumMatchLevel(documentJson.getInt("faceReadMinimumMatchLevel"));
                    }


                    Document document = documentBuilder.build();
                    enrollment.add(document);
                }
                if (json.has("appearanceMode")) {
                    if ("LIGHT".equals(json.getString("appearanceMode"))) {
                        AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_NO);
                    } else if ("DARK".equals(json.getString("appearanceMode"))) {
                        AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_YES);
                    } else if ("SYSTEM".equals(json.getString("appearanceMode"))) {
                        AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_FOLLOW_SYSTEM);
                    }
                } else {
                    AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_FOLLOW_SYSTEM);
                }
                Intent intent = enrollment.build(context);
                cordova.setActivityResultCallback(this);
                cordova.startActivityForResult(this, intent, REQUEST_CODE_ENROLLMENT);
            } catch (Exception e) {
                Log.d("UqudoPlugin", e.getMessage(), e);
                sendError(SessionStatusCode.UNEXPECTED_ERROR.name(), e.getMessage(), null);
            }
        } else {
            sendError(SessionStatusCode.UNEXPECTED_ERROR.name(), "Expected enrollment object as argument.", null);
        }
    }

    private void recover(String message, Context context) {
        if (message != null && message.length() > 0) {
            try {
                JSONObject json = new JSONObject(message);
                UqudoBuilder.AccountRecovery recovery = new UqudoBuilder.AccountRecovery();
                recovery.setToken(json.getString("token"));
                recovery.setEnrollmentIdentifier(json.getString("enrollmentIdentifier"));
                if (json.has("nonce")) {
                    recovery.setNonce(json.getString("nonce"));
                }
                if (json.has("isRootedDeviceAllowed")) {
                    recovery.enableRootedDeviceUsage();
                }
                if (json.has("isSecuredWindowsDisabled")) {
                    recovery.disableSecureWindow();
                }
                if (json.has("minimumMatchLevel") && json.getInt("minimumMatchLevel") > 0) {
                    recovery.setMinimumMatchLevel(json.getInt("minimumMatchLevel"));
                }
                if (json.has("maxAttempts") && json.getInt("maxAttempts") > 0) {
                    recovery.setMaxAttempts(json.getInt("maxAttempts"));
                }
                if (json.has("allowClosedEyes") && json.getBoolean("allowClosedEyes")) {
                    recovery.allowClosedEyes();
                 }

                if (json.has("isReturnDataForIncompleteSession") && json.getBoolean("isReturnDataForIncompleteSession")) {
                    recovery.returnDataForIncompleteSession();
                }
                if (json.has("appearanceMode")) {
                    if ("LIGHT".equals(json.getString("appearanceMode"))) {
                        AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_NO);
                    } else if ("DARK".equals(json.getString("appearanceMode"))) {
                        AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_YES);
                    } else if ("SYSTEM".equals(json.getString("appearanceMode"))) {
                        AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_FOLLOW_SYSTEM);
                    }
                } else {
                    AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_FOLLOW_SYSTEM);
                }
                Intent intent = recovery.build(context);
                cordova.setActivityResultCallback(this);
                cordova.startActivityForResult(this, intent, REQUEST_CODE_ACCOUNT_RECOVERY);
            } catch (Exception e) {
                Log.d("UqudoPlugin", e.getMessage(), e);
                sendError(SessionStatusCode.UNEXPECTED_ERROR.name(), e.getMessage(), null);
            }
        } else {
            sendError(SessionStatusCode.UNEXPECTED_ERROR.name(), "Expected account recovery object as argument.", null);
        }
    }

    private void faceSession(String message, Context context) {
        if (message != null && message.length() > 0) {
            try {
                JSONObject json = new JSONObject(message);
                UqudoBuilder.FaceSession faceSessionBuilder = new UqudoBuilder.FaceSession();
                faceSessionBuilder.setToken(json.getString("token"));
                faceSessionBuilder.setSessionId(json.getString("sessionId"));
                if (json.has("nonce")) {
                    faceSessionBuilder.setNonce(json.getString("nonce"));
                }
                if (json.has("userIdentifier")) {
                    faceSessionBuilder.setUserIdentifier(UUID.fromString(json.getString("userIdentifier")));
                }
                if (json.has("isRootedDeviceAllowed")) {
                    faceSessionBuilder.enableRootedDeviceUsage();
                }
                if (json.has("isSecuredWindowsDisabled")) {
                    faceSessionBuilder.disableSecureWindow();
                }
                if (json.has("minimumMatchLevel") && json.getInt("minimumMatchLevel") > 0) {
                    faceSessionBuilder.setMinimumMatchLevel(json.getInt("minimumMatchLevel"));
                }
                if (json.has("maxAttempts") && json.getInt("maxAttempts") > 0) {
                    faceSessionBuilder.setMaxAttempts(json.getInt("maxAttempts"));
                }
                if (json.has("allowClosedEyes") && json.getBoolean("allowClosedEyes")) {
                    faceSessionBuilder.allowClosedEyes();
                 }
                if (json.has("isReturnDataForIncompleteSession") && json.getBoolean("isReturnDataForIncompleteSession")) {
                    faceSessionBuilder.returnDataForIncompleteSession();
                }
                if (json.has("obfuscationType")){
                    if (json.getString("obfuscationType").equals("FILLED")){
                        faceSessionBuilder.enableAuditTrailImageObfuscation(ObfuscationType.FILLED);
                    } else if (json.getString("obfuscationType").equals("BLURRED")){
                        faceSessionBuilder.enableAuditTrailImageObfuscation(ObfuscationType.BLURRED);
                    } else if (json.getString("obfuscationType").equals("FILLED_WHITE")){
                        faceSessionBuilder.enableAuditTrailImageObfuscation(ObfuscationType.FILLED_WHITE);
                    }
                }
                if (json.has("enableActiveLiveness") && json.getBoolean("enableActiveLiveness")) {
                    if (json.has("disableLivenessGesture")) {
                        LivenessGesture gesture = LivenessGesture.valueOf(json.getString("disableLivenessGesture"));
                        faceSessionBuilder.enableActiveLiveness(gesture);
                    } else {
                        faceSessionBuilder.enableActiveLiveness(null);
                    }
                }

                if (json.has("appearanceMode")) {
                    if ("LIGHT".equals(json.getString("appearanceMode"))) {
                        AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_NO);
                    } else if ("DARK".equals(json.getString("appearanceMode"))) {
                        AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_YES);
                    } else if ("SYSTEM".equals(json.getString("appearanceMode"))) {
                        AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_FOLLOW_SYSTEM);
                    }
                } else {
                    AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_FOLLOW_SYSTEM);
                }

                Intent intent = faceSessionBuilder.build(context);
                cordova.setActivityResultCallback(this);
                cordova.startActivityForResult(this, intent, REQUEST_CODE_FACE_SESSION);
            } catch (Exception e) {
                Log.d("UqudoPlugin", e.getMessage(), e);
                sendError(SessionStatusCode.UNEXPECTED_ERROR.name(), e.getMessage(), null);
            }

        } else {
            sendError(SessionStatusCode.UNEXPECTED_ERROR.name(), "Expected account recovery object as argument.", null);
        }
    }

    private void lookup(String message, Context context) {
        if (message != null && message.length() > 0) {
            try {
                JSONObject json = new JSONObject(message);
                UqudoBuilder.Lookup lookup = new UqudoBuilder.Lookup();
                if (json.has("isSecuredWindowsDisabled") && json.getBoolean("isSecuredWindowsDisabled")) {
                    lookup.disableSecureWindow();
                }
                if (json.has("nonce")) {
                    lookup.setNonce(json.getString("nonce"));
                }
                if (json.has("sessionId")) {
                    lookup.setSessionId(json.getString("sessionId"));
                }
                if (json.has("userIdentifier")) {
                    lookup.setUserIdentifier(UUID.fromString(json.getString("userIdentifier")));
                }
                if (json.has("isReturnDataForIncompleteSession") && json.getBoolean("isReturnDataForIncompleteSession")) {
                    lookup.returnDataForIncompleteSession();
                }
                if (json.has("facialRecognitionSpecification")) {
                    FacialRecognitionConfigurationBuilder faceBuilder = new FacialRecognitionConfigurationBuilder();
                    JSONObject faceObject = json.getJSONObject("facialRecognitionSpecification");
                    if (faceObject.has("enrollFace") && faceObject.getBoolean("enrollFace")) {
                        faceBuilder.enrollFace();
                    }
                    if (faceObject.has("lookupMinimumMatchLevel") && faceObject.getInt("lookupMinimumMatchLevel") > 0) {
                        faceBuilder.setLookupMinimumMatchLevel(faceObject.getInt("lookupMinimumMatchLevel"));
                    }
                    if (faceObject.has("maxAttempts") && faceObject.getInt("maxAttempts") > 0) {
                        faceBuilder.setMaxAttempts(faceObject.getInt("maxAttempts"));
                    }
                    if (faceObject.has("allowClosedEyes") && faceObject.getBoolean("allowClosedEyes")) {
                        faceBuilder.allowClosedEyes();
                    }
                    if (faceObject.has("obfuscationType")){
                        if (faceObject.getString("obfuscationType").equals("FILLED")){
                            faceBuilder.enableAuditTrailImageObfuscation(ObfuscationType.FILLED);
                        } else if (faceObject.getString("obfuscationType").equals("BLURRED")){
                            faceBuilder.enableAuditTrailImageObfuscation(ObfuscationType.BLURRED);
                        } else if (faceObject.getString("obfuscationType").equals("FILLED_WHITE")){
                            faceBuilder.enableAuditTrailImageObfuscation(ObfuscationType.FILLED_WHITE);
                        }
                    }
                    if (faceObject.has("isOneToNVerificationEnabled") && faceObject.getBoolean("isOneToNVerificationEnabled")) {
                        faceBuilder.enableOneToNVerification();
                    }
                    
                    if (faceObject.has("enableActiveLiveness") && faceObject.getBoolean("enableActiveLiveness")) {
                        LivenessGesture disableGesture = null;
                        if (faceObject.has("disableLivenessGesture")) {
                            String gesture = faceObject.getString("disableLivenessGesture");
                            switch (gesture) {
                                case "FACE_MOVE":
                                    disableGesture = LivenessGesture.FACE_MOVE;
                                    break;
                                case "FACE_TILT":
                                    disableGesture = LivenessGesture.FACE_TILT;
                                    break;
                                case "FACE_TURN":
                                    disableGesture = LivenessGesture.FACE_TURN;
                                    break;
                            }
                        }
                        faceBuilder.enableActiveLiveness(disableGesture);
                    }

                    lookup.enableFacialRecognition(faceBuilder.build());
                }
                if (json.has("backgroundCheckConfiguration")) {
                    BackgroundCheckConfigurationBuilder backgroundCheckConfigurationBuilder = new BackgroundCheckConfigurationBuilder();
                    JSONObject backgroundObject = json.getJSONObject("backgroundCheckConfiguration");
                    if (backgroundObject.has("disableConsent") && backgroundObject.getBoolean("disableConsent")) {
                        backgroundCheckConfigurationBuilder.disableConsent();
                    }
                    if (backgroundObject.has("backgroundCheckType")) {
                        backgroundCheckConfigurationBuilder.setBackgroundCheckType(BackgroundCheckType.valueOf(backgroundObject.getString("backgroundCheckType")));
                    }
                    if (backgroundObject.has("monitoringEnabled") && backgroundObject.getBoolean("monitoringEnabled")) {
                        backgroundCheckConfigurationBuilder.enableMonitoring();
                    }
                    if (backgroundObject.has("skipView") && backgroundObject.getBoolean("skipView")) {
                        backgroundCheckConfigurationBuilder.skipView();
                    }
                    lookup.enableBackgroundCheck(backgroundCheckConfigurationBuilder.build());
                }
                lookup.setToken(json.getString("authorizationToken"));
                lookup.setDocumentType(DocumentType.valueOf(json.getString("documentType")));
                if (json.has("appearanceMode")) {
                    if ("LIGHT".equals(json.getString("appearanceMode"))) {
                        AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_NO);
                    } else if ("DARK".equals(json.getString("appearanceMode"))) {
                        AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_YES);
                    } else if ("SYSTEM".equals(json.getString("appearanceMode"))) {
                        AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_FOLLOW_SYSTEM);
                    }
                } else {
                    AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_FOLLOW_SYSTEM);
                }
                Intent intent = lookup.build(context);
                cordova.setActivityResultCallback(this);
                cordova.startActivityForResult(this, intent, REQUEST_CODE_LOOKUP);
            } catch (Exception e) {
                Log.d("UqudoPlugin", e.getMessage(), e);
                sendError(SessionStatusCode.UNEXPECTED_ERROR.name(), e.getMessage(), null);
            }
        } else {
            sendError(SessionStatusCode.UNEXPECTED_ERROR.name(), "Expected lookup object as argument.", null);
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (requestCode == REQUEST_CODE_ENROLLMENT || requestCode == REQUEST_CODE_ACCOUNT_RECOVERY
                || requestCode == REQUEST_CODE_FACE_SESSION || requestCode == REQUEST_CODE_LOOKUP) {
            if (resultCode == Activity.RESULT_OK) {
                PluginResult result = new PluginResult(PluginResult.Status.OK, data.getStringExtra("data"));
                result.setKeepCallback(true);
                callback.sendPluginResult(result);
            } else if (resultCode == Activity.RESULT_CANCELED) {
                if (data != null) {
                    //Something wrong happened while using the SDK
                    SessionStatus sessionStatus = data.getParcelableExtra("key_session_status");
                    assert sessionStatus != null;
                    sendError(sessionStatus.getSessionStatusCode().name(), sessionStatus.getSessionStatusCode().getMessage(), sessionStatus.getSessionTask().name(), sessionStatus.getData());
                }
            }
        }
    }

    private void reading(String message, Context context) {
        if (message != null && message.length() > 0) {
            try {
                JSONObject json = new JSONObject(message);
                UqudoBuilder.Reading readingBuilder = new UqudoBuilder.Reading();
                
                if (json.has("authorizationToken")) {
                    readingBuilder.setToken(json.getString("authorizationToken"));
                }
                
                if (json.has("sessionId")) {
                    readingBuilder.setSessionId(json.getString("sessionId"));
                }
                
                if (json.has("userIdentifier")) {
                    readingBuilder.setUserIdentifier(UUID.fromString(json.getString("userIdentifier")));
                }
                
                if (json.has("nonce")) {
                    readingBuilder.setNonce(json.getString("nonce"));
                }
                
                if (json.has("documentType")) {
                    readingBuilder.setDocumentType(DocumentType.valueOf(json.getString("documentType")));
                }
                
                if (json.has("documentNumber")) {
                    readingBuilder.setDocumentNumber(json.getString("documentNumber"));
                }
                
                if (json.has("dateOfBirth")) {
                    readingBuilder.setDateOfBirth(json.getString("dateOfBirth"));
                }
                
                if (json.has("dateOfExpiry")) {
                    readingBuilder.setDateOfExpiry(json.getString("dateOfExpiry"));
                }
                
                if (json.has("mrz")) {
                    readingBuilder.setMRZ(json.getString("mrz"));
                }
                
                if (json.has("isReturnDataForIncompleteSession") && json.getBoolean("isReturnDataForIncompleteSession")) {
                    readingBuilder.returnDataForIncompleteSession();
                }
                
                if (json.has("isSecuredWindowsDisabled") && json.getBoolean("isSecuredWindowsDisabled")) {
                    readingBuilder.disableSecureWindow();
                }
                
                if (json.has("facialRecognitionSpecification")) {
                    FacialRecognitionConfigurationBuilder faceBuilder = new FacialRecognitionConfigurationBuilder();
                    JSONObject faceObject = json.getJSONObject("facialRecognitionSpecification");
                    if (faceObject.has("enrollFace") && faceObject.getBoolean("enrollFace")) {
                        faceBuilder.enrollFace();
                    }
                    if (faceObject.has("scanMinimumMatchLevel") && faceObject.getInt("scanMinimumMatchLevel") > 0) {
                        faceBuilder.setScanMinimumMatchLevel(faceObject.getInt("scanMinimumMatchLevel"));
                    }
                    if (faceObject.has("readMinimumMatchLevel") && faceObject.getInt("readMinimumMatchLevel") > 0) {
                        faceBuilder.setReadMinimumMatchLevel(faceObject.getInt("readMinimumMatchLevel"));
                    }
                    if (faceObject.has("lookupMinimumMatchLevel") && faceObject.getInt("lookupMinimumMatchLevel") > 0) {
                        faceBuilder.setLookupMinimumMatchLevel(faceObject.getInt("lookupMinimumMatchLevel"));
                    }
                    if (faceObject.has("maxAttempts") && faceObject.getInt("maxAttempts") > 0) {
                        faceBuilder.setMaxAttempts(faceObject.getInt("maxAttempts"));
                    }
                    if (faceObject.has("allowClosedEyes") && faceObject.getBoolean("allowClosedEyes")) {
                        faceBuilder.allowClosedEyes();
                    }
                    if (faceObject.has("obfuscationType")){
                        if (faceObject.getString("obfuscationType").equals("FILLED")){
                            faceBuilder.enableAuditTrailImageObfuscation(ObfuscationType.FILLED);
                        } else if (faceObject.getString("obfuscationType").equals("BLURRED")){
                            faceBuilder.enableAuditTrailImageObfuscation(ObfuscationType.BLURRED);
                        } else if (faceObject.getString("obfuscationType").equals("FILLED_WHITE")){
                            faceBuilder.enableAuditTrailImageObfuscation(ObfuscationType.FILLED_WHITE);
                        }
                    }

                    if (faceObject.has("isOneToNVerificationEnabled") && faceObject.getBoolean("isOneToNVerificationEnabled")) {
                        faceBuilder.enableOneToNVerification();
                    }
                    
                    if (faceObject.has("enableActiveLiveness") && faceObject.getBoolean("enableActiveLiveness")) {
                        LivenessGesture disableGesture = null;
                        if (faceObject.has("disableLivenessGesture")) {
                            String gesture = faceObject.getString("disableLivenessGesture");
                            switch (gesture) {
                                case "FACE_MOVE":
                                    disableGesture = LivenessGesture.FACE_MOVE;
                                    break;
                                case "FACE_TILT":
                                    disableGesture = LivenessGesture.FACE_TILT;
                                    break;
                                case "FACE_TURN":
                                    disableGesture = LivenessGesture.FACE_TURN;
                                    break;
                            }
                        }
                        faceBuilder.enableActiveLiveness(disableGesture);
                    }

                    readingBuilder.enableFacialRecognition(faceBuilder.build());
                }
                
                if (json.has("backgroundCheckConfiguration")) {
                    BackgroundCheckConfigurationBuilder backgroundCheckConfigurationBuilder = new BackgroundCheckConfigurationBuilder();
                    JSONObject backgroundObject = json.getJSONObject("backgroundCheckConfiguration");
                    if (backgroundObject.has("disableConsent") && backgroundObject.getBoolean("disableConsent")) {
                        backgroundCheckConfigurationBuilder.disableConsent();
                    }
                    if (backgroundObject.has("backgroundCheckType")) {
                        backgroundCheckConfigurationBuilder.setBackgroundCheckType(BackgroundCheckType.valueOf(backgroundObject.getString("backgroundCheckType")));
                    }
                    if (backgroundObject.has("monitoringEnabled") && backgroundObject.getBoolean("monitoringEnabled")) {
                        backgroundCheckConfigurationBuilder.enableMonitoring();
                    }
                    if (backgroundObject.has("skipView") && backgroundObject.getBoolean("skipView")) {
                        backgroundCheckConfigurationBuilder.skipView();
                    }
                    readingBuilder.enableBackgroundCheck(backgroundCheckConfigurationBuilder.build());
                }
                
                if (json.has("isLookupEnabled") && json.getBoolean("isLookupEnabled")) {
                    readingBuilder.enableLookup();
                }
                
                if (json.has("appearanceMode")) {
                    if ("LIGHT".equals(json.getString("appearanceMode"))) {
                        AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_NO);
                    } else if ("DARK".equals(json.getString("appearanceMode"))) {
                        AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_YES);
                    } else if ("SYSTEM".equals(json.getString("appearanceMode"))) {
                        AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_FOLLOW_SYSTEM);
                    }
                } else {
                    AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_FOLLOW_SYSTEM);
                }
                
                Intent intent = readingBuilder.build(context);
                cordova.setActivityResultCallback(this);
                cordova.startActivityForResult(this, intent, REQUEST_CODE_READING);
            } catch (Exception e) {
                Log.e("UqudoIdPlugin", e.getMessage(), e);
                sendError(SessionStatusCode.UNEXPECTED_ERROR.name(), e.getMessage(), null);
            }
        } else {
            sendError(SessionStatusCode.UNEXPECTED_ERROR.name(), "Expected reading object as argument.", null);
        }
    }

    public void isReadingSupported(String documentType, Context context) {
        try {
            PluginResult result = new PluginResult(PluginResult.Status.OK, (DocumentType.valueOf(documentType).getReadingSupported()));
            result.setKeepCallback(true);
            callback.sendPluginResult(result);
        } catch (Exception e) {
            sendError(SessionStatusCode.UNEXPECTED_ERROR.name(), "Expected valid document type as argument", null);
        }
    }

    public void isFacialRecognitionSupported(String documentType, Context context) {
        try {
            PluginResult result = new PluginResult(PluginResult.Status.OK, (DocumentType.valueOf(documentType).getFacialRecognitionSupported()));
            result.setKeepCallback(true);
            callback.sendPluginResult(result);
        } catch (Exception e) {
            sendError(SessionStatusCode.UNEXPECTED_ERROR.name(), "Expected valid document type as argument", null);
        }
    }

    public void isLookupSupported(String documentType, Context context) {
        try {
            PluginResult result = new PluginResult(PluginResult.Status.OK, (DocumentType.valueOf(documentType).getLookupSupported()));
            result.setKeepCallback(true);
            callback.sendPluginResult(result);
        } catch (Exception e) {
            sendError(SessionStatusCode.UNEXPECTED_ERROR.name(), "Expected valid document type as argument", null);
        }
    }

    public void isLookupFacialRecognitionSupported(String documentType, Context context) {
        try {
            PluginResult result = new PluginResult(PluginResult.Status.OK, (DocumentType.valueOf(documentType).getLookupFacialRecognitionSupported()));
            result.setKeepCallback(true);
            callback.sendPluginResult(result);
        } catch (Exception e) {
            sendError(SessionStatusCode.UNEXPECTED_ERROR.name(), "Expected valid document type as argument", null);
        }
    }

    public void isEnrollmentSupported(String documentType, Context context) {
        try {
            PluginResult result = new PluginResult(PluginResult.Status.OK, (DocumentType.valueOf(documentType).getEnrollmentSupported()));
            result.setKeepCallback(true);
            callback.sendPluginResult(result);
        } catch (Exception e) {
            sendError(SessionStatusCode.UNEXPECTED_ERROR.name(), "Expected valid document type as argument", null);
        }
    }

    private void sendError(String code, String message, String task) {
        sendError(code, message, task, null);
    }

    private void sendError(String code, String message, String task, String data) {
        PluginResult result;
        JSONObject error = new JSONObject();
        try {
            error.put("code", code);
            error.put("message", message);
            error.put("task", task);
            error.put("data", data);
        } catch (Exception e) {
            e.printStackTrace();
        }
        result = new PluginResult(PluginResult.Status.ERROR, error.toString());
        result.setKeepCallback(true);
        callback.sendPluginResult(result);
    }
}
