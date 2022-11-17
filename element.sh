#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"


ELEMENTS(){
  if [[ $1 ]]
    then 
        # arg check
      if [[ ! $1 =~ ^[0-9]+$ ]]
        # if it's a string not a number
        then 
          if [[ ${#1} -gt 2 ]]
            # if it's a string longer than 2 it's a name
            then INPUT_ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1'")
              # arg exists check
              if [[ -z $INPUT_ELEMENT ]]
                then echo "I could not find that element in the database."
                  return
              fi
            # else it's a symbol
            else INPUT_ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1'")
              # arg exists check
              if [[ -z $INPUT_ELEMENT ]]
                then echo "I could not find that element in the database."
                  return
              fi
          fi
        else
          # it's a number already
          INPUT_ELEMENT=$1
      fi
    else
      echo "Please provide an element as an argument."
        return
  fi

  ELEMENT_SQL=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $INPUT_ELEMENT")
  
  if [[ -z $ELEMENT_SQL ]]
    then 
      echo "I could not find that element in the database."
        return
    else
      echo "$ELEMENT_SQL" | while read TYPE_ID BAR ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR MASS BAR MELT BAR BOIL BAR TYPE 
        do 
          echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
        done
  fi
}

ELEMENTS $1
