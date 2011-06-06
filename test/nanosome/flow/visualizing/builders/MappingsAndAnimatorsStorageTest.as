package nanosome.flow.visualizing.builders
{
    import easing.Linear;

    import nanosome.flow.stateMachine.State;
    import nanosome.flow.visualizing.AnimationMappingDecorator;
    import nanosome.flow.visualizing.TimedEasing;
    import nanosome.flow.visualizing.animators.NumericPropertyAnimator;

    import org.flexunit.Assert;

    public class MappingsAndAnimatorsStorageTest
    {
        [Test]
        public function areAnimatorMappingsRegisteredInStorage():void
        {
            var storage:MappingsAndAnimatorsStorageDecorator = new MappingsAndAnimatorsStorageDecorator();

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
        public function arePrimitiveValuesMapping():void
        {
            var _sprite:Object = new Object();
            var stateNormal:State = new State("normal");
            var stateOvered:State = new State("overed");

            var storage:MappingsAndAnimatorsStorageDecorator = new MappingsAndAnimatorsStorageDecorator();

            storage.registerAnimator("_sprite", "x", NumericPropertyAnimator);

            storage.storeValuesFor(_sprite, "_sprite");
            _sprite.x = 15;
            storage.compareAndMapValuesFor(_sprite, "_sprite", stateNormal);

            storage.storeValuesFor(_sprite, "_sprite");
            _sprite.x = 10;
            storage.compareAndMapValuesFor(_sprite, "_sprite", stateOvered);

            var mapping:AnimationMappingDecorator = new AnimationMappingDecorator();
            mapping.mapValue(stateNormal, 15);
            mapping.mapValue(stateOvered, 10);

            Assert.assertTrue(
                mapping.hasIdenticalMappingsWith(AnimationMappingDecorator(storage.getMapping("_sprite", "x")))
            );
        }

        [Test]
        public function areComplexValuesMapping():void
        {
            var _sprite:Object = new Object();
            var stateNormal:State = new State("normal");
            var stateOvered:State = new State("overed");

            var storage:MappingsAndAnimatorsStorageDecorator = new MappingsAndAnimatorsStorageDecorator();

            storage.registerAnimator("_sprite", "complexProperty", NumericPropertyAnimator);

            storage.storeValuesFor(_sprite, "_sprite");
            _sprite.complexProperty = new ComplexCloneableProperty(1, "first");
            storage.compareAndMapValuesFor(_sprite, "_sprite", stateNormal);

            storage.storeValuesFor(_sprite, "_sprite");
            _sprite.complexProperty = new ComplexCloneableProperty(2, "second");
            storage.compareAndMapValuesFor(_sprite, "_sprite", stateOvered);

            var mapping:AnimationMappingDecorator = new AnimationMappingDecorator();
            mapping.mapValue(stateNormal, new ComplexCloneableProperty(1, "first"));
            mapping.mapValue(stateOvered, new ComplexCloneableProperty(2, "second"));

            Assert.assertTrue(
                mapping.hasIdenticalMappingsWith(AnimationMappingDecorator(storage.getMapping("_sprite", "complexProperty")))
            );
        }

        [Test]
        public function checkSingleEasingsMapping():void
        {
            var _:TestStateMachineBuilder = new TestStateMachineBuilder();
            var _sprite:Object = new Object();

            var storage:MappingsAndAnimatorsStorageDecorator = new MappingsAndAnimatorsStorageDecorator();

            storage.registerAnimator("_sprite", "x", NumericPropertyAnimator);
            
            storage.registerEasing("_sprite", "x", _.fromNormalToOvered, new TimedEasing(Linear.easeIn, 200));
            storage.registerEasing("_sprite", "x", _.fromOveredToNormal, new TimedEasing(Linear.easeOut, 400));

            var mapping:AnimationMappingDecorator = new AnimationMappingDecorator();
            mapping.mapEasing(_.fromNormalToOvered, new TimedEasing(Linear.easeIn, 200));
            mapping.mapEasing(_.fromOveredToNormal, new TimedEasing(Linear.easeOut, 400));

            Assert.assertTrue(
                mapping.hasIdenticalMappingsWith(AnimationMappingDecorator(storage.getMapping("_sprite", "x")))
            );
        }

        [Test]
        public function checkMultipleEasingsMapping():void
        {
            var _:TestStateMachineBuilder = new TestStateMachineBuilder();
            var _sprite:Object = new Object();

            var storage:MappingsAndAnimatorsStorageDecorator = new MappingsAndAnimatorsStorageDecorator();

            storage.registerAnimator("_sprite", "x", NumericPropertyAnimator);
            storage.registerAnimator("_sprite", "y", NumericPropertyAnimator);

            storage.registerEasing("_sprite", "", _.fromNormalToOvered, new TimedEasing(Linear.easeIn, 200));
            storage.registerEasing("_sprite", "", _.fromOveredToNormal, new TimedEasing(Linear.easeOut, 400));

            var mapping:AnimationMappingDecorator = new AnimationMappingDecorator();
            mapping.mapEasing(_.fromNormalToOvered, new TimedEasing(Linear.easeIn, 200));
            mapping.mapEasing(_.fromOveredToNormal, new TimedEasing(Linear.easeOut, 400));

            Assert.assertTrue(
                mapping.hasIdenticalMappingsWith(AnimationMappingDecorator(storage.getMapping("_sprite", "x")))
            );

            Assert.assertTrue(
                mapping.hasIdenticalMappingsWith(AnimationMappingDecorator(storage.getMapping("_sprite", "y")))
            );
        }
    }
}