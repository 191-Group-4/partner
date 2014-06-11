Partner Up 1.0
=========
<img src="http://i62.tinypic.com/eg5veu.png">
Partner up 1.0 is a partner management website that will update the current methods of class partner management which are tedious and cumbersome. Partner up is a fast and easy way for students to find partners and provides an effortless way for professors to oversee student progress. 

Description of MVP
-----------------
Our MVP has succeeded in implementing the following features

1.  Account Creation, Updating and Deleting
2.  Partnerships based on student input
3.  Partner data spreadsheet output
4.  What ifs covered
    * What if a user forgets their password?
    * What if students make more than one account?
    * What if students drop the class?
    * What if the user encounters a bug?
    * What if someone else accessed their email account and used a forgot password link to reset the password?
    * What if a confirmation email never arrives?
    * What if a user sends 5 confirmation emails, which link is valid and which expires?

&nbsp;&nbsp;&nbsp;&nbsp;It uses accounts created in the database to identify users and has different views for different user "roles". It requires email confirmation to sign in and access the features of the website. We have a feature in case students forget their password that will email a link to allow them to change their password. This will prevent students from being locked out of their account. Forgot password and email confirmations will expire after a given amount of time, and only one token is active at a time. This is to add a layer of security so users will not have their accounts comprimised if their email accounts are comprimised.<br><br>
&nbsp;&nbsp;&nbsp;&nbsp;Professors and TAs can view the list of students signed up and their respective partners. At the bottom of the table there is a button that will download the table in csv format. At the moment we only track one project at a time, so in the case of a new project the TA user could clear the table and reset the users to unpartnered status, after downloading the partnerhip data of the previous project.


Diagnostics
-----------

<table>
  <tr>
    <th>Gems</th>
    <th>Recipes</th>
  </tr>
  <tr>
    <td rowspan="3"><ul><li>gem 'rails', '4.1.1'</li><li>gem 'sass-rails', '~> 4.0.3'</li><li>gem 'uglifier', '>= 1.3.0'</li><li>gem 'coffee-rails', '~> 4.0.0'</li><li>gem 'jquery-rails'</li><li>gem 'turbolinks'</li><li>gem 'jbuilder', '~> 2.0'</li><li>gem 'sdoc', '~> 0.4.0', group: :doc</li><li>gem 'spring', group: :development</li><li>gem 'bootstrap-sass'</li><li>gem 'devise'</li><li>gem 'mysql2'</li><li>gem 'pundit'</li><li>gem 'simple_form'</li><li>gem 'better_errors'</li><li>gem 'binding_of_caller', :platforms=>[:mri_21]</li><li>gem 'quiet_assets'</li><li>gem 'rails_layout'</li><li>gem 'factory_girl_rails'</li><li>gem 'rspec-rails', '>= 3.0.0.beta2'</li><li>gem 'capybara'</li><li>gem 'database_cleaner'</li><li>gem 'faker'</li><li>gem 'launchy'</li><li>gem 'selenium-webdriver'</li></ul>
    <td><ul><li>controllers</li><li>email</li><li>gems</li><li>git</li><li>init</li><li>rails_bootstrap</li><li>rails_devise_pundit</li><li>railsapps</li><li>saas</li></ul></td></td>
  </tr>
  <tr>
    <th>Preferences</th>
  </tr>
  <tr>
    <td><ul><li>git: true</li><li>apps4: rails-devise-pundit</li><li>authentication: devise</li><li>authorization: pundit</li><li>dev_webserver: webrick</li><li>prod_webserver: same</li><li>templates: erb</li><li>tests: none</li><li>frontend: bootstrap3</li><li>email: gmail</li><li>devise_modules: confirmable</li><li>form_builder: simple_form</li></ul></td>
  </tr>
</table>

Ruby on Rails
-------------

This application requires:

-   Ruby '2.1.0'
-   Rails '4.1.1'

Database
--------
This application uses MySQL with ActiveRecord.

Development
-----------

-   Template Engine: ERB
-   Testing Framework: Test::Unit
-   Front-end Framework: Bootstrap 3.0 (Sass)
-   Form Builder: SimpleForm
-   Authentication: Devise
-   Authorization: None
-   Admin: None

Email
-------
Email account is set to ryderc@uci.edu right now <br>
All confirmation emails and forgot password emails will be sent from ryderc@uci.edu. <br>
All Bug reports will be sent to ryderc@uci.edu <br>
The application is configured to send email using a Gmail account.

Features
--------
####Sign up with confirmation emails
+ Sign up will create an account in the database 

####Sign in/Sign out
+ Sign in / Sign out will destroy or create a new user session

####Forgot Password
+ If you forget your password you can have a link to reset your password emailed to you

