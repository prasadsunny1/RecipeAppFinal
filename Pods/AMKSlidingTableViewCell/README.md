AMKSlidingTableViewCell
======================

Customizable sliding cell behavior. Based on MKSlidingTableViewCell, adds few new options. Now you can add transformable behavior - for drawer and foreground cell (whole, or its part) which are being 3D transformed - giving you nice, clean look, and several options to customize it:

## Screenshots:

![Custom style Screenshot](https://raw.githubusercontent.com/amichnia/AMKSlidingTableViewCell/master/Screenshots/mk_mov_1.gif)
![Cosmetic Scan Screenshot](https://raw.githubusercontent.com/amichnia/AMKSlidingTableViewCell/master/Screenshots/mk_mov_2.gif)

# Usage

### Setup - cells

Create cells, that conforms to given structure:

1. __Container__ as __*MKSlidingTableViewCell*__ - this is empty container for foreground and background cells.

2. __Foreground__ as subclass of __*MKActionTableViewCell*__ - this is what actually is shown in the cell. To work, you have to set valid auto-layout, and connect outlets. In case of foreground, not connecting outlets will only result in no 3D transform for foreground.

  1. __actionContainer__: this is main container (optional if no transformable)

  1. __transformableContainer__: this should be same size as actionContainer, everything inside is being 3D transformed (optional)

3. __Backgorund__ as subclass of __*MKActionTableViewCell*__ - this is what gets revealed, when cell is sliding.

  1. __actionContainer__: this is main container, its size determines, how much cell will slide (__required__)

  1. __transformableContainer__: this should be same size as actionContainer, everything inside is being 3D transformed (optional)

![Storyboard](Screenshots/storyboard.png)

### Code

When the cells are prepared, (storyboard or XIB) - you create actual sliding cells like below:

Objective-C
```objective-c
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MKSlidingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"container"];
    UITableViewCell *foregroundCell = [tableView dequeueReusableCellWithIdentifier:@"foreground"];
    UITableViewCell *backgroundCell = [tableView dequeueReusableCellWithIdentifier:@"background"];

    cell.foregroundView = foregroundCell;
    cell.drawerView = backgroundCell;
    cell.delegate = self;

    //configure cells

    return cell;
}
```
Swift
```swift
func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    guard let
    containerCell = tableView.dequeueReusableCellWithIdentifier("container") as? MKSlidingTableViewCell,
    foregroundCell = tableView.dequeueReusableCellWithIdentifier("foreground") as? MKActionTableViewCell, // Or its subclass
    drawerCell = tableView.dequeueReusableCellWithIdentifier("background") as? MKActionTableViewCell  // Or its subclass
    else {
        return UITableViewCell()
    }

    containerCell.foregroundView = foregroundCell
    containerCell.drawerView = drawerCell
    containerCell.delegate = self

    return containerCell
}
```

### Handling Taps on Cell
Objective-C:
```objective-c
- (void)didSelectSlidingTableViewCell:(MKSlidingTableViewCell *)cell
{
    //cell tapped!
}
```
Swift:
```swift
func didSelectSlidingTableViewCell(cell: MKSlidingTableViewCell!) {
    print("Did select")
}
```

### Notifications

Objective-C
```objective-c
//Add observers
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRevealDrawerViewForCell:) name:MKDrawerDidOpenNotification object:nil];
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didHideDrawerViewForCell:) name:MKDrawerDidCloseNotification object:nil];

- (void)didRevealDrawerViewForCell:(NSNotification *)notification
{
    MKSlidingTableViewCell *cell = notification.object;

    //additional code
}

- (void)didHideDrawerViewForCell:(NSNotification *)notification
{
    MKSlidingTableViewCell *cell = notification.object;

    //additional code
}
```

## Credits

This fork and updates to AMKSlidingTableViewCell are created by [Andrzej Michnia](https://github.com/amichnia/).

Original MKSlidingTableViewCell was created by [Michael Kirk](https://github.com/PublicStaticVoidMain/) with contributions by [Sam Corder](https://github.com/samus/).

## License

MKSlidingTableViewCell is available under the MIT license. See the LICENSE file for more info.
