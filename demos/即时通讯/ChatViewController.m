//
//  ChatViewController.m
//  demos
//
//  Created by ra on 2019/7/11.
//  Copyright © 2019 tianyixin. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatViewCtr.h"

@interface ChatViewController ()

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
    //设置需要将哪些类型的会话在会话列表中聚合显示
    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                          @(ConversationType_GROUP)]];
}
//-(void)onReceived:(RCMessage *)message left:(int)nLeft object:(id)object{
//    [self refreshConversationTableViewIfNeeded];
//    NSLog(@"收到消息");
//}
-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath{
    
    ChatViewCtr*vc=[[ChatViewCtr alloc]initWithConversationType:ConversationType_PRIVATE targetId:model.targetId];
    vc.hidesBottomBarWhenPushed=YES;
     [self.navigationController pushViewController:vc animated:YES];
//    [ [RCCall sharedRCCall] startSingleCall:model.targetId mediaType:RCCallMediaAudio];
    
    
    
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
