package animators
{
    import nanosome.flow.visualizing.animators.base.BaseAnimator;

    public class BaseTestableAnimator extends BaseAnimator
    {
        public function compareNumbers(comparingFirstValue:Number, comparingSecondValue:Number, positiveContextDelta:Boolean):int
        {
            return _compareNumbers(comparingFirstValue, comparingSecondValue, positiveContextDelta);
        }
    }
}
