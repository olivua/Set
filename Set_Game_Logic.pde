
//returns true if all cards are the same color (based on row)
boolean sameColor(Card a, Card b, Card c) {
  return allEqual(a.getRow() / 3, b.getRow() / 3, c.getRow() / 3); 
}
//returns true if all cards are the same shape (based on row)
boolean sameShape(Card a, Card b, Card c) {
  return allEqual(a.getRow() % 3, b.getRow() % 3, c.getRow() % 3);
}

//returns true if all cards are the same Fill (based on col)
boolean sameFill(Card a, Card b, Card c) {
  return allEqual(a.getCol() / 3, b.getCol() / 3, c.getCol() / 3);
}

//returns true if all cards are the same count (based on col)
boolean sameCount(Card a, Card b, Card c) {
  return allEqual(a.getCol() % 3, b.getCol() % 3, c.getCol() % 3);
}

//returns true if all cards are different color (based on row)
boolean diffColor(Card a, Card b, Card c) {
  
  return allDifferent(a.getRow() / 3, b.getRow() / 3, c.getRow() / 3); 
}

//returns true if all cards are different shape (based on row)
boolean diffShape(Card a, Card b, Card c) {

  return allDifferent(a.getRow() % 3, b.getRow() % 3, c.getRow() % 3);
}


//returns true if all cards are different fill (based on col)
boolean diffFill(Card a, Card b, Card c) {

   return allDifferent(a.getCol() / 3, b.getCol() / 3, c.getCol() / 3);
}

//returns true if all cards are different count (based on col)
boolean diffCount(Card a, Card b, Card c) {
  
  return allDifferent(a.getCol() % 3, b.getCol() % 3, c.getCol() % 3);
} 

//returns true if the three cards form a set, false if otherwise
boolean isSet(Card a, Card b, Card c) {
  
  return ((sameCount(a,b,c) || diffCount(a,b,c)) && (sameShape(a,b,c) || diffShape(a,b,c))
    && (sameFill(a,b,c) || diffFill(a,b,c)) && (sameColor(a,b,c) || diffColor(a,b,c)));
  
}

//returns true if all int's are equal
boolean allEqual(int a, int b, int c)
{
  if (a == b && b == c)
  {
    return true;
  }
  else 
  {
    return false;
  }
}

//returns true if all int's are different
boolean allDifferent(int a, int b, int c)
{
  if(a != b && a != c && b != c)
  {
    return true;
  }
  else 
  {
    return false;
  }
    
}
