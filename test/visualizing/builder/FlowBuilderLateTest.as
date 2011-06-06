package visualizing.builder
{
import easing.Linear;

import misc.ButtonSignals;

import nanosome.flow.visualizing.TimedEasing;
import nanosome.flow.visualizing.animators.ColorPropertyAnimator;
import nanosome.flow.visualizing.animators.NumericPropertyAnimator;
import nanosome.flow.visualizing.builders.TestStateMachineBuilder;

import org.flexunit.Assert;

    public class FlowBuilderLateTest
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
            _icon = {alpha: 1};
        }

        [Test]
        public function isFlowInstantiated():void
        {
            Assert.assertNotNull(_flow);
        }

        [Test]
        public function isFlowLateInitialized():void
        {
            Assert.assertFalse(_flow.initialized);
            var _:TestStateMachineBuilder;
            var s:ButtonSignals = new ButtonSignals();

            // 1) VisualMapping - contains values and easings mapped to state machine. No animated objects or their properties are specified here.
            // 2) Animator - class knows how to animate/access object and its property. Instantiated and disposed automatically.

            // _flow.map will return AnimationMappingBuilder, you can build mapping
            // this way...
            var alphaMapping:VisualMapping = _flow.map
                .state(_.normal).valueIs(0)
                .state(_.overed).valueIs(1)
                .transition(_.fromNormalToOvered).ease(new TimedEasing(Linear.easeIn, 200))
                .transition(_.fromOveredToNormal).ease(new TimedEasing(Linear.easeOut, 400)).endOfMapping();
            // and use it later:
            _flow.visualize(_icon, 'alpha').by(NumericPropertyAnimator).withMapping(alphaMapping);

            // you can also remap it like this:
            var colorMapping:VisualMapping = _flow.remap(myMapping)
                .state(_.normal).valueIs(0x330044)
                .state(_.overed).valueIs(0x004433).endOfMapping();
            // and use with another object:
            _flow.visualize(_backgroundAcc, 'color').by(ColorPropertyAnimator).withMapping(colorMapping);

            // alternatively, you can use it right away:
            _flow.visualize(_icon, 'alpha').by(NumericPropertyAnimator).withMapping()
                .state(_.normal).valueIs(0)
                .state(_.overed).valueIs(1)
                .transition(_.fromNormalToOvered).ease(new TimedEasing(Linear.easeIn, 200))
                .transition(_.fromOveredToNormal).ease(new TimedEasing(Linear.easeOut, 400)).endOfMapping();

            /*
            _flow.initialize({
                _.normal: {
                    _icon.alpha:
                }
                iconAlphaNormal: 0, iconAlphaOvered: .5, iconAlphaPressed: 1,
                backColorNormal: 0x888899, backColorOvered:0x998888,  backColorPressed:0x998888
            });
            */
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

import easing.Linear;

import nanosome.flow.stateMachine.State;
import nanosome.flow.stateMachine.Transition;

import nanosome.flow.visualizing.animators.NumericPropertyAnimator;
import nanosome.flow.visualizing.builders.FlowLateBuilder;

import stateMachine.builder.TestStateMachineBuilder;
import nanosome.flow.visualizing.ticking.ITickGenerator;

internal class ActivePassiveFlow extends FlowLateBuilder
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

    override protected function defineStatesAndTransitions(state:State, transition:Transition, $:Object):void
    {
        switch(state || transition)
        {
            case _.normal:
                _icon.alpha = $['iconAlphaNormal'];
                _backgroundAcc.color  = $['backColorNormal'];
            break;

            case _.fromNormalToOvered:
                ease(_icon).by(Linear.easeIn, 500);
                ease(_backgroundAcc).by(Linear.easeIn, 300);
            break;

            case _.overed:
                _icon.alpha = $['iconAlphaOvered'];
                _backgroundAcc.color  = $['backColorOvered'];
            break;

            case _.fromOveredToNormal:
                ease(_icon, "alpha").by(Linear.easeIn, 500);
                ease(_backgroundAcc).by(Linear.easeIn, 300);
            break;

            case _.fromOveredToPressed:
                ease(_icon).and(_backgroundAcc).by(Linear.easeIn, 500);
            break;

            case _.pressed:
                _icon.alpha = $['iconAlphaPressed'];
                _backgroundAcc.color  = $['backColorPressed'];
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