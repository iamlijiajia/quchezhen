//
//  OrderMessageConfirmViewController.m
//  quchezhen
//
//  Created by lijiajia on 15/7/30.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import "OrderMessageConfirmViewController.h"
#import "VerifyHotelsOrderBar.h"

//
#define Tag_SetNameField        1000
#define Tag_SetTelField         2000


@interface OrderMessageConfirmViewController ()<VerifyHotelsOrderBarDelegate , UITextFieldDelegate>

@property (strong , nonatomic) UITableView *tableView;
@property (strong , nonatomic) VerifyHotelsOrderBar *orderBar;

@property (nonatomic) NSInteger priceAll;
@property (nonatomic) NSInteger daysAll;
@property (nonatomic) NSString *checkinDate;
@property (nonatomic) NSInteger maxRoomsNumber;

@end

@implementation OrderMessageConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)]; //更改header高度
    self.tableView.sectionHeaderHeight = 2;
    self.tableView.sectionFooterHeight = 2;
    
    [self.view addSubview:self.tableView];
    
    [self createVerifyOrdersBar];
}

-(void)setOrderModelArray:(NSMutableArray *)orderModelArray
{
    if (_orderModelArray != orderModelArray)
    {
        _orderModelArray = orderModelArray;
        
        if (_orderModelArray == nil)
        {
            return;
        }
        
        for (NSInteger i=0; i < _orderModelArray.count; i++)
        {
            RoomOrderCellModel *orderModel = [_orderModelArray objectAtIndex:i];
            
            if (0 == i)
            {
                self.checkinDate = orderModel.orderCheckinDate;
                self.maxRoomsNumber = orderModel.orderRoomsCount;
            }
            self.priceAll += orderModel.orderPrice * orderModel.orderRoomsCount * orderModel.durationDays;
            self.daysAll += orderModel.durationDays;
            
            if (orderModel.orderRoomsCount > self.maxRoomsNumber)
            {
                self.maxRoomsNumber = orderModel.orderRoomsCount;
            }
        }
    }
}

- (void)createVerifyOrdersBar
{
    self.orderBar = [[VerifyHotelsOrderBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 45, self.view.frame.size.width, 45)];
    self.orderBar.delegate = self;

    self.orderBar.price = self.priceAll;
    self.orderBar.daysCount = self.daysAll;
    self.orderBar.checkinDate = self.checkinDate;
    
    [self.view addSubview:self.orderBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    switch (section)
    {
        case 0:
            
            return self.maxRoomsNumber;
            
        case 1:
            return 1;
            
        default:
            break;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSString *cellIdentifier = nil;
    
    if (0 == indexPath.section)
    {
        cellIdentifier = @"setName";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        UITextField *setNameField = nil;
        if(!cell)
        {
            cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.layer.cornerRadius = 5; //设置圆角
            
            UILabel *setnamelabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 100, 40)];
            setnamelabel.backgroundColor = [UIColor clearColor];
            setnamelabel.font = [UIFont systemFontOfSize:12];
//            setnamelabel.tag = Tag_SetNameLabel;
            setnamelabel.text = @"姓名";
            [cell.contentView addSubview:setnamelabel];
            
            setNameField = [[UITextField alloc]initWithFrame:CGRectMake(120, 0, self.view.frame.size.width - 140, 40)];
            setNameField.delegate = self;
            setNameField.backgroundColor = [UIColor clearColor];
            setNameField.keyboardType = UIKeyboardTypeDefault;
            setNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
            setNameField.placeholder = @"请填写入住姓名";
            setNameField.autocorrectionType = UITextAutocorrectionTypeNo;
            setNameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            setNameField.returnKeyType = UIReturnKeyNext;
            setNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [cell.contentView addSubview:setNameField];
        }
        setNameField.tag = Tag_SetNameField + indexPath.row;
    }
    else if(1 == indexPath.section)
    {
        cellIdentifier = @"setTelNumber";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        UITextField *setTelField = nil;
        
        if(!cell)
        {
            cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.layer.cornerRadius = 5; //设置圆角
            
            UILabel *setTellabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 100, 40)];
            setTellabel.backgroundColor = [UIColor clearColor];
            setTellabel.font = [UIFont systemFontOfSize:12];
//            setTellabel.tag = Tag_SetNameLabel;
            setTellabel.text = @"联系电话";
            [cell.contentView addSubview:setTellabel];
            
            setTelField = [[UITextField alloc]initWithFrame:CGRectMake(120, 0, self.view.frame.size.width - 140, 40)];
            setTelField.backgroundColor = [UIColor clearColor];
            setTelField.delegate = self;
            setTelField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            setTelField.clearButtonMode = UITextFieldViewModeWhileEditing;
            setTelField.placeholder = @"请填写联系人电话";
            setTelField.autocorrectionType = UITextAutocorrectionTypeNo;
            setTelField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            setTelField.returnKeyType = UIReturnKeyDone;
            setTelField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [cell.contentView addSubview:setTelField];
        }
        
        setTelField.tag = Tag_SetTelField;
    }
    
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (0 == section)
    {
        return @"入住信息";
    }
    
    return nil;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (1 == section)
    {
        return @"如果您需要更改、取消订单，请提前一天拨打客服电话，与我们联系，谢谢！";
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)onVerifyOrderButtonPressed
{
    
}


#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag < Tag_SetTelField)//是姓名field
    {
        if ((textField.tag - Tag_SetNameField) == self.maxRoomsNumber - 1)//最后一个姓名填写
        {
            UITextField *field = (UITextField *)[self.tableView viewWithTag:Tag_SetTelField];
            [field becomeFirstResponder];
        }
        else
        {
            UITextField *field = (UITextField *)[self.tableView viewWithTag:textField.tag + 1]; //下一个姓名填写
            [field becomeFirstResponder];
        }
    }
    else if (textField.tag == Tag_SetTelField)
    {
        [textField resignFirstResponder];
    }
    
    return YES;
}


@end
