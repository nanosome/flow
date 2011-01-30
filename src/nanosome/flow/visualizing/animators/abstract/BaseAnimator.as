package nanosome.flow.visualizing.animators.abstract
{
    import nanosome.flow.visualizing.ticking.ITickGenerator;
    import nanosome.flow.visualizing.ticking.TickGenerator;
    import nanosome.flow.visualizing.ticking.TickGeneratorEvent;

    public class BaseAnimator
    {

        protected var _easing:Function;
        protected var _duration:Number;

        protected var _percentage:Number;

        protected var _tickGenerator:ITickGenerator;

        public function BaseAnimator()
        {
            _tickGenerator = new TickGenerator();
            _tickGenerator.addEventListener(TickGeneratorEvent.TICK_UPDATE, onTickUpdate);
        }

        public function setCustomTickGenerator(tickGenerator:ITickGenerator):void
        {
            _tickGenerator.removeEventListener(TickGeneratorEvent.TICK_UPDATE, onTickUpdate);
            _tickGenerator = tickGenerator;
            _tickGenerator.addEventListener(TickGeneratorEvent.TICK_UPDATE, onTickUpdate);
        }

        protected function onTickUpdate(event:TickGeneratorEvent):void
        {
            throw new Error("This method should be overridden");
        }

    }
}
