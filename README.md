# Note App

A new Flutter project.
***************************************
  <div style="flex: 2;">
    <p>This app helps to record past events, emotions experienced, or to build schedules for a new day easily and vividly</p>
  </div>
</div>

## Features

* CRUD Note
* Manage Data with Firebase


## Screenshots

|Home Page                          | New note Screen                             | Edit note Screen                |
|---------------------|---------------------|---------------------|
| ![Screenshot_1691564306](https://github.com/SpiderMan-XiaoDo/note_app/blob/master/assets/app_demo/home_page.jpg) |![Screenshot_1691564355](https://github.com/SpiderMan-XiaoDo/note_app/blob/master/assets/app_demo/new_note.jpg)|![Screenshot_1691564461](https://github.com/SpiderMan-XiaoDo/note_app/blob/master/assets/app_demo/view_old_note.jpg)|

## Installation

You can clone this repository from source using the
instructions below:

```bash
git clone https://github.com/SpiderMan-XiaoDo/note_app.git
cd note_app
flutter pub get
````
After download this repository, you mus config your firebase to save your data:
  Delete file [firebase_options.dart] in lib folder.

To use npm (the Node Package Manager) to install the Firebase CLI, follow these steps:
  1. Install [Node.js](https://nodejs.org/en) using [nvm](https://github.com/nvm-sh/nvm/blob/master/README.md) (the Node Version Manager).
Installing Node.js automatically installs the npm command tools.
  2. Install the Firebase CLI via npm by running the following command:
```bash
npm install -g firebase-tools
````
Log in and test the Firebase CLI:
  1. Log into Firebase using your Google account by running the following command:
```bash
firebase login
````
  This command connects your local machine to Firebase and grants you access to your Firebase projects.
  2. Install the FlutterFire CLI by running the following command from any directory:
```bash
dart pub global activate flutterfire_cli
````
  3. Config your app to use flutter:
```bash
flutterfire configure
````

Change the 'Rules' in Firestore Database :
<img width="935" alt="image" src="https://github.com/SpiderMan-XiaoDo/note_app/assets/90297125/c54a01ec-7e84-444a-8604-d5bcfe991663">

Change this code:
````bash
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
````
To this code:
````bash
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
````
Change the 'Rules' in RealTime DataBase:
````bash
{
  "rules": {
    ".read": "true",  // 2023-8-19
    ".write": "true",  // 2023-8-19
  }
}
````
<img width="922" alt="image" src="https://github.com/SpiderMan-XiaoDo/note_app/assets/90297125/e516e133-c39a-46c4-ae74-586c88c4cc10">

## You can build APK file to install this app on your Phone.
````bash
flutter build apk
````
This APK file will be appear in the path ````build\app\outputs\apk\release```` in note_app

## Acknowledgements

note_app was built using the following open-source libraries and tools:

* [Flutter](https://flutter.dev/)
* [Dart](https://dart.dev/)