package nanosome.flow.easing
{
    public class EasingLineRunner
    {
        public static const SWITCHING_PRECISION:Number = .001;
        public static const ITERATIONS_LIMIT:uint = 40;

        protected var _line:EasingLine;
        protected var _position:Number;

        public function EasingLineRunner(startingLine:EasingLine, startingPosition:Number = 0)
        {
            _line = startingLine;
            setPosition(startingPosition);
        }

        public function setPosition(value:Number):Boolean
        {
            // NOTE - we're not checking position to be positive value
            if (value < _line._duration)
            {
                _position = value;
                return true;
            }
            else
            {
                _position = _line._duration;
                return false;
            }
        }

        public function makeStep(delta:Number):Boolean
        {
            return setPosition(_position + delta);
        }

        public function get value():Number
        {
            return _line.getValue(_position);
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

            _line = new EasingLine(newLine._easing, newLine._duration, calculatedStartValue, newLine._endValue);
            setPosition(calculatedPosition);
        }

        /**
         * Calculates position in the <code>targetLine</code>, so value of <code>targetLine</code> at this position
         * is close to <code>sourceValue</code>. This is required for seamless switching.
         *
         * Please note  that returned position is integer. This is required to keep number of iterations
         * for bisection method not that high. (You can increase duration of target line to raise precision).
         *
         *  @param targetLine New line to be switched to.
         *  @param sourceValue Current value, we're about to keep new one as close to it as we can.
         *
         *  @return Required position on the <code>targetLine</code>.
         */
        protected function calculatePosition(targetLine:EasingLine, sourceValue:Number):Number
        {
            var _iterations:int = 0;


            // 'from' position during seeking
            var fPos:Number = 0;

            // current position during seeking
            var cPos:Number = 0;

            // actual value during seeking
            var aVal:Number = targetLine._startValue;

            // 'to' position during seeking
            var tPos:Number = targetLine._duration;

            var targetFrom:Number = targetLine._startValue;

            var targetTo:Number = targetLine._startValue + targetLine._deltaValue;

            var srcValue:Number = sourceValue;

            /*
             * This algorithm is using bisection to find in the new easing line
             * a position, closest to current position.
             *
             * 1. Maybe we should limit a number of iterations instead of limiting range.
             * 2. This approach won't work well, if new easing line is too far from current value.
             *    although it should work good enough for alike transitions.
             */
            while (Math.abs(sourceValue - aVal) > SWITCHING_PRECISION && _iterations++ < ITERATIONS_LIMIT)
            {
                cPos = (fPos + tPos) / 2;
                aVal = targetLine.getValueForTest(cPos);

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

            return cPos;
        }

        public function getPositionForTest():Number
        {
            return _position;            
        }
    }
}
