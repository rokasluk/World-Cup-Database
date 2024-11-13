#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $YEAR != "year" ]]
then
  #Check if the team name already exists
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE team='$WINNER'")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE team='$OPPONENT'")
  #If not found
  if [[ -z $WINNER_ID || -z $OPPONENT_ID ]]
  then
    # Insert WINNER and OPPONENT into the teams table if they don't already exist
    [[ -z $WINNER_ID ]] && INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    [[ -z $OPPONENT_ID ]] && INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    [[ -z $WINNER_ID ]] && WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    [[ -z $OPPONENT_ID ]] && OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  fi
  #Insert the games into games table
  echo $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
fi
done
