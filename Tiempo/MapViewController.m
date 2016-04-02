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

    @synthesize _mapView;

    - (void)viewDidLoad {
        [super viewDidLoad];
    }

    - (void)viewWillAppear:(BOOL)animated
    {
        [super viewWillAppear:animated];
        
        CLLocationCoordinate2D zoomLocation;
        zoomLocation.latitude = 39.281516;
        zoomLocation.longitude= -76.580806;
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
        MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
        [_mapView setRegion:adjustedRegion animated:YES];
        
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
        printf("actualiza");
        [self.tablaResultados.tableView reloadData];
    }



@end
