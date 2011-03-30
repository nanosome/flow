package visualizing.builder
{
    import nanosome.flow.visualizing.builders.IInstanceNameResolver;

    import org.flexunit.Assert;

    public class VisualMappingBuilderTest
    {
        [Test]
        public function checkImplicitInstantiation():void
        {
            var builder:TestInstantiationBuilder = new TestInstantiationBuilder();

            Assert.assertEquals(
                "number of implicitly instantiated objects",
                2,
                builder.countRegisteredNames()
            );
        }

        [Test]
        public function areInstanceNamesResolving():void
        {
            var builder:IInstanceNameResolver = new TestNameResolvingBuilder();

            Assert.assertEquals(
                "resolving name for _instanceToResolveOne",
                "_instanceToResolveOne",
                builder.getNameForInstance(TestNameResolvingBuilder(builder)._instanceToResolveOne)
            );

            Assert.assertEquals(
                "resolving name for _instanceToResolveTwo",
                "_instanceToResolveTwo",
                builder.getNameForInstance(TestNameResolvingBuilder(builder)._instanceToResolveTwo)
            );
        }

        // [Test]
        //TODO: Test animators and easings to be properly registered
        public function areAnimatorsAndEasingsRegistering():void
        {
            var builder:TestAnimatorsAndEasingsRegisteringBuilder = new TestAnimatorsAndEasingsRegisteringBuilder();


            
        }
    }
}

import flash.display.Sprite;

import easing.Linear;

import nanosome.flow.stateMachine.State;
import nanosome.flow.stateMachine.Transition;
import nanosome.flow.visualizing.animators.NumericPropertyAnimator;
import nanosome.flow.visualizing.builders.VisualMappingBuilder;

import nanosome.flow.visualizing.builders.MappingsAndAnimatorsStorage;

import stateMachine.builder.TestStateMachineBuilder;

internal class TestInstantiationBuilder extends VisualMappingBuilder
{
    public var _:TestStateMachineBuilder;
    
    public var _icon:Sprite;
    public var _background:Sprite;

    public function countRegisteredNames():uint
    {
        var count:uint = 0;
        for each (var itemName:String in _namesMappings)
        {
            count++;
        }
        return count;
    }
    override protected function registerAnimators():void {}
    override protected function defineStatesAndTransitions(state:State, transition:Transition):void {}
}

internal class TestNameResolvingBuilder extends VisualMappingBuilder
{
    public var _:TestStateMachineBuilder;

    public var _instanceToResolveOne:Sprite;
    public var _instanceToResolveTwo:Sprite;

    override protected function registerAnimators():void {}
    override protected function defineStatesAndTransitions(state:State, transition:Transition):void {}
}


internal class TestAnimatorsAndEasingsRegisteringBuilder extends VisualMappingBuilder
{
    public var _:TestStateMachineBuilder;

    public var _testItemOne:Object;
    public var _testItemTwo:Object;

    public function getMappingStorage():MappingsAndAnimatorsStorage
    {
        return _mappingsAndAnimatorsStorage;
    }

    override protected function registerAnimators():void
    {
        animate("alpha").andProperty("color").ofInstance(_testItemOne).
            by(NumericPropertyAnimator);
        animate("color").ofInstance(_testItemTwo).
            by(NumericPropertyAnimator);
    }

    override protected function defineStatesAndTransitions(state:State, transition:Transition):void
    {
        switch(state || transition)
        {
            case _.normal:
                _testItemOne.alpha = .3;
                _testItemOne.color  = 0xFF0000;
                _testItemTwo.color  = 0xFF0000;
            break;

            case _.fromNormalToOvered:
                ease(_testItemOne, "alpha").and(_testItemTwo, "color").by(Linear.easeIn, 500);
                ease(_testItemOne, "color").by(Linear.easeIn, 300);
            break;

            case _.overed:
                _testItemOne.alpha = .8;
                _testItemOne.color  = 0x00FF00;
                _testItemTwo.color  = 0x00FF00;
            break;

            case _.fromOveredToNormal:
                ease(_testItemOne).by(Linear.easeIn, 500);
                ease(_testItemTwo).by(Linear.easeIn, 300);
            break;
        }
    }
}
