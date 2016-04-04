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


@interface MapViewController : UIViewController <MKMapViewDelegate>

    @property IBOutlet MKMapView *_mapView;
    @property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;

    @property ZonaGeografica *_zonaGeografica;  //si no es nil pediremos y
        //mostraremos sus datos en el mapa y en el Label de temperatura

@end

