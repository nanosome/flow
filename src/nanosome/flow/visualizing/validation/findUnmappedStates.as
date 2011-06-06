package nanosome.flow.visualizing.validation
{
    import nanosome.flow.stateMachine.State;
    import nanosome.flow.stateMachine.StateMachine;
    import nanosome.flow.visualizing.AnimationMapping;

    public function findUnmappedStates(mapping:AnimationMapping, stateMachine:StateMachine):Vector.<State>
    {
        var res:Vector.<State> = new Vector.<State>();

        for each (var state:State in stateMachine.states)
        {
            if (mapping.getValueForState(state) == null)
                res.push(state);
        }
        return res;
    }

}
