package mytetris
{
	import flash.display.Sprite;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.KeyboardEvent;
	
	/**
	 * ...
	 * @author Elvira
	 */
	public class Main extends Sprite 
	{
		
	private const TS:uint=30;
    private var fieldArray:Array;
    private var fieldSprite:Sprite;
    private var tetrominoes:Array = new Array();
    private var colors:Array=new Array();
    private var tetromino:Sprite;
    private var currentTetromino:uint;
    private var nextTetromino:uint;
    private var currentRotation:uint;
    private var tRow:int;
    private var tCol:int;
    private var timeCount:Timer = new Timer(2000);
	private var gameOver:Boolean = false;
	private var isPause:Boolean = false;
	
    public function Main() {

        generateField();
		initTetrominoes();
		nextTetromino=Math.floor(Math.random()*7);
		generateTetromino();
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKDown);
		
    }
    private function generateField():void {
        fieldArray = new Array();
        fieldSprite=new Sprite();
        addChild(fieldSprite);
        fieldSprite.graphics.lineStyle(0,0xCFCCF7);
        for (var i:uint=0; i<20; i++) {
            fieldArray[i]=new Array();
            for (var j:uint=0; j<12; j++) {
                fieldArray[i][j]=0;
                fieldSprite.graphics.beginFill(0x404040);
                fieldSprite.graphics.drawRect(TS*j,TS*i,TS,TS);
                fieldSprite.graphics.endFill();
                }
            }
        }

      private function initTetrominoes():void {
          // I
        tetrominoes[0]=[[[0,0,0,0],[1,1,1,1],[0,0,0,0],[0,0,0,0]],
        [[0,1,0,0],[0,1,0,0],[0,1,0,0],[0,1,0,0]]];
        colors[0]=0x00FFFF;
        // T
        tetrominoes[1]=[[[0,0,0,0],[1,1,1,0],[0,1,0,0],[0,0,0,0]],
        [[0,1,0,0],[1,1,0,0],[0,1,0,0],[0,0,0,0]],
        [[0,1,0,0],[1,1,1,0],[0,0,0,0],[0,0,0,0]],
        [[0,1,0,0],[0,1,1,0],[0,1,0,0],[0,0,0,0]]];
        colors[1]=0xAA00FF;
        // L
        tetrominoes[2]=[[[0,0,0,0],[1,1,1,0],[1,0,0,0],[0,0,0,0]],
        [[1,1,0,0],[0,1,0,0],[0,1,0,0],[0,0,0,0]],
        [[0,0,1,0],[1,1,1,0],[0,0,0,0],[0,0,0,0]],
        [[0,1,0,0],[0,1,0,0],[0,1,1,0],[0,0,0,0]]];
        colors[2]=0xFFA500;
        // J
        tetrominoes[3]=[[[1,0,0,0],[1,1,1,0],[0,0,0,0],[0,0,0,0]],
        [[0,1,1,0],[0,1,0,0],[0,1,0,0],[0,0,0,0]],
        [[0,0,0,0],[1,1,1,0],[0,0,1,0],[0,0,0,0]],
        [[0,1,0,0],[0,1,0,0],[1,1,0,0],[0,0,0,0]]];
        colors[3]=0x0000FF;
        // Z
        tetrominoes[4]=[[[0,0,0,0],[1,1,0,0],[0,1,1,0],[0,0,0,0]],
        [[0,0,1,0],[0,1,1,0],[0,1,0,0],[0,0,0,0]]];
        colors[4]=0xFF0000;
        // S
        tetrominoes[5]=[[[0,0,0,0],[0,1,1,0],[1,1,0,0],[0,0,0,0]],
        [[0,1,0,0],[0,1,1,0],[0,0,1,0],[0,0,0,0]]];
        colors[5]=0x00FF00;
        // O
        tetrominoes[6]=[[[0,1,1,0],[0,1,1,0],[0,0,0,0],[0,0,0,0]]];
        colors[6]=0xFFFF00;
        }     
      private function generateTetromino():void {
          if (! gameOver) {
			  if (! isPause) {
				  currentTetromino = nextTetromino;
				  nextTetromino = Math.floor(Math.random() * 7);
				  drawNext();
				  currentRotation=0;
				  tRow=0;
				  if (tetrominoes[currentTetromino][0][0].indexOf(1)==-1) {
					  tRow=-1;
					  }
					  tCol=4;
					  if (canPlace(tRow, tCol, currentRotation)){			  
						  timeCount.addEventListener(TimerEvent.TIMER, onTime);
						  timeCount.start();
						  drawTetromino();
					  } else {
						  gameOver = true;
					  }
			  
			  }
		  }
      }
      private function drawNext():void {
          if (getChildByName("next")!=null) {
              removeChild(getChildByName("next"));
          }
          var next_t:Sprite=new Sprite();
          next_t.x=390;
          next_t.y=62
          next_t.name="next";
          addChild(next_t);
          next_t.graphics.lineStyle(0,0xb7b7b7);
          for (var i:int=0; i<tetrominoes[nextTetromino][0].length; i++) {
              for (var j:int=0; j<tetrominoes[nextTetromino][0][i].length; j++)
              {
                  if (tetrominoes[nextTetromino][0][i][j]==1) {
                      next_t.graphics.beginFill(colors[nextTetromino]);
                      next_t.graphics.drawRect(TS*j,TS*i,TS,TS);
                      next_t.graphics.endFill();
                  }
              }
          }
      }
	  
      private function onTime(e:TimerEvent):void {
          if(!isPause && !gameOver){
			  if (canPlace(tRow+1,tCol,currentRotation)) {
				  tRow++;
				  placeTetromino();
				  } else {
					  landTetromino();
					  generateTetromino();
				  }
		  }
      }
      private function drawTetromino():void {
          var ct:uint=currentTetromino;
          tetromino=new Sprite();
          addChild(tetromino);
          tetromino.graphics.lineStyle(0,0xCFCCF7);
          for (var i:int=0; i<tetrominoes[ct][currentRotation].length; i++)
          {
              for (var j:int=0; j<tetrominoes[ct][currentRotation][i].length; j++) {
                  if (tetrominoes[ct][currentRotation][i][j]==1) {
                      tetromino.graphics.beginFill(colors[ct]);
                      tetromino.graphics.drawRect(TS*j,TS*i,TS,TS);
                      tetromino.graphics.endFill();
                  }
              }
          }
          placeTetromino();
          }     
      private function placeTetromino():void {
          tetromino.x=tCol*TS;
          tetromino.y=tRow*TS;
      }
      private function onKDown(e:KeyboardEvent):void {
		  if (! gameOver) {
			  switch (e.keyCode) {
				  case 37 :
					if (! isPause) {
					  if (canPlace(tRow,tCol-1,currentRotation)) {
						  tCol--;
						  placeTetromino();
					  }
				    }
				  break;
			  case 38 :
				  if (! isPause) {
					  var ct:uint=currentRotation;
					  var rot:uint=(ct+1)%tetrominoes[currentTetromino].length;
					  if (canPlace(tRow,tCol,rot)) {
						  currentRotation=rot;
						  removeChild(tetromino);
						  drawTetromino();
						  placeTetromino();
					  }
				  }
				  break;
			  case 39 :
				  if (! isPause) {
					  if (canPlace(tRow,tCol+1,currentRotation)) {
						  tCol++;
						  placeTetromino();
					  }
				  }
				  break;
			  case 40 :
				  if (! isPause) {
					  if (canPlace(tRow + 1, tCol, currentRotation)) {
						  tRow++;
						  placeTetromino();
						  }   else {
							  landTetromino();
							  generateTetromino();
						  }
				  }
					  break;
				  case 32:
					  if (! isPause) {
						  while (canPlace(tRow + 1, tCol, currentRotation)) {
							  tRow++;
							  placeTetromino();
						  }
						  landTetromino();
						  generateTetromino();
					  }
					  break;
				  case 80:
					  isPause = !isPause;
					  break;
			  }
		  }
      }
      private function landTetromino():void {
          var ct:uint=currentTetromino;
          var landed:Sprite;
          for (var i:int=0; i<tetrominoes[ct][currentRotation].length; i++)
          {
              for (var j:int=0; j<tetrominoes[ct][currentRotation][i].length; j++) {
                  if (tetrominoes[ct][currentRotation][i][j]==1) {
                      landed = new Sprite();
                      addChild(landed);
                      landed.graphics.lineStyle(0,0x000000);
                      landed.graphics.beginFill(colors[currentTetromino]);
                      landed.graphics.drawRect(TS*(tCol+j),TS*(tRow+i),TS,TS);
                      landed.graphics.endFill();
                      landed.name="r"+(tRow+i)+"c"+(tCol+j);
                      fieldArray[tRow+i][tCol+j]=1;
                  }
              }
          }
          removeChild(tetromino);
          checkForLines();
      }
      private function checkForLines():void {
          for (var i:int=0; i<20; i++) {
              if (fieldArray[i].indexOf(0)==-1) {
                  for (var j:int=0; j<12; j++) {
                      fieldArray[i][j]=0;
                      removeChild(getChildByName("r"+i+"c"+j));
                  }
                  for (j=i; j>=0; j--) {
                      for (var k:int=0; k<12; k++) {
                          if (fieldArray[j][k]==1) {
                              fieldArray[j][k]=0;
                              fieldArray[j+1][k]=1;
                              getChildByName("r"+j+"c"+k).y+=TS;
                              getChildByName("r"+j+"c"+k).name="r"+(j+1)+"c"+k;
                          }
                      }
                  }
              }
          }
      }
      private function canPlace(row:int,col:int,side:uint):Boolean {
          var ct:uint=currentTetromino;
          for (var i:int=0; i<tetrominoes[ct][side].length; i++) {
              for (var j:int=0; j<tetrominoes[ct][side][i].length; j++) {
                  if (tetrominoes[ct][side][i][j]==1) {
                      // out of left boundary
                      if (col+j<0) {
                          return false;
                          }
                          // out of right boundary
                          if (col+j>11) {
                              return false;
                          }
                          // out of bottom boundary
                          if (row+i>19) {
                              return false;
                          }
                          // out of top boundary
                          if (row+i<0) {
                              return false;
                          }
                          // over another tetromino
                          if (fieldArray[row+i][col+j]==1) {
                              return false;
                          }
                      }
                  }
              }
              return true;
		}
		
	}	
}