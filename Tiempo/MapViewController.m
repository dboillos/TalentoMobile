//
//  ViewController.m
//  Tiempo
//
//  Created by David Boillos on 2/4/16.
//  Copyright © 2016 David Boillos. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController () <UISearchResultsUpdating>

@property  UISearchController *barraBusqueda;
@property  TablaResultadosTableViewController *tablaResultados;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)pulsadoBuscar:(id)sender {
    //preparo la llamada para mostrar la barra de busqueda y la tabla de resultados
    self.tablaResultados = (TablaResultadosTableViewController*)[[self storyboard] instantiateViewControllerWithIdentifier:@"TableSearchViewController"];
    self.barraBusqueda = [[UISearchController alloc] initWithSearchResultsController: self.tablaResultados];
    self.barraBusqueda.searchResultsUpdater = self;
    self.barraBusqueda.hidesNavigationBarDuringPresentation = NO;
    self.barraBusqueda.dimsBackgroundDuringPresentation = NO;
    self.definesPresentationContext = YES;
    //self.searchController.searchBar.scopeButtonTitles = @[@"Posts", @"Users", @"Subreddits"];
    [self presentViewController:self.barraBusqueda animated:YES completion:nil];
    
}

//llamada cuando se escribe en la barra de busqueda
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    printf("sdfsf");
    [self.tablaResultados.tableView reloadData];
}



@end
