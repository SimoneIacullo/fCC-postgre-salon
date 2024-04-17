#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

echo -e "Welcome to My Salon, how can I help you?\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  SERVICE=$($PSQL "SELECT service_id, name FROM services")
  echo "$SERVICE" | while read SERVICE_ID BAR NAME_SERVICE
  do
    echo -e "$SERVICE_ID) $NAME_SERVICE"
  done

  read SERVICE_ID_SELECTED
  NAME_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")
  case $SERVICE_ID_SELECTED in
    [1-3]) CUSTOMER_MENU "$SERVICE_ID_SELECTED" ;;
    *) MAIN_MENU "I could not find that service. What would you like today?" ;;
  esac
}

CUSTOMER_MENU() {
  local SERVICE_ID_SELECTED=$1
  echo "What's your phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_ID  ]]
  then
    echo "I don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    NEW_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    else
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id = '$CUSTOMER_ID'")
  fi
  echo "What time would you like your$NAME_SERVICE, $CUSTOMER_NAME?"
  read SERVICE_TIME
  echo "I have put you down for a$NAME_SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
  NEW_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
}

MAIN_MENU
