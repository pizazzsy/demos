//
//  FileOperationCtr.m
//  demos
//
//  Created by ra on 2019/5/30.
//  Copyright © 2019 tianyixin. All rights reserved.
//

#import "FileOperationCtr.h"
#import "CmdModel.h"

@interface FileOperationCtr ()
{
    NSMutableDictionary *dataDic;
    NSMutableArray *keyArr;
    NSMutableArray *valueArr;
}
@end

@implementation FileOperationCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    keyArr=[[NSMutableArray alloc]init];
    
    dataDic=[[NSMutableDictionary alloc]init];
    UIButton *readButton = [UIButton buttonWithType:UIButtonTypeCustom];
    readButton.frame=CGRectMake(100, 100, 100, 50);
    readButton.titleLabel.font = [UIFont systemFontOfSize: 15.0];
    [readButton setTitle:@"读文件" forState:UIControlStateNormal];
    [readButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [readButton addTarget:self action:@selector(readBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:readButton];
    self.view.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view.
}
- (void)readBtnClick:(id)sender
{
    @try {
        [dataDic removeAllObjects];
        [valueArr removeAllObjects];
        [keyArr removeAllObjects];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"cmdlist" ofType:@"txt"];
        NSString *content = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSString *dataStr=[content stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        NSArray *dataArr = [dataStr componentsSeparatedByString:@"\n"];
        NSMutableArray*itemArr=[[NSMutableArray alloc]init];
        for (NSString*str in dataArr) {
            if (![str isEqualToString:@""]&&![str containsString:@"/*"]&&![str containsString:@"//"]) {
                [itemArr addObject:str];
            }
        }
        NSMutableArray*resultArr=[[NSMutableArray alloc]init];
        for (NSString* str in itemArr) {
            NSString*replaceStr= [str stringByReplacingOccurrencesOfString:@"\t" withString:@" "];
            NSError *error = nil;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\s{2,}" options:NSRegularExpressionCaseInsensitive error:&error];
            NSArray *arr = [regex matchesInString:replaceStr options:NSMatchingReportCompletion range:NSMakeRange(0, replaceStr.length)];
            arr = [[arr reverseObjectEnumerator] allObjects];
            for (NSTextCheckingResult *str in arr) {
                replaceStr = [replaceStr stringByReplacingCharactersInRange:[str range] withString:@" "];
            }
            replaceStr = [replaceStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [resultArr addObject:replaceStr];
        }
        NSString*titleStr;
        for (NSString*str in resultArr) {
            NSArray *dataArr = [str componentsSeparatedByString:@" "];
            if (dataArr.count==1) {
                titleStr=str;
                valueArr=[[NSMutableArray alloc]init];
                [dataDic setObject:valueArr forKey:titleStr];
                [keyArr addObject:titleStr];
            }else if (dataArr.count==2){
                valueArr=[dataDic objectForKey:titleStr];
                CmdModel *cmd=[[CmdModel alloc]init];
                cmd.code=dataArr[0];
                cmd.key=dataArr[1];
                cmd.Value=@"";
                [valueArr addObject:cmd];
                [dataDic setObject:valueArr forKey:titleStr];
                
                //            NSDictionary*dic=[[NSDictionary alloc]initWithObjectsAndKeys:dataArr,titleStr,nil];
                //            [valueArr addObject:dic];
                NSLog(@"两项");
            }else if (dataArr.count==3){
                //            valueArr=
                //            NSDictionary*dic=[[NSDictionary alloc]initWithObjectsAndKeys:dataArr,titleStr,nil];
                //            [valueArr addObject:dic];
                valueArr=[dataDic objectForKey:titleStr];
                CmdModel *cmd=[[CmdModel alloc]init];
                cmd.code=dataArr[0];
                cmd.key=dataArr[1];
                cmd.Value=dataArr[2];
                [valueArr addObject:cmd];
                [dataDic setObject:valueArr forKey:titleStr];
                
                NSLog(@"三项");
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"文件格式不正确");
    }
//    NSLog(@"%@",content);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
