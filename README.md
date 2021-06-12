# Book Test Library Swift
 Swift Code for adding Book Test Library Support

Hi! This is a set of code to quickly add support for the Book Test Library in your Swift apps! 
It queries our Book Test Library servers and automatically creates objects in Swift for you to display in your app and to your user. And it's a snap to use!

Step 1: Add the "BookTestLibrary.swift" file to your app

Step 2: At each Pragma mark in that file is information you need to fill in, including your API key. You also need to reference the location of the user's auth token, and the book key of whichever book is currently active. We have been using SwiftUI environment objects to do this, but you can use any location you'd like.

Step 3: In the ContentView.swift file, you'll see examples of functions that allow you to get the account data, available books, and book data via the input of your user. We also added some simple error checking for you to show errors to your user.

Because this calls an api on a server, make sure to run it async and display to the user any delays if it is contacting the server.

Questions about this? Email support@thoughtcastmagic.com for help. 
Want a developer api key? email joshua@joshuariley.co.uk for access.
Want the Book Test Library API docs? https://bookindexapi.com/docs
