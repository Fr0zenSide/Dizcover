//
//  DZRArtistSearchViewController.m
//  DeezerExercice
//  Copyright (c) 2015 Deezer. All rights reserved.
//

#import "DZRArtistSearchViewController.h"
#import "DZRArtistCollectionViewCell.h"

@interface DZRArtistSearchViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *artists;

@end

@implementation DZRArtistSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    User *myUser = [[User alloc] init:@"Jeoffrey"];
    NSLog(@"myUser: %@", myUser);
    
    // fixme: if the next line doesn't work, we need to rename all id properties on swift by objectId
    NSLog(@"Have you a problem with that? %@", myUser.id);
    
    NSDictionary *dict = @{ @"id": [NSString stringWithFormat:@"%f-hi", CACurrentMediaTime()],
                           @"name": @"lilo",
                           @"photo": @"-" };
    User *littleUser = [[User alloc] initWithJson:dict];
    NSLog(@"littleUser: %@", littleUser);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma - Search

- (void)searchArtistsWithName:(NSString *)name {
    NSString *urlRequest = [NSString stringWithFormat:@"https://api.deezer.com/search?q=%@", name];
    NSURLRequest *apiRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlRequest]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:apiRequest
                          completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                              
                              if (error != nil) {
                                  NSLog(@"Error! We haven't received data for the artist named: %@", name);
                                  return;
                              }
                              if (data != nil) {
                                  NSError *e;
                                  NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&e];
                                  if (e != nil) {
                                      NSLog(@"Error! Parsing data error... for the artist named: %@", name);
                                      return;
                                  }
                                  
                                  NSLog(@"json: %@", json);
                                  // todo: need to create a typed object for the artists
                                  NSLog(@"%@", [json objectForKey:@"data"]);
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      self.artists = [json objectForKey:@"data"];
                                      [self.collectionView reloadData];
                                  });
                              }
                          }];
    [task resume];
}

#pragma - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self searchArtistsWithName:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

#pragma - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.artists.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ArtistCollectionViewCellIdentifier";

    DZRArtistCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary *artistDictionary = [self.artists objectAtIndex:indexPath.row];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[artistDictionary objectForKey:@"picture"]]];
    cell.artistImage.image = [UIImage imageWithData:imageData];
    cell.artistName.text = [artistDictionary objectForKey:@"name"];
    return cell;
}

@end
