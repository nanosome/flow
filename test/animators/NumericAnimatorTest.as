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
        public static const TESTING_PRECISION:Number = .0001;

        [Test]
        public function areStepsWorkingCorrectly():void
        {
            var animator:NumericAnimator = new NumericAnimator();
            var tickGenerator:TestingTickGenerator = new TestingTickGenerator();
            animator.setCustomTickGenerator(tickGenerator);

            animator.switchTo(Linear.easeIn, 500, 10, 110);

            Assert.assertEquals(
                "Initial animator value before animation starts",
                10,  roundWithPrecision(animator.value, TESTING_PRECISION)
            );

            tickGenerator.makeTicks(250);

            Assert.assertEquals(
                "Animator value, 250 of 500 steps, value range 10.. 110",
                60, roundWithPrecision(animator.value, TESTING_PRECISION)
            );
        }

        [Test]
        public function isSwitchingReversingFromExpoToLinear():void
        {
            var animator:NumericAnimator = new NumericAnimator();
            var tickGenerator:TestingTickGenerator = new TestingTickGenerator();
            animator.setCustomTickGenerator(tickGenerator);

            animator.switchTo(Exponential.easeIn, 10, 15, 115);

            Assert.assertEquals(
                "Initial animator value before animation starts",
                15, roundWithPrecision(animator.value, TESTING_PRECISION)
            );

            tickGenerator.makeTicks(9);

            Assert.assertEquals(
                "Animator value, expo easing 9 of 10 steps, value range 15.. 115",
                65, roundWithPrecision(animator.value, TESTING_PRECISION)
            );

            animator.reverseTo(Linear.easeIn, 20);

            Assert.assertEquals(
                "Animator value, after switching from expo to linear, at value 65, value range 115.. 15",
                65, roundWithPrecision(animator.value, TESTING_PRECISION)
            );

            Assert.assertEquals(
                "Animator position, after switching from expo to linear, at value 65, value range 115.. 15",
                10,  roundWithPrecision(animator.position, TESTING_PRECISION)
            );
        }

    }
}
