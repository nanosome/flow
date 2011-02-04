package animators
{
    import mx.effects.easing.Exponential;
    import mx.effects.easing.Linear;

    import org.flexunit.Assert;

    import nanosome.flow.visualizing.animators.base.NumericAnimator;

    import utils.roundWithPrecision;

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
        public function isOverflowingPositionLimited():void
        {
            var animator:NumericAnimator = new NumericAnimator();
            var tickGenerator:TestingTickGenerator = new TestingTickGenerator();
            animator.setCustomTickGenerator(tickGenerator);

            animator.switchTo(Linear.easeIn, 200, 10, 110);

            tickGenerator.makeTicks(250);

            Assert.assertEquals(
                "Position after 250 ticks of 200 total",
                200,  animator.position
            );

            Assert.assertEquals(
                "Position after 250 ticks of 200 total",
                200,  animator.position
            );

            Assert.assertFalse(
                "Custom TickGenerator should be stopped after 250 of 200 ticks",
                tickGenerator.isRunning
            );
        }


        [Test]
        public function isReversingFromExpoToLinear():void
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
                "Animator value, after reversing from expo to linear, at value 65, value range 115.. 15",
                65, roundWithPrecision(animator.value, TESTING_PRECISION)
            );

            Assert.assertEquals(
                "Animator position, after reversing from expo to linear, at value 65, value range 115.. 15",
                10,  roundWithPrecision(animator.position, TESTING_PRECISION)
            );
        }

        [Test]
        public function isReversingEasingLinesFromLongToShort():void
        {
            var animator:NumericAnimator = new NumericAnimator();
            var tickGenerator:TestingTickGenerator = new TestingTickGenerator();
            animator.setCustomTickGenerator(tickGenerator);

            animator.switchTo(Linear.easeIn, 200, 10, 110);

            tickGenerator.makeTicks(100);

            Assert.assertEquals(
                "Value BEFORE reversing, precision = " + TESTING_PRECISION,
                60, roundWithPrecision(animator.value, TESTING_PRECISION)
            );

            Assert.assertEquals(
                "Position BEFORE reversing, precision = " + TESTING_PRECISION,
                100, animator.position
            );

            animator.reverseTo(Linear.easeIn, 10);

            Assert.assertEquals(
                "Value AFTER reversing, precision = " + TESTING_PRECISION,
                60, roundWithPrecision(animator.value, TESTING_PRECISION)
            );

            Assert.assertEquals(
                "Position AFTER reversing, precision = " + TESTING_PRECISION,
                5, animator.position
            );
        }

        [Test]
        public function isSwitchingWorks():void
        {
            var animator:NumericAnimator = new NumericAnimator();
            var tickGenerator:TestingTickGenerator = new TestingTickGenerator();
            animator.setCustomTickGenerator(tickGenerator);

            animator.switchTo(Linear.easeIn, 200, 10, 110);

            tickGenerator.makeTicks(100);

            Assert.assertEquals(
                "Value BEFORE switching, precision = " + TESTING_PRECISION,
                60, roundWithPrecision(animator.value, TESTING_PRECISION)
            );

            animator.switchTo(Linear.easeIn, 100, 40, 160);

            Assert.assertEquals(
                "Value AFTER switching, precision = " + TESTING_PRECISION,
                60, roundWithPrecision(animator.value, TESTING_PRECISION)
            );

            Assert.assertEquals(
                "Position AFTER switching",
                0, animator.position
            );

            tickGenerator.makeTicks(50);

            Assert.assertEquals(
                "Value after switching, position 50 of 100, [60.. 160], precision = " + TESTING_PRECISION,
                110, roundWithPrecision(animator.value, TESTING_PRECISION)
            );

            tickGenerator.makeTicks(60);
            Assert.assertEquals(
                "Value after switching, position 110 of 100, [60.. 160], precision = " + TESTING_PRECISION,
                160, roundWithPrecision(animator.value, TESTING_PRECISION)
            );
        }

        [Test]
        public function isTickerRestartedAfterSwitching():void
        {
            var animator:NumericAnimator = new NumericAnimator();
            var tickGenerator:TestingTickGenerator = new TestingTickGenerator();

            animator.setCustomTickGenerator(tickGenerator);
            tickGenerator.start();

            Assert.assertTrue(
                "Custom TickGenerator has been started",
                tickGenerator.isRunning
            );

            animator.switchTo(Linear.easeIn, 500, 0, 100);
            tickGenerator.makeTicks(200);

            Assert.assertTrue(
                "Custom TickGenerator should be running after 200 of 500 ticks",
                tickGenerator.isRunning
            );

            tickGenerator.makeTicks(301);

            Assert.assertFalse(
                "Custom TickGenerator should be stopped after 501 of 500 ticks",
                tickGenerator.isRunning
            );

            animator.switchTo(Linear.easeIn, 50, 100, 200);

            Assert.assertTrue(
                "Custom TickGenerator should be restarted after performing switching",
                tickGenerator.isRunning
            );

            tickGenerator.makeTicks(55);

            Assert.assertFalse(
                "Custom TickGenerator should be stopped after finished switching",
                tickGenerator.isRunning
            );

            animator.reverseTo(Linear.easeIn, 10);

            Assert.assertTrue(
                "Custom TickGenerator should be restarted after performing reversing",
                tickGenerator.isRunning
            );

        }
    }
}
