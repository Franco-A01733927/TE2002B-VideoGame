class Heart{
  int x;
  
  Heart(int k){
    switch (k) {
      case 0: x = 1395;
           break;
      case 1: x = 1455;
            break;
      case 2: x = 1515;
            break;
    }
    
  }
  
  void show(){
    image(life, x, 25);
  }

}
