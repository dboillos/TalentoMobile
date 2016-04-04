//
//  ServicioGeoNames.m
//  Tiempo
//
//  Created by David Boillos on 3/4/16.
//  Copyright © 2016 David Boillos. All rights reserved.
//

#import "Utilidades.h"


@implementation Utilidades


#pragma mark - Funciones estaticas

//Para lanzar un hilo con la busqueda
+(void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSData *))completionHandler{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    // Creamos el hilo
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else{
            NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
            
            if (HTTPStatusCode != 200) {
                NSLog(@"HTTP status code = %ld", (long)HTTPStatusCode);
            }
            
            // Completado, ejecutamos el codigo que nos pasen
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                completionHandler(data);
            }];
        }
    }];
    
    // Arrancamos el hilo
    [task resume];
}



@end
