#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Recipe : NSObject


@property (nonatomic, strong) NSString *ingredientsImages; // search by ingredients images
@property (nonatomic, strong) NSString *ingredientsNames; // search by ingredients name
@property (nonatomic, strong)NSString *isSelected; // for selecting ingredients
@property (nonatomic, strong) NSString *regionName; // search by region- region name
@property (nonatomic, strong) NSString *regionDesc; // search by region- region description
@property (nonatomic, strong) NSString *regionImage; // search by region- region Image
@property (nonatomic, strong) NSString *timeImage; // time tab module - time alarm image
@property (nonatomic , strong) NSString *timeMins; // time tab module - time in minutes
@property (nonatomic , strong) UIColor *timeColor; // time tab module - time lables color




// nitiation methods for initializing parameters defined above 
-(id) initwithIngredientName:(NSString *) theIngredientName andIngredientImage: (NSString *) theIngredientImage andCheckSelected: (NSString *) theisSelected;


-(id) initwithRegionName:(NSString *) theRegionName andRegionImage: (NSString *) theRegionImage andRegionDesc: (NSString *) theRegionDesc;



-(id) initwithtimeImage:(NSString *) theTimeImage andTimeMins: (NSString *) theTimeMins andTimeColor: (UIColor *) theTimeColor;

@end
