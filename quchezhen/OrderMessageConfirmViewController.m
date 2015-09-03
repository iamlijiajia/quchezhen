//
//  OrderMessageConfirmViewController.m
//  quchezhen
//
//  Created by lijiajia on 15/7/30.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import "OrderMessageConfirmViewController.h"
#import "VerifyHotelsOrderBar.h"
#import "BookRoomViewCellDataModel.h"
#import "PayMethodViewController.h"
#import "WBAlertView.h"
#import "BCPay.h"
#import "OwnerViewController.h"
#import "OrderMessageTableViewCell.h"
#import "UIView+Utilities.h"


#define Tag_SetNameField        1000
#define Tag_SetTelField         2000


@interface OrderMessageConfirmViewController ()<VerifyHotelsOrderBarDelegate , UITextFieldDelegate , BCApiDelegate, UIActionSheetDelegate>

@property (strong , nonatomic) UITableView *tableView;
@property (strong , nonatomic) VerifyHotelsOrderBar *orderBar;

@property (nonatomic , strong) RoomOrdersDataModel *dataModel;

@property (nonatomic , strong) BmobObject *routeObject;
@property (nonatomic , strong) NSArray *orderList;

@property (nonatomic , strong) NSString *TelNumber;
@property (nonatomic , strong) NSMutableArray *checkinNamesArray;

@property (nonatomic , strong) NSMutableArray *cellArray;

@property (nonatomic , strong) UITextField *currentTextField;

@property (nonatomic) CGFloat keyboardHeight;

@end

@implementation OrderMessageConfirmViewController

- (id)initWithDataModel:(RoomOrdersDataModel *)model
{
    self = [super init];
    if (self)
    {
        self.dataModel = model;
    }
    
    return self;
}

- (id)initToCheckOrderListWithRouteObject:(BmobObject *)routeObject
{
    self = [super init];
    if (self)
    {
        self.routeObject = routeObject;
    }
    
    return self;
}

- (id)initWithOrderList:(NSArray *)orderlist
{
    self = [super init];
    if (self)
    {
        self.orderList = orderlist;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.dataModel)
    {
        [self setupWithDataModel];
    }
    else if(self.routeObject || self.orderList)
    {
        [self setupToCheckOrderList];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)setupWithDataModel
{
    self.title = @"信息填写";
    self.keyboardHeight = 0;
    
    [self createHotelCell];
    [self createTableView];
    [self createVerifyOrdersBar];
    
    [BCPay setBCApiDelegate:self];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewPressed:)];
    [self.view addGestureRecognizer:recognizer];
}

- (void)setupToCheckOrderList
{
    self.title = @"订单信息";
    
    if (self.routeObject && !self.orderList)
    {
        [self queryOrderList];
    }
    else if(self.orderList)
    {
        [self queryOrderItems];
    }
    
    [self createTableView];
}

- (void)queryOrderList
{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Order"];
    [query whereKey:@"route" equalTo:self.routeObject];
    [query whereKey:@"customer_user" equalTo:[BmobUser getCurrentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        self.orderList = array;
        [self queryOrderItems];
    }];
}

- (void)queryOrderItems
{
    if (self.orderList.count)
    {
        if (self.orderList.count > 1)
        {
            UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"下一个" style:UIBarButtonItemStylePlain target:self action:@selector(nextOrderMessage:)];
            self.navigationItem.rightBarButtonItem = rightButton;
        }
        
        BmobObject *order = [self.orderList objectAtIndex:0];
        self.TelNumber = [order objectForKey:@"Tel"];
        self.checkinNamesArray = [order objectForKey:@"checkinNamesArray"];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        
        BmobQuery *query = [BmobQuery queryWithClassName:@"OrderItem"];
        [query whereKey:@"rootOrder" equalTo:order];
        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            for (BmobObject *orderItem in array)
            {
                NSString *hotelName = [orderItem objectForKey:@"hotelName"];
                NSMutableArray *itemsArray = [dic objectForKey:hotelName];
                if (itemsArray)
                {
                    [itemsArray addObject:orderItem];
                }
                else
                {
                    itemsArray = [[NSMutableArray alloc] init];
                    [itemsArray addObject:orderItem];
                    [dic setObject:itemsArray forKey:hotelName];
                }
            }
            
            [self createHotelCellWithDictionaryWithOrderItemsArray:dic];
            
            [self.tableView reloadData];
        }];
    }
}

