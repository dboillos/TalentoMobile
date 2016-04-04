//
//  ZonaGeografica.h
//  Tiempo
//
//  Created by David Boillos on 3/4/16.
//  Copyright © 2016 David Boillos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZonaGeografica : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

    //Devuelve una representacion en NSDictionary de los atributos
    -(NSDictionary*) toDictionary;

@end

NS_ASSUME_NONNULL_END

#import "ZonaGeografica+CoreDataProperties.h"
