# Description #
The UserManager of bbb-client allows you to easily receive notifications of when users join and leave the client, as well as when the presenter changes. This page contains everything you need to know about getting user updates from within bbb-client.

## The User ##
The User class is located in package org.bigbluebutton.main.model.
Each instance of the User class represents one user. The User object contains information about the user, such as their name, role, presenter status, and unique user id.

## The UserManager ##
The UserManager class is located in package org.bigbluebutton.main.api
To get a UserManager object:
```
   var userManager:UserManager = UserManager.getInstance()
```

It has a couple useful methods:
  * public function getUserList():ArrayCollection
  * public function getPresenter():User

The first one returns the list of users currently in the room. Each object in the ArrayCollection represents one User, and is of the type org.bigbluebutton.main.model.User
The second method returns the current presenter, also of type User. This is a convenience method - you may also iterate through the getUserList() ArrayCollection to find who the presenter is, if there is one.

## The IUserListener interface ##
To receive notifications whenever a user joins or leaves, or when a presenter changes, your class needs to implement the IUserListener interface, located in package org.bigbluebutton.main.api
The interface contains the methods:
  * function userJoined(user:User):void
  * function userLeft(user:User):void
  * function presenterChanged(newPresenter:User):void

Implementing the interface will allow your class to listen to user join/leave, and presenter events. Once implemented, you also need to add your class instance to the UserManager to be notified of these changes:
```
   var userManager:UserManager = UserManager.getInstance();
   userManager.registerListener(new MyUserListenerImplementation());
```