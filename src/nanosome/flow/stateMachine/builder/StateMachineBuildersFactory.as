// @license@
package nanosome.flow.stateMachine.builder
{
    import nanosome.flow.utils.ClassUtils;

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