- (void)createHotelCell
{
    self.cellArray = [[NSMutableArray alloc] init];
    for (BookRoomViewCellDataModel *model in self.dataModel.cellWithOrderHotelsArray)
    {
        if (model.orderRoomsCount)
        {
            OrderMessageTableViewCell *cell = [[OrderMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"orderMessageCell"];
            [cell configureCellDataModel:model andWidth:self.view.frame.size.width];
            
            [self.cellArray addObject:cell];
        }
    }
}

- (void)createHotelCellWithDictionaryWithOrderItemsArray:(NSDictionary *)dic
{
    self.cellArray = [[NSMutableArray alloc] init];
    for (NSString *hotelName in [dic allKeys])
    {
        OrderMessageTableViewCell *cell = [[OrderMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"orderMessageCell"];
        [cell configureCellWithOrderItems:[dic objectForKey:hotelName] andWidth:self.view.frame.size.width];
        
        [self.cellArray addObject:cell];
    }
}

- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 45)]; //更改header高度
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 2;
    
    [self.view addSubview:self.tableView];
    
}

- (void)createVerifyOrdersBar
{
    self.orderBar = [[VerifyHotelsOrderBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 45, self.view.frame.size.width, 45)];
    self.orderBar.delegate = self;
    
    self.orderBar.price = self.dataModel.orderPrice;
    self.orderBar.daysCount = self.dataModel.durationDays;
    self.orderBar.checkinDate = self.dataModel.orderCheckinDate;
    
    self.orderBar.verifyButtonImage = [UIImage imageNamed:@"foot-btn-send-ready.png"];
    
    [self.view addSubview:self.orderBar];
}

- (void)onViewPressed:(id)sender
{
    for (int i = 0; i < self.dataModel.orderRoomsCount; i++)
    {
        UITextField *field = (UITextField *)[self.tableView viewWithTag:Tag_SetNameField + i];
        if (field)
        {
            [field resignFirstResponder];
        }
    }
    
    UITextField *field = (UITextField *)[self.tableView viewWithTag:Tag_SetTelField];
    if (field)
    {
        [field resignFirstResponder];
    }
}

