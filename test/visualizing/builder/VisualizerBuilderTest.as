package visualizing.builder
{
    import misc.ButtonSignals;

    import mx.effects.easing.Linear;
    import mx.effects.easing.Quadratic;

    import nanosome.flow.visualizing.TimedEasing;
    import nanosome.flow.visualizing.AnimationMapper;
    import nanosome.flow.visualizing.Visualizer;

    import nanosome.flow.visualizing.builders.VisualizerBuilder;

    import org.flexunit.Assert;

    import stateMachine.builder.TestStateMachineBuilder;
    import stateMachine.builder.TestStateMachineBuildersFactory;

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

        private static var _tickGenerator:TestingTickGenerator;

        [BeforeClass]
        public static function createBuildersAndStateMachines():void
        {
            var repository:TestVisualizersSMBuildersFactory;
            repository = new TestVisualizersSMBuildersFactory();
            _normalOvered = repository.testNormalOveredSMBuilder;
            _activePassive = repository.testActivePassiveSMBuilder;

            _tickGenerator = new TestingTickGenerator();
        }

        [Test]
        public function areValuesAndEasingsCopied():void
        {
            // configure controller
            var activePassiveSignals:ActivePassiveSignals = _activePassive.getNewSignalsSet();

            var activePassive:VisualizerBuilder = new VisualizerBuilder(
                _activePassive.getStateMachine(), activePassiveSignals
            );

            activePassive.setCustomTickGenerator(_tickGenerator);

            var baseElement:InternalMockSprite = new InternalMockSprite();
            var copyElement:InternalMockSprite = new InternalMockSprite();

            // configure active/passive visualizers

            var baseVis:VisualizerBuilder = activePassive.visualize(
                    new MockAlphaTransform(baseElement)
            );

            var copyVis:VisualizerBuilder = activePassive.visualize(
                    new MockAlphaTransform(copyElement)
            );

            baseVis
                .state(_activePassive.passive, 0)
                .transition(_activePassive.fromPassiveToActive, new TimedEasing(Linear.easeIn, 200))
                .transition(_activePassive.fromActiveToPassive, new TimedEasing(Quadratic.easeOut, 400))
                .state(_activePassive.active, 1)
            .activate();

            copyVis
                .easingsAs(baseVis)
                .valuesAs(baseVis)
            .activate();

            Assert.assertTrue(
                "baseVis and copyVis has identical mappings",
                baseVis.hasIdenticalMappingsWith(copyVis)
            );

        }
    }
}

//--------------------------------------------------------------------------
//
//  Internal classes used in testing
//
//--------------------------------------------------------------------------

import nanosome.flow.visualizing.animators.base.NumericAnimator;


internal class InternalMockAlphaAnimator extends NumericAnimator
{
    protected var _target:*;

    public function setTarget(target:*):void
    {
        _target = target;
    }

    override public function update():void
    {
        _target.alpha = this.value;
    }
}


internal class InternalMockBetaAnimator extends NumericAnimator
{
    protected var _target:*;

    public function setTarget(target:*):void
    {
        _target = target;
    }

    override public function update():void
    {
        _target.beta = this.value;
    }
}


internal class InternalMockSprite
{
    public var alpha:Number;
    public var beta:Number;
}