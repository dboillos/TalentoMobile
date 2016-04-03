//
//  ViewController.h
//  Tiempo
//
//  Created by David Boillos on 2/4/16.
//  Copyright © 2016 David Boillos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "TablaResultadosTableViewController.h"

#define METERS_PER_MILE 1609.344

@interface MapViewController : UIViewController <MKMapViewDelegate>

    @property IBOutlet MKMapView *_mapView;

    @property ZonaGeografica *_zonaGeografica;  //si no es nil mostraremos pediremos y
        //mostraremos sus datos

@end

