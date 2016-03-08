//
//  TinderConstants.m
//  MatchMe
//
//  Created by Tinder Wang on 8/25/14.
//  Copyright (c) 2014 Tinder. All rights reserved.
//

#import "TinderConstants.h"

@implementation TinderConstants

#pragma mark - User Class

NSString *const kTinderUserTagLineKey                       = @"tagLine";

NSString *const kTinderUserClassNameKey                     = @"User";
NSString *const kTinderUserProfileKey                       = @"profile";
NSString *const kTinderUserProfileNameKey                   = @"name";
NSString *const kTinderUserProfileFirstNameKey              = @"first_name";
NSString *const kTinderUserProfileLocationKey               = @"location";
NSString *const kTinderUserProfileGenderKey                 = @"gender";
NSString *const kTinderUserProfileBirthdayKey               = @"birthday";
NSString *const kTinderUserProfileInterestedInKey           = @"interested_in";
NSString *const kTinderUserProfilePictureURL                = @"pictureURL";
NSString *const kTinderUserProfileRelationshipStatusKey     = @"relationshipStatus";
NSString *const kTinderUserProfileAgeKey                    = @"age";
NSString *const kTinderUserProfileObjectIdKey               = @"objectId";
NSString *const kTinderUserProfileLikeusersKey              = @"likeusers";
NSString *const kTinderUserProfileUnLikeusersKey            = @"unlikeusers";

#pragma mark - Photo Class
NSString *const kTinderPhotoClassKey                        = @"Photo";
NSString *const kTinderPhotoUserKey                         = @"user";
NSString *const kTinderPhotoPictureKey                      = @"image";


#pragma mark - Activity Class
NSString *const kTinderActivityClassKey                     = @"Activity";
NSString *const kTinderActivityTypeKey                      = @"type";
NSString *const kTinderActivityFromUserKey                  = @"fromUser";
NSString *const kTinderActivityToUserKey                    = @"toUser";
NSString *const kTinderActivityPhotoKey                     = @"photo";
NSString *const kTinderActivityTypeLikeKey                  = @"like";
NSString *const kTinderActivityTypeDislikeKey               = @"dislike";


#pragma mark - Settings
NSString *const kTinderMenEnabledKey                        = @"men";
NSString *const kTinderWomenEnabledKey                      = @"women";
NSString *const kTinderSingleEnabledKey                     = @"single";
NSString *const kTinderAgeMaxKey                            = @"ageMax";


#pragma mark - ChatRoom
NSString *const kTinderChatRoomClassKey                     = @"ChatRoom";
NSString *const kTinderChatRoomUser1Key                     = @"user1";
NSString *const kTinderChatRoomUser2Key                     = @"user2";


#pragma mark - Chat
NSString *const kTinderChatClassKey                         = @"Chat";
NSString *const kTinderChatChatRoomKey                      = @"chatRoom";
NSString *const kTinderChatFromUserKey                      = @"fromUser";
NSString *const kTinderChatToUserKey                        = @"toUser";
NSString *const kTinderChatTextKey                          = @"text";


@end