- (void)nextOrderMessage:(id)sender
{
    NSMutableArray *items = [NSMutableArray arrayWithArray:self.orderList];
    [items removeObjectAtIndex:0];
    
    OrderMessageConfirmViewController *next = [[OrderMessageConfirmViewController alloc] initWithOrderList:items];
    [self.navigationController pushViewController:next animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    switch (section)
    {
        case 0:
            return self.cellArray.count;
        case 1:
        {
            if (self.dataModel)
            {
                return self.dataModel.orderRoomsCount;
            }
            else if (self.routeObject || self.orderList)
            {
                return self.checkinNamesArray.count;
            }
        }
            
        case 2:
            return 1;
            
        default:
            break;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSString *cellIdentifier = @"cellIdentifier";
    if (0 == indexPath.section)
    {
        cell = [self.cellArray objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (1 == indexPath.section)
    {
        cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.cornerRadius = 5; //设置圆角
        
        UILabel *setnamelabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 100, 40)];
        setnamelabel.backgroundColor = [UIColor clearColor];
        setnamelabel.font = [UIFont systemFontOfSize:12];
        setnamelabel.text = @"姓名";
        [cell.contentView addSubview:setnamelabel];
        
        UITextField *setNameField = [[UITextField alloc]initWithFrame:CGRectMake(120, 0, self.view.frame.size.width - 140, 40)];
        setNameField.delegate = self;
        setNameField.backgroundColor = [UIColor clearColor];
        setNameField.keyboardType = UIKeyboardTypeDefault;
        setNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        setNameField.autocorrectionType = UITextAutocorrectionTypeNo;
        setNameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        setNameField.returnKeyType = UIReturnKeyNext;
        setNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        [cell.contentView addSubview:setNameField];
        if (self.dataModel)
        {
            setNameField.placeholder = @"请填写入住姓名";
        }
        else
        {
            if (self.checkinNamesArray.count > indexPath.row) {
                setNameField.text = [self.checkinNamesArray objectAtIndex:indexPath.row];
            }
            setNameField.userInteractionEnabled = NO;
        }
        setNameField.tag = Tag_SetNameField + indexPath.row;
    }
    else if(2 == indexPath.section)
    {
        cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.cornerRadius = 5; //设置圆角
        
        UILabel *setTellabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 100, 40)];
        setTellabel.backgroundColor = [UIColor clearColor];
        setTellabel.font = [UIFont systemFontOfSize:12];
        setTellabel.text = @"联系电话";
        [cell.contentView addSubview:setTellabel];
        
        UITextField *setTelField = [[UITextField alloc]initWithFrame:CGRectMake(120, 0, self.view.frame.size.width - 140, 40)];
        setTelField.delegate = self;
        setTelField.backgroundColor = [UIColor clearColor];
        setTelField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        setTelField.clearButtonMode = UITextFieldViewModeWhileEditing;
        setTelField.autocorrectionType = UITextAutocorrectionTypeNo;
        setTelField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        setTelField.returnKeyType = UIReturnKeyDone;
        setTelField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        [cell.contentView addSubview:setTelField];
        if (self.dataModel)
        {
            setTelField.placeholder = @"请填写联系人电话";
        }
        else
        {
            setTelField.text = self.TelNumber;
            setTelField.userInteractionEnabled = NO;
        }
        setTelField.tag = Tag_SetTelField;
    }
    
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (1 == section)
    {
        return @"入住个人信息";
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (2 == section)
    {
        return @"如果您需要更改、取消订单，请提前一天拨打客服电话，与我们联系，谢谢！";
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        UITableViewCell *cell = [self.cellArray objectAtIndex:indexPath.row];
        return cell.frame.size.height;
    }
    
    return 40;
}


- (void)onVerifyOrderButtonPressed
{
    if ([self textFieldBeFinished])
    {
        NSString *title = [NSString stringWithFormat:@"共需支付: %ld 元",(long)self.dataModel.orderPrice];
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信支付",@"支付宝支付", nil];
        
        [sheet showInView:self.view];
    }
    else
    {
        
    }
    
//    PayMethodViewController *viewController = [[PayMethodViewController alloc] initWithDataModel:self.dataModel];
//    [self.navigationController pushViewController:viewController animated:YES];
    
}

- (BOOL)textFieldBeFinished
{
    self.checkinNamesArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.dataModel.orderRoomsCount; i++)
    {
        UITextField *field = (UITextField *)[self.tableView viewWithTag:Tag_SetNameField + i];
        if (!field || !field.text.length)
        {
            [self showAlertView:@"请完善行程信息，谢谢！"];
            
            return NO;
        }
        else
        {
            [self.checkinNamesArray addObject:field.text];
        }
    }
    
    UITextField *field = (UITextField *)[self.tableView viewWithTag:Tag_SetTelField];
    if (!field || field.text.length < 11)
    {
        [self showAlertView:@"联系人电话号码有误"];
        return NO;
    }
    else
    {
        self.TelNumber = field.text;
        BOOL ismatch = [self checkTel:self.TelNumber];
        if (ismatch)
        {
            return YES;
        }
        else
        {
            [self showAlertView:@"联系人电话号码有误"];
            return NO;
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"value",@"key", nil];
    
    BCPayReq *payReq = [[BCPayReq alloc] init];
    payReq.title = self.dataModel.routeName;
    payReq.totalfee = [NSString stringWithFormat:@"%d" , self.dataModel.orderPrice *100];
    payReq.billno = [self genOutTradeNo];
    payReq.viewController = self;
    payReq.optional = dict;
    
    switch (buttonIndex)
    {
        case 0:
            payReq.channel = WX;
            [BCPay sendBCReq:payReq];
            break;
        case 1:
            payReq.channel = Ali;
            payReq.scheme = @"cn.quchezhen.quzijia.aliPay";
            [BCPay sendBCReq:payReq];
            break;
//        case 2: //测试
//            [self makeOrderAfterPayment:NO];
//            break;
        default:
            break;
    }
}

- (void)onBCPayResp:(BCBaseResp *)resp {
    if ([resp isKindOfClass:[BCQueryResp class]])
    {
        if (resp.result_code == 0)
        {
            BCQueryResp *tempResp = (BCQueryResp *)resp;
            if (tempResp.count == 0)
            {
                [self showAlertView:@"未找到相关订单信息"];
            }
            else
            {
                [self performSegueWithIdentifier:@"queryResult" sender:self];
            }
        }
    }
    else
    {
        if (resp.result_code == 0) {
            [self makeOrderAfterPayment:NO];
        } else {
            [self showAlertView:resp.err_detail];
        }
    }
}


- (void)showAlertView:(NSString *)msg {
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)makeOrderAfterPayment:(BOOL)isRetry
{
    BmobObject *order = [BmobObject objectWithClassName:@"Order"];
    
    [order setObject:[NSNumber numberWithBool:isRetry] forKey:@"isRetry"];
    [order setObject:self.dataModel.routeName forKey:@"routeName"];
    [order setObject:[NSString stringWithFormat:@"%ld" , (long)self.dataModel.orderPrice] forKey:@"orderPrice"];
    [order setObject:self.TelNumber forKey:@"Tel"];
    [order setObject:self.dataModel.orderCheckinDate forKey:@"orderCheckinDate"];
    [order setObject:self.dataModel.orderCheckoutDate forKey:@"orderCheckoutDate"];
    [order setObject:self.checkinNamesArray forKey:@"checkinNamesArray"];
    [order setObject:self.dataModel.bmobRouteObject forKey:@"route"];
    [order setObject:[BmobUser getCurrentUser] forKey:@"customer_user"];
    
    OrderMessageConfirmViewController *blockself = self;
    __block BOOL saveOK = YES;
    [order saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful)
        {
            BmobUser *currentUser = [BmobUser getCurrentUser];
            
            BmobRelation *customerList = [[BmobRelation alloc] init];
            [customerList addObject:currentUser];
            [self.dataModel.bmobRouteObject addRelation:customerList forKey:@"customerList"];
            [self.dataModel.bmobRouteObject updateInBackground];
            
            BmobRelation *orderRoute = [[BmobRelation alloc] init];
            [orderRoute addObject:self.dataModel.bmobRouteObject];
            [currentUser addRelation:orderRoute forKey:@"orderRoute"];
            
            BmobRelation *orderRelation = [[BmobRelation alloc] init];
            [orderRelation addObject:order];
            [currentUser addRelation:orderRelation forKey:@"orderList"];
            
            [currentUser updateInBackground];
            
            __block NSInteger index = 0;
            __block NSInteger count = 0;
            
            for (NSInteger i = 0; i < self.dataModel.CitiesCellViewModelArray.count ; i++)
            {
                BookRoomViewCellDataModel *cityModel = [self.dataModel.CitiesCellViewModelArray objectAtIndex:i];
                
                for (NSInteger j = 0; j < cityModel.orderHotelInfo.roomCardDataArray.count; j++)
                {
                    RoomCardDataModel *roomModel = [cityModel.orderHotelInfo.roomCardDataArray objectAtIndex:j];
                    
                    if (roomModel.roomsCount)
                    {
                        count++;
                        
                        BmobObject *orderItem = [BmobObject objectWithClassName:@"OrderItem"];
                        
                        [orderItem setObject:cityModel.orderCheckinDate forKey:@"orderCheckinDate"];
                        [orderItem setObject:cityModel.orderEndDate forKey:@"orderEndDate"];
                        
                        [orderItem setObject:cityModel.orderHotelInfo.hotelName forKey:@"hotelName"];
                        [orderItem setObject:cityModel.orderHotelInfo.hotelTel forKey:@"hotelTel"];
                        [orderItem setObject:cityModel.orderHotelInfo.hotelLocation forKey:@"hotelLocation"];
                        [orderItem setObject:roomModel.roomType forKey:@"roomType"];
                        [orderItem setObject:[NSNumber numberWithLong:roomModel.roomsCount] forKey:@"roomsCount"];
                        [orderItem setObject:[NSNumber numberWithLong:roomModel.roomPrice] forKey:@"roomPrice"];
                        [orderItem setObject:roomModel.roomIntro forKey:@"roomIntro"];
                        [orderItem setObject:order forKey:@"rootOrder"];
                        
                        [orderItem saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                            if (isSuccessful)
                            {
                                BmobRelation *relation2 = [[BmobRelation alloc] init];
                                [relation2 addObject:orderItem];
                                [order addRelation:relation2 forKey:@"orderItem"];
                                [order updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                    if (isSuccessful)
                                    {
                                        index++;
                                        
                                        if (saveOK && index == count)
                                        {
                                            [blockself orderSaveFinished];
                                        }
                                    }
                                    else
                                    {
                                        saveOK = NO;
                                        [blockself orderSaveError];
                                    }
                                }];
                            }
                            else
                            {
                                saveOK = NO;
                                [blockself orderSaveError];
                            }
                        }];
                    }
                }
            }
        }
        else
        {
            saveOK = NO;
            [blockself orderSaveError];
        }
    }];
}

