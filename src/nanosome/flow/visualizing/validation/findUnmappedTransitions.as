package nanosome.flow.visualizing.validation
{
    import nanosome.flow.stateMachine.StateMachine;
    import nanosome.flow.stateMachine.Transition;
    import nanosome.flow.visualizing.AnimationMapping;

    public function findUnmappedTransitions(mapping:AnimationMapping, stateMachine:StateMachine):Vector.<Transition>
    {
           var res:Vector.<Transition> = new Vector.<Transition>();

            for each (var transition:Transition in stateMachine.transitions)
            {
                if (mapping.getEasingForTransition(transition) == null)
                    res.push(transition);
            }
            return res;
    }

}
