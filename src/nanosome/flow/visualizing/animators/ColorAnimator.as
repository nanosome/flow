package nanosome.flow.visualizing.animators
{
    import flash.display.DisplayObject;

    import nanosome.flow.easing.TimedEasing;
    import nanosome.flow.visualizing.animators.base.BaseAnimator;

    public class ColorAnimator extends BaseAnimator
    {
        public function animate(easing:Function, duration:Number, fromValue:Number, toValue:Number, isReversing:Boolean):void
        {
            _animate(easing,  duration, fromValue, toValue, isReversing);
        }


        // returns value less than 0, if comparingFirstValue < comparingSecondValue,
        // more than 0, if comparingFirstValue > comparingSecondValue,
        // 0, if they are equal
        override protected function compare(comparingFirstValue:*, comparingSecondValue: *, contextStartValue:*, contextEndValue:*):int
        {
            if (comparingFirstValue == comparingSecondValue)
                return 0;

            var cR:int = _compareNumbers(
                red(comparingFirstValue), red(comparingSecondValue),
                red(contextStartValue), red(contextEndValue)
            );
            var cG:int = _compareNumbers(
                green(comparingFirstValue), green(comparingSecondValue),
                green(contextStartValue), green(contextEndValue)
            );
            var cB:int = _compareNumbers(
                blue(comparingFirstValue), blue(comparingSecondValue),
                blue(contextStartValue), blue(contextEndValue)
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

        override protected function calculateValue(startValue:*, endValue:*, timedEasing:TimedEasing, position:Number):*
        {
            var fR:int = red(startValue);
            var fG:int = green(startValue);
            var fB:int = blue(startValue);

            var cR:int = Math.round(timedEasing.easing(position, fR, red(endValue) - fR, timedEasing.duration));
            var cG:int = Math.round(timedEasing.easing(position, fG, green(endValue) - fG, timedEasing.duration));
            var cB:int = Math.round(timedEasing.easing(position, fB, blue(endValue) - fB, timedEasing.duration));
            
            return (cR << 16) | (cG << 8) | cB;
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
