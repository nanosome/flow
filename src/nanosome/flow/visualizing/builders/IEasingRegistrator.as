package nanosome.flow.visualizing.builders
{
    import nanosome.flow.stateMachine.Transition;
    import nanosome.flow.visualizing.TimedEasing;

    public interface IEasingRegistrator
    {
        function registerEasing(instanceName:String, propertyName:String, transition:Transition, timedEasing:TimedEasing):void;
    }
}
