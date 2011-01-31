package animators
{
    import mx.effects.easing.Exponential;
    import mx.effects.easing.Linear;

    import nanosome.flow.visualizing.animators.ColorAnimator;

    import org.flexunit.Assert;

    import visualizing.TestingTickGenerator;

    public class ColorAnimatorTest
    {
        [Test]
        public function areStepsWorkingCorrectly():void
        {
            var animator:ColorAnimator = new ColorAnimator();
            var tickGenerator:TestingTickGenerator = new TestingTickGenerator();
            animator.setCustomTickGenerator(tickGenerator);

            animator.animate(Linear.easeIn, 500, 0xFE8800, 0x0088FE, false);

            Assert.assertEquals(
                "Initial animator value before animation starts",
                0xFE8800, animator.value
            );

            tickGenerator.makeTicks(250);

            Assert.assertEquals(
                "Animator value, 250 of 500 steps, value range 10.. 110, actual value: " + Number(animator.value).toString(16),
                0x7F887F, animator.value
            );
        }

        [Test]
        public function isSwitchingReversingFromExpoToLinear():void
        {
            var animator:ColorAnimator = new ColorAnimator();
            var tickGenerator:TestingTickGenerator = new TestingTickGenerator();
            animator.setCustomTickGenerator(tickGenerator);

            animator.animate(Exponential.easeIn, 10, 0x880000, 0x000000, false);

            Assert.assertEquals(
                "Initial animator value before animation starts",
                0x880000, animator.value
            );

            tickGenerator.makeTicks(9);

            Assert.assertEquals(
                "Animator value, expo easing 9 of 10 steps, value range 15.. 115",
                0x440000, animator.value
            );

            animator.animate(Linear.easeIn, 20, 0x000000, 0x880000, true);

            Assert.assertEquals(
                "Animator value, after switching from expo to linear, at value 65, value range 115.. 15",
                0x440000, animator.value
            );

            Assert.assertEquals(
                "Animator position, after switching from expo to linear, at value 65, value range 115.. 15",
                10, animator.position
            );
        }

    }
}
