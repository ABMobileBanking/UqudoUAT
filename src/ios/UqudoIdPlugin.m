/********* UqudoIdPlugin.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import <UqudoSDK/UqudoSDK.h>
#import <UqudoSDK/UQTracer.h>
#import "MyTracer.h"

@interface UqudoIdPlugin : CDVPlugin<UQBuilderControllerDelegate> {
    // Member variables go here.
}
@property (nonatomic, retain) CDVInvokedUrlCommand *lastCommand;
@end

@implementation UqudoIdPlugin

@synthesize lastCommand;

- (void)init:(CDVInvokedUrlCommand*)command{
    MyTracer *tracer = [[MyTracer alloc] init];
    tracer.commandDelegate = self.commandDelegate;
    tracer.traceCallbackCommand = command;
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [[UQBuilderController alloc] initWithTracer:tracer];
    });
}

- (void)setLocale:(CDVInvokedUrlCommand*)command {
    NSString* locale = [command.arguments objectAtIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:locale, nil]forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)enroll:(CDVInvokedUrlCommand*)command
{
    self.lastCommand = command;
    NSString* enrollObj = [command.arguments objectAtIndex:0];

    @try {
        if (enrollObj != nil && [enrollObj length] > 0) {
            UQBuilderController *builderController = [UQBuilderController defaultBuilder];
            NSData* data = [enrollObj dataUsingEncoding:NSUTF8StringEncoding];
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

            NSDictionary* documentList = json[@"documentList"];
            NSDictionary* facialRecognitionSpecification = json[@"facialRecognitionSpecification"];
            NSDictionary* backgroundCheckConfiguration = json[@"backgroundCheckConfiguration"];
            NSDictionary* lookupConfiguration = json[@"lookupConfiguration"];

            // Config enrollment builder
            UQEnrollmentBuilder *enrollmentBuilder = [[UQEnrollmentBuilder alloc] init];
            enrollmentBuilder.appViewController = self.viewController;
            enrollmentBuilder.authorizationToken = json[@"authorizationToken"];
            NSString* nonce = json[@"nonce"];
            if (nonce && nonce.length > 0) {
                enrollmentBuilder.nonce = nonce;
            }
            NSString* sessionId = json[@"sessionId"];
            if (sessionId && sessionId.length > 0) {
                [enrollmentBuilder setSessionID:sessionId];
            }
            NSString* userIdentifier = json[@"userIdentifier"];
            if (userIdentifier && userIdentifier.length > 0) {
                NSUUID *uuid = [[NSUUID UUID] initWithUUIDString:userIdentifier];
                if (uuid) {
                    [enrollmentBuilder setUserIdentifier:uuid];
                }
            }
            if (json[@"isReturnDataForIncompleteSession"]) {
                enrollmentBuilder.returnDataForIncompleteSession = [[json valueForKey:@"isReturnDataForIncompleteSession"] boolValue];
            }
            if (json[@"isAllowNonPhysicalDocuments"]) {
                enrollmentBuilder.allowNonPhysicalDocuments = [[json valueForKey:@"isAllowNonPhysicalDocuments"] boolValue];
            }
            if (json[@"isDisableTamperingRejection"]) {
                enrollmentBuilder.disableTamperingRejection = [[json valueForKey:@"isDisableTamperingRejection"] boolValue];
            }
            if (facialRecognitionSpecification) {

                UQFacialRecognitionConfig *config = [[UQFacialRecognitionConfig alloc] init];
                // Enable help page for face recognition
                config.enableFacialRecognition = YES;

                // Enable enroll face option
                if (facialRecognitionSpecification[@"enrollFace"]) {
                    config.enrollFace = [[facialRecognitionSpecification valueForKey:@"enrollFace"] boolValue];
                }

                if (facialRecognitionSpecification[@"scanMinimumMatchLevel"]) {
                    config.scanMinimumMatchLevel = [[facialRecognitionSpecification valueForKey:@"scanMinimumMatchLevel"] integerValue];
                }

                if (facialRecognitionSpecification[@"readMinimumMatchLevel"]) {
                    config.readMinimumMatchLevel = [[facialRecognitionSpecification valueForKey:@"readMinimumMatchLevel"] integerValue];
                }

                if (facialRecognitionSpecification[@"maxAttempts"]) {
                    int maxAttempts = [[facialRecognitionSpecification valueForKey:@"maxAttempts"] intValue];
                    if (maxAttempts > 0) {
                        config.maxAttempts = maxAttempts;
                    }
                }
                if (facialRecognitionSpecification[@"allowClosedEyes"]) {
                    config.allowClosedEyes = [[facialRecognitionSpecification valueForKey:@"allowClosedEyes"] boolValue];
                }
                if (facialRecognitionSpecification[@"obfuscationType"]) {
                    if ([facialRecognitionSpecification[@"obfuscationType"]  isEqualToString:@"BLURRED"]) {
                        config.obfuscationType = BLURRED;
                    } else if ([facialRecognitionSpecification[@"obfuscationType"]  isEqualToString:@"FILLED"]) {
                        config.obfuscationType = FILLED;
                    } else if ([facialRecognitionSpecification[@"obfuscationType"]  isEqualToString:@"FILLED_WHITE"]) {
                        config.obfuscationType = FILLED_WHITE;
                    }
                }
                if (facialRecognitionSpecification[@"isOneToNVerificationEnabled"]) {
                    config.enableOneToNVerification = [[facialRecognitionSpecification valueForKey:@"isOneToNVerificationEnabled"] boolValue];
                }
                
                if (facialRecognitionSpecification[@"enableActiveLiveness"] && [facialRecognitionSpecification[@"enableActiveLiveness"] boolValue]) {
                    config.enableActiveLiveness = YES;
                }
                
                if (facialRecognitionSpecification[@"disableLivenessGesture"]) {
                    NSString *gesture = facialRecognitionSpecification[@"disableLivenessGesture"];
                    if ([gesture isEqualToString:@"FACE_MOVE"]) {
                        config.disableLivenessGesture = FACE_MOVE;
                    } else if ([gesture isEqualToString:@"FACE_TILT"]) {
                        config.disableLivenessGesture = FACE_TILT;
                    } else if ([gesture isEqualToString:@"FACE_TURN"]) {
                        config.disableLivenessGesture = FACE_TURN;
                    }
                }

                enrollmentBuilder.facialRecognitionConfig = config;


            }

            if(lookupConfiguration){
                NSMutableArray *lookupDocumentTypes = [[NSMutableArray alloc] init];
                if(lookupConfiguration[@"documentList"]){
                    for (NSString *document in lookupConfiguration[@"documentList"]) {
                        UQDocumentConfig *documentConfig = [[UQDocumentConfig alloc] initWithDocumentTypeName:document];
                        [lookupDocumentTypes addObject:[NSNumber numberWithInteger:[documentConfig documentType]]];
                    }
                }
                if (lookupDocumentTypes.count) {
                    [enrollmentBuilder enableLookup:lookupDocumentTypes];
                }
                else {
                    [enrollmentBuilder enableLookup];
                }
            }
            if (backgroundCheckConfiguration) {
                BOOL isDisableConsent = FALSE;
                if (backgroundCheckConfiguration[@"disableConsent"]) {
                    isDisableConsent = [[backgroundCheckConfiguration valueForKey:@"disableConsent"] boolValue];
                }
                BackgroundCheckType type = RDC;
                if (backgroundCheckConfiguration[@"backgroundCheckType"]) {
                    type = [backgroundCheckConfiguration[@"backgroundCheckType"]  isEqual: @"RDC"] ? RDC : DOW_JONES;
                }
                BOOL isMonitoringEnabled = FALSE;
                if (backgroundCheckConfiguration[@"monitoringEnabled"]) {
                    isMonitoringEnabled = [[backgroundCheckConfiguration valueForKey:@"monitoringEnabled"] boolValue];
                }
                BOOL isSkipView = FALSE;
                if (backgroundCheckConfiguration[@"skipView"]) {
                    isSkipView = [[backgroundCheckConfiguration valueForKey:@"skipView"] boolValue];
                }
                [enrollmentBuilder enableBackgroundCheck:isDisableConsent type:type monitoring:isMonitoringEnabled skipView:isSkipView];
            }
            for (NSDictionary *document in documentList) {
                NSString* documentType = document[@"documentType"];
                UQDocumentConfig *documentObject = [[UQDocumentConfig alloc] initWithDocumentTypeName:documentType];
                if(documentObject.documentType == UNSPECIFY){
                    continue;
                }

                UQScanConfig *scanConfig = [[UQScanConfig alloc] init];
                if (document[@"isHelpPageDisabled"]) {
                    scanConfig.disableHelpPage = [[document valueForKey:@"isHelpPageDisabled"] boolValue];
                }
                if (document[@"faceScanMinimumMatchLevel"]) {
                    scanConfig.faceMinimumMatchLevel = [[document valueForKey:@"faceScanMinimumMatchLevel"] intValue];
                }
                if (document[@"minimumAge"]) {
                    int minimumAge = [[document valueForKey:@"minimumAge"] intValue];
                    if (minimumAge > 0) {
                        documentObject.enableAgeVerification = minimumAge;
                    }
                }
                BOOL isEnabelFrontSideReview = false;
                BOOL isEnabelBackSideReview = false;

                if (document[@"isFrontSideReviewEnabled"]) {
                    isEnabelFrontSideReview = [[document valueForKey:@"isFrontSideReviewEnabled"] boolValue];
                }
                if (document[@"isBackSideReviewEnabled"]) {
                    isEnabelBackSideReview = [[document valueForKey:@"isBackSideReviewEnabled"] boolValue];
                }
                [scanConfig enableScanReview:isEnabelFrontSideReview backSide:isEnabelBackSideReview];
                if (document[@"isUploadEnabled"]) {
                    scanConfig.enableUpload = [[document valueForKey:@"isUploadEnabled"] boolValue];
                }
                documentObject.scan = scanConfig;

                if (document[@"isExpiredDocumentValidateDisabled"]) {
                    documentObject.disableExpiryValidation = [[document valueForKey:@"isExpiredDocumentValidateDisabled"] boolValue];
                }

                if (document[@"readingConfiguration"]) {
                    NSDictionary *readingConfiguration = document[@"readingConfiguration"];

                    UQReadingConfig *readConfig = [[UQReadingConfig alloc] init];
                    readConfig.enableReading = TRUE;
                    if (readingConfiguration[@"forceReading"]) {
                        [readConfig forceReading:[[readingConfiguration valueForKey:@"forceReading"] boolValue]];
                    }
                    if (readingConfiguration[@"forceReadingIfSupported"]) {
                        [readConfig forceReadingIfSupported:[[readingConfiguration valueForKey:@"forceReadingIfSupported"] boolValue]];
                    }
                    if (document[@"faceReadMinimumMatchLevel"]) {
                        readConfig.faceMinimumMatchLevel = [[document valueForKey:@"faceReadMinimumMatchLevel"] intValue];
                    }
                    if (readingConfiguration[@"timeoutInSeconds"]) {
                        int timeoutInSeconds = [[readingConfiguration valueForKey:@"timeoutInSeconds"] intValue];
                        if (timeoutInSeconds > 0) {
                            readConfig.forceReadingTimeout = timeoutInSeconds;
                        }
                    }

                    documentObject.reading = readConfig;
                }

                [enrollmentBuilder add:documentObject];
            }
            builderController.delegate = self;
            builderController.appViewController = self.viewController;
            [builderController setEnrollment:enrollmentBuilder];
            // set appearanceMode to builder
            NSInteger appearanceMode = SYSTEM;
            if (json[@"appearanceMode"]) {
                if ([json[@"appearanceMode"] isEqualToString:@"LIGHT"]) {
                    appearanceMode = LIGHT;
                } else if ([json[@"appearanceMode"] isEqualToString:@"DARK"]) {
                    appearanceMode = DARK;
                }
            }
            [builderController setAppearanceMode:appearanceMode];
            [builderController performEnrollment];
        } else {
            UQSessionStatus *status =[[UQSessionStatus alloc] init];
            status.statusCode = UNEXPECTED_ERROR;
            status.message = @"Expected enrollment object as argument.";
            status.statusTask = -1;
            [self sendPluginError:status];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.callStackSymbols);
        UQSessionStatus *status =[[UQSessionStatus alloc] init];
        status.statusCode = UNEXPECTED_ERROR;
        status.message = exception.reason;
        status.statusTask = -1;
        [self sendPluginError:status];
    }
}

- (void) didEnrollmentCompleteWithInfo:(NSString *)jwsString {
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:jwsString];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.lastCommand.callbackId];
}

- (void) didEnrollmentIncompleteWithStatus:(UQSessionStatus *)status {
    [self sendPluginError:status];
}

- (void) didEnrollmentFailWithError:(NSError *)error {
    // IGNORE, deprecated in the SDK
}

- (void)recover:(CDVInvokedUrlCommand*)command
{
    self.lastCommand = command;
    NSString* recoverObj = [command.arguments objectAtIndex:0];

    @try {
        if (recoverObj != nil && [recoverObj length] > 0) {
            UQBuilderController *builderController = [UQBuilderController defaultBuilder];
            NSData *data = [recoverObj dataUsingEncoding:NSUTF8StringEncoding];
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

            // Config account recovery builder
            UQAccountRecoveryBuilder *accountRecoveryBuilder = [[UQAccountRecoveryBuilder alloc] init];
            accountRecoveryBuilder.appViewController = self.viewController;
            accountRecoveryBuilder.authorizationToken = json[@"token"];
            accountRecoveryBuilder.enrollmentIdentifier = json[@"enrollmentIdentifier"];
            accountRecoveryBuilder.nonce = json[@"nonce"];
            if (json[@"minimumMatchLevel"]) {
                accountRecoveryBuilder.minimumMatchLevel = [[json valueForKey:@"minimumMatchLevel"] intValue];
            }

            if (json[@"maxAttempts"]) {
                int maxAttempts = [[json valueForKey:@"maxAttempts"] intValue];
                if (maxAttempts > 0) {
                    accountRecoveryBuilder.maxAttempts = maxAttempts;
                }
            }

            if (json[@"allowClosedEyes"]) {
                accountRecoveryBuilder.allowClosedEyes = [[json valueForKey:@"allowClosedEyes"] boolValue];
            }

            if (json[@"isReturnDataForIncompleteSession"]) {
                accountRecoveryBuilder.returnDataForIncompleteSession = [[json valueForKey:@"isReturnDataForIncompleteSession"] boolValue];
            }

            builderController.delegate = self;
            builderController.appViewController = self.viewController;
            [builderController setAccountRecovery:accountRecoveryBuilder];
            // Start enrollment flow
            // accessToken reuire, if no token the UQExceptionInvalidToken will throw
            NSInteger appearanceMode = SYSTEM;
            if (json[@"appearanceMode"]) {
                if ([json[@"appearanceMode"] isEqualToString:@"LIGHT"]) {
                    appearanceMode = LIGHT;
                } else if ([json[@"appearanceMode"] isEqualToString:@"DARK"]) {
                    appearanceMode = DARK;
                }
            }
            [builderController setAppearanceMode:appearanceMode];
            [builderController performAccountRecovery];
        } else {
            UQSessionStatus *status =[[UQSessionStatus alloc] init];
            status.statusCode = UNEXPECTED_ERROR;
            status.message = @"Expected account recovery object as argument.";
            status.statusTask = -1;
            [self sendPluginError:status];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.callStackSymbols);
        UQSessionStatus *status =[[UQSessionStatus alloc] init];
        status.statusCode = UNEXPECTED_ERROR;
        status.message = exception.reason;
        status.statusTask = -1;
        [self sendPluginError:status];
    }
}

- (void)didAccountRecoveryCompleteWithInfo:(nonnull NSString *)jwsString {
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:jwsString];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.lastCommand.callbackId];
}

- (void)didAccountRecoveryIncompleteWithStatus:(UQSessionStatus *)status {
    [self sendPluginError:status];
}

- (void)didAccountRecoveryFailWithError:(nonnull NSError *)error {
    // IGNORE, deprecated in the SDK
}

- (void)faceSession:(CDVInvokedUrlCommand*)command
{
    self.lastCommand = command;
    NSString* configuration = [command.arguments objectAtIndex:0];

    @try {
        if (configuration != nil && [configuration length] > 0) {
            UQBuilderController *builderController = [UQBuilderController defaultBuilder];
            NSData *data = [configuration dataUsingEncoding:NSUTF8StringEncoding];
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

            UQFaceSessionBuilder *faceSessionBuilder = [[UQFaceSessionBuilder alloc] init];
            faceSessionBuilder.authorizationToken = json[@"token"];
            faceSessionBuilder.sessionId = json[@"sessionId"];
            faceSessionBuilder.nonce = json[@"nonce"];

            NSString* userIdentifier = json[@"userIdentifier"];
            if (userIdentifier && userIdentifier.length > 0) {
                NSUUID *uuid = [[NSUUID UUID] initWithUUIDString:userIdentifier];
                if (uuid) {
                    faceSessionBuilder.userIdentifier = uuid;
                }
            }

            if (json[@"minimumMatchLevel"]) {
                faceSessionBuilder.minimumMatchLevel = [[json valueForKey:@"minimumMatchLevel"] intValue];
            }

            if (json[@"maxAttempts"]) {
                int maxAttempts = [[json valueForKey:@"maxAttempts"] intValue];
                if (maxAttempts > 0) {
                    faceSessionBuilder.maxAttempts = maxAttempts;
                }
            }


            if (json[@"allowClosedEyes"]) {
                faceSessionBuilder.allowClosedEyes = [[json valueForKey:@"allowClosedEyes"] boolValue];
            }


            if (json[@"isReturnDataForIncompleteSession"]) {
                faceSessionBuilder.returnDataForIncompleteSession = [[json valueForKey:@"isReturnDataForIncompleteSession"] boolValue];
            }
            if (json[@"obfuscationType"]) {
                if ([json[@"obfuscationType"]  isEqualToString:@"BLURRED"]) {
                    [faceSessionBuilder enableAuditTrailImageObfuscation:BLURRED];
                } else if ([json[@"obfuscationType"]  isEqualToString:@"FILLED"]) {
                    [faceSessionBuilder enableAuditTrailImageObfuscation:FILLED];
                } else if ([json[@"obfuscationType"]  isEqualToString:@"FILLED_WHITE"]) {
                    [faceSessionBuilder enableAuditTrailImageObfuscation:FILLED_WHITE];
                }
            }
            
            if (json[@"enableActiveLiveness"] && [json[@"enableActiveLiveness"] boolValue]) {
                faceSessionBuilder.enableActiveLiveness = YES;
            }
            
            if (json[@"disableLivenessGesture"]) {
                NSString *gesture = json[@"disableLivenessGesture"];
                if ([gesture isEqualToString:@"FACE_MOVE"]) {
                    faceSessionBuilder.disableLivenessGesture = FACE_MOVE;
                } else if ([gesture isEqualToString:@"FACE_TILT"]) {
                    faceSessionBuilder.disableLivenessGesture = FACE_TILT;
                } else if ([gesture isEqualToString:@"FACE_TURN"]) {
                    faceSessionBuilder.disableLivenessGesture = FACE_TURN;
                }
            }
            
            builderController.delegate = self;
            builderController.appViewController = self.viewController;
            [builderController setFaceSession:faceSessionBuilder];

            NSInteger appearanceMode = SYSTEM;
            if (json[@"appearanceMode"]) {
                if ([json[@"appearanceMode"] isEqualToString:@"LIGHT"]) {
                    appearanceMode = LIGHT;
                } else if ([json[@"appearanceMode"] isEqualToString:@"DARK"]) {
                    appearanceMode = DARK;
                }
            }
            [builderController setAppearanceMode:appearanceMode];
            [builderController performFaceSession];
        } else {
            UQSessionStatus *status =[[UQSessionStatus alloc] init];
            status.statusCode = UNEXPECTED_ERROR;
            status.message = @"Expected face session configuration as argument.";
            status.statusTask = -1;
            [self sendPluginError:status];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.callStackSymbols);
        UQSessionStatus *status =[[UQSessionStatus alloc] init];
        status.statusCode = UNEXPECTED_ERROR;
        status.message = exception.reason;
        status.statusTask = -1;
        [self sendPluginError:status];
    }
}

- (void)didFaceSessionCompleteWithInfo:(nonnull NSString *)jwsString {
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:jwsString];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.lastCommand.callbackId];
}

- (void)didFaceSessionIncompleteWithStatus:(UQSessionStatus *)status {
    [self sendPluginError:status];
}

- (void)didFaceSessionFailWithError:(nonnull NSError *)error {
    // IGNORE, deprecated in the SDK
}

- (void)lookup:(CDVInvokedUrlCommand*)command
{
    self.lastCommand = command;
    NSString* lookupObj = [command.arguments objectAtIndex:0];

    @try {
        if (lookupObj != nil && [lookupObj length] > 0) {
            UQBuilderController *builderController = [UQBuilderController defaultBuilder];
            NSData* data = [lookupObj dataUsingEncoding:NSUTF8StringEncoding];
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

            UQLookupBuilder *lookupBuilder = [[UQLookupBuilder alloc] init];
            lookupBuilder.authorizationToken = json[@"authorizationToken"];
            NSString* nonce = json[@"nonce"];
            if (nonce && nonce.length > 0) {
                lookupBuilder.nonce = nonce;
            }
            NSString* documentType = json[@"documentType"];
            UQDocumentConfig *documentConfig = [[UQDocumentConfig alloc] initWithDocumentTypeName:documentType];
            [lookupBuilder setDocumentType:documentConfig.documentType];
            NSString* sessionId = json[@"sessionId"];
            if (sessionId && sessionId.length > 0) {
                [lookupBuilder setSessionID:sessionId];
            }
            NSString* userIdentifier = json[@"userIdentifier"];
            if (userIdentifier && userIdentifier.length > 0) {
                NSUUID *userID = [[NSUUID alloc] initWithUUIDString:userIdentifier];
                if (userID) {
                    [lookupBuilder setUserIdentifier:userID];
                }
            }
            if (json[@"isReturnDataForIncompleteSession"]) {
                lookupBuilder.returnDataForIncompleteSession = [[json valueForKey:@"isReturnDataForIncompleteSession"] boolValue];
            }
            NSDictionary* facialRecognitionSpecification = json[@"facialRecognitionSpecification"];
            if (facialRecognitionSpecification) {
             UQFacialRecognitionConfig *config = [[UQFacialRecognitionConfig alloc] init];
                // Enable help page for face recognition
                config.enableFacialRecognition = YES;
                // Enable enroll face option
                if (facialRecognitionSpecification[@"enrollFace"]) {
                    config.enrollFace = [[facialRecognitionSpecification valueForKey:@"enrollFace"] boolValue];
                }
                if (facialRecognitionSpecification[@"lookupMinimumMatchLevel"]) {
                    config.minimumMatchLevel = [[facialRecognitionSpecification valueForKey:@"lookupMinimumMatchLevel"] integerValue];
                }
                if (facialRecognitionSpecification[@"maxAttempts"]) {
                    int maxAttempts = [[facialRecognitionSpecification valueForKey:@"maxAttempts"] intValue];
                    if (maxAttempts > 0) {
                        config.maxAttempts = maxAttempts;
                    }
                }
                if (facialRecognitionSpecification[@"allowClosedEyes"]) {
                        config.allowClosedEyes = [[facialRecognitionSpecification valueForKey:@"allowClosedEyes"] boolValue];
                }
                if (facialRecognitionSpecification[@"obfuscationType"]) {
                    if ([facialRecognitionSpecification[@"obfuscationType"]  isEqualToString:@"BLURRED"]) {
                        config.obfuscationType = BLURRED;
                    } else if ([facialRecognitionSpecification[@"obfuscationType"]  isEqualToString:@"FILLED"]) {
                        config.obfuscationType = FILLED;
                    } else if ([facialRecognitionSpecification[@"obfuscationType"]  isEqualToString:@"FILLED_WHITE"]) {
                        config.obfuscationType = FILLED_WHITE;
                    }
                }
                if (facialRecognitionSpecification[@"isOneToNVerificationEnabled"]) {
                    config.enableOneToNVerification = [[facialRecognitionSpecification valueForKey:@"isOneToNVerificationEnabled"] boolValue];
                }
                
                if (facialRecognitionSpecification[@"enableActiveLiveness"] && [facialRecognitionSpecification[@"enableActiveLiveness"] boolValue]) {
                    config.enableActiveLiveness = YES;
                }
                
                if (facialRecognitionSpecification[@"disableLivenessGesture"]) {
                    NSString *gesture = facialRecognitionSpecification[@"disableLivenessGesture"];
                    if ([gesture isEqualToString:@"FACE_MOVE"]) {
                        config.disableLivenessGesture = FACE_MOVE;
                    } else if ([gesture isEqualToString:@"FACE_TILT"]) {
                        config.disableLivenessGesture = FACE_TILT;
                    } else if ([gesture isEqualToString:@"FACE_TURN"]) {
                        config.disableLivenessGesture = FACE_TURN;
                    }
                }

               lookupBuilder.facialRecognitionConfig = config;

            }
            NSDictionary* backgroundCheckConfiguration = json[@"backgroundCheckConfiguration"];
            if (backgroundCheckConfiguration) {
                BOOL isDisableConsent = FALSE;
                BackgroundCheckType type = RDC;
                if (backgroundCheckConfiguration[@"disableConsent"]) {
                    isDisableConsent = [[backgroundCheckConfiguration valueForKey:@"disableConsent"] boolValue];
                }
                if (backgroundCheckConfiguration[@"backgroundCheckType"]) {
                    if ([backgroundCheckConfiguration[@"backgroundCheckType"] isEqual:@"RDC"]) {
                        type = RDC;
                    } else {
                        type = DOW_JONES;
                    }
                }
                BOOL isMonitoringEnabled = FALSE;
                if (backgroundCheckConfiguration[@"monitoringEnabled"]) {
                    isMonitoringEnabled = [[backgroundCheckConfiguration valueForKey:@"monitoringEnabled"] boolValue];
                }
                BOOL isSkipView = FALSE;
                if (backgroundCheckConfiguration[@"skipView"]) {
                    isSkipView = [[backgroundCheckConfiguration valueForKey:@"skipView"] boolValue];
                }
                [lookupBuilder enableBackgroundCheck:isDisableConsent type:type monitoring:isMonitoringEnabled skipView:isSkipView];
            }
            builderController.delegate = self;
            [builderController setLookup:lookupBuilder];
            builderController.appViewController = self.viewController;
            NSInteger appearanceMode = SYSTEM;
            if (json[@"appearanceMode"]) {
                if ([json[@"appearanceMode"] isEqualToString:@"LIGHT"]) {
                    appearanceMode = LIGHT;
                } else if ([json[@"appearanceMode"] isEqualToString:@"DARK"]) {
                    appearanceMode = DARK;
                }
            }
            [builderController setAppearanceMode:appearanceMode];
            [builderController performLookup];
        } else {
            UQSessionStatus *status =[[UQSessionStatus alloc] init];
            status.statusCode = UNEXPECTED_ERROR;
            status.message = @"Expected lookup object as argument.";
            status.statusTask = -1;
            [self sendPluginError:status];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.callStackSymbols);
        UQSessionStatus *status =[[UQSessionStatus alloc] init];
        status.statusCode = UNEXPECTED_ERROR;
        status.message = exception.reason;
        status.statusTask = -1;
        [self sendPluginError:status];
    }
}

- (void) didLookupFlowCompleteWithInfo:(NSString *)jwsString {
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:jwsString];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.lastCommand.callbackId];
}

- (void) didLookupFlowIncompleteWithStatus:(UQSessionStatus *)status {
    [self sendPluginError:status];
}

- (void)isReadingSupported:(CDVInvokedUrlCommand*)command {
    self.lastCommand = command;
    NSString* documentType = [command.arguments objectAtIndex:0];
    @try{
        UQDocumentConfig *documentObject = [[UQDocumentConfig alloc] initWithDocumentTypeName:documentType];
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:documentObject.isSupportReading];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.lastCommand.callbackId];

    }
    @catch (NSException *exception) {
        UQSessionStatus *status =[[UQSessionStatus alloc] init];
        status.statusCode = UNEXPECTED_ERROR;
        status.message = @"Expected valid document type as argument";
        status.statusTask = -1;
        [self sendPluginError:status];
    }
}

- (void)isFacialRecognitionSupported:(CDVInvokedUrlCommand*)command {
    self.lastCommand = command;
    NSString* documentType = [command.arguments objectAtIndex:0];
    @try{
        UQDocumentConfig *documentObject = [[UQDocumentConfig alloc] initWithDocumentTypeName:documentType];
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:documentObject.isSupportFaceRecognition];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.lastCommand.callbackId];
    }
    @catch (NSException *exception) {
        UQSessionStatus *status =[[UQSessionStatus alloc] init];
        status.statusCode = UNEXPECTED_ERROR;
        status.message = @"Expected valid document type as argument";
        status.statusTask = -1;
        [self sendPluginError:status];
    }
}

- (void)isLookupSupported:(CDVInvokedUrlCommand*)command {
    self.lastCommand = command;
    NSString* documentType = [command.arguments objectAtIndex:0];
    @try{
        UQDocumentConfig *documentObject = [[UQDocumentConfig alloc] initWithDocumentTypeName:documentType];
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:documentObject.isLookupSupported];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.lastCommand.callbackId];
    }
    @catch (NSException *exception) {
        UQSessionStatus *status =[[UQSessionStatus alloc] init];
        status.statusCode = UNEXPECTED_ERROR;
        status.message = @"Expected valid document type as argument";
        status.statusTask = -1;
        [self sendPluginError:status];
    }
}

- (void)isLookupFacialRecognitionSupported:(CDVInvokedUrlCommand*)command {
    self.lastCommand = command;
    NSString* documentType = [command.arguments objectAtIndex:0];
    @try{
        UQDocumentConfig *documentObject = [[UQDocumentConfig alloc] initWithDocumentTypeName:documentType];
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:documentObject.isLookupFacialRecognitionSupported];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.lastCommand.callbackId];
    }
    @catch (NSException *exception) {
        UQSessionStatus *status =[[UQSessionStatus alloc] init];
        status.statusCode = UNEXPECTED_ERROR;
        status.message = @"Expected valid document type as argument";
        status.statusTask = -1;
        [self sendPluginError:status];
    }
}

- (void)isEnrollmentSupported:(CDVInvokedUrlCommand*)command {
    self.lastCommand = command;
    NSString* documentType = [command.arguments objectAtIndex:0];
    @try{
        UQDocumentConfig *documentObject = [[UQDocumentConfig alloc] initWithDocumentTypeName:documentType];
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:documentObject.isEnrollmentSupported];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.lastCommand.callbackId];
    }
    @catch (NSException *exception) {
        UQSessionStatus *status =[[UQSessionStatus alloc] init];
        status.statusCode = UNEXPECTED_ERROR;
        status.message = @"Expected valid document type as argument";
        status.statusTask = -1;
        [self sendPluginError:status];
    }
}

- (void)reading:(CDVInvokedUrlCommand*)command {
    self.lastCommand = command;
    NSString* readingObj = [command.arguments objectAtIndex:0];
    
    @try {
        if (readingObj != nil && [readingObj length] > 0) {
            UQBuilderController *builderController = [UQBuilderController defaultBuilder];
            NSData *data = [readingObj dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            UQReadingBuilder *readingBuilder = [[UQReadingBuilder alloc] init];
            
            if (json[@"authorizationToken"]) {
                readingBuilder.authorizationToken = json[@"authorizationToken"];
            }

            if (json[@"sessionId"]) {
                readingBuilder.sessionID = json[@"sessionId"];
            }

            NSString* userIdentifier = json[@"userIdentifier"];
            if (userIdentifier && userIdentifier.length > 0) {
                readingBuilder.userIdentifier = userIdentifier;
            }

            if (json[@"nonce"]) {
                readingBuilder.nonce = json[@"nonce"];
            }

            if (json[@"documentType"]) {
                UQDocumentConfig *documentObject = [[UQDocumentConfig alloc] initWithDocumentTypeName:json[@"documentType"]];
                readingBuilder.documentType = documentObject.documentType;
            }

            if (json[@"documentNumber"]) {
                readingBuilder.documentNumber = json[@"documentNumber"];
            }

            if (json[@"dateOfBirth"]) {
                readingBuilder.dateOfBirth = json[@"dateOfBirth"];
            }

            if (json[@"dateOfExpiry"]) {
                readingBuilder.dateOfExpiry = json[@"dateOfExpiry"];
            }

            if (json[@"mrz"]) {
                readingBuilder.mrz = json[@"mrz"];
            }

            if (json[@"isReturnDataForIncompleteSession"]) {
                readingBuilder.returnDataForIncompleteSession = [[json valueForKey:@"isReturnDataForIncompleteSession"] boolValue];
            }

            if (json[@"facialRecognitionSpecification"]) {
                NSDictionary *frConfig = json[@"facialRecognitionSpecification"];
                UQFacialRecognitionConfig *config = [[UQFacialRecognitionConfig alloc] init];
                config.enableFacialRecognition = YES;

                if (frConfig[@"enrollFace"] && [frConfig[@"enrollFace"] boolValue]) {
                    config.enrollFace = YES;
                }

                if (frConfig[@"scanMinimumMatchLevel"]) {
                    config.scanMinimumMatchLevel = [frConfig[@"scanMinimumMatchLevel"] intValue];
                }

                if (frConfig[@"readMinimumMatchLevel"]) {
                    config.readMinimumMatchLevel = [frConfig[@"readMinimumMatchLevel"] intValue];
                }

                if (frConfig[@"lookupMinimumMatchLevel"]) {
                    config.minimumMatchLevel = [frConfig[@"lookupMinimumMatchLevel"] intValue];
                }

                if (frConfig[@"maxAttempts"]) {
                    int maxAttempts = [frConfig[@"maxAttempts"] intValue];
                    if (maxAttempts > 0) {
                        config.maxAttempts = maxAttempts;
                    }
                }

                if (frConfig[@"allowClosedEyes"] && [frConfig[@"allowClosedEyes"] boolValue]) {
                    config.allowClosedEyes = YES;
                }

                if (frConfig[@"obfuscationType"]) {
                    if ([frConfig[@"obfuscationType"] isEqualToString:@"BLURRED"]) {
                        config.obfuscationType = BLURRED;
                    } else if ([frConfig[@"obfuscationType"] isEqualToString:@"FILLED"]) {
                        config.obfuscationType = FILLED;
                    } else if ([frConfig[@"obfuscationType"] isEqualToString:@"FILLED_WHITE"]) {
                        config.obfuscationType = FILLED_WHITE;
                    }
                }

                if (frConfig[@"isOneToNVerificationEnabled"] && [frConfig[@"isOneToNVerificationEnabled"] boolValue]) {
                    config.enableOneToNVerification = YES;
                }

                if (frConfig[@"enableActiveLiveness"] && [frConfig[@"enableActiveLiveness"] boolValue]) {
                    config.enableActiveLiveness = YES;
                }

                if (frConfig[@"disableLivenessGesture"]) {
                    NSString *gesture = frConfig[@"disableLivenessGesture"];
                    if ([gesture isEqualToString:@"FACE_MOVE"]) {
                        config.disableLivenessGesture = FACE_MOVE;
                    } else if ([gesture isEqualToString:@"FACE_TILT"]) {
                        config.disableLivenessGesture = FACE_TILT;
                    } else if ([gesture isEqualToString:@"FACE_TURN"]) {
                        config.disableLivenessGesture = FACE_TURN;
                    }
                }

                readingBuilder.facialRecognitionConfig = config;
            }

            if (json[@"backgroundCheckConfiguration"]) {
                NSDictionary *bgConfig = json[@"backgroundCheckConfiguration"];

                BOOL isDisableConsent = bgConfig[@"disableConsent"] && [bgConfig[@"disableConsent"] boolValue];
                BOOL isMonitoringEnabled = bgConfig[@"monitoringEnabled"] && [bgConfig[@"monitoringEnabled"] boolValue];
                BOOL isSkipView = bgConfig[@"skipView"] && [bgConfig[@"skipView"] boolValue];

                BackgroundCheckType type = RDC;
                if (bgConfig[@"backgroundCheckType"]) {
                    if ([bgConfig[@"backgroundCheckType"] isEqualToString:@"DOW_JONES"]) {
                        type = DOW_JONES;
                    }
                }

                [readingBuilder enableBackgroundCheck:isDisableConsent type:type monitoring:isMonitoringEnabled skipView:isSkipView];
            }

            if (json[@"isLookupEnabled"] && [json[@"isLookupEnabled"] boolValue]) {
                [readingBuilder enableLookup];
            }

            builderController.delegate = self;
            [builderController setReading:readingBuilder];
            builderController.appViewController = self.viewController;

            NSInteger appearanceMode = SYSTEM;
            if (json[@"appearanceMode"]) {
                if ([json[@"appearanceMode"] isEqualToString:@"LIGHT"]) {
                    appearanceMode = LIGHT;
                } else if ([json[@"appearanceMode"] isEqualToString:@"DARK"]) {
                    appearanceMode = DARK;
                }
            }
            [builderController setAppearanceMode:appearanceMode];
            [builderController performReading];
        } else {
            UQSessionStatus *status =[[UQSessionStatus alloc] init];
            status.statusCode = UNEXPECTED_ERROR;
            status.message = @"Expected reading object as argument.";
            status.statusTask = -1;
            [self sendPluginError:status];
        }
    }
    @catch (NSException *exception) {
        UQSessionStatus *status =[[UQSessionStatus alloc] init];
        status.statusCode = UNEXPECTED_ERROR;
        status.message = @"Error processing reading request";
        status.statusTask = -1;
        [self sendPluginError:status];
    }
}

- (void)sendPluginError:(UQSessionStatus *)status {
    NSString *code = nil;
    switch (status.statusCode) {
        case USER_CANCEL:
            code = @"USER_CANCEL";
            break;
        case SESSION_EXPIRED:
            code = @"SESSION_EXPIRED";
            break;
        case UNEXPECTED_ERROR:
            code = @"UNEXPECTED_ERROR";
            break;
        case SESSION_INVALIDATED_CHIP_VALIDATION_FAILED:
            code = @"SESSION_INVALIDATED_CHIP_VALIDATION_FAILED";
            break;
        case SESSION_INVALIDATED_READING_NOT_SUPPORTED:
            code = @"SESSION_INVALIDATED_READING_NOT_SUPPORTED";
            break;
        case SESSION_INVALIDATED_READING_INVALID_DOCUMENT:
            code = @"SESSION_INVALIDATED_READING_INVALID_DOCUMENT";
            break;
        case SESSION_INVALIDATED_FACE_RECOGNITION_TOO_MANY_ATTEMPTS:
            code = @"SESSION_INVALIDATED_FACE_RECOGNITION_TOO_MANY_ATTEMPTS";
            break;
        case SESSION_INVALIDATED_OTP_TOO_MANY_ATTEMPTS:
            code = @"SESSION_INVALIDATED_OTP_TOO_MANY_ATTEMPTS";
            break;
        case SESSION_INVALIDATED_CAMERA_NOT_AVAILABLE:
            code = @"SESSION_INVALIDATED_CAMERA_NOT_AVAILABLE";
            break;
        case SESSION_INVALIDATED_CAMERA_PERMISSION_NOT_GRANTED:
            code = @"SESSION_INVALIDATED_CAMERA_PERMISSION_NOT_GRANTED";
            break;
    }
    NSString *task = nil;
    switch (status.statusTask) {
        case SCAN:
            task = @"SCAN";
            break;
        case READING:
            task = @"READING";
            break;
        case FACE:
            task = @"FACE";
            break;
        case BACKGROUND_CHECK:
            task = @"BACKGROUND_CHECK";
            break;
        case LOOKUP:
            task = @"LOOKUP";
            break;
    }
    NSMutableDictionary *error = [[NSMutableDictionary alloc]init];
    [error setValue:code forKey:@"code"];
    [error setValue:status.message forKey:@"message"];
    [error setValue:task forKey:@"task"];
    [error setValue:status.data forKey:@"data"];

    NSError *err = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:error options:NSJSONWritingPrettyPrinted error:&err];

    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:jsonString];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.lastCommand.callbackId];
}

@end

@implementation MyTracer

- (void)trace:(UQTrace *)trace {
    if (self.traceCallbackCommand != nil) {
        NSMutableDictionary* parameters = [[NSMutableDictionary alloc] init];

        if(nil != trace.sessionId){
            [parameters setValue:trace.sessionId forKey:@"sessionId"];
        }
        [parameters setValue:trace.category->name forKey:@"category"];
        [parameters setValue:trace.event->name forKey:@"event"];
        [parameters setValue:trace.status->name forKey:@"status"];

        NSString *timeStamp = [self timeStamp:trace.timestamp];
        [parameters setValue:timeStamp forKey:@"timestamp"];

        if (TP_NULL != trace.page) {
            [parameters setValue:trace.page->name forKey:@"page"];
        }
        if (TSC_NULL != trace.statusCode) {
            [parameters setValue:trace.statusCode->name forKey:@"statusCode"];
        }
        if (trace.documentType != UNSPECIFY) {
            UQDocumentConfig *document = [[UQDocumentConfig alloc] initWithDocumentType:trace.documentType];
            [parameters setValue:document.documentName forKey:@"documentType"];
        }
        if (trace.statusMessage) {
            [parameters setValue:trace.statusMessage forKey:@"statusMessage"];
        }

        NSError *err = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&err];

        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:jsonString];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.traceCallbackCommand.callbackId];
    }
}

- (NSString *)timeStamp:(NSDate *)currentDate {
    NSISO8601DateFormatter *dateFormatter = [[NSISO8601DateFormatter alloc] init];
    return [dateFormatter stringFromDate:currentDate];
}

- (void)didRootedDeviceDetected:(NSString *)info {
    // IGNORE, deprecated in the SDK
}

@end

