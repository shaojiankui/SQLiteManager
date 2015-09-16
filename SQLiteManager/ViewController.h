//
//  ViewController.h
//  DBManager
//
//  Created by Jakey on 15/7/14.
//  Copyright © 2015年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "DBManagerQueue.h"
@interface ViewController : UIViewController
{
    DBManagerQueue *_managerQueue;
}
- (IBAction)insertTouched:(id)sender;

- (IBAction)deleteTouched:(id)sender;

- (IBAction)updateTouched:(id)sender;

- (IBAction)queryTouched:(id)sender;

- (IBAction)createTouched:(id)sender;

- (IBAction)countTouched:(id)sender;

- (IBAction)clearTouched:(id)sender;

- (IBAction)allTableTouched:(id)sender;

- (IBAction)deleteTableTouched:(id)sender;

- (IBAction)lastInsertIDTouched:(id)sender;

- (IBAction)columnTitlesInTable:(id)sender;

- (IBAction)lastRecodeId:(id)sender;

- (IBAction)versionTouched:(id)sender;

- (IBAction)multiTouched:(id)sender;
@end

