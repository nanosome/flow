package nanosome.flow.visualizing.builders
{
    import nanosome.flow.visualizing.TimedEasing;

    public interface IEasingRegistrator
    {
        function registerEasing(instanceName:String, propertyName:String, timedEasing:TimedEasing):void;
    }
}
