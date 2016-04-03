//
//  ZonaGeografica.m
//  Tiempo
//
//  Created by David Boillos on 3/4/16.
//  Copyright © 2016 David Boillos. All rights reserved.
//

#import "ZonaGeografica.h"

@implementation ZonaGeografica

// Insert code here to add functionality to your managed object subclass

-(NSDictionary*) toDictionary{
    NSDictionary *representacion = @{
                                     @"nombre" : [self nombre],
                                      @"limiteEste" : [self limiteEste],
                                      @"limiteNorte" : [self limiteNorte],
                                      @"limiteSur" : [self limiteSur],
                                      @"limiteOeste" : [self limiteOeste]
                                     };
    return representacion;
}

@end
