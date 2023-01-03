#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")
echo Teams resetted...

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WIN_GOALS OP_GOALS
do
  if [[ $WINNER != "winner" ]]
  then
    #get team ID
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    # if not found
    if [[ -z $WINNER_ID ]]
    then
      # insert team
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted $WINNER to teams
      fi
    # get new major_id
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi
  fi
done
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WIN_GOALS OP_GOALS
do
  if [[ $OPPONENT != "opponent" ]]
  then
    #get team ID
    OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # if not found
    if [[ -z $OPP_ID ]]
    then
      # insert team
      INSERT_OPP_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_OPP_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted $OPPONENT to teams
      fi
    # get new major_id
      OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi
  fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WIN_GOALS OP_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    #get team IDs
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # insert ids, round, goals and year
    INSERT_GAME=$($PSQL "INSERT INTO games(winner_id, opponent_id, round, winner_goals, opponent_goals, year) 
    VALUES($WINNER_ID,$OPPONENT_ID,'$ROUND', $WIN_GOALS, $OP_GOALS, $YEAR)")
    if [[ $INSERT_GAME == "INSERT 0 1" ]]
    then
      echo Inserted game between $WINNER and $OPPONENT, resulted $WIN_GOALS - $OP_GOALS on $YEAR $ROUND round to games
    fi
  fi
done


echo $($PSQL "SELECT*FROM teams")
echo $($PSQL "SELECT*FROM games")

