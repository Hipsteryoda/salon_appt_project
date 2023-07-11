#!/bin/bash

#### FUNCTIONS AND DEFINITIONS ####
PSQL="psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

list_services() {
    SERVICES="$($PSQL "select * from services;")"
    LIM="$($PSQL "SELECT MAX(service_id) FROM services;")"

    for (( c=1; c<=$LIM; c++))
    do
        SERVICE="$($PSQL "SELECT name FROM services WHERE service_id = $c;")"
        echo "$c) $SERVICE"
    done
}

#### END FUNCTIONS AND DEFINITIONS #### 

echo -e "\n~~ MY SALON ~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"

# call the list services function to list services
list_services
read SERVICE_ID_SELECTED

SERVICE_SELECTION="$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED;")"

# Check whether a good value was passed
if [[ -z $SERVICE_SELECTION ]]
then
    echo -e "\nI could not find that service. What would you like today?"
    list_services
    read SERVICE_ID_SELECTED
    SERVICE_SELECTION="$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED;")"
fi

# retain SERVICE_SELECTION for later

# Get customer phone number
echo -e "\nWhat is your phone number?"
read CUSTOMER_PHONE

# check if phone number exists
CUST_ID="$($PSQL "SELECT customer_id FROM customers
WHERE phone = '$CUSTOMER_PHONE';")"
# if not exists
if [[ -z $CUST_ID ]]
then
    # get customer CUSTOMER_NAME 
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    # insert CUSTOMER_NAME and phone number into customers
    INSERT_CUST="$(
        $PSQL "INSERT INTO customers (name, phone)
                VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE');"
    )"
    # Check valid insert
    if [[ $INSERT_CUST == "INSERT 0 1" ]]
    then
        # if valid insert, get customer id
        CUST_ID="$(
            $PSQL "SELECT customer_id FROM customers
                    WHERE phone = '$CUSTOMER_PHONE';"
        )"
    fi

fi

# get time customer wants the appointment
echo -e "\nWhat time would you like your $SERVICE_SELECTION, $CUSTOMER_NAME?"
read SERVICE_TIME

INSERT_APPT="$(
    $PSQL "INSERT INTO appointments (customer_id, service_id, time)
    VALUES ('$CUST_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME');"
    )"

echo -e "\nI have put you down for a $SERVICE_SELECTION at $SERVICE_TIME, $CUSTOMER_NAME."
