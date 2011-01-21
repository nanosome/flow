package easing
{
    import mx.effects.easing.Exponential;
    import mx.effects.easing.Linear;

    import nanosome.flow.easing.EasingLine;
    import nanosome.flow.easing.EasingLineRunner;

    import org.flexunit.Assert;

    public class EasingLinesTest
    {
        [Test]
        public function areStepsWorking():void
        {
            // changing values from 0 to 100 in 10 steps, with linear easing
            var runner:EasingLineRunner = new EasingLineRunner(new EasingLine(Linear.easeIn, 10, 0, 100));
            Assert.assertEquals(0, runner.value);

            runner.makeStep(1);
            Assert.assertEquals(10, runner.value);

            runner.makeStep(1);
            Assert.assertEquals(20, runner.value);

            runner.makeStep(5);
            Assert.assertEquals(70, runner.value);
        }

        [Test]
        public function isSwitchingEasingLinesFromLinearToExpo():void
        {
            // changing values  from 0 to 100 in 10 steps, with linear easing
            var linearLine:EasingLine = new EasingLine(Linear.easeIn, 10, 0, 100);

            // changing values back from 100 to 0 in 10 steps, with exponential easing
            var expoLine:EasingLine = new EasingLine(Exponential.easeIn, 10, 100, 40);

            // initiate runner with linear line, starting position to 5
            var runner:EasingLineRunner = new EasingLineRunner(linearLine, 5);

            // value should be equal 50
            var precision:uint = 1000;
            Assert.assertEquals(
                "runner.value after rounding with precision = " + precision,
                50, Math.round(runner.value * precision) / precision
            );

            runner.switchToNewEasingLine(expoLine, false);
            Assert.assertEquals(
                "runner value after switching with precision = " + precision,
                50, Math.round(runner.value * precision) / precision
            ); // value should be the same

            // unlike with switching reversing lines, position should be equal to 0
            Assert.assertEquals(0, runner.getPositionForTest());

            runner.setPosition(10); // go to last step

            Assert.assertEquals(
                "runner value after making all steps precision = " + precision,
                40, Math.round(runner.value * precision) / precision
            );
        }

        [Test]
        public function isSwitchingReversingEasingLinesFromExpoToLinear():void
        {
            // changing values  from 0 to 100 in 10 steps, with exponential easing
            var expoLine:EasingLine = new EasingLine(Exponential.easeIn, 10, 0, 100);

            // changing values back from 100 to 0 in 10 steps, with linear easing
            var linearLine:EasingLine = new EasingLine(Linear.easeIn, 10, 100, 0);

            // initiate runner with expo line, starting position to 9
            var runner:EasingLineRunner = new EasingLineRunner(expoLine, 9);

            // according to Mathematica calculations, value should be equal 50
            var precision:uint = 1000;
            Assert.assertEquals(
                "runner.value after rounding with precision = " + precision,
                50, Math.round(runner.value * precision) / precision
            );

            runner.switchToNewEasingLine(linearLine, true);
            Assert.assertEquals(
                "runner value after switching with precision = " + precision,
                50, Math.round(runner.value * precision) / precision
            ); // value should be the same

            Assert.assertEquals(5, runner.getPositionForTest()); // check correct position
        }

        [Test]
        public function isSwitchingReversingEasingLinesFromLinearToExpo():void
        {
            // changing values  from 0 to 100 in 10 steps, with linear easing
            var linearLine:EasingLine = new EasingLine(Linear.easeIn, 10, 0, 100);

            // changing values back from 100 to 0 in 10 steps, with exponential easing
            var expoLine:EasingLine = new EasingLine(Exponential.easeIn, 10, 100, 0);

            // initiate runner with linear line, starting position to 5
            var runner:EasingLineRunner = new EasingLineRunner(linearLine, 5);

            // value should be equal 50
            var precision:uint = 1000;
            Assert.assertEquals(
                "runner.value after rounding with precision = " + precision,
                50, Math.round(runner.value * precision) / precision
            );

            runner.switchToNewEasingLine(expoLine, true);
            Assert.assertEquals(
                "runner value after switching with precision = " + precision,
                50, Math.round(runner.value * precision) / precision
            ); // value should be the same

            Assert.assertEquals(9, runner.getPositionForTest()); // check correct position
        }
    }
}
