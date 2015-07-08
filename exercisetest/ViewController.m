//
//  ViewController.m
//  exercisetest
//
//  Created by Souvik on 08/07/15.
//  Copyright (c) 2015 karmick. All rights reserved.
//

#import "ViewController.h"
#import "ContainHeader.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *AllDataArry;
}
@property (weak, nonatomic) IBOutlet UITableView *AboutCanadaListtable;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *ActivitySpinn;

@end

@implementation ViewController
@synthesize AboutCanadaListtable;
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    AllDataArry=[[NSMutableArray alloc] init];
    AboutCanadaListtable.delegate=self;
    AboutCanadaListtable.dataSource=self;
    self.title=@"Facts";
    [self DownloadAboutCanadaList];
}

-(void)DownloadAboutCanadaList
{
    NSString *urlString=[NSString stringWithFormat:@"%@/facts.json",API];
    NSLog(@"The string url:%@",urlString);
    NSURL *GetUrl=[NSURL URLWithString:urlString];
    NSURLRequest *Request=[NSURLRequest requestWithURL:GetUrl];
    AFHTTPRequestOperation *FetchData = [[AFHTTPRequestOperation alloc] initWithRequest:Request];
    FetchData.responseSerializer = [AFJSONResponseSerializer serializer];
    [FetchData setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id Maindataobj)
     {
         [_ActivitySpinn stopAnimating];
       NSDictionary *aboutCanadaalldata = (NSDictionary *)Maindataobj;
       NSArray *arryList=[aboutCanadaalldata valueForKey:@"rows"];
         for (NSDictionary *dataAC in arryList)
         {
             NSMutableDictionary *DicMut=[[NSMutableDictionary alloc] init];
             NSString *titleStr=([[dataAC valueForKey:@"title"] isKindOfClass:[NSNull class]])?@"":[dataAC valueForKey:@"title"];
             NSString *Description=([[dataAC valueForKey:@"description"] isKindOfClass:[NSNull class]])?@"":[dataAC valueForKey:@"description"];
             NSString *imageUrl=([[dataAC valueForKey:@"imageHref"] isKindOfClass:[NSNull class]])?@"":[dataAC valueForKey:@"imageHref"];
             [DicMut setValue:titleStr forKey:@"title"];
             [DicMut setValue:Description forKey:@"description"];
             [DicMut setValue:imageUrl forKey:@"imageHref"];
             [AllDataArry addObject:DicMut];
             
         }
       
         [AboutCanadaListtable reloadData];
      }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
       
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving data about canada."
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    [FetchData start];
}

#pragma UITableViewDelegate and UITableViewDatasource implemantation

//Number of row method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [AllDataArry count];
}
//About canada tableview cell

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *CanadaDic=[AllDataArry objectAtIndex:indexPath.row];
    AboutCanadaTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"AboutCanada"];
    if (cell==nil)
    {
        cell=(AboutCanadaTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"AboutCanadaTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.ACImageView.image=nil;
    [cell.ACImageView setImageWithURL:[NSURL URLWithString:[CanadaDic valueForKey:@"imageHref"]] placeholderImage:[UIImage imageNamed:@"Serviceprover_noimage"]];
   
    cell.ACTitle.text=[CanadaDic valueForKey:@"title"];
    cell.ACSubTitle.text=[CanadaDic valueForKey:@"description"];
     return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
