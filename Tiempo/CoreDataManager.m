//
//  CoreDataUtil.m
//  Ej18_CoreData
//
//  Created by Profesortarde on 25/09/15.
//  Copyright (c) 2015 Profesortarde. All rights reserved.
//

#import "CoreDataManager.h"


@implementation CoreDataManager

//singleton/////////////
static CoreDataManager *_instancia;

+(CoreDataManager *) defaultCoreDataManager{
    if( _instancia == nil ){
        _instancia = [ [ CoreDataManager alloc ] init ];
    }
    return _instancia;
}


@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel   = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

-(id) init{
    if( _instancia == nil){
        if( self = [super init ]){
            _instancia = self;
        }
    }
    return _instancia;
}

- (void)guardarEntidadGeografica: (NSDictionary*) datosEntidad{
    ZonaGeografica *entidadGeografica = [NSEntityDescription insertNewObjectForEntityForName:@"ZonaGeografica" inManagedObjectContext: [self managedObjectContext] ];
    [entidadGeografica setNombre: [datosEntidad objectForKey:@"nombre"]];
    /*[entidadGeografica setLimiteNorte: [datosEntidad objectForKey:@"limiteNorte"]];
    [entidadGeografica setLimiteSur: [datosEntidad objectForKey:@"limiteSur"]];
    [entidadGeografica setLimiteEste: [datosEntidad objectForKey:@"limiteEste"]];
    [entidadGeografica setLimiteOeste: [datosEntidad objectForKey:@"limiteOeste"]];*/
     
}

-(NSArray*)obtenerHistorial{

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ZonaGeografica"];
    
    NSError *error = nil;
    NSArray *zonasGeograficas = [[self managedObjectContext] executeFetchRequest:request error:&error];
    if (!zonasGeograficas) {
        NSLog(@"Error fetching Employee objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    
    //metemos los datos en un array con NSDictionary con los datos porque asi es mas facil
    //usarlo en el TableView
    NSMutableArray *resultados = [[NSMutableArray alloc] init];
    for (id zonaGeografica in zonasGeograficas) {
        NSDictionary *datos = @{
                                       @"nombre" : [zonaGeografica nombre],
                                      /* @"limiteEste" : [bbox objectForKey:@"east"],
                                       @"limiteNorte" : [bbox objectForKey:@"north"],
                                       @"limiteSur" : [bbox objectForKey:@"south"],
                                       @"limiteOeste" : [bbox objectForKey:@"west"]*/
                                       };
        [ resultados addObject:datos ];
    }
    
    return resultados;
}


#pragma mark - Core Data stack

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.talentomobile.Tiempo" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Tiempo" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Tiempo.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}



@end





