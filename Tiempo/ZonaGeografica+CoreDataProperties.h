//
//  ZonaGeografica+CoreDataProperties.h
//  Tiempo
//
//  Created by David Boillos on 3/4/16.
//  Copyright © 2016 David Boillos. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ZonaGeografica.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZonaGeografica (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *nombre;
@property (nullable, nonatomic, retain) NSString *limiteNorte;
@property (nullable, nonatomic, retain) NSString *limiteSur;
@property (nullable, nonatomic, retain) NSString *limiteEste;
@property (nullable, nonatomic, retain) NSString *limiteOeste;

@end

NS_ASSUME_NONNULL_END
