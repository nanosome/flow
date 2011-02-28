package visualizing.builder
{
    import mx.effects.easing.Linear;
    import mx.effects.easing.Quadratic;

    import nanosome.flow.visualizing.TimedEasing;


    import nanosome.flow.visualizing.builders.VisualMappingBuilder;

    import org.flexunit.Assert;

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

    }
}



//--------------------------------------------------------------------------
//
//  Internal classes for configuring visualizer
//
//--------------------------------------------------------------------------

import flash.display.Sprite;

import mx.effects.easing.Linear;

import nanosome.flow.stateMachine.State;
import nanosome.flow.stateMachine.Transition;

import nanosome.flow.visualizing.animators.NumericPropertyAnimator;
import nanosome.flow.visualizing.builders.VisualMappingBuilder;

import stateMachine.builder.TestStateMachineBuilder;

internal class ActivePassiveMapping extends VisualMappingBuilder
{
    protected var _:TestStateMachineBuilder;
    public var _icon:Sprite;
    public var _backgroundAcc:TestBackgroundColorAccessor;

    override protected function getTickGenerator():ITickGenerator
    {
        return new TestingTickGenerator();
    }

    override protected function registerAnimators():void
    {
        animate("alpha").ofInstance(_icon).
            by(NumericPropertyAnimator);
        animate("color").ofInstance(_backgroundAcc).
            by(NumericPropertyAnimator);
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
                ease(_icon, "alpha").by(Linear.easeIn, 500);
                ease(_backgroundAcc).by(Linear.easeIn, 300);
            break;

            case _.fromOveredToPressed:
                ease(_icon).and(_backgroundAcc).by(Linear.easeIn, 500);
            break;

            case _.pressed:
                _icon.alpha = 1;
                _backgroundAcc.color  = 0x0000FF;
            break;

            case _.fromPressedToOvered:
                ease(_icon, "alpha").and(_backgroundAcc, "color").by(Linear.easeIn, 500);
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

//--------------------------------------------------------------------------
//
//  Internal classes used in testing
//
//--------------------------------------------------------------------------

internal class TestBackgroundColorAccessor
{
    public var color:uint;
}

import flash.events.EventDispatcher;

import nanosome.flow.visualizing.ticking.ITickGenerator;
import nanosome.flow.visualizing.ticking.TickGeneratorEvent;

internal class TestingTickGenerator extends EventDispatcher implements ITickGenerator
{
    private var _isRunning:Boolean = false;

    public function TestingTickGenerator()
    {
    }

    public function start():void
    {
        _isRunning = true;
    }

    public function stop():void
    {
        _isRunning = false;
    }

    public function makeTicks(delta:Number):void
    {
        dispatchEvent(new TickGeneratorEvent(TickGeneratorEvent.TICK_UPDATE, delta));
    }

    public function get isRunning():Boolean
    {
        return _isRunning;
    }
}