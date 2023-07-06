public class Grid {
  // In the physical SET game, cards are placed on the table.
  // The table contains the grid of cards and is typically called the board.
  //
  // Note that the minimum number of cards that guarantees a set is 21,
  // so we create an array with enough columns to accommodate that.
  // (MAX_COLS == 7)
  Card[][] board = new Card[MAX_COLS][ROWS];   
  
  ArrayList<Location> selectedLocs = new ArrayList<Location>();  // Locations selected by the player
  ArrayList<Card> selectedCards = new ArrayList<Card>();         // Cards selected by the player 
                                                                 // (corresponds to the locations)  
  int cardsInPlay;    // Number of cards visible on the board

  public Grid() { 
    cardsInPlay = 0;
  }


  // GRID MUTATION PROCEDURES
  
  // 1. Highlight (or remove highlight) selected card
  // 2. Add (or remove) the location of the card in selectedLocs
  // 3. Add the card to (or remove from) the list of selectedCards
  public void updateSelected(int col, int row) {
    Card card = board[col][row];
    if (selectedCards.contains(card)) {
      int index = selectedCards.indexOf(card);
      selectedLocs.remove(index);
      selectedCards.remove(card);
      //score--;
    } else {
      selectedLocs.add(new Location(col, row));
      selectedCards.add(card);
    }

    //System.out.println("Cards = " + selectedCards + ", Locations = " + selectedLocs);
  }

  // Precondition: A Set has been successfully found
  // Postconditions: 
  //    * The number of columns is adjusted as needed to reflect removal of the set
  //    * The number of cards in play is adjusted as needed
  //    * The board is mutated to reflect removal of the set
 
 
public void removeSet() { 
  //If the number of cards in play is greater than 12 or there are no cards are left in the deck..
   if (cardsInPlay > 12 || deck.size() == 0) {    
  // If the selectedLocation is in the last col, set the card to null 
  // else, add the location to swapLocations (locations that can be swapped)
   ArrayList<Location> swapLocations = new ArrayList<Location>();
   for(int i = 0; i < 3; i++)
   {
     Location loc = selectedLocs.get(i);
      if(loc.getCol() == currentCols - 1)
      {
        board[loc.getCol()][loc.getRow()] = null;      
      }
     else {
       swapLocations.add(loc);
     }      
    }        
    // Create an array of locations in the last column that can be swapped
    ArrayList<Location> lastColLocs = new ArrayList<Location>();
    for (int row = 0; row < 3; row++) {
        if (board[currentCols - 1][row] != null) {
            lastColLocs.add(new Location(currentCols - 1, row));
        }
    }
    //Swap ONLY locations in swapLocations and lastColLocs
    for (int i = 0; i < swapLocations.size(); i++) {
        
        Location loc = swapLocations.get(i);
        Location lastColLoc = lastColLocs.get(i);
        board[loc.getCol()][loc.getRow()] = board[lastColLoc.getCol()][lastColLoc.getRow()];
    }    
    currentCols--;
    cardsInPlay -= 3;
   }
   //If there are exactly 12 cards in play and the deck is not empty, deal three new cards into 
   //the locations on the grid specified in the selectedLocs array. 
   else if (cardsInPlay == 12 && deck.size() > 0) {
        for (int i = 0; i < selectedLocs.size(); i++) {
            int col = selectedLocs.get(i).getCol();
            int row = selectedLocs.get(i).getRow();
            board[col][row] = deck.deal();
        }
}
}



  
  // Precondition: Three cards have been selected by the player
  // Postcondition: Game state, score, game message mutated, selected cards list cleared
 
  public void processTriple() {
    if (isSet(selectedCards.get(0), selectedCards.get(1), selectedCards.get(2))) {
      score += 10;
      removeSet();
      if (isGameOver()) { 
        state = State.GAME_OVER;
        runningTimerEnd = millis(); 
        score += timerScore(); //if the game is over, add timerScore to score
        message = 7; 
      } else {
        state = State.PLAYING;
        message = 1;
      }
    } else {
      score -= 5;
      state = State.PLAYING;
      message = 2;
    }
    clearSelected();
  }
  
  
  // DISPLAY CODE
  
  public void display() {
    int cols = cardsInPlay / 3;
    for (int col = 0; col < cols; col++) {
      for (int row = 0; row < ROWS; row++) {
        board[col][row].display(col, row);
      }
    }
  }

  public void highlightSelectedCards() {
    color highlight;
    if (state == State.FIND_SET) {
      highlight = FOUND_HIGHLIGHT;
      selectedLocs = findSet();
      if (selectedLocs.size() == 0) {
        message = 6;
        return;
      }
    } else if (selectedLocs.size() < 3) {
      highlight = SELECTED_HIGHLIGHT;
    } else {
      highlight = isSet(selectedCards.get(0), selectedCards.get(1), selectedCards.get(2)) ?
                  CORRECT_HIGHLIGHT :
                  INCORRECT_HIGHLIGHT;
    }
    for (Location loc : selectedLocs) {
      drawHighlight(loc, highlight);
    }
  }
  
  public void drawHighlight(Location loc, color highlightColor) {
    stroke(highlightColor);
    strokeWeight(5);
    noFill();
    int col = loc.getCol();
    int row = loc.getRow();
    rect(GRID_LEFT_OFFSET+col*(CARD_WIDTH+GRID_X_SPACER), 
      GRID_TOP_OFFSET+row*(CARD_HEIGHT+GRID_Y_SPACER), 
      CARD_WIDTH, 
      CARD_HEIGHT);
    stroke(#000000);
    strokeWeight(1);
  }

  
  // DEALING CARDS

  // Preconditions: cardsInPlay contains the current number of cards on the board
  //                the array board contains the cards that are on the board
  // Postconditions: board has been updated to include the card
  //                the number of cardsInPlay has been increased by one
  public void addCardToBoard(Card card) {
    int col = cardsInPlay % ROWS;
    int row = cardsInPlay / ROWS;
    board[row][col] = card;
    cardsInPlay++;
  }
   
    
  //1.if there are no more cards in deck, display "No cards left in the deck!" and return
  //2.if there are no sets, add 5 points to score and add 3 new cards, update currentCols
  //3.if there are still sets, subtract 5 points and display "There is a set on the board!"
  public void addColumn() {
    if (deck.size() == 0)
    {
      message = 5;
      return;
    }
    else if (findSet().size() == 0)
    {
      score = score + 5;
      addCardToBoard(deck.deal());
      addCardToBoard(deck.deal());
      addCardToBoard(deck.deal());
      currentCols++;
      message = 3;
      
    }
    else if (findSet().size() > 0)
    {
      score = score - 5;
      message = 4;    
  }
  }

  
  // GAME PROCEDURES
  
  //if there are no more cards in the deck and no more sets, the game is over
  public boolean isGameOver() {
    // YOU WRITE THIS
   if (deck.size() == 0 && findSet().size() == 0)
    {
      return true;
    }
    else 
    {
      return false;
    }
  }

  public boolean tripleSelected() {
    return (selectedLocs.size() == 3);
  }
   
  // Preconditions: --
  // Postconditions: The selected locations and cards ArrayLists are empty
  public void clearSelected() {
    selectedLocs.clear();
    selectedCards.clear();
  }
  
  //If there is a set on the board, addHint() returns a hint (ex: same color, same fill, different count) and remove 2 from score
  //The hint does not necessarily need to match with the "find set" as there can be multiple sets er cardsInPlay
  //else, returns no set on board to find!
  public void addHint()
  {   
    ArrayList<Location> foundSet = findSet();
    
    if(foundSet.size() == 0)
    {
      message = 6;
    }
    else 
    {
       score -= 2;
       Card a = board[foundSet.get(0).getCol()][foundSet.get(0).getRow()];
       Card b = board[foundSet.get(1).getCol()][foundSet.get(1).getRow()];
       Card c = board[foundSet.get(2).getCol()][foundSet.get(2).getRow()];
       
       if(sameColor(a,b,c))
       {
         message = 11;
       }
       else if(sameShape(a,b,c))
       {
         message = 12;
       }
       else if(sameFill(a,b,c))
       {
         message = 13;
       }
       else if(sameCount(a,b,c))
       {
         message = 14;
       }
       else if(diffColor(a,b,c))
       {
         message = 15;
       }
       else if(diffShape(a,b,c))
       {
         message = 16;
       }
        else if(diffFill(a,b,c))
       {
         message = 17;
       }
        else if(diffCount(a,b,c))
       {
         message = 18;
       }    
    }
  }
  
  // findSet(): If there is a set on the board, existsSet() returns an ArrayList containing
  // the locations of three cards that form a set, an empty ArrayList (not null) otherwise
  // Preconditions: --
  // Postconditions: No change to any state variables
  public ArrayList<Location> findSet() {
    ArrayList<Location> locs = new ArrayList<Location>();
    for (int i = 0; i < currentCols*3 - 2; i++) {
      for (int j = i+1; j < currentCols*3 - 1; j++) {
        for (int k = j+1; k < currentCols*3; k++) {
          if (isSet(board[col(i)][row(i)], board[col(j)][row(j)], board[col(k)][row(k)])) {
            locs.add(new Location(col(i), row(i)));
            locs.add(new Location(col(j), row(j)));
            locs.add(new Location(col(k), row(k)));
            return locs;
          }
        }
      }
    }
    return new ArrayList<Location>();
  }

  
  // UTILITY FUNCTIONS FOR GRID CLASS
  
  public int col(int n) {
    return n/3;
  }
  
  public int row(int n) {
    return n % 3;
  }
   
  public int rightOffset() {
    return GRID_LEFT_OFFSET + currentCols * (CARD_WIDTH + GRID_X_SPACER);
  }
}
