# User Account Management Script with Custom Email Notification

This Bash script simplifies user account management on a local Linux system. It allows for the creation and deletion of user accounts and sends email notifications to users.

## Features

- **User Account Creation:** Easily create user accounts with custom comments and email notifications.
- **User Account Deletion:** Efficiently delete existing user accounts and send confirmation emails.
- **Custom Email Notifications:** Collect user email addresses for account-related notifications.
- **Password Security:** Generates strong, random passwords for new accounts.
- **Error Handling:** Provides clear feedback and handles various error scenarios.
- **User Interaction:** Prompts for user comments and email addresses to enhance user experience.

## Usage

`User_Managment.sh [options] USER_NAME [COMMENT]...`

**Options**

- `-c` Create a new user.
- `-d` Delete an existing user.
- `-h` Display this help message.
