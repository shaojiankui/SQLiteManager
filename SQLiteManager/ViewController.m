//
//  ViewController.m
//  DBManager
//
//  Created by Jakey on 15/7/14.
//  Copyright © 2015年 www.skyfox.org. All rights reserved.
//

#import "ViewController.h"
#import "DBManager.h"
#import "DBManagerQueue.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _managerQueue = [DBManagerQueue managerQueueWithDBPath:[[self class] documentsPath:@"test.db"]];
    
    DBManager *manager= [DBManager managerWithDocumentName:@"test.db"];
    [manager createTable:@"test" fields:@[@"brandId",@"itemId",@"cOrder"] ];
    [manager close];
    
    //执行sql文件
    DBManager *manager2= [DBManager managerWithDocumentName:@"PPNote.db"];
    [manager2 executeFromFile:[[NSBundle mainBundle] pathForResource:@"Note" ofType:@"sql"]];
    [manager2 close];
}

-(NSString*)randomCode{
    NSInteger count = 8;
    char chars[] = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLOMNOPQRSTUVWXYZ";
    char codes[count];
    
    for(int i=0;i<count; i++){
        codes[i]= chars[arc4random()%62];
    }
    
    NSString *text = [[NSString alloc] initWithBytes:codes
                                              length:count encoding:NSUTF8StringEncoding];
    return text;
}
/**
 *  @brief  插入记录
 *
 *  @param sender sender description
 */
- (IBAction)insertTouched:(id)sender {
    [_managerQueue inTransaction:^(DBManager *manager, BOOL *rollback) {
        for (int i=0; i<10000; i++) {
    
                [manager insert:@"test" data:@{@"brandId":[self randomCode],@"itemId":[self randomCode]} replace:YES ];
                if (i==9999) {
                    NSLog(@"insert a 10000 record done");
                }
            }
    }];
}

/**
 *  @brief  删除记录
 *
 *  @param sender sender description
 */
- (IBAction)deleteTouched:(id)sender {
    DBManager *manager= [DBManager managerWithDocumentName:@"test.db"];
    [manager delete:@"test" where:nil limit:@"100"];
    [manager close];

}
/**
 *  @brief  清空记录
 *
 *  @param sender sender description
 */
- (IBAction)clearTouched:(id)sender {
    DBManager *manager= [DBManager managerWithDocumentName:@"test.db"];
    [manager delete:@"test" where:nil limit:nil];
    [manager close];
}
/**
 *  @brief  更新记录
 *
 *  @param sender sender description
 */
- (IBAction)updateTouched:(id)sender {
    
}
/**
 *  @brief  查询记录
 *
 *  @param sender sender description
 */
- (IBAction)queryTouched:(id)sender {
    DBManager *manager= [DBManager managerWithDocumentName:@"test.db"];
    NSArray *modles = [manager select:@"test" where:nil limit:@"10"];
    NSLog(@"modles:%@",[modles description]);
    [manager close];
}



/**
 *  @brief  创建表
 *
 *  @param sender sender description
 */
- (IBAction)createTouched:(id)sender {
    DBManager *manager= [DBManager managerWithDocumentName:@"test.db"];
    [manager createTable:[self randomCode] fields:@[@"brandid",@"userid",@"dd2"]];
    if (![manager isExistTable:@"test"]) {
        [manager createTable:@"test" fields:@[@"brandId",@"itemId",@"cOrder"] ];

    }
    NSArray *array =  [manager tables];
    NSLog(@"tables:%@",[array description]);
    [manager close];
}
/**
 *  @brief  统计
 *
 *  @param sender sender description
 */
- (IBAction)countTouched:(id)sender {
    DBManager *manager= [DBManager managerWithDocumentName:@"test.db"];
    NSLog(@"count:%zd", [manager count:@"test" where:nil]);
    [manager close];

}
/**
 *  @brief  数据库中所有表
 *
 *  @param sender sender description
 */
- (IBAction)allTableTouched:(id)sender {
    DBManager *manager= [DBManager managerWithDocumentName:@"test.db"];
    NSArray *array =  [manager tables];
    NSLog(@"tables:%@",[array description]);
}
/**
 *  @brief  随机删除一个表
 *
 *  @param sender sender description
 */
- (IBAction)deleteTableTouched:(id)sender {
    DBManager *manager= [DBManager managerWithDocumentName:@"test.db"];
    NSArray *array =  [manager tables];
    [manager dropTable:[array lastObject]];
    NSLog(@"tables:%@",[array description]);
    [manager close];

}
/**
 *  @brief  最后插入ID
 *
 *  @param sender sender description
 */
- (IBAction)lastInsertIDTouched:(id)sender {
    DBManager *manager= [DBManager managerWithDocumentName:@"test.db"];
    NSNumber *index=  [manager lastInsertID];
    NSLog(@"lastInsertID%@",index);
    [manager close];
}
/**
 *  @brief  表中列的标题
 *
 *  @param sender sender description
 */
- (IBAction)columnTitlesInTable:(id)sender {
    DBManager *manager= [DBManager managerWithDocumentName:@"test.db"];
    NSLog(@"columnTitlesInTable:%@",[ [manager columnTitlesInTable:@"test"] description]);
    [manager close];

}
/**
 *  @brief  最后一条记录的ID
 *
 *  @param sender sender description
 */
- (IBAction)lastRecodeId:(id)sender {
    DBManager *manager= [DBManager managerWithDocumentName:@"test.db"];
    NSLog(@"lastRecodeId%zd", [manager lastRecodeId:@"test"]);
    [manager close];


}
/**
 *  @brief  SQLite版本
 *
 *  @param sender sender description
 */
- (IBAction)versionTouched:(id)sender {
    NSLog(@"versionNumber:%d",[DBManager versionNumber]);
    NSLog(@"libraryVersionNumber:%d",[DBManager libraryVersionNumber]);
    NSLog(@"sqliteLibVersion:%@",[DBManager sqliteLibVersion]);

    
}
/**
 *  @brief  多线程插入
 *
 *  @param sender sender description
 */
- (IBAction)multiTouched:(id)sender {
    DBManagerQueue * queue = [DBManagerQueue managerQueueWithDocumentName:@"test.db"];
    dispatch_queue_t q1 = dispatch_queue_create("queue1", NULL);
    dispatch_queue_t q2 = dispatch_queue_create("queue2", NULL);
    
    dispatch_async(q1, ^{
        for (int i = 0; i < 100; ++i) {
            [queue inDatabase:^(DBManager *manager) {
                [manager insert:@"test" data:@{@"brandId":[self randomCode],@"itemId":[self randomCode]} replace:YES ];

            }];
        }
    });
    
    dispatch_async(q2, ^{
        for (int i = 0; i < 100; ++i) {
            [queue inDatabase:^(DBManager *manager) {
                [manager insert:@"test" data:@{@"brandId":[self randomCode],@"itemId":[self randomCode]} replace:YES ];

            }];
        }
    });
}

#pragma mark--helper
+ (NSString *)documentsPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}
+(NSString *)documentsPath:(NSString *)fileName{
    return [[self  documentsPath] stringByAppendingPathComponent:fileName];
}
@end
