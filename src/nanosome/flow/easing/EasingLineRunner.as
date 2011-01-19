package nanosome.flow.easing
{
    public class EasingLineRunner
    {
        private static const SWITCHING_PRECISION:Number = .001;

        private var _line:EasingLine;
        private var _position:Number;

        public function EasingLineRunner(initialPosition:uint = 0)
        {
            setPosition(initialPosition);
        }

        public function setEasingLine(value:EasingLine):void
        {
            _line = value;
        }

        public function setPosition(value:Number):void
        {
            _position = value;
        }

        public function makeStep(delta:Number):void
        {
            _position += delta;
        }

        public function get value():Number
        {
            return _line.getValueForTest(_position);
        }

        /**
         * Switching to new easing lines is tricky.
         * Let's imagine we have a black button. On rollover it should quickly become green,
         * on press it should very slowly turn from green to red.
         *
         * If we're performing "black to green" transition, and in the midst of it,
         * reversing direction back to black - transition should be done quickly.
         *
         * If in the midst of "black to green" we're switching to "green to red",
         * then button should slowly turn to green from whatever color it has now.
         *
         * Thus, reversing easing and switching to new one is very different.
         */
        public function switchToNewEasingLine(newLine:EasingLine, isReversing:Boolean):void
        {

            var calculatedStartValue:Number;
            var calculatedPosition:Number;

            if (!isReversing)
            {
                calculatedStartValue = this.value;
                calculatedPosition = 0; // start from 0
            }
            else
            {
                calculatedStartValue = newLine._startValue;

                if (!(_line._startValue == newLine._endValue && _line._endValue == newLine._startValue))
                    throw new Error(
                        "Current easing line starting/ending values (" + _line._startValue + ".." + _line._endValue +
                        ") should match to reversed starting/ending values of the new line " +
                        "(" + newLine._startValue + ".." + newLine._endValue + ")."
                    );

                // now we have to calculate position
                if (newLine._duration < _position)
                    calculatedPosition = 0;
                else
                    calculatedPosition = calculatePosition(newLine, this.value);
            }

            setEasingLine(
                new EasingLine(newLine._easing, newLine._duration, calculatedStartValue, newLine._endValue)
            );
            setPosition(calculatedPosition);
        }

        /**
         *  Calculates position at in the current <code>sourceLine</code> required to seamlessly switch to <code>targetLine</code>.
         *
         *  @param targetLine New line to be switched to.
         *  @param sourceValue Current value, we're about to keep new one as close to it as we can.
         *
         *  @return Position of the playhead in the current easingLine
         */
        protected function calculatePosition(targetLine:EasingLine, sourceValue:Number):uint
        {
            // sourceValue is the value required to catch

            // actual value during seeking
            var aVal:Number;

            // current position during seeking
            var cPos:int;

            // 'from' position during seeking
            var fPos:int = 0;

            // 'to' position during seeking
            var tPos:Number = targetLine._duration;

            var targetFrom:Number = targetLine._startValue;

            var targetTo:Number = targetLine._startValue + targetLine._deltaValue;

            var srcValue:Number = Math.round(sourceValue / SWITCHING_PRECISION);

            /*
             * This algorithm is using bisection to find in the new easing line
             * a position, closest to current position.
             *
             * 1. Maybe we should limit a number of iterations instead of limiting range.
             * 2. This approach won't work well, if new easing line is too far from current value.
             *    although it should work good enough for alike transitions.
             */
            while (Math.abs(fPos - tPos) > 1)
            {
                cPos = Math.round((fPos + tPos) / 2);
                aVal = Math.round(targetLine.getValueForTest(cPos) / SWITCHING_PRECISION);

                if (targetFrom < targetTo)
                {
                    if (aVal > srcValue)
                        tPos = cPos;
                    else if (aVal < srcValue)
                        fPos = cPos;
                    else
                        return cPos;
                }
                else
                {
                    if (aVal < srcValue)
                        tPos = cPos;
                    else if(aVal > srcValue)
                        fPos = cPos;
                    else
                        return cPos;
                }
            }

            var fDiff:Number = Math.abs(srcValue - targetLine.getValueForTest(fPos) / SWITCHING_PRECISION);
            var tDiff:Number = Math.abs(srcValue - targetLine.getValueForTest(tPos) / SWITCHING_PRECISION);
            return fDiff < tDiff ? fPos : tPos;
        }

        public function getPositionForTest():Number
        {
            return _position;            
        }
    }
}
