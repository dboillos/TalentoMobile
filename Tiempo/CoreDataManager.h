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

//Contiene todas las funcionalidades de CoreData

@interface CoreDataManager : NSObject

    +(CoreDataManager *) defaultCoreDataManager;

    @property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
    @property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
    @property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

    //Guarda el contexto para que se graban en disco los objetos que se mantengan en "Core Data"
    - (void)saveContext;

    - (NSURL *)applicationDocumentsDirectory;

    //Crea y guarda un objeto de tipo ZonaGeografica.h que contiene
    //el nombre de la zona geografica, limiteNorte, limiteSur, limiteEste y limiteOeste
    - (ZonaGeografica*)guardarEntidadGeografica: (NSDictionary*) datosEntidad;

    //Obtiene un NSArray con objetos ZonaGeografica.h con las ultimas selecciones
    //que se hicieron en la barra de busqueda
    -(NSArray*)obtenerHistorial;

@end
