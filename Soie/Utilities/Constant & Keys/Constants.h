//
//  Constants.h
//  INRVU
//
//  Created by Abhishek Tyagi on 23/04/15.
//  Copyright (c) 2015 Abhishek Tyagi. All rights reserved.
//

#ifndef INRVU_Constants_h
#define INRVU_Constants_h

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

static NSString * API_BASE_URL = @"http://www.soie.in.php54-3.dfw1-2.websitetestlink.com/api/rest/";

static NSString * applicationName = @"SOIE";


#define NAVIGATE_TO_VIEW(id)           [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:(NSString *)CFSTR(#id)] animated:YES];
#define NAVIGATE_BACK [self.navigationController popViewControllerAnimated:YES];

#endif
