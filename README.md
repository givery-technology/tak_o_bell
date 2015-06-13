# tak_o_bell
## Basic information
### Product name
* Picky

#### Queue
* My Menu
* Yum

### Background(Problem)
* We don't know which foods are included for each menu. (Some restaurants have that in the menu)
* Sometimes there are foods which customer can't eat because of allergy and religion.
* Basically we don't wanna order menu we don't like.

### Solution
* Implement an app which can store foods which users can't eat.
* Unvisible menus which customers can't or don't wanna eat.

### Target
* Customer(user of the smartphone app)
    * have some foods which users don't like
    * have allergy
    * are in a religion
* Restaurant owner
    * Register menu to our service

## Service Specification
### Functions
* Store foods users can't or don't wanna eat(Register foods)
* Take a menu picture
* Look a renewed picture(menus which users can't eat have already removed)
* Editing foods

### Technology
* Image recognization([Docomo API?](https://www.nttdocomo.co.jp/service/developer/smart_phone/analysis/character_recognition/))

### Design
#### Referer
* My Baby & Me : https://www.behance.net/gallery/25471921/Philips-AVENT-My-Baby-Me