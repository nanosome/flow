package visualizing.builder
{
    import misc.ButtonSignals;

    import mx.effects.easing.Linear;
    import mx.effects.easing.Quadratic;

    import nanosome.flow.easing.TimedEasing;
    import nanosome.flow.visualizing.Visualizer;
    import nanosome.flow.visualizing.builder.VisualizerBuilder;

    import nanosome.flow.visualizing.builder.VisualizerControllerBuilder;
    import nanosome.flow.visualizing.controller.VisualizerController;

    import org.flexunit.Assert;

    import stateMachine.builder.TestStateMachineBuilder;
    import stateMachine.builder.TestStateMachineBuildersFactory;

    import visualizing.MockAlphaTransform;
    import visualizing.MockBetaTransform;
    import visualizing.MockSprite;
    import visualizing.TestingTickGenerator;

    import visualizing.builder.stateMachinesConfig.ActivePassiveSignals;
    import visualizing.builder.stateMachinesConfig.NormalOveredSignals;
    import visualizing.builder.stateMachinesConfig.TestActivePassiveSM;
    import visualizing.builder.stateMachinesConfig.TestNormalOveredSM;
    import visualizing.builder.stateMachinesConfig.TestVisualizersSMBuildersFactory;

    public class VisualizerBuilderTest
    {
        private static var _normalOvered:TestNormalOveredSM;
        private static var _activePassive:TestActivePassiveSM;

        [BeforeClass]
        public static function createBuildersAndStateMachines():void
        {
            var repository:TestVisualizersSMBuildersFactory;
            repository = new TestVisualizersSMBuildersFactory();
            _normalOvered = repository.testNormalOveredSMBuilder;
            _activePassive = repository.testActivePassiveSMBuilder;
        }

        [Test]
        public function inProgress():void
        {

            // configure controller
            var normalOveredSignals:NormalOveredSignals = _normalOvered.getNewSignalsSet();
            var activePassiveSignals:ActivePassiveSignals = _activePassive.getNewSignalsSet();

            var activePassive:VisualizerControllerBuilder = new VisualizerControllerBuilder(
                _activePassive.getStateMachine(), activePassiveSignals
            );

            var normalOvered:VisualizerControllerBuilder = new VisualizerControllerBuilder(
                _normalOvered.getStateMachine(), normalOveredSignals
            );
            var tickGenerator:TestingTickGenerator = new TestingTickGenerator();
            activePassive.setCustomTickGenerator(tickGenerator);
            normalOvered.setCustomTickGenerator(tickGenerator);

            //----------------------------------
            //  now we will try to recreate double state button (i.e. tumbler)
            //----------------------------------

            // declare targets to visualize
            
            var activeNormal:MockSprite = new MockSprite();
            var activeOvered:MockSprite = new MockSprite();

            var passiveNormal:MockSprite = new MockSprite();
            var passiveOvered:MockSprite = new MockSprite();


            // configure active/passive visualizers

            var activeVis:VisualizerBuilder = activePassive.visualize(
                    new MockAlphaTransform(activeNormal).and(activeOvered)
            );

            var passiveVis:VisualizerBuilder = activePassive.visualize(
                    new MockAlphaTransform(passiveNormal).and(passiveOvered)
            );

            activeVis
                .state(_activePassive.passive, 0)
                .transition(_activePassive.fromPassiveToActive, new TimedEasing(Linear.easeIn, 200))
                .transition(_activePassive.fromActiveToPassive, new TimedEasing(Quadratic.easeOut, 400))
                .state(_activePassive.active, 1)
            .activate();

            passiveVis
                .transitionsAs(activeVis)
                .state(_activePassive.passive, 1)
                .state(_activePassive.active, 0)
            .activate();


            // configure normal/overed visualizers

            var normalVis:VisualizerBuilder = normalOvered.visualize(
                new MockAlphaTransform(activeNormal).and(activeOvered)
            );
            
            var overedVis:VisualizerBuilder = normalOvered.visualize(
                new MockAlphaTransform(passiveNormal).and(passiveOvered)
            );

            var inEasing:TimedEasing = new TimedEasing(Linear.easeIn, 200);
            var outEasing:TimedEasing = new TimedEasing(Quadratic.easeOut, 400);

            normalVis
                .state(_normalOvered.normal, 0)
                .transition(_normalOvered.fromNormalToOvered, inEasing)
                .transition(_normalOvered.fromOveredToNormal, outEasing)
                .state(_normalOvered.overed, 1)
            .activate();

            overedVis
                .transitionsAs(normalVis)
                .state(_normalOvered.normal, 1)
                .state(_normalOvered.overed, 0)
            .activate();
        }
    }
}
