/**
 @author Sergey Mamontov
 @since 4.0
 @copyright © 2009-2015 PubNub, Inc.
 */
#import "PubNub+Presence.h"


#pragma mark Private interface declaration

@interface PubNub (PresencePrivate)


///------------------------------------------------
/// @name Heartbeat
///------------------------------------------------

/**
 @brief  If client configured with heartbeat value and interval client will send "heartbeat" 
         notification to \b PubNub service.
 
 @since 4.0
 */
- (void)startHeartbeatIfRequired;

#pragma mark -


@end
