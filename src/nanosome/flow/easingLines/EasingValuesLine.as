// @license@
package nanosome.flow.easingLines
{
    public class EasingValuesLine extends EasingLine
    {
        private var _easingLine:EasingLine;

        private var _startValue:Number;
        private var _deltaValue:Number;

        public function EasingValuesLine(easing:Function, duration:Number, startValue:Number, endValue:Number)
        {
            super(easing, duration);
            
            _startValue = startValue;
            _deltaValue = endValue - startValue;
        }

        public function getValue(progress:Number):Number
        {
            return _easingLine.calculateValue(progress, _startValue, _deltaValue);
        }

        /**
         * The best way to explain what this method does is an example:
         * <code>
         * var lineA:EasingValuesLine = new EasingValuesLine(Linear.easeIn, 5, 10, 5);
         * var lineB:EasingValuesLine = new EasingValuesLine(Linear.easeIn, 5,  5, 0);
         * </code>
         * Let's say you have to process lineA first from 10 to 5, then lineB from 5 to 0.
         * Duration of each transition is 5 seconds. 2 seconds later after start of lineA
         * value is 8, and suddenly there's command to start lineB. Value should be changing
         * smoothly, you can't jump from 0 to 5. Thus, we can't actually use lineB,
         * we need something more like lineC = new EasingValueLine(Linear.easeIn, duration, 8, 0);
         *
         * Thus, when we need to switch from lineA to lineB, we're using
         * lineA.getSwitchingLine(progress, lineB) instead of using lineB.
         *
         * @param progress
         * @param newLine
         * @return
         */
        public function getSwitchingLine(progress:Number, newLine:EasingValuesLine):EasingValuesLine
        {
            return new EasingValuesLine(
                        newLine.getEasingFunction(), newLine.getDuration(),
                        getValue(progress), newLine.getValue(1)
                   );
        }
    }
}
