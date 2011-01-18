package easing
{
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
        public function isSwitchingEasingLinesWorking():void
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
    }
}
