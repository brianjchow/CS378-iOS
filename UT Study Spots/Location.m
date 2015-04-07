//
//  Location.m
//  UT Study Spots
//
//  Created by Fatass on 3/27/15.
//  Copyright (c) 2015 Fatass. All rights reserved.
//

#import "Location.h"

#import "Constants.h"
#import "Utilities.h"

#import "NSString+Tools.h"

@interface Location ()
    @property (strong, nonatomic) NSString *building;
    @property (strong, nonatomic) NSString *room;
@end

@implementation Location

- (instancetype) initFullyQualified : (NSString *) building_room {
    if (!building_room) {
        // TODO - throw exception
    }
    
    self = [super init];
    
    if (self) {
        NSArray *split = [building_room componentsSeparatedByString : @" "];
        
        if ([split count] < 2) {
            self.building = GDC;
            self.room = DEFAULT_GDC_LOCATION;
        }
        else {
            self.building = split[0];
            self.room = split[1];
        }
        
    }
    
    return self;
}

- (instancetype) initSeparated : (NSString *) building room : (NSString *) room {
    if (!building || [building isEqual : [NSNull class]]) {
        building = GDC;
    }
    if (!room || [room isEqual : [NSNull class]]) {
        room = DEFAULT_GDC_LOCATION;
    }
    
    self = [super init];
    
    if (self) {
        self.building = building;
        self.room = room;
    }
    
    return self;
}

- (NSString *) get_building {
    return self.building;
}

- (NSString *) get_room {
    return self.room;
}

- (id) copy {
//    Location *out = [[Location alloc] initSeparated : [self.building copy] room : [self.room copy]];
//    return out;
    
    return self;
}

// http://stackoverflow.com/questions/4089238/implementing-nscopying
- (id) copyWithZone : (NSZone *) zone {
//    Location *out = [[[self class] allocWithZone : zone] init];
//    
//    if (out) {
//        out.building = [self.building copyWithZone : zone];
//        out.room = [self.room copyWithZone : zone];
//    }
//    
//    return out;
    
    return self;
}

- (NSComparisonResult) compare : (Location *) otherObject {
    // return either NSOrderedAscending (this < other), NSOrderedSame, NSOrderedDescending (this > other)
    
    return [[self toString] compare : [otherObject toString]];
}

- (BOOL) isEqual : (id) other {
    
    if (self == other) {
        return YES;
    }
    
    if (![other isKindOfClass : [Location class]]) {
        return NO;
    }
    
    Location *other_location = (Location *) other;
//    if (![self.building isEqualToString : other_location.building] ||
//        ![self.room isEqualToString : other_location.room]) {
//        return NO;
//    }
    
//    NSLog(@"COMPARING %@ to %@", [self toString], [other_location toString]);
    
    if ([self compare : other_location] != NSOrderedSame) {
        return NO;
    }
    
    return YES;
}

- (NSUInteger) hash {
    return ([[self toString] hash] * [self.building hash] * 17 * [self.room hash] * 37);
}

- (NSString *) toString {
    if (!self.building || !self.room) {
        // TODO - throw ISException
    }
    
    return [NSString stringWithFormat : @"%@ %@", self.building, self.room];
}

- (NSString *) description {
    return [self toString];
}

@end






