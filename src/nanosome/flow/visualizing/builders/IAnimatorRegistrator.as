package nanosome.flow.visualizing.builders
{
    import nanosome.flow.visualizing.TimedEasing;

    public interface IAnimatorRegistrator
    {
        function registerAnimator(instanceName:String, propertyName:String, animatorClass:Class):void;
    }
}
