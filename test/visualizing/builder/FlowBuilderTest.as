package visualizing.builder
{
    import misc.ButtonSignals;

    import org.flexunit.Assert;

    // TODO: Finish FlowBuilderTest
    public class FlowBuilderTest
    {
        private static var _flow:ActivePassiveFlow;

        public var _backgroundAcc:Object;
        public var _icon:Object;

        [BeforeClass]
        public static function InstantiateFlow():void
        {
            _flow = new ActivePassiveFlow();
        }

        [Before]
        public function createObjects():void
        {
            _backgroundAcc = {color: 0x00000};
            // _icon = {alpha: 1};
        }


        [Test]
        public function isFlowInstantiated():void
        {
            Assert.assertNotNull(_flow);
        }

        [Test(expects="Error")]
        public function isErrorThrownOnAbsentInstances():void
        {
            Assert.assertNotNull(_backgroundAcc);
            Assert.assertNotNull(_flow);
            
            var signals:ButtonSignals = _flow.getSignals();

            _flow.visualize(this, signals);
        }

    }
}


//--------------------------------------------------------------------------
//
//  Internal classes for configuring visualizer
//
//--------------------------------------------------------------------------

import flash.display.Sprite;

import misc.ButtonSignals;

import mx.effects.easing.Linear;

import nanosome.flow.stateMachine.State;
import nanosome.flow.stateMachine.Transition;

import nanosome.flow.visualizing.animators.NumericPropertyAnimator;
import nanosome.flow.visualizing.builders.FlowBuilder;

import stateMachine.builder.TestStateMachineBuilder;

internal class ActivePassiveFlow extends FlowBuilder
{
    public var _:TestStateMachineBuilder; // all of these members should be public to be discoverable
    public var _icon:Sprite;
    public var _backgroundAcc:Object;

    override protected function getTickGenerator():ITickGenerator
    {
        return new TestingTickGenerator();
    }

    public function getSignals():ButtonSignals
    {
        return _.getNewSignalsSet();
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