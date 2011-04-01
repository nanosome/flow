package nanosome.flow.visualizing
{
    import flash.utils.Dictionary;
    import nanosome.flow.IComparable;
    import nanosome.flow.stateMachine.Transition;

    public class AnimationMappingDecorator extends AnimationMapping
    {

        public function hasIdenticalMappingsWith(target:AnimationMappingDecorator):Boolean
        {
            var targetValues:Dictionary = target._values;
            var targetEasings:Dictionary = target._easings;

            var stateObj:Object;
            for (stateObj in targetValues)
            {
                if (targetValues[stateObj] is IComparable)
                {
                    if (!IComparable(targetValues[stateObj]).isEqualTo(_values[stateObj]))
                        return false;
                }
                else
                {
                    if (targetValues[stateObj] != _values[stateObj])
                        return false;
                }
            }

            var transitionObj:Object;
            for (transitionObj in targetEasings)
            {
                if (!areTimedEasingsEqual(targetEasings[transitionObj], _easings[transitionObj]))
                    return false
            }

            for (stateObj in _values)
            {
                if (_values[stateObj] is IComparable)
                {
                    if (!IComparable(_values[stateObj]).isEqualTo(targetValues[stateObj]))
                        return false;
                }
                else
                {
                    if (_values[stateObj] != targetValues[stateObj])
                        return false
                }
            }
            for (transitionObj in _easings)
            {
                if (!areTimedEasingsEqual(_easings[transitionObj], targetEasings[transitionObj]))
                    return false
            }

            return true;
        }

        private function areTimedEasingsEqual(easingOne:TimedEasing, easingTwo:TimedEasing):Boolean
        {
            return (easingOne._duration == easingTwo.duration && easingOne._easing  == easingTwo._easing);
        }

        public function publicGetEasingForTransition(transition:Transition):TimedEasing
        {
            return getEasingForTransition(transition);
        }
    }
}
