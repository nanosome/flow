package nanosome.flow.visualizing.animators.abstract
{
    import nanosome.flow.easing.TimedEasing;
    import nanosome.flow.visualizing.ticking.ITickGenerator;
    import nanosome.flow.visualizing.ticking.TickGenerator;
    import nanosome.flow.visualizing.ticking.TickGeneratorEvent;

    public class BaseAnimator
    {
        protected static const SWITCHING_ITERATIONS_LIMIT:uint = 16;

        protected var _timedEasing:TimedEasing;
        protected var _position:Number;
        protected var _startValue:*;
        protected var _endValue:*;

        protected var _tickGenerator:ITickGenerator;

        public function BaseAnimator()
        {
            _tickGenerator = new TickGenerator();
            _tickGenerator.addEventListener(TickGeneratorEvent.TICK_UPDATE, onTickUpdate);
        }

        public function setCustomTickGenerator(tickGenerator:ITickGenerator):void
        {
            _tickGenerator.removeEventListener(TickGeneratorEvent.TICK_UPDATE, onTickUpdate);
            _tickGenerator = tickGenerator;
            _tickGenerator.addEventListener(TickGeneratorEvent.TICK_UPDATE, onTickUpdate);
        }

        protected function onTickUpdate(event:TickGeneratorEvent):void
        {
            throw new Error("This method should be overridden");
        }

        protected function _animate(easing:Function, duration:Number, newStartValue:*, newEndValue:*, isReversing:Boolean):void
        {
            var newTimedEasing = new TimedEasing(easing, duration);
            var currentValue:* = calculateValue(_startValue, _endValue, _timedEasing, _position);
            if (!isReversing)
            {
                _startValue = currentValue;
                _position = 0;
            }
            else
            {
                _startValue = newStartValue;

                if (!(_startValue == newEndValue && _endValue == newStartValue))
                    throw new Error(
                        "Current easing line starting/ending values " +
                        "(" + _startValue + ".." + newEndValue + ") " +
                        "should match to reversed starting/ending values of the new line " +
                        "(" + _startValue + ".." + newStartValue + ")."
                    );

                _position = calculatePosition(currentValue, newTimedEasing, newStartValue, newEndValue);

            }
             _timedEasing = newTimedEasing;
            _endValue = newEndValue;
        }


        protected function calculatePosition(
            sourceValue: *,
            targetEasing:TimedEasing, targetStartValue: *, targetEndValue: *
        ):Number
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
                    calculateValue(targetStartValue, targetEndValue, targetEasing, cPos),
                    targetStartValue, targetEndValue
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
        protected function compare(comparingFirstValue:*, comparingSecondValue: *, contextStartValue:*, contextEndValue:*):int
        {
            throw new Error("This method should be overriden");
        }

        protected function calculateValue(startValue:*, endValue:*, timedEasing:TimedEasing, position:Number):*
        {
            throw new Error("This method should be overriden");
        }

    }
}
