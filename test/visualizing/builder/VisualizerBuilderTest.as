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
                    new AlphaAnimator(baseElement)
            );

            var copyVis:VisualizerBuilder = activePassive.visualize(
                    new AlphaAnimator(copyElement)
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

            activePassive.visualize(target).by(AlphaAnimator)
                .state(_activePassive.active).valueIs(1)
                .state(_activePassive.passive).valueIs(.3)
                .transition(_activePassive, new TimedEasing(Linear.easeIn, 200))
                .transition(_activePassive, new TimedEasing(Linear.easeIn, 200))

            alphaAnimator = animatorsFactory.getAlphaAnimatorFor(target);
            alphaAnimator.state(_normalOvered.normal, .3);
            alphaAnimator.state(_normalOvered.normal, .3);
            alphaAnimator.state(_normalOvered.normal, .3);
            alphaAnimator.transition(_normalOvered.fromNormalToOvered, easing01)


        }
    }
}

//--------------------------------------------------------------------------
//
//  Internal classes used in testing
//
//--------------------------------------------------------------------------

import mx.effects.easing.Linear;

import nanosome.flow.stateMachine.State;
import nanosome.flow.stateMachine.Transition;
import nanosome.flow.visualizing.animators.base.NumericAnimator;

import stateMachine.builder.TestStateMachineBuilder;


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

// ----------------------------------------------------------------------
internal class TestViewAlpha
{
    public function init():void
    {
        var visualizer = 
    }
}

internal class ActivePassiveMappingAlpha
{
    protected var _:TestStateMachineBuilder;
    protected var _iconAlphaVisualizer:IMockVisualizer;
    protected var _backgroundColorVisualizer:IMockVisualizer;

    public function define():void
    {
        defineDefaultTransition(Linear.easeIn, 50); // default one

        defineState(_.normal);
            _iconAlphaVisualizer.alpha = .1;
            _backgroundColorVisualizer.color  = 0xFF0000;

        defineTransition(_.fromNormalToOvered);
            _iconAlphaVisualizer.ease(Linear.easeInOut, 10);
            _backgroundColorVisualizer.ease(Linear.easeInOut, 10);

        defineTransition(_.fromOveredToNormal);
            _iconAlphaVisualizer.ease(Linear.easeInOut, 10);
            _backgroundColorVisualizer.ease(Linear.easeInOut, 10);

        defineState(_.overed);
            _iconAlphaVisualizer.alpha = .1;
            _backgroundColorVisualizer.color  = 0xFF0000;
        done();
    }
}

internal class ActivePassiveMappingAlphaTwo
{
    protected var _:TestStateMachineBuilder;
    protected var _iconAlphaVisualizer:IMockVisualizer;
    protected var _backgroundColorVisualizer:IMockVisualizer;

    public function define(state:State, transition:Transition):void
    {
        switch(state || transition)
        {
            case _.normal:
                _iconAlphaVisualizer.alpha = .3;
                _backgroundColorVisualizer.color  = 0xFF0000;
            break;

            case _.fromNormalToOvered:
                _iconAlphaVisualizer.ease(Linear.easeIn, 500);
                _backgroundColorVisualizer.ease(Linear.easeIn, 300);
            break;

            case _.overed:
                _iconAlphaVisualizer.alpha = .8;
                _backgroundColorVisualizer.color  = 0x00FF00;
            break;

            case _.fromOveredToNormal:
                _iconAlphaVisualizer.ease(Linear.easeIn, 500);
                _backgroundColorVisualizer.ease(Linear.easeIn, 300);
            break;

            case _.fromOveredToPressed:
                _iconAlphaVisualizer.ease(Linear.easeIn, 500);
                _backgroundColorVisualizer.ease(Linear.easeIn, 300);
            break;

            case _.pressed:
                _iconAlphaVisualizer.alpha = 1;
                _backgroundColorVisualizer.color  = 0x0000FF;
            break;

            case _.fromPressedToOvered:
                _iconAlphaVisualizer.ease(Linear.easeIn, 500);
                _backgroundColorVisualizer.ease(Linear.easeIn, 300);
            break;

            case _.fromPressedToPressedOutside:
                _iconAlphaVisualizer.ease(Linear.easeIn, 500);
                _backgroundColorVisualizer.ease(Linear.easeIn, 300);
            break;

            case _.pressedOutside:
                _iconAlphaVisualizer.alpha = .9;
                _backgroundColorVisualizer.color  = 0x0000FF;
            break;

            case _.fromPressedOutsideToPressed:
            case _.fromPressedOutsideToNormal:
                _iconAlphaVisualizer.ease(Linear.easeIn, 500);
                _backgroundColorVisualizer.ease(Linear.easeIn, 300);
            break;


            default:
                _iconAlphaVisualizer.alpha = .6;
                _backgroundColorVisualizer.color = 0x333333;
                _iconAlphaVisualizer.ease(Linear.easeIn, 400);
                _backgroundColorVisualizer.ease(Linear.easeIn, 200);
            break;
        }
    }

}

internal class ActivePassiveMappingBeta
{
    protected var _:TestStateMachineBuilder;
    protected var _iconAlphaVisualizer:IMockVisualizer;
    protected var _backgroundColorVisualizer:IMockVisualizer;

    public function define():void
    {
        default.ease(Linear.easeIn, 50); // default one

        _iconAlphaVisualizer
            .state(_.normal).mapTo(.1)
            .transition(_.fromNormalToOvered).mapTo(Linear.easeIn, 300)
            .transition(_.fromOveredToNormal).mapTo(Linear.easeOut, 500)
            .state(_.overed).mapTo(.8);

        _backgroundColorVisualizer
            .state(_.normal).mapTo(0xFF0000)
            .transition(_.fromNormalToOvered).mapTo(Linear.easeIn, 300)
            .transition(_.fromOveredToNormal).mapTo(Linear.easeOut, 500)
            .state(_.overed).mapTo(.8);
    }
}
