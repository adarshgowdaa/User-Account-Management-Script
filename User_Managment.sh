            #!/bin/bash

            # User Account Management Script with Custom Email Notification
            # This script allows for the creation and deletion of user accounts on the local system.

            # Constants
            ADMIN_UID=0  # Root user's UID
            PASSWORD_LENGTH=12

            # Check if the script is run with root privileges
            if [[ "${UID}" -ne ${ADMIN_UID} ]]; then
                echo "Root privileges are required to execute this script."
                exit 1
            fi

            # Display usage information
            display_usage() {
                echo "Usage: ${0} [options] USER_NAME [COMMENT]..."
                echo "Options:"
                echo "  -c     Create a new user."
                echo "  -d     Delete an existing user."
                echo "  -h     Display this help message."
            }

            # Function to generate a random password
            generate_password() {
                local PASSWORD
                PASSWORD=$(date +%s%N | sha256sum | head -c${PASSWORD_LENGTH})
                echo "${PASSWORD}"
            }

            # Function to create a new user and send an email notification
            create_user() {
                local USER_NAME="${1}"
                local COMMENT="${@:2}"

                # Prompt the user for their email address
                read -p "Enter the user's email address: " USER_EMAIL

                # Generate a random password
                local PASSWORD=$(generate_password)

                # Create the user with the provided comment or use a default comment
                useradd -c "${COMMENT:-User Account}" -m "${USER_NAME}"

                if [[ $? -ne 0 ]]; then
                    echo "Failed to create the user account for ${USER_NAME}."
                    exit 1
                fi

                # Set the user's password
                echo "${USER_NAME}:${PASSWORD}" | chpasswd

                # Send an email notification to the user's email address with their username and password
                echo -e "Your account has been created on ${HOSTNAME}.\nUsername: ${USER_NAME}\nPassword: ${PASSWORD}" | mail -s "Account Details" "${USER_EMAIL}"

                # Display user information
                echo "User Account Created:"
                echo "Username: ${USER_NAME}"
                echo "Password: ${PASSWORD}"
                echo "Comment: ${COMMENT:-User Account}"
                echo "Host: ${HOSTNAME}"
            }

            # Function to delete an existing user
            delete_user() {
                local USER_NAME="${1}"

                # Check if the user exists
                if id "${USER_NAME}" &>/dev/null; then
                    # Delete the user and home directory
                    userdel -r "${USER_NAME}"
                    echo "User account ${USER_NAME} has been deleted."
                else
                    echo "User account ${USER_NAME} does not exist."
                    exit 1
                fi
            }

            # Main script
            case "${1}" in
                -c)
                    shift
                    create_user "${@}"
                    ;;
                -d)
                    shift
                    delete_user "${1}"
                    ;;
                -h|--help)
                    display_usage
                    ;;
                *)
                    echo "Invalid! Check the Usage,"
                    display_usage
                    exit 1
                    ;;
            esac

            exit 0
