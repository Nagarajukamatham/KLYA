//
//  HDLocalizeHelper.h
//  NBSmartApp
//
//  Created by Yetthapu's on 16/9/17.
//  Copyright © 2017 Hexadots. All rights reserved.
//

// Use "LocalizedString(key)" the same way you would use "NSLocalizedString(key,comment)"
#define LocalizedString(key) [[HDLocalizeHelper sharedLocalSystem] localizedStringForKey:(key)]

// "language" can be (for american english): "en", "en-US", "english". Analogous for other languages.
#define LocalizationSetLanguage(language) [[HDLocalizeHelper sharedLocalSystem] setLanguage:(language)]
#define LocalizationReset [[HDLocalizeHelper sharedLocalSystem] resetLocalizeHelper]

#import <Foundation/Foundation.h>

@interface HDLocalizeHelper : NSObject

// a singleton:
+ (HDLocalizeHelper*) sharedLocalSystem;

// this gets the string localized:
- (NSString*) localizedStringForKey:(NSString*) key;

//set a new language:
- (void) setLanguage:(NSString*) lang;
- (void)resetLocalizeHelper;


@end
