//
//  myUILabel.h
//  CollectionViewTest
//
//  Created by 魏文彬 on 2017/4/11.
//  Copyright © 2017年 XW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabel+Extension.h"

typedef enum{
    // default
    VerticalAlignmentTop = 0,
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface myUILabel : UILabel{
    @private
    VerticalAlignment _verticalAlignment;
}

@property (nonatomic) VerticalAlignment verticalAlignment;

@end
