//
//  ViewController.m
//  Tiempo
//
//  Created by David Boillos on 2/4/16.
//  Copyright © 2016 David Boillos. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

    //Colores con los que pintaremos el Label
    #define TEMPERATURA_MENOR_10 [UIColor colorWithRed:0.076  green:0.212  blue:0.804  alpha:1.00]
    #define TEMPERATURA_10_20  [UIColor colorWithRed: 0.618 green: 0.794 blue: 0.804 alpha: 1.00]
    #define TEMPERATURA_20_30  [UIColor colorWithRed: 0.804 green: 0.500 blue: 0.535 alpha: 1.00]
    #define TEMPERATURA_MAYOR_30 [UIColor colorWithRed: 0.804 green: 0.071 blue: 0.102 alpha: 1.00]

    #define URL_SERVICIO_TEMPERATURAS @"http://api.geonames.org/weatherJSON?north=%@&south=%@&east=%@&west=%@&username=ilgeonamessample"

    #define NO_HAY_TEMPERATURAS @"NO HAY TEMPERATURAS"

    @property  UISearchController *barraBusqueda;
    @property  TablaResultadosTableViewController *tablaResultados;
    @property NSMutableArray *resultadoBusqueda;
    @property double temperaturaMedia;

    @property (weak, nonatomic) IBOutlet UILabel *temperaturaLabel;


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
        } else {
            _temperaturaLabel.text = @"";
        }
    
        [ _mapView setShowsPointsOfInterest:NO ];
    }

    - (void)didReceiveMemoryWarning {
        [super didReceiveMemoryWarning];
    }

#pragma mark - IBAction

    //evento de pulsacion del boton buscar de la barra de navegacion
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

    //se encarga de pedir las temperaturas y las estaciones meteorologicas
    - (void)pedirTemperaturas:(ZonaGeografica*) zona
    {
        NSLog(@"Pedimos las temperaturas");
        // Prepare the URL that we'll get the country info data from.
        NSString *URLString = [NSString stringWithFormat:URL_SERVICIO_TEMPERATURAS,
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
                    //extraemos los datos que hemos recibido del json
                    NSLog(@"%@",returnedDict);
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
                    [self pintarEstacionesEnMapa];
                }
            }
        }];
    }

    //pinta las estacioens meteorologicas en el mapa, calcula la temperatura media
    //y cambia el titulo de la navegacion
    -(void) pintarEstacionesEnMapa {
        
        _temperaturaMedia = 0;
        //recorremos los resultados pintando las estaciones
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
        [self pintarLabelTemperatura];
        
        [_mapView showAnnotations:estaciones animated:YES];
        
        _navigationBar.title = [_zonaGeografica nombre];
    }

    //Pone la temperatura en _temperaturaLabel y le cambia el color
    -(void) pintarLabelTemperatura{
        if ( isnan(_temperaturaMedia) ){
            _temperaturaLabel.text = NO_HAY_TEMPERATURAS;
            return;
        }
        
        _temperaturaLabel.text =  [NSString stringWithFormat:@"%.2f grados", _temperaturaMedia];
        
        if (_temperaturaMedia < 10){
            _temperaturaLabel.backgroundColor = TEMPERATURA_MENOR_10;
        } else if (10 <= _temperaturaMedia && _temperaturaMedia < 20){
            _temperaturaLabel.backgroundColor  = TEMPERATURA_10_20;
        } else if (20 <= _temperaturaMedia && _temperaturaMedia < 30){
            _temperaturaLabel.backgroundColor = TEMPERATURA_MENOR_10;
        } else {
            _temperaturaLabel.backgroundColor = TEMPERATURA_MENOR_10;
        }
            
    }

@end
