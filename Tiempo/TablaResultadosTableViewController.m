//
//  TablaResultadosTableViewController.m
//  Tiempo
//
//  Created by David Boillos on 2/4/16.
//  Copyright © 2016 David Boillos. All rights reserved.
//

#import "TablaResultadosTableViewController.h"

@interface TablaResultadosTableViewController ()

    #define URL_SERVICIO_ZONAS @"http://api.geonames.org/searchJSON?q=%@&maxRows=10&startRow=0&lang=en&isNameRequired=true&style=FULL&username=ilgeonamessample"

    @property NSMutableArray *resultadoBusqueda;
    @property CoreDataManager *coreDataManager;

@end

@implementation TablaResultadosTableViewController

    - (void)viewDidLoad {
        [super viewDidLoad];
        _coreDataManager = [ CoreDataManager defaultCoreDataManager ];
    }

    -(void) viewWillAppear:(BOOL)animated{
        _resultadoBusqueda = (NSMutableArray*)[_coreDataManager obtenerHistorial];
    }


    - (void)didReceiveMemoryWarning {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
    }

#pragma mark - Table view data source

    //devolvemso el numero de filas a mostrar en la tabla
    - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return [_resultadoBusqueda count];
    }

    //tenemos que devolver al celda de la tabla. Utilizamos el identificador "cell" para la reutilizacion
    - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        cell.textLabel.text = [[_resultadoBusqueda objectAtIndex:indexPath.row] objectForKey:@"nombre"];

        return cell;
    }

#pragma mark - Table view delegate

    //captura el evento de seleccion de una fila de la tabla
    //Guardaremos la zona en el historial y lanzamos el segue
    - (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
        
        //guardamos el objeto que corresponde a la pulsación con CoreData para mostrarlo la primera que se
        //muestra la barra de busqueda a modo de historial.
        NSDictionary *datosFila = [_resultadoBusqueda objectAtIndex: [indexPath row]];
        ZonaGeografica *zonaGeografica = [_coreDataManager guardarEntidadGeografica:datosFila];
        
        [self performSegueWithIdentifier:@"irAMapViewController" sender:zonaGeografica];
        
    }


#pragma mark - UISearchResultsUpdating

    //llamada cuando se escribe en la barra de busqueda
    - (void)updateSearchResultsForSearchController:(UISearchController *)searchController
    {
        NSString *cadenaDeBusqueda = searchController.searchBar.text;
        if ([cadenaDeBusqueda length] == 0 ) {
            _resultadoBusqueda = (NSMutableArray*)[_coreDataManager obtenerHistorial];
            if ([_resultadoBusqueda count] > 0){
                searchController.searchResultsController.view.hidden = false; //para que
                //muestre la tabla
            }
                
        } else {
            [self buscarGeoName: cadenaDeBusqueda ];
        }
        
        [self.tableView reloadData];
    }


#pragma mark - Funciones Privadas

- (void)buscarGeoName:(NSString*) nombre
{
    NSLog(@"Pedimos entidades geograficas");
    // Prepare the URL that we'll get the country info data from.
    NSString *URLString = [NSString stringWithFormat:URL_SERVICIO_ZONAS, nombre];
    NSURL *url = [NSURL URLWithString:URLString];
    
    _resultadoBusqueda = [[NSMutableArray alloc] init];
    
    [Utilidades downloadDataFromURL:url withCompletionHandler:^(NSData *data) {
        // Check if any data returned.
        if (data != nil) {
            // Convert the returned data into a dictionary.
            NSError *error;
            NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            }
            else{
                NSLog(@"%@",returnedDict);
                NSArray* datos = [returnedDict objectForKey:@"geonames"];
                for (id dato in datos) {
                    NSDictionary *bbox = [dato objectForKey:@"bbox"];
                    
                    if (bbox != nil){
                        NSString *name = [dato objectForKey:@"name"];
                        NSString *limiteEste = [[bbox objectForKey:@"east"] stringValue];
                        NSString *limiteOeste = [[bbox objectForKey:@"west"] stringValue];
                        NSString *limiteSur = [[bbox objectForKey:@"south"] stringValue];
                        NSString *limiteNorte = [[bbox objectForKey:@"north"] stringValue];
                        NSDictionary *datosGeoName = @{
                                    @"nombre" : name,
                                    @"limiteEste" : limiteEste,
                                    @"limiteNorte" : limiteNorte,
                                    @"limiteSur" : limiteSur,
                                    @"limiteOeste" : limiteOeste};
                        [_resultadoBusqueda addObject:datosGeoName];
                        
                        [self.tableView reloadData];
                    }
                }
            }
        }
    }];
}

#pragma mark - Navigation

    // Le añadimos el objeto ZonaGeografica con los datos de la zona a mostrar
    - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
        [[segue destinationViewController] setValue:sender forKey:@"_zonaGeografica"];

    }


@end
