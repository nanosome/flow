package nanosome.flow.easing
{
    public class EasingLineRunner
    {
        private var _line:EasingLine;
        public var _position:Number;

        public function EasingLineRunner()
        {
            setPosition(0);
        }

        public function setEasingLine(value:EasingLine):void
        {
            _line = value;
        }

        private function setPosition(value:Number):void
        {
            _position = value;
        }

        public function makeStep(delta:Number):void
        {
            _position += delta;
        }

        public function get value():Number
        {
            return _line.getValue(_position); // using normalized length
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

            var calculatedLine:EasingLine;
            var calculatedPosition:Number;

            if (!isReversing)
            {
                calculatedLine = new EasingLine(
                    new TimedEasing(newLine._easing, newLine._duration),
                    this.value, newLine._startValue + newLine._deltaValue
                );
                calculatedPosition = 0; // start from 0
            }
            else
            {
                calculatedLine = new EasingLine(
                    new TimedEasing(newLine._easing, newLine._duration),
                    newLine._startValue, newLine._startValue + newLine._deltaValue
                );

                // now we have to calculate position

                if (newLine._duration < _position)
                    calculatedPosition = 0;
                else
                    calculatedPosition = calculatePosition(newLine, this.value);
            }

            setEasingLine(calculatedLine);
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
            var cPos:uint;

            // 'from' position during seeking
            var fPos:uint = 0;

            // 'to' position during seeking
            var tPos:Number = targetLine._duration;

            var targetFrom:Number = targetLine._startValue;

            var targetTo:Number = targetLine._startValue + targetLine._deltaValue;

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
                aVal = targetLine.getValue(cPos);
                if (targetFrom < targetTo)
                {
                    if (aVal >= sourceValue)
                        tPos = cPos;
                    else if (aVal < sourceValue)
                        fPos = cPos;
                }
                else
                {
                    if (aVal <= sourceValue)
                        tPos = cPos;
                    else if(aVal > sourceValue)
                        fPos = cPos;
                }
            }
            return cPos;
        }

    }
}
