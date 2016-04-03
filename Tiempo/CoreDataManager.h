//
//  CoreDataUtil.h
//  Ej18_CoreData
//
//  Created by Profesortarde on 25/09/15.
//  Copyright (c) 2015 Profesortarde. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ZonaGeografica.h"

@interface CoreDataManager : NSObject

+(CoreDataManager *) defaultCoreDataManager;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (ZonaGeografica*)guardarEntidadGeografica: (NSDictionary*) datosEntidad;
-(NSArray*)obtenerHistorial;

@end
