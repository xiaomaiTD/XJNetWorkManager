//
//  ViewController.m
//  XJNetWorkManager-Example
//
//  Created by 江鑫 on 2018/5/11.
//  Copyright © 2018年 XJ. All rights reserved.
//

#import "ViewController.h"
#import "XJNetWorkManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSDictionary*dic = @{@"item_model":@"0",@"item_type":@"all",@"sign":@"gPWzKIyeAGkFXhZxUlknIk+fJknP02UPoVbUm3Jx//XqI0cw+Ro2Nk5wzKeB8YOBfkA1T8hwnyTQh3cpIb0jLmyMcbShu/wchrJgM0ygX2Z9neFZz2C5HS35Ift/zGgmhb8RjtsVqUbTOrjEC0aEmwGwqou785bltXAbWMhSMQs=",@"sign_type":@"RSA",@"uid":@"30370811",@"v":@"3.0.0"};
    
    [XJNetWorkManager xj_PostRequestWithURL:@"api/topc/list" parameter:dic successBlock:^(id response) {
        
    } failBlock:^(NSString *failMessage) {
        
    }];
    
    
}



//http://test.bzsns.cn/api/topic/list?v=3.0.0&sign=gPWzKIyeAGkFXhZxUlknIk%2BfJknP02UPoVbUm3Jx//XqI0cw%2BRo2Nk5wzKeB8YOBfkA1T8hwnyTQh3cpIb0jLmyMcbShu/wchrJgM0ygX2Z9neFZz2C5HS35Ift/zGgmhb8RjtsVqUbTOrjEC0aEmwGwqou785bltXAbWMhSMQs%3D&item_model=0&item_type=all&uid=30370811&sign_type=RSA


/*
{
    "item_model" = 0;
    "item_type" = all;
    sign = "gPWzKIyeAGkFXhZxUlknIk+fJknP02UPoVbUm3Jx//XqI0cw+Ro2Nk5wzKeB8YOBfkA1T8hwnyTQh3cpIb0jLmyMcbShu/wchrJgM0ygX2Z9neFZz2C5HS35Ift/zGgmhb8RjtsVqUbTOrjEC0aEmwGwqou785bltXAbWMhSMQs=";
    "sign_type" = RSA;
    uid = 30370811;
    v = "3.0.0";
}
2018-05-14 15:51:19.372233+0800 cowork[25223:1223898] ------http://test.bzsns.cn//api/topic/list?item_model=0&item_type=all&sign=gPWzKIyeAGkFXhZxUlknIk%2BfJknP02UPoVbUm3Jx//XqI0cw%2BRo2Nk5wzKeB8YOBfkA1T8hwnyTQh3cpIb0jLmyMcbShu/wchrJgM0ygX2Z9neFZz2C5HS35Ift/zGgmhb8RjtsVqUbTOrjEC0aEmwGwqou785bltXAbWMhSMQs%3D&sign_type=RSA&uid=30370811&v=3.0.0
 */
@end
