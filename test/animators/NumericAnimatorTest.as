package animators
{
    import mx.effects.easing.Exponential;
    import mx.effects.easing.Linear;

    import org.flexunit.Assert;

    import nanosome.flow.visualizing.animators.base.NumericAnimator;

    import utils.roundWithPrecision;

    import visualizing.TestingTickGenerator;

    public class NumericAnimatorTest
    {
        [Test]
        public function areStepsWorkingCorrectly():void
        {
            var precision:Number = NumericAnimator.SWITCHING_PRECISION;
            var animator:NumericAnimator = new NumericAnimator();
            var tickGenerator:TestingTickGenerator = new TestingTickGenerator();
            animator.setCustomTickGenerator(tickGenerator);

            animator.animate(Linear.easeIn, 500, 10, 110, false);

            Assert.assertEquals(
                "Initial animator value before animation starts",
                10,  roundWithPrecision(animator.value, precision)
            );

            tickGenerator.makeTicks(250);

            Assert.assertEquals(
                "Animator value, 250 of 500 steps, value range 10.. 110",
                60, roundWithPrecision(animator.value, precision)
            );
        }

        [Test]
        public function isSwitchingReversingFromExpoToLinear():void
        {
            var precision:Number = NumericAnimator.SWITCHING_PRECISION;
            var animator:NumericAnimator = new NumericAnimator();
            var tickGenerator:TestingTickGenerator = new TestingTickGenerator();
            animator.setCustomTickGenerator(tickGenerator);

            animator.animate(Exponential.easeIn, 10, 15, 115, false);

            Assert.assertEquals(
                "Initial animator value before animation starts",
                15, roundWithPrecision(animator.value, precision)
            );

            tickGenerator.makeTicks(9);

            Assert.assertEquals(
                "Animator value, expo easing 9 of 10 steps, value range 15.. 115",
                65, roundWithPrecision(animator.value, precision)
            );

            animator.animate(Linear.easeIn, 20, 115, 15, true);

            Assert.assertEquals(
                "Animator value, after switching from expo to linear, at value 65, value range 115.. 15",
                65, roundWithPrecision(animator.value, precision)
            );

            Assert.assertEquals(
                "Animator position, after switching from expo to linear, at value 65, value range 115.. 15",
                10,  roundWithPrecision(animator.position, precision)
            );
        }

    }
}
