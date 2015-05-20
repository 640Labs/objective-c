#import "PNResult.h"
#import "PNStructures.h"


/**
 @brief      Class which is used to describe request processing status.
 @discussion Depending on used API type status may deliver error or \b PubNub service acknowledgment
             response.
 
 @author Sergey Mamontov
 @since 4.0
 @copyright © 2009-2015 PubNub, Inc.
 */
@interface PNStatus : PNResult <NSCopying>


///------------------------------------------------
/// @name Information
///------------------------------------------------

/**
 @brief  One of \b PNStatusCategory fields which provide information about for which status this
         instance has been created.

 @since 4.0
*/
@property (nonatomic, readonly, assign) PNStatusCategory category;

/**
 @brief  Stores whether client currently used secured connection or not.
 
 @since 4.0
 */
@property (nonatomic, readonly, assign, getter = isTLSEnabled) BOOL TLSEnabled;

/**
 @brief      Stores reference on list of channels on which client currently subscribed.
 @discussion This property populated only for \c operation eaqual to \b PNSubscribeOperation or
             \b PNUnsubscribeOperation.
 
 @since 4.0
 */
@property (nonatomic, readonly, copy) NSArray *channels;

/**
 @brief      Stores reference on channel group names list on which client currently subscribed.
 @discussion This property populated only for \c operation eaqual to \b PNSubscribeOperation or
             \b PNUnsubscribeOperation.
 
 @since 4.0
 */
@property (nonatomic, readonly, copy) NSArray *channelGroups;

/**
 @brief  UUID which is currently used by client to identify user on \b PubNub service.
 
 @since 4.0
 */
@property (nonatomic, readonly, copy) NSString *uuid;

/**
 @brief      Authorization which is used to get access to protected remote resources.
 @discussion Some resources can be protected by \b PAM functionality and access done using this 
             authorization key.
 
 @since 4.0
 */
@property (nonatomic, readonly, copy) NSString *authKey;

/**
 @brief      Reference on cached client state which is used for subscribe and heartbeat requests.
 @discussion To keep bound client state on remote service client should perform "heartbeat" requests
             to keep it there.
 
 @since 4.0
 */
@property (nonatomic, readonly, copy) NSDictionary *state;

/**
 @brief  Whether status object represent error or not.
 
 @since 4.0
 */
@property (nonatomic, readonly, assign, getter = isError) BOOL error;

/**
 @brief      Stores reference on time token which has been used to establish current subscription 
             cycle.
 @discussion This property populated only for \c operation eaqual to \b PNSubscribeOperation or
             \b PNUnsubscribeOperation.
 
 @since 4.0
 */
@property (nonatomic, readonly, strong) NSNumber *currentTimetoken;

/**
 @brief      Stores reference on previous key which has been used in subscription cycle to receive
             \c currentTimetoken along with other events.
 @discussion This property populated only for \c operation eaqual to \b PNSubscribeOperation or
             \b PNUnsubscribeOperation.
 
 @since 4.0
 */
@property (nonatomic, readonly, strong) NSNumber *previousTimetoken;

/**
 @brief      Stores whether client will try to resend request associated with status or not.
 @discussion In most cases client will keep retry request sending till it won't be successful or
             canceled with \c -cancelAutomaticRetry method.

 @since 4.0
 */
@property (nonatomic, readonly, assign, getter = willAutomaticallyRetry) BOOL automaticallyRetry;


#pragma mark - Recovery

/**
 @brief      Try to resend request associated with processing status object.
 @discussion Some operations which perform automatic retry attempts will ignore method call.

 @since 4.0
 */
- (void)retry;

/**
 @brief      For some requests client try to resend them to \b PubNub for processing.
 @discussion This method can be performed only on operations which respond with \c YES on
             \c willAutomaticallyRetry property. Other operation types will ignore method call.

 @since 4.0
 */
- (void)cancelAutomaticRetry;

#pragma mark -


@end
