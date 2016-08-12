#import "Recipe.h"

@implementation Recipe

#pragma mark -  initializing method to get ingredients and related properties

-(id) initwithIngredientName:(NSString *) theIngredientName andIngredientImage: (NSString *) theIngredientImage andCheckSelected: (NSString *) theisSelected
{

   
    if(self)
    {
        self.ingredientsNames = theIngredientName;
        self.ingredientsImages = theIngredientImage;
        self.isSelected = theisSelected;


    }
    return self;
}


#pragma mark -  initializing method to get region names and related properties

-(id) initwithRegionName:(NSString *) theRegionName andRegionImage: (NSString *) theRegionImage andRegionDesc: (NSString *) theRegionDesc
{
    {
        
        
        if(self)
        {
            self.regionName = theRegionName;
            self.regionImage = theRegionImage;
            self.regionDesc = theRegionDesc;
            
            
        }
        return self;
    }


}


#pragma mark -  initializing method to get time images and related properties 

-(id) initwithtimeImage:(NSString *) theTimeImage andTimeMins: (NSString *) theTimeMins andTimeColor: (UIColor *) theTimeColor
{
    {
        
        
        if(self)
        {
            self.timeImage = theTimeImage;
            self.timeMins = theTimeMins;
            self.timeColor = theTimeColor;
            
            
        }
        return self;
    }
    


}


@end
