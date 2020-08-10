//
//  NSObject+JSON.h
//  SuningEBuy
//
//  Created by @xzoscar
//  Copyright (c) 2016年 Suning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JSON)

/*!
 @author 徐韦, 16-03-04 14:03:34
 
 @brief Generate JSON data from a Foundation object
 
 @return A NSString instance
 
 @since 5.0
 */
- (id)JSONRepresentation;

@end


#pragma mark JSON Parsing

/// Adds JSON parsing methods to NSString
@interface NSString (JSON)

/*!
 @author 徐韦, 16-03-04 14:03:36
 
 @brief Create a Foundation object from JSON String
 
 @return return a Foundation object
 
 @since 5.0
 */
- (id)JSONValue2;

@end

/// Adds JSON parsing methods to NSData
@interface NSData (JSON)

/*!
 @author 徐韦, 16-03-04 14:03:01
 
 @brief Create a Foundation object from JSON Data
 
 @return return a Foundation object
 
 @since 5.0
 */
- (id)JSONValue2;

@end
