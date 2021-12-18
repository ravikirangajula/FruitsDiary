# FruitsDiary
My Fruits Diary is a mobile application where you can store the number of fruits you have eaten each day. The user is able to add date entries and for each date choose the fruits eaten on that specific day. The application consumes a webservice where the current entries and fruits are located. 

## Architecture concepts used here
Used MVVM Architecture

## Networking
Used NSURLSession for All API Calls

## Requirements
* Xcode Version 11.2.1+  Swift 5.0+ iOS 13+

## Roles and Responsibility 
 HomeViewController : 
Responsible for showing all Available Entries, Adding and Deletion of Entries

HomeViewModel:
Responsible for handling all business logic and APis calls which includes fetching current
entries, Available fruits list and stroing Available fruits list to USerdefaults , Sorting current Entries and feeding data source to table view 

FruitEntryViewController:
Responsible for taking user inputs and saving entry to backend  

HomeViewModel
Responsible for handling alll bsuines logic which includes creating entry and adding fruits to entry 

DetailViewController:
Responsible for showing all entries for specific entry and edit for entry 

DetailViewModel:
Responsible for handling all business logic and call apis for submit entry and modifiy entry 

DropdownListViewController
Responsible for showing all Available Fruits and give option to select 

APIWrapper Class
Responsible for calling remote apis and fecthing response and send back to classes

ImageDownLoadHelper:
Responsible for downlaoding images and saving in NSCache 



# How to use app
Launch the App and select myentries tab , MyEnries screen will show with all available entries . 
Click on Add Button from top navigation bar to add new entry.
Click on Delete All Button to delete alll entries 
To Delete Single entry swipe tableview cell from Right -> Left 
Click on any entry to see the details of entry
To Edit  swipe tableview cell from Right -> Left in detial page 
