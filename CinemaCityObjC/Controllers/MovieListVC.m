#import "MovieListVC.h"
#import "NetworkManager.h"
#import "Movie.h"
#import "MovieCell.h"

@interface MovieListVC ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> 
@property (strong, nonatomic) NSMutableArray<Movie *> *searchBarData;
@property (strong, nonatomic) NSMutableArray<Movie *> *movieList;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation MovieListVC

static NSString *cellId = @"MovieCell";
static NSString *movieURL = @"https://x-mode.co.il/exam/allMovies/allMovies.txt";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.tableFooterView = [UIView new];
    self.searchBar.delegate = self;
    [self addTouchGesture];
    [self sendRequest];
}

-(void)sendRequest {
    NetworkManager * networkManager = [[NetworkManager alloc] init];
    [networkManager request:@"GET" andURL:movieURL completion:^(NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error %@", error );
        } else {
            NSError *err;
            NSDictionary *movieJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
            
            NSMutableArray<Movie *> *movieList = NSMutableArray.new;
            for (NSDictionary *movieDict in movieJSON[@"movies"]) {
                
                NSString *name = movieDict[@"name"];
                NSString *year = movieDict[@"year"];
                NSString *category = movieDict[@"category"];
                Movie * movie = Movie.new;
                movie.name = name;
                movie.year = year;
                movie.category = category;
                [movieList addObject: movie];
            }
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"year" ascending:NO];
            [movieList sortUsingDescriptors:@[sortDescriptor]];
            self.movieList = movieList;
            self.searchBarData = [movieList copy];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.table reloadData];
            });
            if (err) {
                NSLog(@"Failed to serialize into JSON: %@", err);
                return;
            }
        }
    }];;
}


#pragma mark Keyboard Methods
-(void)dismissKeyboard {
    [self.searchBar resignFirstResponder];
}

-(void)addTouchGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}


#pragma mark TableView Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _movieList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier: cellId forIndexPath: indexPath];
    Movie *movie = self.movieList[indexPath.row];
    cell.movieName.text = movie.name;
    cell.movieYear.text = movie.year;
    cell.movieCategory.text = movie.category;
    
    return cell;
}


#pragma mark SearchBar Methods
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    NSMutableArray *removedMovies = [NSMutableArray array];
    
    if (searchText.length == 0) {
        [self.movieList removeAllObjects];
        for (id object in self.searchBarData) {
            [self.movieList addObject: object];
        }
    } else {
        for (id object in self.movieList) {
            NSInteger indexOfTheObject = [self.movieList indexOfObject: object];
            Movie *movie = self.movieList[indexOfTheObject];
            if ([movie.name containsString: searchText] == false) {
                [removedMovies addObject:object];
            }
        }
    }
    
    [self.movieList removeObjectsInArray:removedMovies];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.table reloadData];
    });
}

@end
