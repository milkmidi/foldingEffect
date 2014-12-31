/**
 * @author milkmidi
 * @date created 2014/12/30/
 */
package  {		
	import com.greensock.TweenMax;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	
	[SWF(width = "990", height = "400", frameRate = "30", backgroundColor = "#ffffff")]
	public class FoldingTest2DMainEntry extends Sprite{	
		private static const LINE_LENGTH:int = 150;
		private const MAX_ANGLE		:Number = 40;
		private const TWEEN_DURATION:Number = 1.2;
		private var _container			:Sprite;
		private var _currentAngle		:Number = 0;
		private var _isOpen				:Boolean = true;
		//private static const DEGRESS_TO_RADIAN:Number = Math.PI / 180;
		private static const DEGRESS_TO_RADIAN:Number = 0.017453292519943295;
		
		private static const TEST_WITH_PIVOT:Boolean = true;
		//__________________________________________________________________________________ Constructor
		public function FoldingTest2DMainEntry()  {			
			stage.scaleMode = "noScale";
			stage.align = "tl";
			
			this.addChild( _container = new Sprite );			
			this._container.y = stage.stageHeight >> 1;
			
		
			for (var i:int = 0; i < 7; i++) {
				var cube:Shape;
				if (i % 2 ==0) {
					cube = getRedCube();
				}else {
					cube = getBlackCub( TEST_WITH_PIVOT );
				}
				cube.x = i * LINE_LENGTH;
				
				this._container.addChild( cube );
			}			
			stage.addEventListener(MouseEvent.CLICK , onClick );	
			this.currentAngle = 45;
		}

		
		private function onClick(e:MouseEvent):void {		
			_isOpen = !_isOpen;
			TweenMax.killTweensOf( this );
			trace( _isOpen );
			if (_isOpen){
				TweenMax.to( this , TWEEN_DURATION , { currentAngle:MAX_ANGLE  } );
			}else {
				TweenMax.to( this , TWEEN_DURATION , { currentAngle:0  } );
			}
		}
		private function foldAccordion( deg:Number ):void {
			var radius:Number = deg * DEGRESS_TO_RADIAN;
			for (var i:int = 0; i < _container.numChildren; i++) {
				var child:DisplayObject = _container.getChildAt( i );
				child.rotation = deg * Math.pow( -1, i);				
				if (i % 2 == 0) {								
					// even
					child.x = Math.cos(radius)  * LINE_LENGTH * i;								
				}else {
					// odd
					child.y = Math.sin(radius) * LINE_LENGTH;
					child.x = Math.cos(radius) * LINE_LENGTH * i;		
				}							
			}			
		}
		private function foldAccordionWithPivot( deg:Number):void {
			var radius:Number = deg * DEGRESS_TO_RADIAN;
			for (var i:int = 0; i < _container.numChildren; i++) {
				var child:DisplayObject = _container.getChildAt( i );
				child.rotation = deg * Math.pow( -1, i);				
				if (i % 2 == 0) {								
					// even
					child.x = Math.cos(radius)  * LINE_LENGTH * i;								
				}else {
					// odd
					var value:Number = Math.cos(radius)  * LINE_LENGTH;
					child.x = value * i + value;
				}							
			}		
		}
		
		private function getRedCube():Shape {
			var shape:Shape = new Shape();
			var g:Graphics = shape.graphics;
			g.beginFill( 0xff0000 );
			g.drawRect(0, 0, LINE_LENGTH, 10);
			g.beginFill( 0x00ff00 );
			g.drawCircle(0, 0, 10);
			
			
			return shape;
		}
		public function getBlackCub( pivot:Boolean = false):Shape {
			var black:Shape = new Shape;
			var g:Graphics = black.graphics;
			g.beginFill( 0x000000 );
			if (pivot) {
				g.drawRect( -LINE_LENGTH, 0, LINE_LENGTH, 10);				
			}else {
				g.drawRect( 0, 0, LINE_LENGTH, 10);				
			}
			
			
			g.beginFill( 0x0000ff );
			g.drawCircle(0, 0, 10);
			return black;
		}
		
		public function get currentAngle():Number {	return _currentAngle; }		
		public function set currentAngle(value:Number):void {
			_currentAngle = value;
			if (TEST_WITH_PIVOT) {
				foldAccordionWithPivot( _currentAngle );	
			}else {
				foldAccordion( _currentAngle );	
			}
			
		}
		
	
		
	}//__________________________________________________________________________________ End Class
}//__________________________________________________________________________________ End Package