####Edit Account
+ Users can edit their name, email or password if they want. 

####Delete Account
+ Users can delete their accounts

####Student View

######Partner
+ Students can partner with other students, and it will be recorded in the database

######Undo Partnership
+ Students can undo a partnership if they need to

######View Profile
+ Students can view their own and other student's profiles

######Check Partner Status
+ Students can check their status to see if they are partered and with whom.

####Professor View

######View Roster
+ Professors and TAs can view a list of all students who have registered an account and who they have partnered with

######Download Roster
+ Professors and TAs can download a CSV file of the partnership data

######Clear Partnerships
+ Professors and TAs have the ability to clear all partnerships and return the students to unpartnered state


Getting Started
---------------


Documentation and Support
-------------------------

###1. Models
#### Users
######Roles
| "Roles" | Types of User                 | Enum DB Value |
|---------|-------------------------------|---------------|
| User    | Student                       | 0             |
| VIP     | Professor, TA, Course Manager | 1             |
| Admin   | Webmaster                     | 2             |

######Status
+ Status is a boolean value of the partnership status of a user. "True" or 1 means 'is partnered'. "False" or 0 means 'is NOT partnered'

######Partner1
+ Partner1 is a column of corresponding names of the partners.  This should probably be done by ID in the future to make it easier to find current_user's partner's imgsrc for example.

######Imgsrc
+ Pictures are stored in the database as URLs for now.

#### Contact
empty for now

###2. Controllers
####Users_controller
+ index
+ show - This can be used later to determine whether to show a user or not. Currently the commented code restricts access to user profiles, only the current_users profile is visible to the current_user
+ update - current code updates the attributes as secure parameters and displays alert messages to user
+ destroy - destroys user, can be used by admins. 
+ flop - flips the user's status to partnered and puts the partners name in partner1 of the current_user and puts the current_user name in the partner's partner1
+ cancel - clear current_user partnership and status. a reset to unpartnered. for database inconsistencies.
+ clearall - resets all partnerships.
+ export - Downloads csv of html table

####Visitors_controller
empty for now

####Contacts_controller
+ index
+ new - makes @contact a new Contact (from model)
+ create - makes @contact a new Contact (from model) taking parameters and renders alert based on delivery success

####Application_controller
Currently filled with pundit code for authorization. Available if we need it later.  <a href="http://www.oit.uci.edu/help/webauth/webauth_instructions.html">Prevents CSRF Cross Site Request Forgery attacks by raising an exception, as suggested in Webauth documentation.</a>


###3. Views
####Layout#Application
In every page header, the _headerbar.html.erb partial is rendered.  That's the partnerup logo and the sign out/edit links. Then the _navigation.html.erb is rendered. That's the Nav bar Then the body first leaves room for dismissable bootstrap messages to be displayed at the top of the body. Then yields to content. The footer contains _footer.html.erb which is the report bug, submit suggestion and the kay easter egg.
There are two main pages that will be used, visitors#index and users#index.
<img src=http://i57.tinypic.com/2rcc03c.png>

####Visitors#Index
Visitors index is the "Homepage". It displays your profile info and partner status if you're a user, or number of registered users if you're a admin/vip. If you are not signed in, 

####Users#Index
First we check for database inconsistencies that will cause problems with rendering the page.

    if (current_user.status == true && current_user.partner1.empty?) || (current_user.status == false && !current_user.partner1.empty?)</b>
>First users index checks to make sure that the current user doesn't have either

>+ If they are partnered with no name in their partner column
    + Partner Status set to TRUE with Partner1 set to .empty?
+ If they are UNpartnered with a name in their partner column
    + Partner Status set to FALSE with Partner1 set to !.empty?

>If either of these cases are true, then it will show a button with clear_user_path link. clear is a method in the user controller, and the path was made in routes.rb. This will clear both the status and partner1 to defaults.

>Otherwise, It will render the appropriate header and table th's for users and admin/vips.

>Then for each user in the database, it will render the partial _user.html.erb. Each rendered user is a row in the table. It will render a user for each user in the database.


>+ For students this is a table of other students names, emails, status and request button. Students will see a different views based on their partner status. This is done with if statements in the view. There is probably a better way to do this in the future.
>+ For admins/vips this is a table of student names and their partners. Below that list are two buttons, to export the data to csv format, and to clear the database of all partnerships and reset all users status to 0/false and all users partner1 to "".

<img src= http://i60.tinypic.com/14tlhft.png>

### Issues

<s>+ Report Bug contact form used to be merged in visitors controller. Routes may be affected by the change to contacts controller.</s>

+ Report bug not working at the moment

Credits
-------
<img src="http://i58.tinypic.com/264l3pj.png" width=50%>
