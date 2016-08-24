//
//  NSURLs.h
//  cdcarlife
//
//  Created by ksm on 15/11/26.
//  Copyright © 2015年 ksm. All rights reserved.
//

#ifndef NSURLs_h
#define NSURLs_h


//http://112.74.20.53:8080/zyz-app/
//http://192.168.10.200:8080/zyz-app/
#define  BaseURLString (@"http://112.74.20.53:8080/zyz-app/")

#endif /* NSURLs_h */
//imageUrl
#define KImageUrl [BaseURLString stringByAppendingString:@"file/zhiliaoDownload?fileName="]

#define KVisiterUrl [BaseURLString stringByAppendingString:@"file/visitorDownload?fileName="]

//登录
#define KLogin [BaseURLString stringByAppendingString:@"zhiliao/login"]

//获取星评
#define KLevel [BaseURLString stringByAppendingString:@"zhiliao/getEvaluationLevel"]

//获取token
#define KGetToken [BaseURLString stringByAppendingString:@"file/getZhiliaoToken"]

//带车费用列表
#define KGetCostList [BaseURLString stringByAppendingString:@"cost/getCostlist"]

//补全个人资料
#define KInfoEdit [BaseURLString stringByAppendingString:@"zhiliao/editZhiliao"]

//上传照片名字
#define KPhotosName [BaseURLString stringByAppendingString:@"zhiliaoPhoto/uploadPics"]

//个人认证
#define KPersonalAuth [BaseURLString stringByAppendingString:@"zhiliao/zhiliaoAuth"]

//车辆认证
#define KCarAuth [BaseURLString stringByAppendingString:@"zhiliao/carServiceAuth"]

//校验token
#define KLoginByToken [BaseURLString stringByAppendingString:@"zhiliao/loginByToken"]

//获取城市列表
#define KGetCityList [BaseURLString stringByAppendingString:@"zhiliaoCity/vcityList"]

//退出登录
#define KLogout [BaseURLString stringByAppendingString:@"zhiliao/quit"]

//获取rongCloudToken
#define KGgetRongCloudToken [BaseURLString stringByAppendingString:@"apptalk/getRongCloudToken"]

//获取游客信息
#define KGetVisiterMsg [BaseURLString stringByAppendingString:@"visitor/getVisitorByZhiliao"]

//添加游记
#define KAddTravelNotes [BaseURLString stringByAppendingString:@"zhiliaoTravelNotes/addTravelNotes"]

//获取游记列表
#define KGetTravelList [BaseURLString stringByAppendingString:@"zhiliaoTravelNotes/travelNotesList"]

//删除游记
#define KDeleteTravel [BaseURLString stringByAppendingString:@"zhiliaoTravelNotes/delTravelNotes"]


//知了获取最近一个月接单日
#define KGetCalendar [BaseURLString stringByAppendingString:@"zhiliaoCalendar/getZhiliaoCalendarByZhiliao"]


//设置成不接单日
#define KNotOderTake [BaseURLString stringByAppendingString:@"zhiliaoCalendar/save"]


//恢复为可接单日
#define KorderTake [BaseURLString stringByAppendingString:@"zhiliaoCalendar/delete"]

#warning 订单
//预约订单
#define KAppointOrder [BaseURLString stringByAppendingString:@"zhiliaoOrder/orderListByZ"]
#define KAppointOrderDetail [BaseURLString stringByAppendingString:@"zhiliaoOrder/orderDetailsByZ"]

//聊天订单
#define KChatOrder [BaseURLString stringByAppendingString:@"talkOrder/talkOrderListByZ"]


#warning 消息
//系统未读消息
#define KUnreadSystemMsgCount      [BaseURLString stringByAppendingString:@"zhiliaoSystemMessage/findCountByZhiliaoIdAndState"]
//所有系统消息
#define KAllSystemMsg              [BaseURLString stringByAppendingString:@"zhiliaoSystemMessage/findSystemMessageByZhiliaoId"]

//订单未读消息
#define KUnreadOrderMsgCount       [BaseURLString stringByAppendingString:@"zhiliaoOrderMessage/findCountByZhiliaoIdAndState"]
//所有订单消息
#define KAllOrderMsg               [BaseURLString stringByAppendingString:@"zhiliaoOrderMessage/findOrderMessageByZhiliaoId"]

//预约未读消息
#define KUnreadAppointmentMsgCount [BaseURLString stringByAppendingString:@"appOppointmentMessage/findBookingMessageCountByZhiliaoId"]
//所有预约消息
#define KAllAppointmentMsg          [BaseURLString stringByAppendingString:@"appOppointmentMessage/findBookingMessageByZhiliaoId"]
//处理预约
#define KDealAppointment            [BaseURLString stringByAppendingString:@"appOppointmentMessage/agreeBooking"]

//知了钱包
#define KGEtWallet            [BaseURLString stringByAppendingString:@"zhiliaoWallet/wallet"]

//收支明细
#define KGetIncomeDetail           [BaseURLString stringByAppendingString:@"zhiliaoWallet/findWalletWithdrawByWalletId"]
//申请提现
#define KApplyForCash           [BaseURLString stringByAppendingString:@"zhiliaoWallet/walletWithdraw"]