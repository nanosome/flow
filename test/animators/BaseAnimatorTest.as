package animators
{

    import mx.effects.easing.Linear;
    import org.flexunit.Assert;

    public class BaseAnimatorTest
    {
        [Test]
        public function areNumbersComparedWithinDifferentContext():void
        {
            var animator:BaseTestableAnimator = new BaseTestableAnimator();

            Assert.assertTrue(
                "Comparison - 1 is more than 3 with positive context delta",
                animator.compareNumbers(1, 3, true) < 0
            );

            Assert.assertTrue(
                "Comparison - 1 is less than 3 in negative context delta",
                animator.compareNumbers(1, 3, false) > 0
            );

            Assert.assertTrue(
                "Comparison - 2 is equal to 2 in positive context delta",
                animator.compareNumbers(2, 2, true) == 0
            );

            Assert.assertTrue(
                "Comparison - 2 is equal to 2 in negative context delta",
                animator.compareNumbers(2, 2, false) == 0
            );
        }

    }
}

import nanosome.flow.visualizing.animators.base.BaseAnimator;

internal class BaseTestableAnimator extends BaseAnimator
{
    public function compareNumbers(comparingFirstValue:Number, comparingSecondValue:Number, positiveContextDelta:Boolean):int
    {
        return _compareNumbers(comparingFirstValue, comparingSecondValue, positiveContextDelta);
    }
}