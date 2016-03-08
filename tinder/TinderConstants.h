//
//  TinderConstants.h
//  MatchMe
//
//  Created by Tinder Wang on 8/25/14.
//  Copyright (c) 2014 Tinder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TinderConstants : NSObject

#pragma mark - User Class

extern NSString *const kTinderUserTagLineKey;

extern NSString *const kTinderUserClassNameKey;
extern NSString *const kTinderUserProfileKey;
extern NSString *const kTinderUserProfileNameKey;
extern NSString *const kTinderUserProfileFirstNameKey;
extern NSString *const kTinderUserProfileLocationKey;
extern NSString *const kTinderUserProfileGenderKey;
extern NSString *const kTinderUserProfileBirthdayKey;
extern NSString *const kTinderUserProfileInterestedInKey;
extern NSString *const kTinderUserProfilePictureURL;
extern NSString *const kTinderUserProfileRelationshipStatusKey;
extern NSString *const kTinderUserProfileAgeKey;
extern NSString *const kTinderUserProfileObjectIdKey;
extern NSString *const kTinderUserProfileLikeusersKey;
extern NSString *const kTinderUserProfileUnLikeusersKey;


#pragma mark - Photo Class
extern NSString *const kTinderPhotoClassKey;
extern NSString *const kTinderPhotoUserKey;
extern NSString *const kTinderPhotoPictureKey;


#pragma mark - Activity Class
extern NSString *const kTinderActivityClassKey;
extern NSString *const kTinderActivityTypeKey;
extern NSString *const kTinderActivityFromUserKey;
extern NSString *const kTinderActivityToUserKey;
extern NSString *const kTinderActivityPhotoKey;
extern NSString *const kTinderActivityTypeLikeKey;
extern NSString *const kTinderActivityTypeDislikeKey;


#pragma mark - Settings
extern NSString *const kTinderMenEnabledKey;
extern NSString *const kTinderWomenEnabledKey;
extern NSString *const kTinderSingleEnabledKey;
extern NSString *const kTinderAgeMaxKey;


#pragma mark - ChatRoom
extern NSString *const kTinderChatRoomClassKey;
extern NSString *const kTinderChatRoomUser1Key;
extern NSString *const kTinderChatRoomUser2Key;


#pragma mark - Chat
extern NSString *const kTinderChatClassKey;
extern NSString *const kTinderChatChatRoomKey;
extern NSString *const kTinderChatFromUserKey;
extern NSString *const kTinderChatToUserKey;
extern NSString *const kTinderChatTextKey;



@end
