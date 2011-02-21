package visualizing.builder
{
    import misc.ButtonSignals;

    import mx.effects.easing.Linear;
    import mx.effects.easing.Quadratic;

    import nanosome.flow.visualizing.TimedEasing;
    import nanosome.flow.visualizing.AnimationMapping;
    import nanosome.flow.visualizing.VisualizerManager;

    import nanosome.flow.visualizing.builders.VisualMappingBuilder;

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

            var activePassive:VisualMappingBuilder = new VisualMappingBuilder(
                _activePassive.getStateMachine(), activePassiveSignals
            );

            activePassive.setCustomTickGenerator(_tickGenerator);

            var baseElement:InternalMockSprite = new InternalMockSprite();
            var copyElement:InternalMockSprite = new InternalMockSprite();

            // configure active/passive visualizers

            var baseVis:VisualMappingBuilder = activePassive.visualize(
                    new AlphaAnimator(baseElement)
            );

            var copyVis:VisualMappingBuilder = activePassive.visualize(
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

import flash.display.Sprite;

import mx.effects.easing.Linear;

import nanosome.flow.stateMachine.State;
import nanosome.flow.stateMachine.Transition;
import nanosome.flow.visualizing.animators.ColorPropertyAnimator;
import nanosome.flow.visualizing.animators.NumericPropertyAnimator;
import nanosome.flow.visualizing.animators.base.NumericAnimator;

import nanosome.flow.visualizing.builders.VisualMappingBuilder;

import nanosome.flow.visualizing.ticking.ITickGenerator;

import stateMachine.builder.TestStateMachineBuilder;

import visualizing.TestingTickGenerator;


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
        
    }
}

internal class ActivePassiveMapping extends VisualMappingBuilder
{
    protected var _:TestStateMachineBuilder;
    protected var _icon:Sprite; // = new SpriteAccessor() ??
    protected var _backgroundAcc:TestBackgroundColorAccessor;

    override protected function getTickGenerator():ITickGenerator
    {
        return new TestingTickGenerator();
    }

    override protected function registerAnimators():void
    {
        forProperty("alpha").
            ofInstance(_icon).
            useAnimator(NumericPropertyAnimator);
        forProperty("color").
            ofInstance(_backgroundAcc).
            useAnimator(NumericPropertyAnimator);
    }

    override protected function defineStatesAndTransitions(state:State, transition:Transition):void
    {
        switch(state || transition)
        {
            case _.normal:
                _icon.alpha = .3;
                _backgroundAcc.color  = 0xFF0000;
            break;

            case _.fromNormalToOvered:
                ease(_icon).by(Linear.easeIn, 500);
                ease(_backgroundAcc).by(Linear.easeIn, 300);
            break;

            case _.overed:
                _icon.alpha = .8;
                _backgroundAcc.color  = 0x00FF00;
            break;

            case _.fromOveredToNormal:
                ease(_icon).by(Linear.easeIn, 500);
                ease(_backgroundAcc).by(Linear.easeIn, 300);
            break;

            case _.fromOveredToPressed:
                ease(_icon).by(Linear.easeIn, 500);
                ease(_backgroundAcc).by(Linear.easeIn, 300);
            break;

            case _.pressed:
                _icon.alpha = 1;
                _backgroundAcc.color  = 0x0000FF;
            break;

            case _.fromPressedToOvered:
                ease(_icon, _backgroundAcc).by(Linear.easeIn, 500);
            break;

            case _.fromPressedToPressedOutside:
                ease(_icon).by(Linear.easeIn, 500);
                ease(_backgroundAcc).by(Linear.easeIn, 300);
            break;

            case _.pressedOutside:
                _icon.alpha = .9;
                _backgroundAcc.color  = 0x0000FF;
            break;

            case _.fromPressedOutsideToPressed:
            case _.fromPressedOutsideToNormal:
                ease(_icon).by(Linear.easeIn, 500);
                ease(_backgroundAcc).by(Linear.easeIn, 300);
            break;


            default:
                _icon.alpha = .6;
                _backgroundAcc.color = 0x333333;
                ease(_icon).by(Linear.easeIn, 400);
                ease(_backgroundAcc).by(Linear.easeIn, 200);
            break;
        }
    }

}
