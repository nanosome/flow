// @license@
package nanosome.flow.stateMachine.builders
{
    import nanosome.flow.utils.ClassUtils;

    /**
     * This is a helper class, implicitly instantiating declared state machines.
     *
     */
    public class StateMachineBuildersFactory
    {
        public function StateMachineBuildersFactory()
        {
            initiateBuilders();
        }

        private function initiateBuilders():void
        {
            var names:Vector.<String>;
            var name:String;
            var cl:Class;

            names = ClassUtils.getVariablesOfTypeOrInherited(this, StateMachineBuilder);

            for each (name in names)
            {
                cl = ClassUtils.getClassForVariable(this, name);
                this[name] = new cl();
            }
        }
    }
}
