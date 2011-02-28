package visualizing.builder
{
    import flash.utils.describeType;

    import org.flexunit.Assert;

    public class VisualMappingBuilderTest
    {
        [Test]
        public function checkImplicitInstantiation():void
        {
            var mapping:TestVisualMappingBuilder = new TestVisualMappingBuilder();

            Assert.assertEquals(
                "number of implicitly instantiated objects",
                mapping.countRegisteredNames(),
                2
            );
        }
    }
}

import flash.display.Sprite;
import flash.utils.describeType;

import nanosome.flow.stateMachine.State;
import nanosome.flow.stateMachine.Transition;
import nanosome.flow.visualizing.builders.VisualMappingBuilder;


import stateMachine.builder.TestStateMachineBuilder;

internal class TestVisualMappingBuilder extends VisualMappingBuilder
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


    override protected function registerAnimators():void
    {
    }

    override protected function defineStatesAndTransitions(state:State, transition:Transition):void
    {
    }

}
