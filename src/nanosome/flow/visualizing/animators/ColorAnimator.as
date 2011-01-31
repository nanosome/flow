package nanosome.flow.visualizing.animators
{
    import nanosome.flow.easing.TimedEasing;
    import nanosome.flow.visualizing.animators.base.BaseAnimator;

    public class ColorAnimator extends BaseAnimator
    {
        protected var _startR:int;
        protected var _startG:int;
        protected var _startB:int;

        protected var _endR:int;
        protected var _endG:int;
        protected var _endB:int;

        protected var _deltaR:int;
        protected var _deltaG:int;
        protected var _deltaB:int;

        override protected function compare(comparingFirstValue:*, comparingSecondValue: *):int
        {
            if (comparingFirstValue == comparingSecondValue)
                return 0;

            var cR:int = _compareNumbers(
                red(comparingFirstValue), red(comparingSecondValue),
                _startR, _endR
            );
            var cG:int = _compareNumbers(
                green(comparingFirstValue), green(comparingSecondValue),
                _startG, _endG
            );
            var cB:int = _compareNumbers(
                blue(comparingFirstValue), blue(comparingSecondValue),
                _startB, _endB
            );

            var more:Boolean = (cR > 0 || cG > 0 || cB > 0);
            var less:Boolean = (cR < 0 || cG < 0 || cB < 0);

            if (more && !less)
                return 1;

            if (less && !more)
                return -1;

            throw new Error(
                "Error while comparing color values 0x" + comparingFirstValue.toString(16) +
                " and 0x" + comparingSecondValue.toString(16) + "(less: " + less + ", more: " + more + ")"
            );
        }

        override protected function calculateValue(timedEasing:TimedEasing, position:Number):*
        {
            var cR:int = Math.round(timedEasing.easing(position, _startR, _deltaR, timedEasing.duration));
            var cG:int = Math.round(timedEasing.easing(position, _startG, _deltaG, timedEasing.duration));
            var cB:int = Math.round(timedEasing.easing(position, _startB, _deltaB, timedEasing.duration));
            
            return (cR << 16) | (cG << 8) | cB;
        }

        override protected function setStartEndValues(startValue:*, endValue:*):void
        {
            super.setStartEndValues(startValue, endValue);
            _startR = red(_startValue);
            _startG = green(_startValue);
            _startB = blue(_startValue);

            _endR = red(_endValue);
            _endG = green(_endValue);
            _endB = blue(_endValue);

            _deltaR = _endR - _startR;
            _deltaG = _endG - _startG;
            _deltaB = _endB - _startB;
        }

        protected function red(value:uint):int
        {
            return (value >> 16) & 0xFF;
        }

        protected function green(value:uint):int
        {
            return (value >> 8) & 0xFF;
        }

        protected function blue(value:uint):int
        {
            return (value & 0xFF);
        }

    }
}
