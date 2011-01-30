package nanosome.flow.visualizing.ticking
{
    import flash.events.IEventDispatcher;

    /**
     * ITickGenerator produces ticks with some regularity.
     * Every tick has it delta - offset from the last tick.
     * Delta usually is a number of milliseconds lasted since last tick,
     * but it can be any unit used in computing visualizer steps.
     */
    public interface ITickGenerator extends IEventDispatcher
    {
        function start():void;
        function stop():void;
    }
}
