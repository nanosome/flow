package nanosome.flow.visualizing.builders
{
    public interface IAnimatorRegistrator
    {
        function registerAnimator(instanceName:String, propertyName:String, animatorClass:Class):void;
    }
}
