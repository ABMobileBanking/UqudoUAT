#import <UqudoSDK/UQTracer.h>

@interface MyTracer : UQTracer {
    void (^_completionHandler)(NSString* someParameter);
}
@property (nonatomic, weak) id <CDVCommandDelegate> commandDelegate;
@property (nonatomic, retain) CDVInvokedUrlCommand *traceCallbackCommand;
@end
