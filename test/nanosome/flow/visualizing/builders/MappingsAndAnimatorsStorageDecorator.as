package nanosome.flow.visualizing.builders
{
    import nanosome.flow.visualizing.AnimationMappingDecorator;

    public class MappingsAndAnimatorsStorageDecorator extends MappingsAndAnimatorsStorage
    {

        override public function registerAnimator(instanceName:String, propertyName:String, animatorClass:Class):void
        {
            super.registerAnimator(instanceName, propertyName, animatorClass);

            var key:String = instanceName + "." + propertyName;
            _mappings[key] = new AnimationMappingDecorator();
        }
    }
}
