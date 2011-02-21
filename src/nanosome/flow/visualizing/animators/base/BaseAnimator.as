package nanosome.flow.visualizing.animators.base
{
    import flash.events.EventDispatcher;

    import mx.effects.easing.Linear;

    import nanosome.flow.visualizing.TimedEasing;

    public class BaseAnimator extends EventDispatcher
    {
        protected static const SWITCHING_ITERATIONS_LIMIT:uint = 30;

        protected var _timedEasing:TimedEasing;
        protected var _position:Number;
        protected var _startValue:*;
        protected var _endValue:*;


        public function BaseAnimator()
        {
            _position = 0;
        }

        public function get position():Number
        {
            return _position;
        }

        public function makeStep(delta:Number):Boolean
        {
            _position += delta;
            if (_position > _timedEasing.duration)
            {
                _position = _timedEasing.duration;
                return false;
            }
            return true;
        }

        protected function setStartEndValues(startValue:*, endValue:*):void
        {
            _startValue = startValue;
            _endValue = endValue;
        }

        public function setInitialValue(startValue:*):void
        {
            // we have to mimic switching because some transformations (like shaders)
            // may require both inputs
            switchTo(Linear.easeIn, 1, startValue, startValue);
        }

        public function switchTo(easing:Function, duration:Number, newStartValue:*, newEndValue:*):void
        {
            if (_timedEasing)
            {
                switchEasingTo(easing, duration, newEndValue);
                return;
            }
            setStartEndValues(newStartValue, newEndValue);
            _timedEasing = new TimedEasing(easing, duration);
            _position = 0;
            update();
        }

        private function switchEasingTo(easing:Function, duration:Number, newEndValue:*):void
        {
            setStartEndValues(switchingValue, newEndValue);
            _timedEasing = new TimedEasing(easing, duration);
            _position = 0;
        }

        public function reverseTo(easing:Function, duration:Number):void
        {
            var newTimedEasing:TimedEasing = new TimedEasing(easing, duration);
            var targetValue:* = this.value;

            setStartEndValues(_endValue, _startValue);
            _position = calculatePosition(targetValue, newTimedEasing);
            _timedEasing = newTimedEasing;
        }

        protected function calculatePosition(sourceValue: *,  targetEasing:TimedEasing):Number
        {
            var _iterations:int = 0;

            // 'from' position during seeking
            var fPos:Number = 0;

            // current position during seeking
            var cPos:Number = 0;

            // 'to' position during seeking
            var tPos:Number = targetEasing.duration;

            var compareResult:int = 1;

            while (compareResult != 0 && _iterations++ < SWITCHING_ITERATIONS_LIMIT)
            {
                cPos = (fPos + tPos) / 2;
                compareResult = compare(
                    sourceValue,
                    calculateValueToCompare(targetEasing, cPos)
                );

                if (compareResult == 0)
                    return cPos;

                if (compareResult < 0)
                    tPos = cPos;
                else
                    fPos = cPos;
            }
            return cPos;
        }

        // returns value less than 0, if comparingFirstValue < comparingSecondValue,
        // more than 0, if comparingFirstValue > comparingSecondValue,
        // 0, if they are equal
        protected function compare(comparingFirstValue:*, comparingSecondValue: *):int
        {
            throw new Error("This method should be overriden");
        }

        protected function calculateValueToCompare(timedEasing:TimedEasing, position:Number):*
        {
            throw new Error("This method should be overriden");
        }

        public function get value():*
        {
            return calculateValueToCompare(_timedEasing, _position);
        }

        public function get switchingValue():*
        {
            return this.value;
        }

        public function update():void
        {}

        protected function _compareNumbers (comparingFirstValue:Number, comparingSecondValue:Number, positiveContextDelta:Boolean):int
        {
            var biggerValue:Number;
            var lesserValue:Number;

            if (comparingFirstValue == comparingSecondValue)
                return 0;

            if (positiveContextDelta)
            {
                lesserValue = comparingFirstValue;
                biggerValue = comparingSecondValue;
            }
            else
            {
                lesserValue = comparingSecondValue;
                biggerValue = comparingFirstValue;
            }

            if (lesserValue < biggerValue)
                return -1;

            return 1;
        }
    }
}
