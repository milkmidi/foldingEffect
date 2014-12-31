/**
 * @author milkmidi
 * @date created 2014/12/30/
 */
package  {		
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	
	[SWF(width = "990", height = "500", frameRate = "30", backgroundColor = "#ffffff")]
	public class FoldingEffectWithYZMainEntry extends Sprite{		
		[Embed(source = "img_480.png")]
		private static const IMAGE:Class;
		
		private const MAX_ANGLE		:Number = 65;
		private const TWEEN_DURATION:Number = 1.2;
		private var _sliceWidth		:int;
		private var _sliceHeight	:int;	
		private var _childArr		:Vector.<DisplayObject>;
		private var _isOpen			:Boolean = true;
		private var _lightEdgeFactor:Number = 0;
		private var _darkEdgeFactor	:Number = 0.5;
		private var _numSlices		:int = 5;	
		
		private var _currentAngle	:Number = 0;
		
		//private static const DEGRESS_TO_RADIAN:Number = Math.PI / 180;
		private static const DEGREE_TO_RADIAN:Number = 0.017453292519943295;
		
		public function FoldingEffectWithYZMainEntry() {
			super();
			
			var bitmapData:BitmapData = Bitmap( new IMAGE()).bitmapData;
			
			this.x = stage.stageWidth - bitmapData.width >> 1;
			
			
			var picWidth	:int = bitmapData.width;
			var picHeight	:int = bitmapData.height;
			this._sliceWidth = picWidth;
			this._sliceHeight  = picHeight / _numSlices;		
			this._childArr = new Vector.<DisplayObject>();
			
			trace("numSlices:" + _numSlices, "_sliceHeight:" + _sliceHeight);		
			
			for (var i:int = 0; i < _numSlices; i++) {			
				
				var bmd:BitmapData = new BitmapData(_sliceWidth, _sliceHeight);
				bmd.copyPixels(bitmapData, new Rectangle(0, i * _sliceHeight, _sliceWidth, _sliceHeight), new Point(0, 0));			
				
				var child:Sprite = new Sprite;				
				var bitmap:Bitmap = new Bitmap(bmd);
				child.addChild( bitmap );
				
				// center color for debugging
				var shape:Shape = new Shape;
				shape.graphics.beginFill( 0x00ff00 );
				shape.graphics.drawCircle( 0, 0, 15 );
				child.addChild( shape );
				
				child.y = i * _sliceHeight;
				if (i % 2 == 0) {					
					//child.y = i * _sliceHeight;
				}else {
					//bitmap.y = -_sliceHeight;
					//child.y = i * _sliceHeight + _sliceHeight;
				}				
				_childArr.push( child );
				addChild(_childArr[i]);
			}
			
			addEventListener(MouseEvent.CLICK, onClick);
			this._currentAngle = 45;
			foldAccordion( this._currentAngle);
		}

		private function foldAccordion( deg:Number ):void {
			
			
			var evenFactor	:Number = ( -_darkEdgeFactor / MAX_ANGLE) * deg + 1;
			var oddFactor	:Number = (_lightEdgeFactor / MAX_ANGLE) * deg + 1;
			var radian		:Number = deg * DEGREE_TO_RADIAN;		
			var child		:DisplayObject;
			
			for (var i:int = 0; i < _numSlices; i++) {
				child = _childArr[i];
				child.rotationX = deg * Math.pow( -1, i);				
				
				if (i % 2 == 0) {
					// even
					child.y = _sliceHeight * Math.cos(radian) * i;
					child.transform.colorTransform = new ColorTransform(evenFactor, evenFactor, evenFactor, 1, 0, 0, 0, 0);					
					
					//child.y = i * _sliceHeight;
				} else {
					// odd
					child.z = _sliceHeight * Math.sin(radian) ;
					child.y = _sliceHeight * Math.cos(radian) * i;
					child.transform.colorTransform = new ColorTransform(oddFactor, oddFactor, oddFactor, 1, 0, 0, 0, 0);
					
				}
			
			}
		}
		

		private function onClick(e:MouseEvent):void {		
			_isOpen = !_isOpen;
			TweenMax.killTweensOf( this );
			if (_isOpen){
				TweenMax.to( this , TWEEN_DURATION , { currentAngle:MAX_ANGLE  } );
			}else {
				TweenMax.to( this , TWEEN_DURATION , { currentAngle:0  } );
			}
		}
		
		public function get currentAngle():Number {	return _currentAngle;	}	
		public function set currentAngle(value:Number):void {
			_currentAngle = value;
			foldAccordion( _currentAngle );
		}
		
	}//__________________________________________________________________________________ End Class
}//__________________________________________________________________________________ End Package
