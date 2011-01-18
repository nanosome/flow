package easing
{
    import mx.effects.easing.Exponential;
    import mx.effects.easing.Linear;

    import nanosome.flow.easing.EasingLine;
    import nanosome.flow.easing.EasingLineRunner;

    import nanosome.flow.easing.TimedEasing;

    import org.flexunit.Assert;

    public class EasingLinesTest
    {

        [Test]
        public function areStepsWorking():void
        {
            var runner:EasingLineRunner = new EasingLineRunner();
            // 10 steps, linear easing
            var timedEasing:TimedEasing = new TimedEasing(Linear.easeIn, 10);
            // changing values from 0 to 100 in 10 steps, with linear easing
            var line:EasingLine = new EasingLine(timedEasing, 0, 100);
            runner.setEasingLine(line);

            runner.setPosition(0);
            Assert.assertEquals(0, runner.value);

            runner.makeStep(1);
            Assert.assertEquals(10, runner.value);

            runner.makeStep(1);
            Assert.assertEquals(20, runner.value);

            runner.makeStep(5);
            Assert.assertEquals(70, runner.value);
        }

        [Test]
        public function isSwitchingReversingEasingLines():void
        {
            var runner:EasingLineRunner = new EasingLineRunner();
            // 10 steps, linear easing
            var linearEasing:TimedEasing = new TimedEasing(Linear.easeIn, 10);

            // 10 steps, linear easing
            var expoEasing:TimedEasing = new TimedEasing(Exponential.easeIn, 10);

            // changing values  from 0 to 100 in 10 steps, with exponential easing
            var expoLine:EasingLine = new EasingLine(expoEasing, 0, 100);

            // changing values back from 100 to 0 in 10 steps, with linear easing
            var linearLine:EasingLine = new EasingLine(linearEasing, 100, 0);

            // initiate runner with expo line...
            runner.setEasingLine(expoLine);
            // set position to 9
            runner.setPosition(9);

            // according to Mathematica calculations, value should be equal 50
            var precision:uint = 1000;
            Assert.assertEquals(
                "runner.value after rounding with precision = " + precision,
                50, Math.round(runner.value * precision) / precision
            );

            runner.switchToNewEasingLine(linearLine, true);
            Assert.assertEquals(
                "runner value after switching",
                50, runner.value
            ); // value should be the same


            /*
            Assert.assertEquals(5, runner._position); // check correct position
            */
        }
    }
}
