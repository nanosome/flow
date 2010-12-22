package tests.visualizing
{
    import mx.effects.easing.Linear;

    import nanosome.flow.easing.EasingLine;
    import nanosome.flow.easing.EasingLineRunner;

    import org.flexunit.Assert;

    public class EasingLinesTest
    {

        [Test]
        public function isLinesRunnerWorking():void
        {
            var runner:EasingLineRunner = new EasingLineRunner();
            var line01:EasingLine = new EasingLine(Linear.easeIn, 0, 100);
            runner.setEasingLine(line01);

            runner.setPosition(0);
            Assert.assertEquals(0, runner.value);

            // because of rounding errors, we have to apply rounding to check
            runner.makeStep(.1);
            Assert.assertEquals(10, Math.round(runner.value));

            runner.makeStep(.1);
            Assert.assertEquals(20, Math.round(runner.value));

            runner.makeStep(.15);
            Assert.assertEquals(35, Math.round(runner.value));
        }
    }
}
