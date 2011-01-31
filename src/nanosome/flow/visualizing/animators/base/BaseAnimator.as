package nanosome.flow.visualizing.animators.base
{
    import nanosome.flow.easing.TimedEasing;
    import nanosome.flow.visualizing.ticking.ITickGenerator;
    import nanosome.flow.visualizing.ticking.TickGenerator;
    import nanosome.flow.visualizing.ticking.TickGeneratorEvent;

    public class BaseAnimator
    {
        protected static const SWITCHING_ITERATIONS_LIMIT:uint = 30;

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

        public function get position():Number
        {
            return _position;
        }

        public function get value():*
        {
            return calculateValue(_timedEasing, _position);
        }

        protected function onTickUpdate(event:TickGeneratorEvent):void
        {
            if (!makeStep(event.delta))
                _tickGenerator.stop();
        }

        protected function makeStep(delta:Number):Boolean
        {
            _position += delta;
            if (_position > _timedEasing.duration)
            {
                _position = _timedEasing.duration;
                return false;
            }
            return true;
        }

        protected function _switchTo(easing:Function, duration:Number, newStartValue:*, newEndValue:*):void
        {
            if (_timedEasing)
            {
                switchEasingTo(easing, duration, newEndValue);
                return;
            }

            _timedEasing = new TimedEasing(easing, duration);
            _startValue = newStartValue;
            _endValue = newEndValue;
            _position = 0;
        }

        protected function _reverseTo(easing:Function, duration:Number):void
        {
            var newTimedEasing:TimedEasing = new TimedEasing(easing, duration);
            var currentValue:* = this.value;

            var newStartValue:* = _endValue;
            _endValue = _startValue;
            _startValue = newStartValue;
            _position = calculatePosition(currentValue, newTimedEasing);

            _timedEasing = newTimedEasing;
        }

        private function switchEasingTo(easing:Function, duration:Number, newEndValue:*):void
        {
            _startValue = this.value;
            _position = 0;

             _timedEasing = new TimedEasing(easing, duration);
            _endValue = newEndValue;
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
                    calculateValue(targetEasing, cPos),
                    _startValue, _endValue
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

        protected function calculateValue(timedEasing:TimedEasing, position:Number):*
        {
            throw new Error("This method should be overriden");
        }

        protected function _compareNumbers (comparingFirstValue:Number, comparingSecondValue:Number, contextStartValue:Number, contextEndValue:Number):int
        {
            var biggerValue:Number;
            var lesserValue:Number;

            if (comparingFirstValue == comparingSecondValue)
                return 0;

            if (contextEndValue > contextStartValue)
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
