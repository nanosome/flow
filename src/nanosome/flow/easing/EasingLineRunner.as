package nanosome.flow.easing
{
    public class EasingLineRunner
    {
        private var _line:EasingLine;
        public var _position:Number;

        public function EasingLineRunner()
        {
            setPosition(0);
        }

        public function setEasingLine(value:EasingLine):void
        {
            _line = value;
        }

        public function setPosition(value:Number):void
        {
            _position = value;
        }

        public function makeStep(delta:Number):void
        {
            _position += delta;
        }

        public function get value():Number
        {
            return _line.getValue(_position, 1); // using normalized length
        }

    }
}