- (void)orderSaveFinished
{
    OwnerViewController *ownerVC = [[OwnerViewController alloc] init];
    ownerVC.segmentType = orderList;
    [self.navigationController pushViewController:ownerVC animated:YES];
}

- (void)orderSaveError
{
    OrderMessageConfirmViewController *blockself = self;
    [WBAlertView alertWithTitle:@"订单出错" message:@"订单已支付，但保存出错.请选择重新保存订单信息，或联系客服人员处理，谢谢！" cancelTitle:@"重试" okTitle:@"联系客服" cancel:^{
        [blockself makeOrderAfterPayment:YES];
    } complete:^{
        
    }];
}

- (NSString *)genOutTradeNo
{
    NSUInteger time = [NSDate date].timeIntervalSince1970;
    NSString *tradeNo = [NSString stringWithFormat:@"%ld" , (unsigned long)time];
    
    return tradeNo;
}


#pragma mark - UITextField Delegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentTextField = textField;
    [self scrollWhenKeyboardFrameChanged];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag < Tag_SetTelField)//是姓名field
    {
        if ((textField.tag - Tag_SetNameField) == self.dataModel.orderRoomsCount - 1)//最后一个姓名填写
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

#pragma mark - UIKeyboardWillChangeFrameNotification handler

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
//    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
//    CGRect beginKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    self.keyboardHeight = endKeyboardRect.size.height;
    if (self.keyboardHeight > 0)
    {
        [self scrollWhenKeyboardFrameChanged];
    }
    else
    {
        
    }
    
}

- (void)scrollWhenKeyboardFrameChanged
{
    CGRect frame = self.currentTextField.frame;
    CGRect frameInView = [self.currentTextField convertRect:frame toView:self.view];
    CGFloat touchedTextFiledHeight = frameInView.origin.y + frameInView.size.height;
    
    if (self.keyboardHeight > 0 && touchedTextFiledHeight > self.keyboardHeight)
    {
        CGFloat offset = self.keyboardHeight - (self.view.height - touchedTextFiledHeight);
        CGPoint tableOffset = self.tableView.contentOffset;
        [self.tableView setContentOffset:CGPointMake(0, tableOffset.y + offset)];
    }
}

- (BOOL)checkTel:(NSString *)str
{
    if ([str length] == 0)
    {
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入联系号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
        
        return NO;
        
    }
    
    //1[0-9]{10}
    
    //^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$
    
    //    NSString *regex = @"[0-9]{11}";
    
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    
//    if (!isMatch)
//    {
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//        
//        return NO;
//    }
    return isMatch;
}

@end
