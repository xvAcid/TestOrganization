//
//  StructDefs.h
//  TestOrganization
//
//  Created by xvAcid on 10/09/2017.
//
//

#import <Foundation/Foundation.h>

typedef void (^CompleteCallback)(NSArray*);

@interface Organization : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, readwrite) float latitude;
@property (nonatomic, readwrite) float longitude;
@end

@interface Vizit : NSObject
@property (nonatomic, readwrite) int id;
@property (nonatomic, readwrite) int index;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) Organization *organization;
@end
