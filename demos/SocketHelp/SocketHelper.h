
#import <Foundation/Foundation.h>

typedef enum {
    typeIDUdp = 0x2fff,
    typeIDGetInfo = 0x2000,
    typeIDGetInfoResp = 0x2001,
    typeIDConfigServer = 0x2002,
    typeIDConfigServerResp = 0x2003,
    typeIDCheckKey = 0x2004,
    typeIDBindKey = 0x2005,
    typeIDNetInfo = 0x200a,
    typeIDWifis = 0x200e,
    typeIDWifisResp = 0x200f,
    typeIDConfigWifi = 0x2010,
    typeIDConfigWifiResp = 0x2011
}typeID;

typedef enum {
    ECAuthorized                    =0,
    ECUnauthorizedUnkown            =-1,
    ECUnauthorizedLocal             =-2,
    ECUnauthorizedServerNoResponse  =-3,
    ECUnauthorizedServerBadResponse =-4,
    ECUnauthorizedServer            =-5,
    ECUnauthorizedUnBind            =-6,
    ECAuthorizedBefore              =-7
}ErrorConnect;

typedef void (^udpSocketBlock)(NSDictionary* dic,NSError* err);
typedef void (^socketBlock)(NSDictionary* dic,NSError* err);

@interface SocketHelper : NSObject
@property (nonatomic,copy) udpSocketBlock udpSocketBlock;

+ (SocketHelper *)Share;
- (void)sendUdpBoardcast:(udpSocketBlock)block;
- (void)connect:(NSString *)ip port:(NSInteger )number block:(socketBlock)block;
- (void)send:(typeID)type message:(NSDictionary *)dict block:(socketBlock)block;

- (BOOL)socketIsConnect;
- (void)disconnect;
- (void)tcpSocketDisconnect;
@end

