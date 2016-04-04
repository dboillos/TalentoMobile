//
//  ServicioGeoNames.h
//  Tiempo
//
//  Created by David Boillos on 3/4/16.
//  Copyright © 2016 David Boillos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

//Contiene metodos de utilidades

@interface Utilidades : NSObject

    //Abre un hilo con la petición de la URL que se le pasa
    //al finaliza ejecuta el bloque de codigo que se le pasa en completionHandler
    //ejecuta el codigo que se le
    +(void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSData *))completionHandler;

@end
