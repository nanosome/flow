package nanosome.flow.visualizing.builders
{
    import mx.effects.easing.Linear;

    import nanosome.flow.stateMachine.State;
    import nanosome.flow.stateMachine.Transition;
    import nanosome.flow.visualizing.AnimationMapping;
    import nanosome.flow.visualizing.TimedEasing;
    import nanosome.flow.visualizing.animators.NumericPropertyAnimator;
    import nanosome.flow.visualizing.builders.MappingsAndAnimatorsStorage;

    import org.flexunit.Assert;


    public class VisualMappingsStorageTest
    {
        [Test]
        public function checkMappingsRegistration():void
        {
            var storage:MappingsAndAnimatorsStorage = new MappingsAndAnimatorsStorage();

            storage.registerAnimator("_sprite", "x", NumericPropertyAnimator);
            storage.registerAnimator("_sprite", "y", NumericPropertyAnimator);

            Assert.assertNotNull(
                "mapping for _sprite.x",
                storage.getMapping("_sprite", "x")
            );

            Assert.assertNotNull(
                "mapping for _sprite.y",
                storage.getMapping("_sprite", "y")
            );

            Assert.assertNull(
                "mapping for _sprite.z",
                storage.getMapping("_sprite", "z")
            );
        }

        [Test]
        public function checkValuesMapping():void
        {
            var _sprite:Object = new Object();
            var stateNormal:State = new State("normal");
            var stateOvered:State = new State("overed");

            var storage:MappingsAndAnimatorsStorage = new MappingsAndAnimatorsStorage();

            storage.registerAnimator("_sprite", "x", NumericPropertyAnimator);

            storage.storeValuesFor(_sprite, "_sprite");
            _sprite.x = 15;
            storage.compareAndMapValuesFor(_sprite, "_sprite", stateNormal);

            storage.storeValuesFor(_sprite, "_sprite");
            _sprite.x = 10;
            storage.compareAndMapValuesFor(_sprite, "_sprite", stateOvered);

            var mapping:AnimationMapping = new AnimationMapping();
            mapping.mapValue(stateNormal, 15);
            mapping.mapValue(stateOvered, 10);

            Assert.assertTrue(
                mapping.hasIdenticalMappingsWith(storage.getMapping("_sprite", "x"))
            );
        }

        [Test]
        public function checkSingleEasingsMapping():void
        {
            var _:TestStateMachineBuilder = new TestStateMachineBuilder();
            var _sprite:Object = new Object();

            var storage:MappingsAndAnimatorsStorage = new MappingsAndAnimatorsStorage();

            storage.registerAnimator("_sprite", "x", NumericPropertyAnimator);
            
            storage.registerEasing("_sprite", "x", _.fromNormalToOvered, new TimedEasing(Linear.easeIn, 200));
            storage.registerEasing("_sprite", "x", _.fromOveredToNormal, new TimedEasing(Linear.easeOut, 400));

            var mapping:AnimationMapping = new AnimationMapping();
            mapping.mapTransition(_.fromNormalToOvered, new TimedEasing(Linear.easeIn, 200));
            mapping.mapTransition(_.fromOveredToNormal, new TimedEasing(Linear.easeOut, 400));

            Assert.assertTrue(
                mapping.hasIdenticalMappingsWith(storage.getMapping("_sprite", "x"))
            );
        }

        [Test]
        public function checkMultipleEasingsMapping():void
        {
            var _:TestStateMachineBuilder = new TestStateMachineBuilder();
            var _sprite:Object = new Object();

            var storage:MappingsAndAnimatorsStorage = new MappingsAndAnimatorsStorage();

            storage.registerAnimator("_sprite", "x", NumericPropertyAnimator);
            storage.registerAnimator("_sprite", "y", NumericPropertyAnimator);

            storage.registerEasing("_sprite", "", _.fromNormalToOvered, new TimedEasing(Linear.easeIn, 200));
            storage.registerEasing("_sprite", "", _.fromOveredToNormal, new TimedEasing(Linear.easeOut, 400));

            var mapping:AnimationMapping = new AnimationMapping();
            mapping.mapTransition(_.fromNormalToOvered, new TimedEasing(Linear.easeIn, 200));
            mapping.mapTransition(_.fromOveredToNormal, new TimedEasing(Linear.easeOut, 400));

            Assert.assertTrue(
                mapping.hasIdenticalMappingsWith(storage.getMapping("_sprite", "x"))
            );

            Assert.assertTrue(
                mapping.hasIdenticalMappingsWith(storage.getMapping("_sprite", "y"))
            );
        }
    }
}