//
//  ViewController.m
//  Tiempo
//
//  Created by David Boillos on 2/4/16.
//  Copyright © 2016 David Boillos. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController () 

    @property  UISearchController *barraBusqueda;
    @property  TablaResultadosTableViewController *tablaResultados;
    @property NSMutableArray *resultadoBusqueda;
    @property double temperaturaMedia;

@end

@implementation MapViewController

    @synthesize _mapView;
    @synthesize _zonaGeografica;

    - (void)viewDidLoad {
        [super viewDidLoad];
    }

    - (void)viewWillAppear:(BOOL)animated
    {
        [super viewWillAppear:animated];
        
        
        if (_zonaGeografica != nil){
            //tenemos datos para pintar
            [self pedirTemperaturas:_zonaGeografica];
        } /*else {
            CLLocationCoordinate2D zoomLocation;
            zoomLocation.latitude = 40.416775;
            zoomLocation.longitude= -3.703789;
            
            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 500, 500);
            
            MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
            [ _mapView setRegion:adjustedRegion animated:YES];
        }*/
    
    
        [ _mapView setShowsPointsOfInterest:NO ];
    }

    - (void)didReceiveMemoryWarning {
        [super didReceiveMemoryWarning];
    }

#pragma mark - IBAction

    - (IBAction)pulsadoBuscar:(id)sender {
        //preparo la llamada para mostrar la barra de busqueda y la tabla de resultados
        self.tablaResultados = (TablaResultadosTableViewController*)[[self storyboard] instantiateViewControllerWithIdentifier:@"TableSearchViewController"];
        self.barraBusqueda = [[UISearchController alloc] initWithSearchResultsController: self.tablaResultados];
        self.barraBusqueda.searchResultsUpdater = self.tablaResultados;
        self.barraBusqueda.hidesNavigationBarDuringPresentation = NO;
        self.barraBusqueda.dimsBackgroundDuringPresentation = NO;
        [self presentViewController:self.barraBusqueda animated:YES completion:nil];
        
    }

#pragma mark - Metodos privados

- (void)pedirTemperaturas:(ZonaGeografica*) zona
{
    NSLog(@"Pedimos las temperaturas");
    // Prepare the URL that we'll get the country info data from.
    NSString *URLString = [NSString stringWithFormat:@"http://api.geonames.org/weatherJSON?north=%@&south=%@&east=%@&west=%@&username=ilgeonamessample",
                           [zona limiteNorte],
                           [zona limiteSur],
                           [zona limiteEste],
                           [zona limiteOeste]];
    NSURL *url = [NSURL URLWithString:URLString];
    
    _resultadoBusqueda = [[NSMutableArray alloc] init];
    
    [Utilidades downloadDataFromURL:url withCompletionHandler:^(NSData *data) {
        if (data != nil) {
            NSError *error;
            NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            }
            else{
                
                NSArray *datos = [returnedDict objectForKey:@"weatherObservations"];
                for (id dato in datos) {
                    NSNumber *latitud = [dato objectForKey:@"lat"];
                    NSNumber *longitud = [dato objectForKey:@"lng"];
                    NSString *temperatura = [dato objectForKey:@"temperature"] ;
                    NSDictionary *datosTemperatura = @{
                                                   @"longitud" : longitud,
                                                   @"latitud" : latitud,
                                                   @"temperatura" : temperatura
                                                   };
                    [_resultadoBusqueda addObject:datosTemperatura];
                }
                NSLog(@"%@",_resultadoBusqueda);
                [self pintarEstacionesEnMapa];
            }
        }
    }];
}

-(void) pintarEstacionesEnMapa {
    
    _temperaturaMedia = 0;
    NSMutableArray *estaciones = [[NSMutableArray alloc]init];
    for (NSDictionary* estacion in _resultadoBusqueda) {
        NSNumber * latitud = [estacion objectForKey:@"latitud"];
        NSNumber * longitud = [estacion objectForKey:@"longitud"];
        NSString * temperatura = [estacion objectForKey:@"temperatura"];
        _temperaturaMedia = _temperaturaMedia + [temperatura doubleValue];
        
        CLLocationCoordinate2D coordenadas;
        coordenadas.latitude = [latitud doubleValue];
        coordenadas.longitude = [longitud doubleValue];
        
        MKPointAnnotation *anotacion = [[ MKPointAnnotation alloc ] init];
        [ anotacion setCoordinate:coordenadas ];
        [ anotacion setTitle: [NSString stringWithFormat:@"Temperatura: %@", temperatura] ];
        [estaciones addObject:anotacion];
    }
    _temperaturaMedia = _temperaturaMedia / [_resultadoBusqueda count];
    
    [_mapView showAnnotations:estaciones animated:YES];
}



@end
