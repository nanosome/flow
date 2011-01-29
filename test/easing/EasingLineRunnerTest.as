package easing
{
    import mx.effects.easing.Exponential;
    import mx.effects.easing.Linear;

    import nanosome.flow.easing.EasingLine;
    import nanosome.flow.easing.EasingLineRunner;

    import org.flexunit.Assert;

    import utils.roundWithPrecision;

    public class EasingLineRunnerTest
    {

        [Test]
        public function isDefaultPositionSets():void
        {
            var runner:EasingLineRunner;

            runner = new EasingLineRunner(new EasingLine(Linear.easeIn, 10, 0, 100));
            Assert.assertEquals(
                "default position after EasingLineRunner initialization",
                0, runner.getPositionForTest()
            );

            runner = new EasingLineRunner(new EasingLine(Linear.easeIn, 10, 0, 100), 5);
            Assert.assertEquals(
                "position while EasingLineRunner initialization was set to 5  (duration is 10)",
                5, runner.getPositionForTest()
            );

            runner = new EasingLineRunner(new EasingLine(Linear.easeIn, 10, 0, 100), 15);
            Assert.assertEquals(
                "position while EasingLineRunner initialization was set to 15 (duration is 10)",
                10, runner.getPositionForTest()
            );
        }


        [Test]
        public function isOverflowingPositionWorksCorrectly():void
        {
            var runner:EasingLineRunner;

            runner = new EasingLineRunner(new EasingLine(Linear.easeIn, 10, 0, 100));

            Assert.assertTrue(
                "setPosition():Boolean return value, setting position within its duration (position 5, duration 10)",
                runner.setPosition(5)
            );

            Assert.assertFalse(
                "setPosition():Boolean return value, setting position exactly its duration (position 5, duration 10)",
                runner.setPosition(10)
            );

            Assert.assertFalse(
                "setPosition():Boolean return value, setting position more over duration (position 12, duration 10)",
                runner.setPosition(12)
            );

            runner.setPosition(15);
            Assert.assertEquals(
                "runner position after setting position more than duration (position 15, duration 10)",
                10, runner.getPositionForTest()
            );
        }


        [Test]
        public function areStepsWorking():void
        {
            // changing values from 15 to 115 in 10 steps, with linear easing
            var runner:EasingLineRunner = new EasingLineRunner(new EasingLine(Linear.easeIn, 10, 15, 115));

            Assert.assertEquals(
                "value after making step (step 1 out of 100), values range [15.. 115]",
                15, runner.value
            );

            runner.makeStep(1);
            Assert.assertEquals(
                "value after making step (step 2 out of 100), values range [15.. 115]",
                25, runner.value
            );

            runner.makeStep(1);
            Assert.assertEquals(
                "value after making step (step 2 out of 100), values range [15.. 115]",
                35, runner.value
            );

            runner.makeStep(5);
            Assert.assertEquals(
                "value after making several steps (2 steps +5 = 7 out of 100), values range [15.. 115]",
                85, runner.value
            );
        }


        [Test]
        public function isSwitchingEasingLinesFromLinearToExpo():void
        {
            // changing values  from 15 to 100 in 10 steps, with linear easing
            var linearLine:EasingLine = new EasingLine(Linear.easeIn, 10, 15, 115);

            // changing values back from 50 to 30 in 10 steps, with exponential easing
            var expoLine:EasingLine = new EasingLine(Exponential.easeIn, 10, 50, 30);

            // initiate runner with linear line, starting position to 5
            var runner:EasingLineRunner = new EasingLineRunner(linearLine, 5);

            Assert.assertEquals(
                "position before switching reversing line, default position 5 ",
                5, runner.getPositionForTest()
            );

            var precision:Number = EasingLineRunner.SWITCHING_PRECISION;
            Assert.assertEquals(
                "value BEFORE switching reversing line, precision = " + precision,
                65, roundWithPrecision(runner.value, precision)
            );

            runner.switchToNewEasingLine(expoLine, false);
            Assert.assertEquals(
                "value AFTER switching lines, precision = " + precision,
                65, roundWithPrecision(runner.value, precision)
            );

            Assert.assertEquals(
                "position after switching easing lines",
                0, runner.getPositionForTest()
            );

            runner.setPosition(12);

            Assert.assertEquals(
                "position after switching from linear to expo and making all steps",
                10, runner.getPositionForTest()
            );

            Assert.assertEquals(
                "value after switching from linear to expo and making all steps, precision = " + precision,
                30, roundWithPrecision(runner.value, precision)
            );
        }

        
        [Test]
        public function isSwitchingReversingEasingLinesFromExpoToLinear():void
        {
            // changing values with expo easing in 10 steps, from 15 to 115
            var inEasingLine:EasingLine = new EasingLine(Exponential.easeIn, 10, 15, 115);

            // changing values with linear easing in 20 steps, back from 115 to 15
            var outEasingLine:EasingLine = new EasingLine(Linear.easeIn, 20, 115, 15);

            // initiate runner with exponential line, starting position to 9
            var runner:EasingLineRunner = new EasingLineRunner(inEasingLine, 9);

            var precision:Number = EasingLineRunner.SWITCHING_PRECISION;
            Assert.assertEquals(
                "value BEFORE switching with position 9 on expo line, precision = " + precision,
                65, roundWithPrecision(runner.value, precision)
            );

            runner.switchToNewEasingLine(outEasingLine, true);
            Assert.assertEquals(
                "value AFTER switching from expo to linear, precision = " + precision,
                65, roundWithPrecision(runner.value, precision)
            );

            Assert.assertEquals(
                "position AFTER switching from expo to linear",
                10, runner.getPositionForTest()
            );
        }

        [Test]
        public function isSwitchingReversingEasingLinesFromLongToShort():void
        {
            var inEasingLine:EasingLine = new EasingLine(Linear.easeIn, 20, 15, 115);

            var outEasingLine:EasingLine = new EasingLine(Linear.easeIn, 6, 115, 15);

            var runner:EasingLineRunner = new EasingLineRunner(inEasingLine, 10);

            var precision:Number = EasingLineRunner.SWITCHING_PRECISION;
            
            Assert.assertEquals(
                "value BEFORE switching with position 10 on linear line, precision = " + precision,
                65, roundWithPrecision(runner.value, precision)
            );

            runner.switchToNewEasingLine(outEasingLine, true);
            Assert.assertEquals(
                "value AFTER switching from easing in to easing out, precision = " + precision,
                65, roundWithPrecision(runner.value, precision)
            );

            Assert.assertEquals(
                "position AFTER switching from expo to linear",
                3, runner.getPositionForTest()
            );
        }
    }
}
