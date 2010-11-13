package tests.builder
{
    import tests.*;
    import nanosome.flow.stateMachine.StateMachine;
    import nanosome.flow.stateMachine.controller.StateMachineController;

    import org.flexunit.Assert;

    import tests.misc.ButtonSignals;

    public class StateMachineBuilderTest
    {
        private var _smc:TestStateMachineBuilder;

        [Before]
        public function CreateBuildersAndStateMachines():void
        {
            _smc = new TestStateMachineBuilder();
            _smc.getStateMachine();
        }

        [Test]
        public function CheckStateMachineCreation():void
        {
            Assert.assertNotNull(_smc.getStateMachine());
        }

        [Test]
        public function BuilderTest():void
        {
            // alternatively, we can use new ButtonSignals(), but taking signals from _smc
            // helps us to validate types before compilation
            var signals:ButtonSignals = _smc.getNewSignalsSet();
            var sm:StateMachine = _smc.getStateMachine();

            var c:StateMachineController = new StateMachineController(sm, signals);

            Assert.assertEquals(c.getCurrentState().id, _smc.normal.id);
            signals.mouseDown.fire();
            Assert.assertEquals(c.getCurrentState().id, _smc.overed.id);
        }

    }
}
