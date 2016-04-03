//
//  TablaResultadosTableViewController.m
//  Tiempo
//
//  Created by David Boillos on 2/4/16.
//  Copyright © 2016 David Boillos. All rights reserved.
//

#import "TablaResultadosTableViewController.h"

@interface TablaResultadosTableViewController () 

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

    - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return [_resultadoBusqueda count];
    }

    - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        cell.textLabel.text = [[_resultadoBusqueda objectAtIndex:indexPath.row] objectForKey:@"nombre"];

        return cell;
    }

#pragma mark - Table view delegate

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
    NSString *URLString = [NSString stringWithFormat:@"http://api.geonames.org/searchJSON?q=%@&maxRows=10&startRow=0&lang=en&isNameRequired=true&style=FULL&username=ilgeonamessample", nombre];
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [[segue destinationViewController] setValue:sender forKey:@"_zonaGeografica"];

}


@end
